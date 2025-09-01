# Easy access to frequently modified config files
editproj() {
    if [[ $# -ne 1 ]] || [[ ! -d $1 ]]; then
        ec ${yellow} "usage: editproj ${green}</path/to/project>{color}" && return 1
    fi
    nvim -c "cd $1" $1
}
alias zshconfig="editproj $zdotdir"
alias zconfig="zshconfig"
alias zconf="zconfig"

alias nvimconfig="editproj $dotdir/nvim"
alias nvimconf="nvimconfig"
alias nvconf="nvimconfig"
alias nvconfig="nvimconfig"
alias vconf="nvimconfig"
alias vconfig="nvimconfig"
alias hyprconfig="editproj $dotdir/hypr"
alias hconfig="editproj $dotdir/hypr"
alias hconf="editproj $dotdir/hypr"

alias barconfig="editproj $dotdir/waybar"
alias barconf="editproj $dotdir/waybar"
alias wbconf="editproj $dotdir/waybar"
alias bconf="editproj $dotdir/waybar"

alias wezconfig="editproj $dotdir/wezterm"
alias termconfig="wezconfig"
alias wezconf="termconfig"
alias tconf="termconfig"
