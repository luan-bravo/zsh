# System and shell
alias c="clear" # Clean your room
alias q="exit"
alias stdn="shutdown now"
alias f="fg"
alias xzsh="exec zsh"
alias nv="nvim"
alias v="nvim"
alias il="i3lock"
alias py="python"
alias ino="arduino-cli"
# Fix overscan (when using old HDMI TV as monitor)
alias osfix="xrandr --output HDMI-A-0 --set underscan on & xrandr --output HDMI-A-0 --set 'underscan hborder' 80 --set 'underscan vborder' 40"
# IWD Wi-Fi manager aliases
alias iwpower="rfkill unblock all && iwctl device wlan0 set-property Powered on"
alias iwshow="iwctl station wlan0 show"
alias iwscan="iwctl station wlan0 get-networks"
# Keyboard layouts
alias huebr="setxkbmap br"
alias merica="setxkbmap us"
alias inter="setxkbmap -layout us -variant intl"


echocol() {
    #TODO: accept multiple strings
    if [[ $# -ne 2 ]]; then
        echo "${blue}Usage: echocol <color> <string>\n       add '{COLOR}' to the string if you wish to scape back to the given color${nc}"
        return -1
    fi
    if [[ -n $1 ]] || (( $colors[(Ie)$1] )); then
        if [[ -z $clr ]]; then
            local clr="$1"
        fi
    else
        echo "${red}please insert a valid color from array \$colors${nc}"
        return 1
    fi
    # last color
    local text="${2/\{COLOR\}/${clr}}"
    echo "${clr}${text}${nc}"
}
alias ec="echocol"

del() {
    if [[ -n $TRASH ]]; then
        $trash=$TRASH
    else
        export trash="$HOME/.trash"
    fi
    if [[ -d "$trash" ]]; then
        throwaway() {
            # TODO: create/rename to another file/dir if there is already a file with the same name in .trash
            mv "$1" "$2" || {
                ec ${red} "Failed to move ${green}$1{COLOR} into ${green}$2{COLOR}."
                return 1
            }
        }
        throwaway $* $trash
    else
        ec ${red} "Directory ${green}${trash}{COLOR} does not exist."
        ec ${yellow} "Creating ${green}${trash}{COLOR}..."
        md $trash || {
            ec ${red} "Failed to create ${green}${trash}{COLOR}."
            return 1
        }
        throwaway $* $trash
    fi
}

# Git
alias gaa="git add -A"
alias gap="git add -p"
alias gs="git status --short"
alias gsv="git status"
alias gsvv="git status --verbose"
alias gc="git commit --verbose"
alias gcs="git commit"
alias gcm="git commit -m"
alias gcam="git commit -am"
alias gp="git push"
alias gcl="git clone --recurse-submodules"
alias gsubup="git submodule sync && git submodule update --remote"
gsync() {
    gap && gc && gp
}
gclgh() {
    if [[ "$1" == *"/"* ]]; then
        gcl "https://github.com/$1"
    else
        gcl "https://github.com/luan-bravo/$1"
    fi
}

# eza aliases (formerly for exa) - ls made with rust and a much nicer
alias x="eza -lhn -s='type' --icons"
alias ll="x"
alias xa="x -a"
alias l="xa"
alias xt="x -T"
alias xta="xa -T"
alias xtd="xa -TD"

# Easy access to frequently modified config files
editproj() {
    if [[ $# -ne 1 ]] || [[ ! -d $1 ]]; then
        ec ${yellow} "usage: editproj ${green}</path/to/project>{COLOR}" && return 1
    fi
    nvim -c "cd $1" $1
}
alias zshconfig="editproj $ZDOTDIR"
alias zconfig="zshconfig"
alias zconf="zconfig"
alias nvimconfig="editproj $DOTDIR/nvim"
alias nvimconf="nvimconfig"
alias nvconf="nvimconfig"
alias nvconfig="nvimconfig"
alias vconf="nvimconfig"
alias vconfig="nvimconfig"

# Note taking
mknote() {
    echo "# TITLE: $1\n\n# DATE: $(date +"%y/%m/%d")\n\n# TIME: $(date +"%H:%M")\n" \
        >> ./"$(date +"%y%m%d%H%M")--$1".md
    nvim ./"$(date +"%y%m%d%H%M")--$1".md
}

# Push todo strings to todoFile (it was a very good source of shell scripting learning for me)
todo() {
    # Set default global todofile or custom with '-f' flag
    local todoFile="$TODOFILE"
    while getopts "f:" opt; do
        case $opt in
            f)
                todoFile="$OPTARG"
            ;;
            \?) echo "Invalid option: -$OPTARG" ;;
        esac
        # Takes the flag argument out of the arg array
        shift $((OPTIND - 1))
    done
    # If todoFile doesn't exists, create it
    if [[ ! -f "$todoFile" ]]; then
        ec ${yellow} "No file $todoFile currently exists. Touching todoFile."
        touch "$todoFile"
    fi
    # Adds a new line if there are already other todos in file
    if [[ -s "$todoFile" ]]; then
        echo "" >> "$todoFile"
    fi
    # MAIN LOOP
    for arg in "$@"; do
        if echo "- [ ] $arg" >> "$todoFile"; then
            ((added++))
        else
            ec ${red} "todo: Error when trying to 'echo $arg' to $todoFile."
        fi
    done
    # Total incomplete todos
    local todoCount=$(grep -c -v '^[[:space:]#]*$' "$todoFile")
    # Echo staturs
    if [[ $added -gt 0 ]]; then
        ec ${green} "todo: $added todos added out of $#! Total incomplete todos: $todoCount."
        return 0
    elif [[ $added -st $# ]]; then
        ec ${yellow} "todo: $added todos added out of $#! Total incomplete todos: $todoCount."
        return 1
    else
        ec ${red} "todo:  No new todos added! Total incomplete todos: $todoCount."
        return 1
    fi
}

potp() {
    [[ $# -ne 1 ]] && {
        ec ${red} "potp: Please provide (only) one argument" && return 1
    }
    pass otp "$1"
}

# TODO: Check if this still is necessary or if just the alias is enough
# Exporting and sourcing added to $ZSH_CUSTOM/exports.zsh file
alias idf="idf.py"
: << 'IDF'
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
    idf.py "$*"
}
IDF
