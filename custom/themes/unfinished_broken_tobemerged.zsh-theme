setopt localoptions glob nullglob

local -A char
() {
	local LC_ALL='' LC_CTYPE='en_US.UTF-8'
	local single_separator=$'¦'
	char=(
		[LEFT_SEPARATOR]="$single_separator"
		[RIGHT_SEPARATOR]="$single_separator"
		[GIT_BRANCH]=$'\ue0a0' # 
		[GIT_REF_SHORT]=$'\u21b3' # ↳
		[GIT_STAGEDSTR]=$'\u271a' # ✚
		[GIT_UNSTAGEDSTR]=$'\u25cf' # ●
		[GIT_MODIFIED]=$'\uf044' # 
		[GIT_UNSTAGED]=$'\ueb32' # 
		[GIT_STAGED]=$'\uf046' # 
		[GIT_AHEAD_AND_BEHIND]=$'\u21c5' # ⇅
		[GIT_AHEAD]=$'\u2191' # ↑
		[GIT_BEHIND]=$'\u2193' # ↓
		[OS_LINUX]=$'\ue712' # 
		[OS_ARCH]=$'\uf303' # 󰣇
		[OS_DEBIAN]=$'\uf306' # 󰣚
		[OS_UBUNTU]=$'\uf306' # 
		[OS_NIX]=$'\uf313' # 
		[OS_DARWIN]=$'\ue29e' # 
		[USER_ROOT]=$'\uf0ad' # 
		[SUSPENDED_JOBS]=$'\U000f0637' # 󰘷
	)
}


# set_color() {
# 	local color
# 	[[ ! "$1" ]] \
# 		&& return \
# 		|| color="$1"
# 	[[ "$SET_BG" = true ]] \
# 		&& echo -n "${bg_bold[${color%${BOLD_SUFIX}}]:-${bg[${color}]}}" \
# 		|| echo -n "${fg_bold[${color%${BOLD_SUFIX}}]:-${fg[${color}]}}"
# }
#
# set_fg() { echo -n "$(SET_FG=true)"; }
# set_bg() { echo -n "$()"; }

local PREV_K='NONE' PREV_F='NONE'

prompt_segment() {
	local -r content="$1"
	[[ ! "$content" ]] && return

	local color_f="${2:-default}"
	local color_k="${3:-default}"
	local segment=''

	[[ "$BOLD_F" = true ]]


	if [[ "$RIGHT_SEG" = true ]]; then
		separator="${char[RIGHT_SEPARATOR]}"
		if [[ "$RIGHT_START" = true ]]; then
			segment+="%{%k${fg[color_f]}%}${separator}"
			RIGHT_START=false
		else
			[[ "$separator" && "$PREV_F" != 'NONE' && "$color_f" != "$PREV_F" ]] \
				&& segment+=" %{${bg[$PREV_F]}${fg[$color_k]}%}${separator}" \
				|| segment+="%{${bg[default]}${fg[$color_k]}%}${separator}"
		fi
	else
		separator="${char[LEFT_SEPARATOR]}"
		if [[ "$PREV_F" != 'NONE' && "$PREV_F" != "$color_f" ]]; then
			segment+=" %{${fg[$PREV_F]}%}${separator}"
		fi
	fi

	segment+="%{${bg[$color_k]}${fg[$color_f]}%}"

	[[ "$SEG_START" ]] && segment+="$SEG_START" || segment+=' '
	segment+="$content"
	[[ "$SEG_END" ]] && segment+="$SEG_END" || segment+=' '

	PREV_F="$color_f"
	echo -n "$segment"
}

prompt_end() {
	prompt_segment '$' 'cyan'
}


# TODO: Refactor `prompt_end` and join with `prompt_segment` fn like `rprompt` (possible? Should I? How to detect we are at end and reset `fg` and `bg`?)


prompt_dir() {
	prompt_segment '%~' 'blue'
}


prompt_git() {
	command -v git >/dev/null || return
	git config --get oh-my-zsh.hide-status 2> /dev/null && return
	git rev-parse --is-inside-work-tree > /dev/null 2>&1 || return



	local -r git_dir="$(git rev-parse --git-dir 2> /dev/null)"
	local -r dirty="$(parse_git_dirty)"
	local ref="${$(git symbolic-ref HEAD 2> /dev/null):-${char[GIT_REF_SHORT]}}"
	[[ ! "$ref" ]] && ref="$(git rev-parse --short HEAD 2> /dev/null)"

	local segment=''

	[[ "$ref" ]] && segment=+="${ref/refs\/heads\//${char[GIT_BRANCH]} }"


	local mode
	if [[ -e "$git_dir/BISECT_LOG" ]]; then
		mode=' <B>'
	elif [[ -e "$git_dir/MERGE_HEAD" ]]; then
		mode=' >M<'
	elif [[ -e "$git_dir/rebase" || -e "$git_dir/rebase-apply" || -e "$git_dir/rebase-merge" || -e "$git_dir/../.dotest" ]]; then
		mode=' >R>'
	fi

	setopt promptsubst
	autoload -Uz vcs_info

	zstyle ':vcs_info:*' enable git
	zstyle ':vcs_info:*' get-revision true
	zstyle ':vcs_info:*' check-for-changes true
	zstyle ':vcs_info:*' stagedstr "${char[GIT_STAGEDSTR]}"
	zstyle ':vcs_info:*' unstagedstr  "${char[GIT_UNSTAGEDSTR]}"
	zstyle ':vcs_info:*' formats ' %m'
	zstyle ':vcs_info:*' actionformats ' %m'
	zstyle ':vcs_info:git*+set-message:*' hooks git-st
	vcs_info

	local f="green"
	[[ "$dirty" ]] && f="yellow"

	local stash_count=$(git stash list 2>/dev/null | wc -l | tr -d ' ')

	prompt_segment "|${vcs_info_msg_0_%% }$mode|" "$f"
}

