if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH="/home/raiven/.oh-my-zsh"

POWERLEVEL9K_MODE='nerdfont-complete'
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(git golang zsh-autosuggestions docker history-substring-search kubectl zsh-docker-aliases)
source $ZSH/oh-my-zsh.sh

bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:/usr/local/node/bin
export PATH=~/.npm-global/bin:$PATH
export ZPLUG_HOME=~/.zplug
export KUBECONFIG=$HOME/.kube/config
source <(kubectl completion zsh)
alias k=kubectl
