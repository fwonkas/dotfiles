# shell options
setopt auto_cd

# aliases
alias ls="ls -F"
alias bv="brew-visit"
alias bi="brew info"
alias bs="brew search"
[[ "$(command -v bat)" ]] && alias cat="bat"
[[ "$(command -v htop)" ]] && alias top="htop"

# environment variables
export CLICOLOR=1
# export ZSH_HIGHLIGHT_HIGHLIGHTERS_DIR=/opt/homebrew/share/zsh-syntax-highlighting/highlighters

fd() {
	local dir
	dir=$(find ${1:-.} -path '*/\.*' -prune \
		-o -type d -print 2> /dev/null | fzf +m) &&
	cd "$dir"
}

# Open the finder to a specified path or to current directory.
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
	# USAGE: ql [file1] [file2]
	qlmanage -p "${*}" &>/dev/null
}

brew-visit() {
	open -a Safari `brew info "${1}" | grep ^http | head -1`
}

autoload -Uz compinit
compinit

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh	
source <(fzf --zsh)
[ -f ~/.config/op/plugins.sh ] && source ~/.config/op/plugins.sh
[ -f /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] && source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
[ -f /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh ] && source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
[ -e "${HOME}/.iterm2_shell_integration.zsh" ] && source "${HOME}/.iterm2_shell_integration.zsh"

eval "$(starship init zsh)"
