if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH="${HOME}/.oh-my-zsh"

POWERLEVEL9K_MODE='nerdfont-complete'
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(git golang zsh-autosuggestions docker history-substring-search kubectl)
source $ZSH/oh-my-zsh.sh

# bind home & end key
bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

export ZPLUG_HOME=~/.zplug

# tmux
export TMUX_PLUGIN_MANAGER_PATH=${HOME}/.tmux/plugins/tpm/

# golang
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin

# podman
# source <(podman completion zsh)

# npm
export PATH="${HOME}/.npm-global/bin":"${PATH}"

# kubernetes
# export KUBECONFIG=$HOME/.kube/config
# source <(kubectl completion zsh)
# alias k=kubectl

# rust
# source $HOME/.cargo/env
# alias cat=bat
# alias ls=eza

# leetgo
export LEETCODE_SESSION=
export LEETCODE_CSRFTOKEN=