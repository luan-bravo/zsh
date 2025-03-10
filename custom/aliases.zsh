# aliases by luan-brav0

# easy config files
zshconfig() {
    pushd $ZDOTDIR > /dev/null
    nvim .
    popd > /dev/null
}
alias zconfig="zshconfig"
# alias nvimconfig="nvim $HOME/config/nvim"
nvimconfig() {
    pushd $DOTFILES/nvim > /dev/null
    nvim .
    popd > /dev/null
}

alias c="clear" # Clean your room
alias q="exit"
alias f="fzf"

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

gsync (){
    git add -p
    git commit
    git push
}

gsubsinit(){
    for dir in */; do
      if git -C "$dir" rev-parse 2>/dev/null; then
        url=$(git -C "$dir" config --get remote.origin.url)
        if [ -n "$url" ]; then
            git submodule add --force "$url" "$dir"
        fi
      fi
    done
    git submodule update --init
}

# exa aliases - ls made with rust
alias x="exa -l -h -n -s='type' --icons"
alias xt="exa -l -h -n -T -s='type' --icons"
alias xa="exa -l -a -h -n -s='type' --icons"
alias xta="exa -l -a -h -n -T -s='type' --icons"

# Fix overscan (when using old HDMI TV as monitor)
alias osfix="xrandr --output HDMI-A-0 --set underscan on & xrandr --output HDMI-A-0 --set 'underscan hborder' 80 --set 'underscan vborder' 40"

# iwd wifi manager aliases
alias iwpower="rfkill unblock all && iwctl device wlan0 set-property Powered on"
alias iwshow="iwctl station wlan0 show"
alias iwscan="iwctl station wlan0 get-networks"
alias huebr="setxkbmap br"
alias merica="setxkbmap us"
alias inter="setxkbmap -layout us -variant intl"

potp () {
    pass otp $1
}

mknote () {
    echo "# TITLE: $1\n\n# DATE: $(date +"%y/%m/%d")\n\n# TIME: $(date +"%H:%M")\n" >> ./"$(date +"%y%m%d%H%M")--$1".md
    nvim ./"$(date +"%y%m%d%H%M")--$1".md
}

idf () {
    if [ ! -x "$(command -v idf.py)" ]; then
        echo "no idf.py"
        if [ -z "$IDF_PATH" ] && [ -d "/opt/esp-idf" ]; then
            echo "no idf_path"
            export IDF_PATH="/opt/esp-idf"
            source "$IDF_PATH/export.sh"
        else
            echo "Error: '/opt/esp-idf/' not found."
        fi
        source "$IDF_PATH/export.sh"
    fi
    idf.py $@
}
