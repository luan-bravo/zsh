# aliases by luan-brav0

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

# exa aliases - ls made with rust
alias x="exa -l -h -n -s='type' --icons"
alias xa="x -a"
alias xt="x -T"
alias xta="xa -T"

# Fix overscan (when using old HDMI TV as monitor)
alias osfix="xrandr --output HDMI-A-0 --set underscan on & xrandr --output HDMI-A-0 --set 'underscan hborder' 80 --set 'underscan vborder' 40"

# iwd wifi manager aliases
alias iwpower="rfkill unblock all && iwctl device wlan0 set-property Powered on"
alias iwshow="iwctl station wlan0 show"
alias iwscan="iwctl station wlan0 get-networks"
alias huebr="setxkbmap br"
alias merica="setxkbmap us"
alias inter="setxkbmap -layout us -variant intl"

# easy access to frequently modified confi files
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


# note taking
mknote() {
    echo "# TITLE: $1\n\n# DATE: $(date +"%y/%m/%d")\n\n# TIME: $(date +"%H:%M")\n" >> ./"$(date +"%y%m%d%H%M")--$1".md
    nvim ./"$(date +"%y%m%d%H%M")--$1".md
}


# push todo strings to todoFile (it was a very good source of shell scripting learning for me)
todo() {
    # set default global todofile or custom with '-f' flag
    local todoFile="$TODOFILE"
    while getopts "f:" opt; do
        case $opt in
            f)
                todoFile="$OPTARG"
            ;;
            \?) echo "Invalid option: -$OPTARG" ;;
        esac
        # takes the flag argument out of the arg array
        shift $((OPTIND - 1))
    done

    # if todoFile doesn't exists, create it
    if [[ ! -f "$todoFile" ]]; then
        echo "${yellow}No file $todoFile currently exists. Touching todoFile.${nc}"
        touch "$todoFile"
    fi
    # adds a new line if there are already other todos in file
    if [[ -s "$todoFile" ]]; then
        echo "" >> "$todoFile"
    fi

    # MAIN LOOP
    for arg in "$@"; do
        if echo "- [ ] $arg" >> "$todoFile"; then
            ((added++))
        else
            echo "todo: ${red}Error when trying to 'echo $arg' to $todoFile.${nc}"
        fi
    done


    # Total incomplete todos
    local todoCount=$(grep -v -i '^[[:space:]]*- \[[xX]\]' "$todoFile" | grep -v '^[[:space:]#]*$' | tee "$todoFile" | wc -l)
    if $added; then
        echo "todo: ${green}$added todos added out of $#! Total incomplete todos: $todoCount.${nc}"
    else
        echo "todo: ${red} No new todos added! Total incomplete todos: $todoCount.${nc}"
    fi
}


idf() {
    if [ ! -x "$(command -v idf.py)" ]; then
        echo "no idf.py"
        if [ -z "$IDF_PATH" ] && [ -d "/opt/esp-idf" ]; then
            echo "no idf_path"
            export IDF_PATH="/opt/esp-idf"
            source "$IDF_PATH/export.sh"
        else
            echo "Error: '/opt/esp-idf/' not found."
        fi
        # TODO: wtf is this line doing inside and ouside of the if statement? what crack was I smoking?
        source "$IDF_PATH/export.sh"
    fi
    idf.py $@
}


potp() {
    pass otp $1
}
