dohere() {
    if [[ "$#" -eq 0 ]]; then
        echo "[dohere] USAGE: dohere <command> [args]"
        echo "[dohere] if no arguments are provided, the command is ran as \`<command> \$(pwd)\`"
        return
    fi

    local cmd="$@"
    for arg in $cmd; do
        if [[ -e "${arg}" ]]; then
            echo "[dohere] found valid path '${arg}' in args"
            "$@"
            return
        fi
    done

    if [[ "$1" = "git" ]]; then
        set -- "$@" "$(git rev-parse --show-toplevel || echo '.')"
        $@ $(git rev-parse --show-toplevel)
        return

    else
        set -- "$@" "."
        return
    fi
    echo "[dohere] cmd: '${cmd}'"
}


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

# note taking
mknote() {
    [[ $# -gt 1 ]] && ec "${red}" "[mknote]: Too many arguments. Provide just a note name or no arguments."
    local date="$(date +%y%m%d)"
    local time="$(date +%H%M)"
    local fileName="${date}${time}"
    [[ -n "$1" ]] && fileName+="--$1"
    fileName+=".md"
    echo "# TITLE: $1\n# DATE: ${date}\n# TIME: ${time}\n\n" \
        >> "./${fileName}"
    nvim "./${fileName}"
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


# TODO: Check if this still is necessary or if just the alias is enough
# Exporting and sourcing added to $ZSH_CUSTOM/exports.zsh file
alias idf="idf.py"
: << 'IDF'
idf() {
    if [ ! -x "$(command -v idf.py)" ]; then
        echo "no idf.py"
        if [ -z "$IDF_PATH" ] && [ -d "/opt/esp-idf" ]; then
            echo "no IDF_PATH"
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
