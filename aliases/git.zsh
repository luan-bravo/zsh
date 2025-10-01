# git
alias gap="git add -p"
unalias gaa 2> /dev/null
gaa() {
	if [[ "$#" -ne 0 ]]; then
		git add "$@"
	else
		dohere git add
	fi
}

alias gs="git status --short"
alias gsv="git status --show-stack"
alias gsvv="gsv --verbose"

alias gc="git commit --verbose"
alias gcs="git commit"
alias gcamd="gc --amend"
alias gcm="git commit -m"
alias gcam="git commit -am"

alias gp="git push"

alias gsubup="git submodule sync && git submodule update --remote"

unalias grst 2> /dev/null
alias grst="dohere git restore --staged"
unalias grs 2> /dev/null
alias grs="dohere git restore"

alias gcl="git clone --recurse-submodules"
gclgh() {
	if [[ "$1" = *"/"* ]]; then
		gcl "https://github.com/$1"
	else
		gcl "https://github.com/luan-bravo/$1"
	fi
}

alias gd="git diff"
alias glogv="git log --graph"
alias glogav="git log --all --graph"
alias glog="git log --oneline --graph"
alias gloga="git log --oneline --graph --all"
