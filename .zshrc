if [ ! -d "$ZDOTDIR/ohmyzsh" ]; then
    git clone https://github.com/ohmyzsh/ohmyzsh.git $ZDOTDIR/ohmyzsh
fi
export ZSH="$ZDOTDIR/ohmyzsh"
export ZSH_CUSTOM="$ZDOTDIR/custom"

export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

export ANDROID_HOME=$HOME/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/platform-tools

# Fly.io
export FLYCTL_INSTALL="/home/lul/.fly"
export PATH="$FLYCTL_INSTALL/bin:$PATH"
ZSH_THEME="gruvbox"
SOLARIZED_THEME="dark"
zstyle ':omz:update' mode auto
ENABLE_CORRECTION="true"
plugins=(
    git
    z
)

source $ZSH/oh-my-zsh.sh
if [[ -n $SSH_CONNECTION ]]; then
    export EDITOR='nvim'
else
    export EDITOR='vim'
fi

alias zshconfig="nvim $ZDOTDIR/.zshrc"
alias zconfig="nvim ~/.config/zsh/.zshrc"
alias ohmyzsh="nvim $ZSH/oh-my-zsh.sh"
alias nvimconfig="nvim ~/.config/nvim"

# Clean your room
alias c="clear"
alias q="exit"

alias stdn="shutdown now"
alias il="i3lock"

alias py="python"
alias ino="arduino-cli"

# not that great. nvim ftw
# alias hx="helix"

alias gaa="git add -A"
alias gap="git add -p"
alias gs="git status"
alias gc="git commit"
alias gcm="git commit -m"
alias gcam="git commit -am"
alias gp="git push"
alias gcl= "git clone"
alias gclr= "git clone --recurse-submodules"

# Fix overscan (when using old HDMI TV as monitor)
alias osfix="xrandr --output HDMI-A-0 --set underscan on & xrandr --output HDMI-A-0 --set 'underscan hborder' 80 --set 'underscan vborder' 40"

# iwd wifi manager aliases
alias iwpower="rfkill unblock all && iwctl device wlan0 set-property Powered on"
alias iwshow="iwctl station wlan0 show"
alias iwscan="iwctl station wlan0 get-networks"

# exa aliases - rust based ls like
alias x="exa -l -h -n -s='type' --icons"
alias xt="exa -l -h -n -T -s='type' --icons"
alias xa="exa -l -a -h -n -s='type' --icons"
alias xta="exa -l -a -h -n -T -s='type' --icons"

alias huebr="setxkbmap br"
alias merica="setxkbmap us"
alias inter="setxkbmap -layout us -variant intl"


# sync existing git repository
gsync (){
    git add -p
    git commit
    git push
}
# `pass otp` alias

potp () {
    pass otp $1
}

# Personal Sripts
mknote () {
    echo "# TITLE: $1\n\n# DATE: $(date +"%y/%m/%d")\n\n# TIME: $(date +"%H:%M")\n" >> ./"$(date +"%y%m%d%H%M")--$1".md
    nvim ./"$(date +"%y%m%d%H%M")--$1".md
}


# Fix del key (set as ^H)
bindkey "^H" delete-char

# Fix backspace key (set as ^H)
bindkey "^M" accept-line

if [ -d "$HOME/.local/share/adb-fastboot/platform-tools" ] ; then
    export PATH="$HOME/.local/share/adb-fastboot/platform-tools:$PATH"
fi

# MUST REMAIN AT END!
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null
export PNPM_HOME="/home/lul/.local/share/pnpm"
case ":$PATH:" in
    *":$PNPM_HOME:"*) ;;
    *) export PATH="$PNPM_HOME:$PATH" ;;
esac
if [ -s "/home/lul/.bun/_bun" ]; then
    source "/home/lul/.bun/_bun"
fi
if [ -d "$PWD/esp-idf" ] || [ -f "$PWD/sdkconfig" ]; then
    if [ -z "$IDF_PATH" ]; then
      echo "Sourcing ESP-IDF..."
      source ~/esp/esp-idf/export.sh
    fi
fi

