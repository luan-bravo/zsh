# Exports

src() {
    [[ -s "$1" ]] && source "$*"
}
xpt() {
    [[ -d "$2" ]] && export "$1"="$2"
}

export IDF_PATH="/opt/esp-idf"
src "$IDF_PATH/export.sh"

# Exports for set up
export GIT_CONFIG_GLOBAL="$HOME/.config/.gitconfig"
src "$ZDOTDIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" 2>"/dev/null"

# Path and sourcing
if [ -d "$HOME/.local/share/adb-fastboot/platform-tools" ] ; then
    export PATH="$PATH:$HOME/.local/share/adb-fastboot/platform-tools"
fi

src "$HOME/.bun/_bun"
export BUN_INSTALL="$HOME/.bun"
export PATH="$PATH:$BUN_INSTALL/bin"

export ANDROID_HOME="$HOME/Android/sdk"
export PATH="$PATH:$ANDROID_HOME/emulator"
export PATH="$PATH:$ANDROID_HOME/platform-tools"

export FLYCTL_INSTALL="$HOME/.fly"
export PATH="$PATH:$FLYCTL_INSTALL/bin"

export PATH="$PATH:$HOME/.turso"

export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
    # find if this case is really necessary, if it isn't, remove the echo in the next line, else modify every $PATH update in this file to use a case statement
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PATH:$PNPM_HOME" ;;
esac
export PATH="$PATH:$ZDOTDIR/custom/bin"
