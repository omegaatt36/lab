# Base stage with common tools and user setup
FROM ubuntu:noble AS base

ARG USERNAME=coder

# Install base dependencies
RUN apt update && apt install -y --no-install-recommends \
    git vim curl zsh wget unzip gpg make \
    fd-find bat ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Create the user
RUN useradd -m -U -s /bin/zsh ${USERNAME}

# Install Wakatime CLI (Assuming install_wakatime-cli.sh exists in build context)
COPY install_wakatime-cli.sh .
ENV ZSH_WAKATIME_BIN=/usr/local/bin/wakatime-cli
RUN chmod +x install_wakatime-cli.sh && bash -c ./install_wakatime-cli.sh && rm install_wakatime-cli.sh

# Switch to user
USER ${USERNAME}

ENV HOME=/home/${USERNAME}
WORKDIR ${HOME}

# Setup basic dotfiles and directories
RUN <<EOF
touch ${HOME}/.zshenv
mkdir -p ${HOME}/.cargo/
touch ${HOME}/.cargo/env
touch ${HOME}/.vimrc
EOF

# Install chezmoi, oh-my-zsh, plugins, fzf, vim-plug
# Need git installed before this step
RUN <<EOF
bash -c "$(curl -fsLS get.chezmoi.io) -- init --apply omegaatt36"
bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/sobolevn/wakatime-zsh-plugin.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/wakatime
git clone --depth 1 https://github.com/unixorn/fzf-zsh-plugin.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fzf-zsh-plugin
./bin/chezmoi update --force
# Apply chezmoi changes first, then modify .zshrc if needed
sed -i '/fzf-tab/d' ${HOME}/.zshrc || true # Allow failure if pattern not found
EOF

# Install fzf separately as it needs user interaction simulation (using install script defaults)
RUN bash -c "git clone --depth 1 https://github.com/junegunn/fzf.git "${HOME}"/.fzf \
    && curl -fLo ${HOME}/.fzf/fzf-git.sh https://raw.githubusercontent.com/junegunn/fzf-git.sh/main/fzf-git.sh \
    && yes | "${HOME}"/.fzf/install"

# Install vim plugins
RUN <<EOF
curl -fLo "${HOME}"/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
vim +'PlugInstall --sync' +qa
EOF

# Set default entrypoint for base stage (can be overridden)
ENTRYPOINT ["zsh"]

# ==============================================================================
# Java stage
# ==============================================================================
FROM base AS java

ARG USERNAME=coder

USER root

# Install Java development tools
RUN apt update && apt install -y --no-install-recommends \
    maven openjdk-17-jdk \
    && rm -rf /var/lib/apt/lists/*

USER ${USERNAME}
WORKDIR /home/${USERNAME}

# ==============================================================================
# Node.js stage
# ==============================================================================
FROM base AS node

ARG USERNAME=coder
ARG NODE_VERSION=22

USER root

# Install Node.js
RUN <<EOF
curl -fsSL https://deb.nodesource.com/setup_${NODE_VERSION}.x -o nodesource_setup.sh
bash nodesource_setup.sh
apt-get update && apt-get install -y --no-install-recommends nodejs && rm -rf /var/lib/apt/lists/*
rm nodesource_setup.sh
EOF

USER ${USERNAME}
WORKDIR /home/${USERNAME}

# Configure npm global prefix
RUN mkdir ${HOME}/.npm-global && npm config set prefix ${HOME}/.npm-global
# Add npm global bin to PATH in .zshenv (or similar profile file)
RUN echo 'export PATH=${HOME}/.npm-global/bin:$PATH' >> ${HOME}/.zshenv

# ==============================================================================
# Python stage
# ==============================================================================
FROM base AS python

ARG USERNAME=coder

USER root

# Install Python tools
RUN apt update && apt install -y --no-install-recommends \
    python3 python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Install uv
RUN curl -LsSf https://astral.sh/uv/install.sh | sh

USER ${USERNAME}
WORKDIR /home/${USERNAME}

# ==============================================================================
# NPX stage (separate base image)
# ==============================================================================
FROM debian:bookworm AS npx

ARG NODE_VERSION=22

# Install dependencies
RUN apt update && apt install -y --no-install-recommends \
    git curl ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js
RUN <<EOF
curl -fsSL https://deb.nodesource.com/setup_${NODE_VERSION}.x -o nodesource_setup.sh
bash nodesource_setup.sh
apt-get update && apt-get install -y --no-install-recommends nodejs && rm -rf /var/lib/apt/lists/*
rm nodesource_setup.sh
EOF

# Set default command
CMD ["npx"]
