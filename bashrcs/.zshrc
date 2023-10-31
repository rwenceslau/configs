if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

source /Users/rwenceslau/.bash_profile

export PATH=$HOME/bin:/usr/local/bin:$PATH

export ZSH="/Users/rwenceslau/.oh-my-zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(
    git
)
source $ZSH/oh-my-zsh.sh
alias k="kubectl"
alias kgx="kubectl config get-contexts"
alias vim="nvim"

[[ -f ~/.config/tabtab/__tabtab.zsh ]] && . ~/.config/tabtab/__tabtab.zsh || true


PSQL_PATH="/Applications/Postgres.app/Contents/Versions/latest/bin"
PATH="$PATH:$PSQL_PATH"

export PATH=/usr/local/mysql/bin:$PATH

PATH="$HOME/.composer/vendor/bin:$PATH"

eval $(/opt/homebrew/bin/brew shellenv)

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /opt/homebrew/bin/terraform terraform

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv 1>/dev/null 2>&1; then
    eval "$(pyenv init --path)"
    eval "$(pyenv init -)"
fi

export NVM_DIR=~/.nvm
source $(brew --prefix nvm)/nvm.sh
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
alias ll="ls -la"

complete -C '/usr/local/bin/aws_completer' aws

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
