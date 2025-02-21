FROM node:22-bookworm

ENV USERNAME=raiven_kao

RUN usermod -l ${USERNAME} node && \
    usermod -d /home/${USERNAME} ${USERNAME} && \
    groupmod -n ${USERNAME} node && \
    mv /home/node /home/${USERNAME}

RUN apt update && apt upgrade -y && apt install -y vim git curl zsh fd-find bat

USER ${USERNAME}

ENV HOME=/home/${USERNAME}

WORKDIR ${HOME}

RUN python3 -c "$(wget -q -O - https://raw.githubusercontent.com/wakatime/vim-wakatime/master/scripts/install_cli.py)"

RUN touch ${HOME}/.zshenv

RUN mkdir $HOME/.npm-global && npm config set prefix $HOME/.npm-global

RUN bash -c "$(curl -fsLS get.chezmoi.io) -- init --apply omegaatt36"

RUN mkdir -p ${HOME}/.cargo/ && touch ${HOME}/.cargo/env

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

RUN bash -c "sed -i '/fzf-tab/d' ${HOME}/.zshrc && sed -i 's/fd /fdfind /g' ${HOME}/.zshrc"

ENTRYPOINT ["/bin/env", "zsh"]
