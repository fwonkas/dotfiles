system_type=$(uname -s)

# eval "$(/opt/homebrew/bin/brew shellenv)"

# Ghostty shell integration for ZSH.
if [ -n "${GHOSTTY_RESOURCES_DIR}" ]; then
    builtin source "${GHOSTTY_RESOURCES_DIR}/shell-integration/zsh/ghostty-integration"
fi


if [ "$system_type" = "Darwin" ]; then
    # Set up Homebrew
    local BREW=/opt/homebrew/bin/brew
    if [ -x $BREW ]; then
        eval "$($BREW shellenv)"
    fi
fi

if [ -e ~/.zprofile.local ]; then
    source ~/.zprofile.local
fi
