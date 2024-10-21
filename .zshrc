system_type=$(uname -s)

# shell options
setopt auto_cd
setopt append_history share_history histignorealldups

# aliases
alias ls="ls -F"
alias top10="print -l -- ${(o)history%% *} | uniq -c | sort -nr | head -n 10"

# Homebrew aliases
alias bv="brew-visit" # points to the function below because I'm complicated
alias bi="brew info"
alias bs="brew search"

# These depend on some installed packages, so just to be safe
[[ "$(command -v bat)" ]] && alias cat="bat"
[[ "$(command -v htop)" ]] && alias top="htop"

# environment variables
export CLICOLOR=1
# export ZSH_HIGHLIGHT_HIGHLIGHTERS_DIR=/opt/homebrew/share/zsh-syntax-highlighting/highlighters

# Functions

fd() {
	# DESC:  I forget
	# ARGS:  $1 (optional):
	# REQS:  ???
	# USAGE: fd [path]
	local dir
	dir=$(find ${1:-.} -path '*/\.*' -prune \
		-o -type d -print 2> /dev/null | fzf +m) &&
	cd "$dir"
}

f() {
	# DESC:  Opens the Finder to specified directory. (Default is current oath)
	# ARGS:  $1 (optional): Path to open in finder
	# REQS:  MacOS
	# USAGE: f [path]
	open -a "Finder" "${1:-.}"
}

ql() {
	# DESC:  Opens files in MacOS Quicklook
	# ARGS:  $1 (optional): File to open in Quicklook
	# REQS:  MacOS
	# USAGE: ql [file1] [file2]
	qlmanage -p "${*}" &>/dev/null
}

brew-visit() {
	# DESC:  Open a Homebrew formula's web page
	# ARGS:  $1: Homebrew formula name
	# REQS:  MacOS
	# USAGE: brew-visit [url]
	open -a Safari `brew info "${1}" | grep ^http | head -1`
}

# See https://github.com/dduan/tre/blob/main/README.md
tre() { command tre "$@" -e && source "/tmp/tre_aliases_$USER" 2>/dev/null; }

autoload -Uz compinit
compinit

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh	
source <(fzf --zsh)
[ -f ~/.config/op/plugins.sh ] && source ~/.config/op/plugins.sh
[ -f /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] && source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
[ -f /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh ] && source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
[ -f /opt/homebrew/opt/git-extras/share/git-extras/git-extras-completion.zsh ] && source /opt/homebrew/opt/git-extras/share/git-extras/git-extras-completion.zsh
[ -f /opt/homebrew/share/liquidprompt ] && source /opt/homebrew/share/liquidprompt
[ -e "${HOME}/.iterm2_shell_integration.zsh" ] && source "${HOME}/.iterm2_shell_integration.zsh"

if it2check
then
	iterm2_print_user_vars() {
		it2git
	}
fi

eval "$(zoxide init --cmd j zsh)"
eval $(thefuck --alias)
# eval "$(starship init zsh)"
