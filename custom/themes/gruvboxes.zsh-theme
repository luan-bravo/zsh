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


case ${SOLARIZED_THEME:-dark} in
		light) CURRENT_FG='3';;
		*)	 CURRENT_FG='0';;
esac

() {
	local LC_ALL="" LC_CTYPE="en_US.UTF-8"
	SEGMENT_SEPARATOR=$' ' # 
	RIGHT_SEPARATOR=$' '	 # 
}

prompt_segment() {
	local bg fg
	[[ -n $1 ]] && bg="%K{$1}" || bg="%k"
	[[ -n $2 ]] && fg="%F{$2}" || fg="%f"
	if [[ $CURRENT_BG != 'NONE' && $1 != $CURRENT_BG ]]; then
		echo -n " %{$bg%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR%{$fg%} "
	else
		echo -n "%{$bg%}%{$fg%} "
	fi
	CURRENT_BG=$1
	[[ -n $3 ]] && echo -n $3
}

prompt_end() {
	if [[ -n $CURRENT_BG ]]; then
		echo -n " %{%k%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR"
	else
		echo -n "%{%k%}"
	fi
	echo -n "%{%f%}"
	CURRENT_BG='NONE'
}


prompt_dir() {
	prompt_segment 4 $CURRENT_FG '%~'
}

prompt_git() {
	(( $+commands[git] )) || return
	if [[ "$(git config --get oh-my-zsh.hide-status 2>/dev/null)" = 1 ]]; then
		return
	fi
	local PL_BRANCH_CHAR
	() {
		local LC_ALL="" LC_CTYPE="en_US.UTF-8"
		PL_BRANCH_CHAR=$'GIT:'		 # 
	}
	local ref dirty mode repo_path

	if $(git rev-parse --is-inside-work-tree >/dev/null 2>&1); then
		repo_path=$(git rev-parse --git-dir 2>/dev/null)
		dirty=$(parse_git_dirty)
		ref=$(git symbolic-ref HEAD 2> /dev/null) || ref="➦ $(git rev-parse --short HEAD 2> /dev/null)"
		if [[ -n $dirty ]]; then
			prompt_segment 3 0
		else
			prompt_segment 2 $CURRENT_FG
		fi

		if [[ -e "${repo_path}/BISECT_LOG" ]]; then
			mode=" <B>"
		elif [[ -e "${repo_path}/MERGE_HEAD" ]]; then
			mode=" >M<"
		elif [[ -e "${repo_path}/rebase" || -e "${repo_path}/rebase-apply" || -e "${repo_path}/rebase-merge" || -e "${repo_path}/../.dotest" ]]; then
			mode=" >R>"
		fi

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
	fi
}

function +vi-git-st() {
	local ahead behind
	local -a gitstatus
	local -a ahead_and_behind=($(git rev-list --left-right --count HEAD...${hook_com[branch]}@{upstream} 2>/dev/null))
	local -a stat=("$(git status --porcelain)")
	local -a untracked=($(echo "$stat" | grep '^??' | wc -l))
	local -a modified=($(echo "$stat" | grep '^.M' | wc -l))
	local -a staged=($(echo "$stat" | grep '^[AM]' | wc -l))
	ahead=${ahead_and_behind[1]}
	behind=${ahead_and_behind[2]}
	(( $modified )) && gitstatus+=( "%{\033[1m%}${modified}M" )
	(( $staged )) && gitstatus+=( "%{\033[1m%}${staged}S" )
	(( $untracked )) && gitstatus+=( "%{\033[1m%}${untracked}U" )
	(( $ahead )) && gitstatus+=( '>' )
	(( $behind )) && gitstatus+=( '<' )
	[[ -n "$gitstatus" ]] && hook_com[misc]+=' '
	hook_com[misc]+=${(j:	:)gitstatus}
}

prompt_go() {
	(( $+commands[go] )) || return
	if [[ -f "go.mod" || -n "$(find . -maxdepth 1 -name '*.go')" ]]; then
		local go_version=$(go version 2>/dev/null | grep -o 'go[0-9]\+\.[0-9]\+\.[0-9]\+' || echo "")
		[[ -n $go_version ]] && prompt_segment 12 0 "GO: $go_version"
	fi
}

prompt_julia() {
	(( $+commands[julia] )) || return
	if [[ -f "Project.toml" || -n "$(find . -maxdepth 1 -name '*.jl')" ]]; then
		local julia_version=$(julia --version 2>/dev/null | grep -o '[0-9]\+\.[0-9]\+\.[0-9]\+' || echo "")
		[[ -n $julia_version ]] && prompt_segment 4 0 "JULIA: $julia_version"
	fi
}

