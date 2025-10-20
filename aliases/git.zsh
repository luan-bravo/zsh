# git
alias gap="git add -p"
unalias gaa 2> /dev/null
gaa() {
	if [[ "$#" -ne 0 ]]; then
		git add "$@"
	else
		githere git add
	fi
}

alias gs="git status --short"
alias gsv="git status --show-stash"
alias gsvv="gsv --verbose"

alias gc="git commit --verbose"
alias gcs="git commit"
alias gcamd="gc --amend"
alias gcm="git commit -m"
alias gcam="git commit -am"

alias gp="git push"


unalias grst 2> /dev/null
alias grst="githere git restore --staged"
unalias grs 2> /dev/null
alias grs="githere git restore"

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

alias gsubup="git submodule sync && git submodule update --remote"
#
# `git submodule foreach` with alias expansion
gsufe() {
	local cmd="$*"
	local expanded=""

	local -A aliases
	while read line; do
		local name="${line%%=*}"
		local val="${line#*=}"
		val="${val#[\'\"]}"; val="${val%[\'\"]}"
		aliases[$name]="$val"
	done < <(alias)

	# Expand each word if it's an alias
	for word in ${=cmd}; do
		if [[ -n "${aliases[$word]}" ]]; then
			expanded+="${aliases[$word]} "
		else
			expanded+="$word "
		fi
	done

	[[ -n "$VERBOSE" ]] && echo "Running: $expanded" >&2

	git submodule foreach "${expanded% }"
}
alias gsufev='VERBOSE=1 gsufe'
