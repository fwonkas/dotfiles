system_type=$(uname -s)

# shell options
setopt auto_cd append_history share_history histignorealldups

# aliases
get_ls_command() {
	command -v lsd &>/dev/null
	if [ $? -eq 0 ]; then
		echo "lsd"
	else
		echo "ls"
	fi
}
alias ls="$(get_ls_command) -F"

# git aliases
alias g=git
alias gi=git

# Homebrew aliases
alias b="brew"
alias bv="brew-visit" # points to the function below because I'm complicated
alias bi="brew info"
alias bs="brew search"

# YADM aliases
alias y="yadm"
alias ys="yadm status"

# These depend on some installed packages, so just to be safe
[[ "$(command -v bat)" ]] && alias cat="bat"
[[ "$(command -v htop)" ]] && alias top="htop"

# environment variables
export PATH="$PATH:${HOME}/.local/bin"
export CLICOLOR=1
# export ZSH_HIGHLIGHT_HIGHLIGHTERS_DIR=/opt/homebrew/share/zsh-syntax-highlighting/highlighters

# Load functions
fpath=("$HOME/.functions" "${fpath[@]}")
autoload -Uz ql f brew-visit tre compinit && compinit

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh && source <(fzf --zsh)
[ -f ~/.config/op/plugins.sh ] && source ~/.config/op/plugins.sh
[ -f /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] && source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
[ -f /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh ] && source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
[ -f /opt/homebrew/opt/git-extras/share/git-extras/git-extras-completion.zsh ] && source /opt/homebrew/opt/git-extras/share/git-extras/git-extras-completion.zsh
[ -f /opt/homebrew/share/liquidprompt ] && source /opt/homebrew/share/liquidprompt
[ -e "${HOME}/.iterm2_shell_integration.zsh" ] && source "${HOME}/.iterm2_shell_integration.zsh"

if it2check; then
	iterm2_print_user_vars() {
		it2git
	}
fi

eval "$(zoxide init --cmd j zsh)"
eval $(thefuck --alias)
# eval "$(starship init zsh)"