prompt_python() {
	if [[ -f "pyproject.toml" || -f "requirements.txt" || -n "$(find . -maxdepth 1 -name '*.py')" ]]; then
		local python_version=$(python --version 2>/dev/null | grep -o '[0-9]\+\.[0-9]\+\.[0-9]\+' || echo "")
		[[ -n $python_version ]] && prompt_segment 11 0 "PY: $python_version"
	fi
}

prompt_ruby() {
	(( $+commands[ruby] )) || return
	if [[ -f "Gemfile" || -n "$(find . -maxdepth 1 -name '*.rb')" ]]; then
		local ruby_version=$(ruby --version 2>/dev/null | grep -o '[0-9]\+\.[0-9]\+\.[0-9]\+' || echo "")
		[[ -n $ruby_version ]] && prompt_segment 1 7 "RB: $ruby_version"
	fi
}

prompt_azfunc() {
	[[ -f "host.json" || -f "function.json" ]] && prompt_segment 208 7 "AZURE"
}

prompt_aws() {
	local aws_profile="${AWS_PROFILE:-$AWS_DEFAULT_PROFILE}"
	local aws_region="$AWS_REGION"
	if [[ -n $aws_profile ]]; then
		local aws_info="AWS: $aws_profile"
		[[ -n $aws_region ]] && aws_info+="@$aws_region"
		prompt_segment 3 7 "$aws_info"
	fi
}

prompt_root() {
	[[ $UID -eq 0 ]] && prompt_segment 11 0 "ROOT"
}

prompt_status() {
	local -a symbols
	[[ $RETVAL -ne 0 ]] && symbols+="%{%F{235}%}󰜺 $RETVAL"
	[[ $BG_JOBS -ne 0 ]] && symbols+="%{%F{235}%}󰘷 $BG_JOBS"

build_prompt() {
	RETVAL="$?"
	BG_JOBS=${#${(M)jobstates:#suspended:*}} # "$(jobs -s | wc -l)" doesn't work and has a weird behavior and only returns the right amount if not in the directory of the first suspended jobs (???)
	prompt_status
	prompt_dir
	prompt_git
	prompt_go
	prompt_julia
	prompt_python
	prompt_ruby
	prompt_azfunc
	prompt_aws
	prompt_root
	prompt_end
}

# rsep(k,Fclock), clock, rsep(Kclock, Fos), os
### Right Prompt [by luan-bravo]
rprompt_segment() {
	local bg fg
	[[ -n $1 ]] && bg="%K{$1}" || bg="%k"
	[[ -n $2 ]] && fg="%F{$2}" || fg="%f"
	if [[ $CURRENT_BG != 'NONE' && $1 != $CURRENT_BG ]]; then # not the first rprompt
		echo -n " %{%K{$CURRENT_BG}%F{$1}%}$RIGHT_SEPARATOR%{$bg$fg%} "
	else # is first rprompt
		echo -n "%{%k%F{$1}%}%{$RIGHT_SEPARATOR%}%{$bg$fg%} "
	fi
	CURRENT_BG=$1
	[[ -n $3 ]] && echo -n $3
}


rprompt_clock() {
	[[ -n $hour ]] && rprompt_segment 0 7 "$hour"
}

rprompt_os() {
	[[ -s /etc/os-release ]] && local distro=$(. /etc/os-release && echo "$NAME" || echo "")
	local os_icon
	case "$OSTYPE" in
		linux*)
			case "$distro" in
				Arch*)
					os_color=4
					os_icon="%{%F{$os_color}%}ARCH%{%f%}" ;; # 󰣇
				Debian*)
					os_color=1
					os_icon="%{%F{$os_color}%}DEBIN%{%f%}" ;; # 󰣚
				Ubuntu*)
					os_color=5
					os_icon="%{%F{$os_color}%}UBUNTU%{%f%}" ;; # 
				Nix*)
					os_color=12
					os_icon="%{%F{$os_color}%}NIXOS%{%f%}" ;; # 
				*)
					os_color=15
					os_icon="%{%F{$os_color}%}LNX%{%f%}" ;; # 
			esac
		;;
		darwin*)
			os_color=1
			os_icon="%{%F{$os_color}%}MAC%{%f%}" ;; # 
		*)
			return ;;
	esac
	#os_icon+=" " # Extra space for two-characters wide icons. Comment this if using mono spaced
	[[ -n "$os_icon" ]] && rprompt_segment 237 "%k" "$os_icon "
}

build_rprompt() {
	hour="$(date '+%H:%M:%S')"
	rprompt_clock
	rprompt_os
}

PROMPT='%{%f%b%k%}$(build_prompt) '
RPROMPT=' $(build_rprompt)%{%f%b%k%}'
