# git
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




unalias gr
alias gr="dohere git restore"

unalias grst
alias grst="dohere git restore --staged"

unalias gr
alias grs="dohere git restore --staged"

unalias gaa
gaa() {
    { [[ "$#" -ne 0 ]] && git add "$@" } || git add $(pwd)
    }

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
