system_type=$(uname -s)

# eval "$(/opt/homebrew/bin/brew shellenv)"

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
