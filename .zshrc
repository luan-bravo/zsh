# luan-bravo's ZSH config
setopt glob nullglob extendedglob shwordsplit

src() {
	[[ $# -eq 1 ]] && {
		source "$1" 2> /dev/null || {
			echo "${red}[.zshrc]${nc} ERROR: Failed to source '$*'"
			return 1
		}
	}
}


# Oh-my-zsh and Plugins
plugins=(
	vi-mode # enhance zsh vi mode

	zoxide
	fzf

	git
	gh
	tmux

	docker
	rust
	arduino-cli
	node
	npm
	bun
	asdf
)
src "$ZSH/oh-my-zsh.sh"

src "$ROOT_PLUGINS/zsh-autosuggestions/zsh-autosuggestions.zsh"
src "$ROOT_PLUGINS/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"


for alias in "$ZDOTDIR/aliases/"*; do
	source "$alias"
done
