
FROM node:20-bookworm

ENV USERNAME=raiven

RUN usermod -l ${USERNAME} node && \
    usermod -d /home/${USERNAME} ${USERNAME} && \
    groupmod -n ${USERNAME} node && \
    mv /home/node /home/${USERNAME}

RUN apt update && apt upgrade -y && apt install -y vim git curl zsh

# wakatime
RUN bash -c "wget https://github.com/wakatime/wakatime-cli/releases/download/v1.98.3/wakatime-cli-linux-amd64.zip \
    && unzip wakatime-cli-linux-amd64.zip \
    && chmod +x wakatime-cli-linux-amd64 \
    && mv wakatime-cli-linux-amd64 /usr/local/bin/wakatime-cli \
    && rm wakatime-cli-linux-amd64.zip"

USER ${USERNAME}

ENV HOME=/home/${USERNAME}

WORKDIR $HOME

RUN mkdir $HOME/.npm-global && npm config set prefix $HOME/.npm-global && npm install -g pnpm

RUN bash -c "$(curl -fsLS get.chezmoi.io) -- init --apply omegaatt36"

RUN bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh) -y"

# zsh
RUN bash -c "git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k \
    && git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions \
    && git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting \
    && git clone https://github.com/sobolevn/wakatime-zsh-plugin.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/wakatime \
    && git clone --depth 1 https://github.com/unixorn/fzf-zsh-plugin.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fzf-zsh-plugin \
    && ./bin/chezmoi update --force"

RUN bash -c "git clone --depth 1 https://github.com/junegunn/fzf.git "${HOME}"/.fzf \
    && curl https://raw.githubusercontent.com/junegunn/fzf-git.sh/main/fzf-git.sh -o ${HOME}/.fzf/fzf-git.sh \
    https://raw.githubusercontent.com/junegunn/fzf-git.sh/main/fzf-git.sh \
    && "${HOME}"/.fzf/install"

RUN bash -c "curl -fLo "${HOME}"/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim \
    && vim +'PlugInstall --sync' +qa"

RUN cat <<'EOF' > ${HOME}/change_wakatime_cfg.sh
#!/bin/bash
echo "hostname=$(cat /proc/sys/kernel/hostname)-container-node:20-bookworm" >> ${HOME}/.wakatime.cfg
EOF

RUN chmod +x ${HOME}/change_wakatime_cfg.sh

ENTRYPOINT ["/bin/sh", "-c", "/home/raiven/change_wakatime_cfg.sh && exec zsh"]
