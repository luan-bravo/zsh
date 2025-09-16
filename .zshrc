# ZSH base configuration

# setopt localoptions glob nullglob

# oh-my-zsh
plugins=(
    # from ohmyzsh
    git
    z
    fzf
    man
    tldr
    gh
    archlinux
    arduino-cli
    npm
    bun
    tmux
    rust
    # from ./custom/plugins/
    zsh-autosuggestions
    zsh-syntax-highlighting
)

if  [[ ! -f "$ZSH/oh-my-zsh.sh" ]]; then
    echo "${red}No 'oh-my-zsh.sh' file found. Attempting to update zsh config folder submodules${nc}"
    pushd "$ZDOTDIR" > /dev/null || {
        echo "${red}pushd $ZDOTDIR failed${nc}" &&
        return 1
    }
    git submodule update --init -f
    popd > /dev/null || {
        echo "${red}popd $ZDOTDIR failed${nc}" && \
            return 1
    }
    [[ -s "$ZSH/oh-my-zsh.sh" ]] || echo "${green}ZSH submodules updated. ${yellow}Please, run 'exec zsh' to see applied changes${nc}"
else
    source "$ZSH/oh-my-zsh.sh" || echo "${red}Could not source 'oh-my-zsh.sh' file${nc}"
fi

zstyle ':omz:update' mode auto
export ENABLE_CORRECTION="false"

# ZSH enviroment
if [[ -e "$HOME/.zshenv" ]]; then
    source "$ZDOTDIR/.zshenv"
else
    echo "${red}No '.zshenv' file found in '\$HOME' directory. Attempting create symbolic link from file in '\$ZDOTDIR'${nc}"
    ln -s "$ZDOTDIR/.zshenv" "$HOME/.zshenv"
    if [[ -e "$HOME/.zshenv" ]]; then
        echo "${green}Symbolic link created. Sourcing.${nc}"
        source "$HOME/.zshenv"
    else
        echo "${red}Could not create '.zshenv' symlink in home directory.${nc}"
    fi
fi


local dirs=("$ZSH_CUSTOM/aliases/")

for dir in $dirs; do
    # echo $dir
    for file in $dir/*; do;
        # echo $file
        source $file
    done
done
