ARG HOST_USER
ARG HOST_SSH_PUB
ARG DOCKER_GID
ARG TARGETARCH=arm64

FROM ubuntu:25.04

ARG HOST_USER
ARG HOST_SSH_PUB
ARG DOCKER_GID

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN apt update -y \
    && DEBIAN_FRONTEND=noninteractive apt upgrade -y \
    && apt install -y --no-install-recommends \
    sudo curl openssh-server ca-certificates \
    apt-transport-https gnupg lsb-release wget \
    build-essential git python3 python3-pip \
    fd-find bat unzip vim zsh binutils-gold locales

RUN apt update && apt install -y --no-install-recommends \
    build-essential \
    curl \
    ca-certificates \
    protobuf-compiler \
    procps \
    libgtest-dev \
    liblog4cxx-dev \
    libjsoncpp-dev \
    libmongoc-1.0-0 \
    libmongoc-dev \
    protobuf-c-compiler \
    libprotobuf-dev \
    libxml2 \
    libcurl4-openssl-dev \
    libcurl4 \
    libevent-dev \
    libevent-core-2.1-7 \
    libboost-dev \
    libboost-program-options-dev \
    libboost-filesystem-dev \
    gnupg \
    wget \
    logrotate \
    supervisor \
    libxml2-dev \
    libssl3 \
    libssl-dev

RUN install -m 0755 -d /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc && \
    chmod a+r /etc/apt/keyrings/docker.asc

RUN useradd -m -s /bin/zsh "$HOST_USER" \
    && usermod -aG sudo "$HOST_USER" \
    && echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers


RUN mkdir /var/run/sshd \
    && ssh-keygen -A

# Install Wakatime CLI (Assuming install_wakatime-cli.sh exists in build context)
COPY install_wakatime-cli.sh .
ENV ZSH_WAKATIME_BIN=/usr/local/bin/wakatime-cli
RUN chmod +x install_wakatime-cli.sh && bash -c ./install_wakatime-cli.sh && rm install_wakatime-cli.sh

USER $HOST_USER

ENV HOME=/home/${HOST_USER}
WORKDIR /home/$HOST_USER

RUN echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

RUN sudo apt update && \
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

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
    sudo chsh -s $(which zsh)
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

# Install Golang 1.24
RUN wget -q https://go.dev/dl/go1.24.3.linux-$(dpkg --print-architecture).tar.gz \
    && sudo tar -C /usr/local -xzf go1.24.3.linux-$(dpkg --print-architecture).tar.gz \
    && rm go1.24.3.linux-$(dpkg --print-architecture).tar.gz

ENV GOROOT=/usr/local/go
ENV GOPATH=/home/$HOST_USER/./go
ENV PATH $GOROOT/bin:$GOPATH/bin:/usr/local/go/bin:${PATH}

# Install uv (Python package manager)
RUN curl -LsSf https://astral.sh/uv/install.sh | sh

RUN curl -fL https://install-cli.jfrog.io | sh

# Install Zed editor
RUN curl -fsSL https://zed.dev/install.sh | SHELL=zsh sh

RUN if [ "$(dpkg --print-architecture)" = "arm64" ]; then \
    sudo ln -s /home/$HOST_USER/.local/zed.app/lib/libssl.so.1.1 /usr/lib/aarch64-linux-gnu/ || true \
    && sudo ln -s /home/$HOST_USER/.local/zed.app/lib/libcrypto.so.1.1 /usr/lib/aarch64-linux-gnu/ || true; \
    else \
    sudo ln -s /home/$HOST_USER/.local/zed.app/lib/libssl.so.1.1 /usr/lib/x86_64-linux-gnu/ || true \
    && sudo ln -s /home/$HOST_USER/.local/zed.app/lib/libcrypto.so.1.1 /usr/lib/x86_64-linux-gnu/ || true; \
    fi

EXPOSE 22

# Use init script to fix permissions before starting SSH
ENTRYPOINT ["sudo", "/usr/sbin/sshd", "-D"]
