# git
alias gap="git add -p"
unalias gaa
gaa() {
    if [[ "$#" -ne 0 ]]; then
        git add "$@"
    else
        dohere git add
    fi
}

alias gs="git status --short"
alias gsv="git status"
alias gsvv="git status --verbose"

alias gc="git commit --verbose"
alias gcs="git commit"
alias gcm="git commit -m"
alias gcam="git commit -am"
alias gcamd="git commit --amend"

alias gp="git push"

alias gcl="git clone --recurse-submodules"

alias gsubup="git submodule sync && git submodule update --remote"


unalias grst
alias grst="dohere git restore --staged"
unalias grs
alias grs="dohere git restore"


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
