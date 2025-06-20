ARG HOST_USER
ARG HOST_SSH_PUB
ARG DOCKER_GID
ARG TARGETARCH=arm64

FROM ubuntu:24.04

ARG HOST_USER
ARG HOST_SSH_PUB
ARG DOCKER_GID
ARG TARGETARCH

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Set DEBIAN_FRONTEND to noninteractive to avoid prompts
ENV DEBIAN_FRONTEND=noninteractive

# Install base dependencies and project-specific dependencies
RUN apt-get update -y \
    && apt-get upgrade -y \
    && apt-get install -y --no-install-recommends \
    sudo curl openssh-server ca-certificates \
    apt-transport-https gnupg lsb-release wget \
    build-essential git python3 python3-pip \
    fd-find bat unzip vim zsh binutils-gold locales \
    protobuf-compiler procps libgtest-dev liblog4cxx-dev \
    libjsoncpp-dev libmongoc-1.0-0 libmongoc-dev \
    protobuf-c-compiler libprotobuf-dev libxml2 \
    libcurl4-openssl-dev libcurl4 libevent-dev \
    libevent-core-2.1-7t64 \
    libboost-dev libboost-program-options-dev libboost-filesystem-dev \
    zlib1g-dev \
    logrotate supervisor libxml2-dev libssl3 libssl-dev

# Generate en_US.UTF-8 locale
RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
    && locale-gen en_US.UTF-8 \
    && update-locale LANG=en_US.UTF-8

ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

COPY ./debs/hiredis-ssl-1.2.0-noble-${TARGETARCH}.deb /tmp/hiredis-ssl.deb
RUN dpkg -i /tmp/hiredis-ssl.deb && rm /tmp/hiredis-ssl.deb

# Docker GPG Key and apt repository setup (for installing Docker CE client tools if needed)
RUN install -m 0755 -d /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc && \
    chmod a+r /etc/apt/keyrings/docker.asc

# Create user and set up sudo
RUN useradd -m -s /bin/zsh "$HOST_USER" \
    && usermod -aG sudo "$HOST_USER" \
    && echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# SSH server setup
RUN mkdir -p /var/run/sshd \
    && ssh-keygen -A

# Install Wakatime CLI (Assuming install_wakatime-cli.sh exists in build context)
COPY install_wakatime-cli.sh .
ENV ZSH_WAKATIME_BIN=/usr/local/bin/wakatime-cli
RUN chmod +x install_wakatime-cli.sh && bash -c ./install_wakatime-cli.sh && rm install_wakatime-cli.sh

# --- Switch to non-root user ---
USER $HOST_USER
ENV HOME=/home/${HOST_USER}
WORKDIR ${HOME}

# Docker CE installation (Consider mounting host Docker socket instead for local dev)
RUN echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
RUN sudo apt-get update && \
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin && \
    sudo apt-get clean && sudo rm -rf /var/lib/apt/lists/*

# Docker group setup
RUN if getent group docker; then \
    sudo groupmod -g $DOCKER_GID docker; \
    else \
    sudo groupadd -g $DOCKER_GID docker; \
    fi \
    && sudo usermod -aG docker "$HOST_USER"

RUN sudo docker --version

# Create .ssh directory for SSH key mounting
RUN mkdir -p ${HOME}/.ssh \
    && echo "$HOST_SSH_PUB" > ${HOME}/.ssh/authorized_keys \
    && chmod 700 ${HOME}/.ssh \
    && chmod 600 ${HOME}/.ssh/authorized_keys

# Setup basic dotfiles and directories
RUN <<EOF
    touch ${HOME}/.zshenv
    mkdir -p ${HOME}/.cargo/
    touch ${HOME}/.cargo/env
    touch ${HOME}/.vimrc
EOF

# Install Golang 1.24.4
ENV GOLANG_VERSION 1.24.4
RUN wget -q https://go.dev/dl/go${GOLANG_VERSION}.linux-${TARGETARCH}.tar.gz \
    && tar -xzf go${GOLANG_VERSION}.linux-${TARGETARCH}.tar.gz \
    && sudo cp go /usr/local -R \
    && rm go${GOLANG_VERSION}.linux-${TARGETARCH}.tar.gz
ENV GOROOT=/usr/local/go
ENV GOPATH=/home/${HOST_USER}/go
ENV PATH=$GOROOT/bin:$GOPATH/bin:/usr/local/go/bin:${PATH}

# Install chezmoi, oh-my-zsh, plugins, fzf, vim-plug
RUN <<EOF
    bash -c "$(curl -fsLS get.chezmoi.io) -- init --apply omegaatt36"
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    git clone https://github.com/sobolevn/wakatime-zsh-plugin.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/wakatime
    git clone --depth 1 https://github.com/unixorn/fzf-zsh-plugin.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fzf-zsh-plugin
    git clone https://github.com/Aloxaf/fzf-tab ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fzf-tab
    # Make sure chezmoi executable is in PATH or use absolute path if installed locally by user
    # Example: ${HOME}/bin/chezmoi or /usr/local/bin/chezmoi
    # This assumes chezmoi is in PATH after installation
    ./bin/chezmoi update --force
    sed -i '/fzf-tab/d' ${HOME}/.zshrc || true
    # Default shell change for user (might need password or NOPASSWD for chsh)
    # This should work due to NOPASSWD sudo, but it's changing user's shell
    sudo chsh -s "$(which zsh)" "$HOST_USER"
EOF

# Install fzf separately
RUN bash -c "git clone --depth 1 https://github.com/junegunn/fzf.git "${HOME}"/.fzf \
    && curl -fLo ${HOME}/.fzf/fzf-git.sh https://raw.githubusercontent.com/junegunn/fzf-git.sh/main/fzf-git.sh \
    && yes | "${HOME}"/.fzf/install"

# Install vim plugins
RUN <<EOF
    curl -fLo "${HOME}"/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    vim +'PlugInstall --sync' +qa || true # Allow failure if vim is not fully set up for non-interactive PlugInstall
EOF

# Install uv (Python package manager)
RUN curl -LsSf https://astral.sh/uv/install.sh | sh

# Install JFrog CLI
RUN curl -fL https://install-cli.jfrog.io | sh

# Install Zed editor
# Note: Consider if Zed editor needs to be installed system-wide or for the user
RUN curl -fsSL https://zed.dev/install.sh | SHELL=/bin/zsh sh

# Symlinking Zed's bundled libssl can be fragile.
# It's better if Zed can use system libraries or bundle them in a way that doesn't require system-level links.
# This is kept as per your original file but consider alternatives if issues arise.
RUN if [ "$(dpkg --print-architecture)" = "arm64" ]; then \
    sudo ln -sf /home/$HOST_USER/.local/bin/zed.app/lib/libssl.so.1.1 /usr/lib/aarch64-linux-gnu/libssl.so.1.1 || true \
    && sudo ln -sf /home/$HOST_USER/.local/bin/zed.app/lib/libcrypto.so.1.1 /usr/lib/aarch64-linux-gnu/libcrypto.so.1.1 || true; \
    else \
    sudo ln -sf /home/$HOST_USER/.local/bin/zed.app/lib/libssl.so.1.1 /usr/lib/x86_64-linux-gnu/libssl.so.1.1 || true \
    && sudo ln -sf /home/$HOST_USER/.local/bin/zed.app/lib/libcrypto.so.1.1 /usr/lib/x86_64-linux-gnu/libcrypto.so.1.1 || true; \
    fi

EXPOSE 22
ENTRYPOINT ["sudo", "/usr/sbin/sshd", "-D"]
