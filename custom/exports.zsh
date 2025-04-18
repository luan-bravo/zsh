# Exports

src() { [[ -f "$1" ]] && source "$1" }
xpt() { [[ -d "$2" ]] && export "$1"="$2" }
nvr() { [[ -d "$1" ]] && export PATH="$PATH:$1" }

src "$HOME/.bun/_bun"

xpt IDF_PATH "/opt/esp-idf"
src "$IDF_PATH/export.sh"

# Exports for set up
xpt GIT_CONFIG_GLOBAL "$HOME/.config/.gitconfig"
# src "$ZDOTDIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" # now in plugins

# Path and sourcing
if [ -d "$HOME/.local/share/adb-fastboot/platform-tools" ]; then
    nvr "$HOME/.local/share/adb-fastboot/platform-tools"
fi

src "$HOME/.bun/_bun"
xpt BUN_INSTALL "$HOME/.bun"
nvr "$BUN_INSTALL/bin"

xpt ANDROID_HOME "$HOME/Android/sdk"
nvr "$ANDROID_HOME/emulator"
nvr "$ANDROID_HOME/platform-tools"

xpt FLYCTL_INSTALL "$HOME/.fly"
nvr "$FLYCTL_INSTALL/bin"

nvr "$HOME/.turso"

xpt PNPM_HOME "$HOME/.local/share/pnpm"
case ":$PATH:" in
    # find if this case is really necessary, if it isn't, remove the echo in the next line, else modify every $PATH update in this file to use a case statement
  *":$PNPM_HOME:"*) ;;
  *) nvr "$PNPM_HOME" ;;
esac
nvr "$ZDOTDIR/custom/bin"

# WSL browser, requires wslu installation to be followerd
if [[ -n $WSL_DISTRO_NAME ]]; then
    xpt BROWSER "wslview"
fi
