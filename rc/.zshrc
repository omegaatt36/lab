if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH="${HOME}/.oh-my-zsh"

POWERLEVEL9K_MODE='nerdfont-complete'
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(git golang zsh-autosuggestions docker history-substring-search kubectl zsh-docker-aliases)
source $ZSH/oh-my-zsh.sh

# bind home & end key
bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

export ZPLUG_HOME=~/.zplug

# go dev
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin

# podman dev
if command -v podman &> /dev/null
  source <(podman completion zsh)
fi

# npm dev
export PATH="${HOME}/.npm-global/bin":"${PATH}"

# kubernetes dev
if command -v kubectl &> /dev/null
then
  export KUBECONFIG=$HOME/.kube/config
  source <(kubectl completion zsh)
  alias k=kubectl
fi

# rust dev
if command -v cargo &> /dev/null
  source $HOME/.cargo/env
  # alias cat=batcat
  # alias ls=eza
fi

# leetgo dev
export LEETCODE_SESSION=
export LEETCODE_CSRFTOKEN=