function +vi-git-st {
	local gitstatus=''
	local -a stts=("$(git status --porcelain)")
	gitstatus+="%{${fg[default]}%}"

	# TO QUOTE
	local -a ahead_and_behind=($(git rev-list --left-right --count HEAD...${hook_com[branch]}@{upstream} 2>/dev/null))
	local ahead="${ahead_and_behind[1]}"
	local behind="${ahead_and_behind[2]}"

	if (( "$ahead" )); then
		if (( "$behind" )); then
			gitstatus+=("${char[GIT_AHEAD_AND_BEHIND]}")
		else
			gitstatus+=("${char[GIT_AHEAD]}")
		fi
	elif (( "$behind" )); then
		gitstatus+=("${char[GIT_BEHIND]}") # ↓ behind
	fi

	[[ "$gitstatus" ]] && hook_com[misc]+=' '
	hook_com[misc]+="${(j: :)gitstatus}"
}


prompt_root() {
	[[ "$UID" -eq 0 ]] && prompt_segment "(${char[USER_ROOT]})" "yellow_bold"
}


prompt_errors() {
	local rv
	case "$retval" in
		0) ;; # Success
		148|141) ;; # Suspend job | Resume Job
		130)
			rv="!" ;; # (^C)anceled
		*)
			rv="$retval" ;; # fallback: echo $?
	esac
	prompt_segment "$rv" "red_bold"
}
 

prompt_jobs() {
	local -i ij=0
	for j in $jobstates; do [[ "$j" = "suspended"* ]] && (( $ij++ )); done

	local jbs
	(( "$ij" > 0 )) && jbs+="${char[SUSPENDED_JOBS]} "
	(( "$ij" > 1 )) && jbs+="$ij"

	prompt_segment "$jbs" 'cyan'
}

build_prompt() {
	local retval="$?"
	# TODO: Move errors on right prompt and add $HOST to left prompt
	prompt_errors
	# BG_JOBS="${#${(M)jobstates:#suspended\:*:*}}"
	prompt_jobs
	prompt_dir
	prompt_git
	prompt_root
	prompt_end
}



prompt_clock() {
	[[ "$hour" ]] && prompt_segment "$hour" 'white'
}

prompt_os() {
	local icon f
	case "$OSTYPE" in
		'linux'*)
			local os_release='/etc/os-release'
			local distro
			[[ -s "$os_release" ]] && source "$os_release" \
				&& distro="$NAME" \
				|| return
			case "$distro" in
				'Arch'*)
					f='blue' icon="${char[OS_ARCH]}" ;; # 󰣇
				'debian'*)
					f='red' icon="${char[OS_DEBIAN]}" ;; # 󰣚
				'ubuntu'*)
					f='red_bold' icon="${char[OS_UBUNTU]}" ;; # 
				'nix'*)
					f='cyan_bold' icon="${char[OS_NIX]}" ;; # 
				*)
					f='default' icon="${char[OS_LINUX]}" ;; # 
			esac ;;
		'darwin'*)
			f='default' icon="${char[OS_DARWIN]}" ;; # 
		*)
			return ;;
	esac
	local os="$icon"
	prompt_segment "$os" "$f" 'gray'
}


build_rprompt() {
	local RIGHT_SEG=true
	local hour="$(date '+%H:%M:%S')"
	prompt_clock
	prompt_os
	echo -n "%{ %}"
}


PROMPT='%{%f%b%k%}$(build_prompt)%{%f%b%k%}'
RPROMPT='%{%f%b%k%}$(build_rprompt)%{%f%b%k%}'
# TODO: fix RPROMPT='%{%f%b%k%}$(build_rprompt)%{%f%b%k%}'

### [COLORS]
## 0-14 colors based on the color scheme of your terminal
# 0 black
# 1 red
# 2 green
# 3 yellow
# 4 blue
# 5 purple
# 6 green
# 7 default
# 8 black_bold
# 9 red_bold
# 10 green_bold
# 11 yellow_bold
# 12 blue_bold
# 13 magenta_bold
# 14 cyan_bold
# 15 white_bold
#
# 16 0,0,0 black
## + other more specific shades shades...
