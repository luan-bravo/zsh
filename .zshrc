# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$ZDOTDIR/ohmyzsh"
export ZSH_CUSTOM="$ZDOTDIR/custom"

export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

#Android 
export ANDROID_HOME=$HOME/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/platform-tools

# Fly.io
export FLYCTL_INSTALL="/home/lul/.fly"
export PATH="$FLYCTL_INSTALL/bin:$PATH"

# set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="gruvbox"
SOLARIZED_THEME="dark"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# style ':omz:update' frequency 15

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
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
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  z
)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='nvim'
else
  export EDITOR='vim'
fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
alias q="exit"
alias py="python"
alias zshconfig="nvim $ZDOTDIR/.zshrc"
alias ohmyzsh="nvim $ZSH/oh-my-zsh.sh"
# Better and easier than nvim
# alias hx="helix"
# Clean your room
alias c="clear"
# Let get this over with
alias gs="git status"
alias gaa="git add -A"
alias gcm="git commit -m"
alias gpm="git push"
# Fix overscan (when using old HDMI TV as monitor)
alias osfix="xrandr --output HDMI-A-0 --set underscan on & xrandr --output HDMI-A-0 --set 'underscan hborder' 80 --set 'underscan vborder' 40"
alias x="exa -l -h -n -s='type' --icons"
alias xt="exa -l -h -n -T -s='type' --icons"
alias xa="exa -l -a -h -n -s='type' --icons"
alias xta="exa -l -a -h -n -T -s='type' --icons"
alias py="python"
alias pacman="pacman --color=auto"
alias yay="yay --color=auto"
alias paru="paru --color=auto"
alias ala="alacritty; clear"
alias gap="git add -p"

# `pass otp` alias
potp () {
  pass otp $1
}

# Personal Sripts
mknote () {
  echo "# TITLE: $1\n\n# AUTHOR: luan-brav0\n\n# DATE: $(date +"%y/%m/%d")\n\n# TIME: $(date +"%H:%M")\n" >> ./"$(date +"%y%m%d%H%M")--$1".md
  nvim ./"$(date +"%y%m%d%H%M")--$1".md
}

# sync existing git repository
gsync (){
  git add -p
  git commit $1
  git push
}

# Fix del key (set as ^H)
#
bindkey "^H" delete-char
# Fix backspace key (set as ^H) 
bindkey "^M" accept-line

if [ -d "$HOME/.local/share/adb-fastboot/platform-tools" ] ; then
  export PATH="$HOME/.local/share/adb-fastboot/platform-tools:$PATH"
fi

# MUST REMAIN LAST! : ZSH Highlighting
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null

# MUST REMAIN LAST!
# pnpm
export PNPM_HOME="/home/lul/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

