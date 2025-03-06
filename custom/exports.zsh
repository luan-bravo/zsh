# Exports

# Exports for set up
export GIT_CONFIG_GLOBAL=$HOME/.config/.gitconfig
source $ZDOTDIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null

# Path and sourcing
if [ -d "$HOME/.local/share/adb-fastboot/platform-tools" ] ; then
    export PATH="$HOME/.local/share/adb-fastboot/platform-tools:$PATH"
fi

if [ -s "$HOME/.bun/_bun" ]; then
    source "$HOME/.bun/_bun"
fi
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

export ANDROID_HOME=$HOME/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/platform-tools

export FLYCTL_INSTALL="$HOME/.fly"
export PATH="$FLYCTL_INSTALL/bin:$PATH"

export PATH="$PATH:$HOME/.turso"

export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
