# User
export DOTDIR="$HOME/.config"

# ZSH
export ZDOTDIR="$DOTDIR/zsh"
export ZSH_CUSTOM="$ZDOTDIR/custom"
export ZSH="$ZDOTDIR/ohmyzsh"
export ZSH_THEME="gruvbox"
export HISTFILE="$HOME/.zsh_history"
export HISTSIZE="10000"


# Other apps
export GIT_CONFIG_GLOBAL="$DOTDIR/git/gitconfig"
export RUSTC_WRAPPER="$(which sccache)"

# Personal paths and variables
export GH="https://github.com/"
export NOTES="$HOME/notes"
export TODOFILE="$NOTES/todo.md"


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
