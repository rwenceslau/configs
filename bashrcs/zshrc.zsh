# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:$PATH

source /Users/rwenceslau/.bash_profile

# Path to your oh-my-zsh installation.
export ZSH="/Users/rwenceslau/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export ENVY_ROOT=$HOME/envy
alias enterpod="kubectl exec -it $(kubectl get pods --selector=app=schoology-sgy-web --output=jsonpath='{.items[0].metadata.name}') bash"
alias enterroot="cd /var/www/html/schoology/docroot/"
alias evaldocker="eval $(minikube docker-env)"
alias nohuppod="nohup kubectl port-forward $(kubectl get pods -l app=selenium-node -o jsonpath='{ .items[0].metadata.name }') 5901:5900 &>/dev/null & [1] 38966"
# tabtab source for packages
# uninstall by removing these lines
[[ -f ~/.config/tabtab/__tabtab.zsh ]] && . ~/.config/tabtab/__tabtab.zsh || true

# Export environment variables into the current shell that can be used by the awscli
# or other applications that respond to standard AWS configuration.
#
# Parameters:
#
# --profile - The named AWS profile to use. Defaults to "dev" unless $HOME/.aws/default_profile
#             exists, in which case that value is used when --profile is not supplied.
# --role-session-name - If profile uses role assumption, then name for session. Defaults to
#                       current user name.
# --duration-seconds - Duration of a session when using role assumption. Defaults to 3600.
#
function awsenv {
    local region
    local profile
    local key
    local secret
    local token
    local role_arn
    local source_profile
    local session
    local duration
    local creds
    local expiration
    local consumed_arg

    profile="dev"
	if [ -e $HOME/.aws/default_profile ]; then
        profile="$(cat $HOME/.aws/default_profile)"
	fi

    session="$(id -un)"
    duration=3600
    consumed_arg=1

    for arg in "$@"; do
        shift
        case "$arg" in
            "--profile")
                profile="$1"
                consumed_arg=0
                ;;
            "--role-session-name")
                session="$1"
                consumed_arg=0
                ;;
            "--duration-seconds")
                duration="$1"
                consumed_arg=0
                ;;
            *)
                if [ $consumed_arg -eq 1 ]; then
                    set -- "$@" "$arg"
                fi
                consumed_arg=1
        esac
    done

    if [ ! -f $(command -v jq) ]; then
        (>&2 echo "ERROR: jq must be intalled for 'awsenv' to work")
        return
    fi

    region="$(aws configure get region --profile ${profile})"
    source_profile="$(aws configure get source_profile --profile ${profile})"
    role_arn="$(aws configure get role_arn --profile ${profile})"

    # Handle role assumption with temporary credentials if necessary, otherwise just
    # pull the key and secret from the extant configuration.
    if [ -n "$source_profile" ]; then
        if [ -z "$role_arn" ]; then
            (>&2 echo "ERROR: Must specify a role_arn if using a source_profile in $profile")
            return
        fi

        creds=$(aws sts assume-role --role-arn $role_arn --profile $profile --role-session-name $session --duration-seconds $duration)
        if [ $? -ne 0 ]; then
            (>&2 echo "ERROR: Could not assume role $role_arn")
            return
        fi

        key=$(echo "$creds" | jq -r .Credentials.AccessKeyId)
        secret=$(echo "$creds" | jq -r .Credentials.SecretAccessKey)
        token=$(echo "$creds" | jq -r .Credentials.SessionToken)
        expiration=$(echo "$creds" | jq -r .Credentials.Expiration)

        echo "WARNING: Assumed credentials expire at $expiration"
    else
        key="$(aws configure get aws_access_key_id --profile ${profile})"
        secret="$(aws configure get aws_secret_access_key --profile ${profile})"
    fi

    # Ensure the environment variables are set
	export AWS_DEFAULT_PROFILE=${profile}
	export AWS_DEFAULT_REGION=${region}
    export AWS_REGION=${region}
	export AWS_ACCESS_KEY_ID=${key}
	export AWS_SECRET_ACCESS_KEY=${secret}
    export AWS_SESSION_TOKEN=${token}
}

function awsc {
	if [ -z $1 ]; then
		echo "AWS default env is ${AWS_DEFAULT_PROFILE}"
		return
	fi
	echo $1 > $HOME/.aws/default_profile

	if [ -n "$2" ]; then
		(awsenv && $(which aws) "${@:2}")
	else
		awsenv
	fi
}
