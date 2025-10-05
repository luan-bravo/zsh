CURRENT_BG='NONE'

### Colors
## 0-14 colors based on the color scheme of your terminal
# 0 black
# 1 red
# 2 green
# 3 yellow
# 4 blue
# 5 purple
# 6 dark green
# 7 light gray
# 8 dark gray
# 9 orange
# 10 light green
# 11 light yellow
# 12 light blue
# 13 light pink
# 14 light green / teal
# 15 FF,FF,FF white
# 16 0,0,0 black
## + other more specific shades shades...


case "${SOLARIZED_THEME:-dark}" in
		light) CURRENT_FG='3';;
		*)     CURRENT_FG='0';;
esac

() {
	local LC_ALL="" LC_CTYPE="en_US.UTF-8"
}

prompt_segment() {
	CURRENT_BG="$1"
	local bg fg
	[[ -n "$1" && -n "$2" ]] \
		&& echo -n "%{%K{$1}%F{$2}%}" \
		|| echo -n "%{%k%f%}"
	echo -n " $3 "
}

prompt_dir() {
	prompt_segment 4 "$CURRENT_FG" '%~'
}

prompt_git() {
	(( "$+commands[git]" )) \
		|| return

	[[ "$(git config --get oh-my-zsh.hide-status 2>/dev/null)" = 1 ]] \
		&& return

	local PL_BRANCH_CHAR
	() {
		local LC_ALL="" LC_CTYPE="en_US.UTF-8"
		PL_BRANCH_CHAR=$'\ue0a0' # 
	}

	local ref dirty mode repo_path
	# TO QUOTE
	$(git rev-parse --is-inside-work-tree >/dev/null 2>&1) && {
		repo_path="$(git rev-parse --git-dir 2>/dev/null)"
		dirty="$(parse_git_dirty)"
		ref="$(git symbolic-ref HEAD 2> /dev/null)" \
			|| ref="➦ $(git rev-parse --short HEAD 2> /dev/null)"

		[[ -n "$dirty" ]] && {
			prompt_segment 3 0
		} || {
			prompt_segment 2 "$CURRENT_FG"
		}

		[[ -e "${repo_path}/BISECT_LOG" ]] && {
			mode=" <B>"
		} || [[ -e "${repo_path}/MERGE_HEAD" ]] && {
			mode=" >M<"
		} || [[ -e "${repo_path}/rebase" || -e "${repo_path}/rebase-apply" || -e "${repo_path}/rebase-merge" || -e "${repo_path}/../.dotest" ]] && {
			mode=" >R>"
		}

		setopt promptsubst
		autoload -Uz vcs_info

		zstyle ':vcs_info:*' enable git
		zstyle ':vcs_info:*' get-revision true
		zstyle ':vcs_info:*' check-for-changes true
		zstyle ':vcs_info:*' stagedstr '✚'
		zstyle ':vcs_info:*' unstagedstr '●'
		zstyle ':vcs_info:*' formats ' %m'
		zstyle ':vcs_info:*' actionformats ' %m'
		zstyle ':vcs_info:git*+set-message:*' hooks git-st

		vcs_info
		echo -n "${ref/refs\/heads\//$PL_BRANCH_CHAR }${vcs_info_msg_0_%% }${mode}"
	}
}

function +vi-git-st() {
	local -a gitstatus
	local -a stat=("$(git status --porcelain)")

	local -a modified=($(echo "$stat" | grep '^.M' | wc -l))
	(( "$modified" )) \
		&& gitstatus+=("%{\033[30m%}${modified}\uf044")
	local -a staged=($(echo "$stat" | grep '^[AM]' | wc -l))
	(( "$staged" )) \
		&& gitstatus+=("%{\033[30m%}${staged}\uf046")
	local -a untracked=($(echo "$stat" | grep '^??' | wc -l))
	(( "$untracked" )) \
		&& gitstatus+=("%{\033[30m%}${untracked}\ueb32")

	# TO QUOTE
	local -a ahead_and_behind=($(git rev-list --left-right --count HEAD...${hook_com[branch]}@{upstream} 2>/dev/null))
	local ahead="${ahead_and_behind[1]}"
	(( "$ahead" )) \
		&& gitstatus+=('')
	local behind="${ahead_and_behind[2]}"
	(( "$behind" )) \
		&& gitstatus+=('')

	[[ -n "$gitstatus" ]] \
		&& hook_com[misc]+=' '
	hook_com[misc]+="${(j: :)gitstatus}"
}

prompt_root() {
	[[ "$UID" -eq 0 ]] \
		&& prompt_segment 11 0 "\uf0ad"
}

prompt_errors() {
	# [[ $(jobs -l | wc -l) -gt 0 ]] && errors+="%{%F{15}%}󰘷" #󰘷
	[[ "$RETVAL" -gt 0 ]] \
		&& prompt_segment 1 15 "$RETVAL"
}

prompt_jobs() {
	local -a jbs
	# TODO: Count jobs properly
	# "$(jobs -s | wc -l)" doesn't work and has a weird behavior and only returns the right amount if not in the directory of the first suspended jobs (???)
	local bg_jobs=${#${(M)jobstates:#suspended\:*:*}}
	[[ "$BG_JOBS" -ne 0 ]] && {
		jbs+="󰘷 "
		[[ "$BG_JOBS" -ge 1 ]] \
			&& jbs+="$BG_JOBS"
	}
	[[ -n "$jbs" ]] \
		&& prompt_segment 14 0 "$jbs"
}

build_prompt() {
	local RETVAL="$?"
	prompt_errors
	prompt_jobs
	prompt_dir
	prompt_git
	prompt_root
}


rprompt_segment() {
	prompt_segment $@
}


rprompt_clock() {
	[[ -n "$hour" ]] \
		&& rprompt_segment 0 7 "$hour"
}

rprompt_os() {
	[[ -s /etc/os-release ]] \
		&& local distro=$(. /etc/os-release && echo "$NAME" || echo "")
	local icon color
	case "$OSTYPE" in
		linux*)
			case "$distro" in
				Arch*)
					color=4
					icon=$'\uf303' ;; # 󰣇
				debian*)
					color=1
					icon=$'\uf306' ;; # 󰣚
				ubuntu*)
					color=5
					icon=$'\uf306' ;; # 
				nix*)
					color=12
					icon=$'\uf313' ;; # 
				*)
					color=15
					icon=$'\ue712' ;; # 
			esac ;;
		darwin*)
			color=7
			icon=$'\ue29e' ;; # 
		*)
			return ;;
	esac
	local os="%{%F{$color}%}$icon%{ %}"
	[[ -n "$os" ]] \
		&& rprompt_segment 237 "%k" "$os"
}

build_rprompt() {
	hour="$(date '+%H:%M:%S')"
	rprompt_clock
	rprompt_os
}

PROMPT='%{%f%b%k%}$(build_prompt)%{%f%b%k%} '
RPROMPT=' $(build_rprompt)%{%f%b%k%}'
