#!/bin/bash



function install_zsh() {
    sudo apt install git curl -y
    sudo apt install zsh -y
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" -y
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"

    git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"
    git clone https://github.com/sobolevn/wakatime-zsh-plugin.git "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/wakatime"
    curl https://raw.githubusercontent.com/omegaatt36/lab/main/rc/.zshrc -o "${HOME}/.zshrc"
    curl https://raw.githubusercontent.com/omegaatt36/lab/main/rc/.p10k.zsh -o "${HOME}/.p10k.zsh"

    source ${HOME}/.zshrc
}

function install_tmux() {
    sudo apt install tmux -y
    git clone https://github.com/tmux-plugins/tpm "${HOME}/.tmux/plugins/tpm"
    curl https://raw.githubusercontent.com/omegaatt36/lab/main/rc/.tmux.conf -o "${HOME}/.tmux.conf"
}

function git_config() {
    git config --global core.editor "vim"
    git config --global alias.lg "log --color --graph --all --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --"
}

function install_go() {
    cd "${HOME}"
    local go_version="1.21.1"

    wget "https://go.dev/dl/go${go_version}.linux-amd64.tar.gz"
    rm -rf "${HOME}/go" && tar -xzf go${go_version}.linux-amd64.tar.gz
}

function install_vscode() {
    curl 'https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64' -o "${HOME}/vscode.deb"
    sudo apt install "${HOME}/vscode.deb" -y
}

function install_kubectl() {
    sudo apt install -y apt-transport-https ca-certificates curl
    curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.28/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
    sudo apt update
    sudo apt install kubectl -y
}

function install_rust() {
    sudo apt install build-essential -y
    curl --proto '=https' --tlsv1.3 https://sh.rustup.rs -sSf | sh
    source ${HOME}/.cargo/env
    cargo install eza
    cargo install topgrade
    cargo install buttom
}

set -ex

function main() {
    sudo apt update && sudo apt upgrade -y
    install_zsh
    install_tmux
    git_config
    install_go
    install_vscode
    install_kubectl
    install_rust
    sudo apt autoremove -y
    source ${HOME}/.zshrc
}

main