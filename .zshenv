# ZSH
export ZDOTDIR="$HOME/.config/zsh"
export ZSH="/usr/share/oh-my-zsh/"
export ZSH_CUSTOM="$ZDOTDIR/custom"
export ZSH_THEME="gruvbox"
export HISTFILE="$HOME/.config/.zsh_history"
export HISTSIZE="10000"

# Instalation path of oh-my-zsh
export ROOT_PLUGINS="/usr/share/zsh/plugins"

## ohmyzsh flags
export DISABLE_AUTO_UPDATE=true # Update though paru
export DISABLE_UPDATE_PROMPT=true # No need, gonna read release notes already
### Shell Experience
export ENABLE_CORRECTION=true
export CASE_SENSITIVE=false
export HYPHEN_INSENSITIVE=true


# Other apps
export GIT_CONFIG_GLOBAL="$HOME/.config/git/gitconfig"
export RUSTC_WRAPPER
RUSTC_WRAPPER="$(which sccache)" # Assign separately to avoid masking return value with declaration (exportation)
# export SHELLCHECK_OPTS='--shell=bash --exclude=SC1090' # TODO: Figure out how to pass shellcheck args when running it in nvim


#Personal paths and variables
export GH="https://github.com/"
export NOTES="$HOME/notes"
export TODOFILE="$NOTES/todos/todo.md"


# Colors
export -a colors
export nc=$'\033[0m'
colors+=("$nc")
export black=$'\033[0;30m'
colors+=("$black")
export dark_red=$'\033[0;31m'
colors+=("$dark_red")
export dark_green=$'\033[0;32m'
colors+=("$dark_green")
export orange=$'\033[0;33m'
colors+=("$orange")
export dark_blue=$'\033[0;34m'
colors+=("$dark_blue")
export dark_purple=$'\033[0;35m'
colors+=("$dark_purple")
export dark_cyan=$'\033[0;36m'
colors+=("$dark_cyan")
export gray=$'\033[0;37m'
colors+=("$gray")
export red=$'\033[1;31m'
colors+=("$red")
export green=$'\033[1;32m'
colors+=("$green")
export yellow=$'\033[1;33m'
colors+=("$yellow")
export blue=$'\033[1;34m'
colors+=("$blue")
export purple=$'\033[1;35m'
colors+=("$purple")
export cyan=$'\033[1;36m'
colors+=("$cyan")
export white=$'\033[1;37m'
colors+=("$white")
