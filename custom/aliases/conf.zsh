# Easy access to frequently modified config files
editproj() {
    if [[ $# -ne 1 ]] || [[ ! -d $1 ]]; then
        echocol ${yellow} "usage: editproj ${green}</path/to/project>{color}" && return 1
    fi
    nvim -c "cd $1" $1
}

alias zconf="editproj $ZDOTDIR"

alias vconf="editproj $DOTDIR/nvim/lua/lul"

alias hconf="editproj $DOTDIR/hypr"

alias bconf="editproj $DOTDIR/waybar"

alias tconf="editproj $DOTDIR/wezterm"
