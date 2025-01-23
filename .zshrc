system_type=$(uname -s)

# Shell options
OPTIONS=(
	auto_cd
	append_history
	share_history
	histignorealldups
	INC_APPEND_HISTORY

	## Gonna slowly turn these on and see what I like

	# auto_list
	# auto_menu
	# auto_pushd
	# completeinword
	# correct
	# extended_history
	# histexpiredupsfirst
	# histignoredups
	# histignorespace
	# histverify # this one can get annoying...
	# interactivecomments
	# listpacked
	# longlistjobs
	# nocaseglob
	# noflowcontrol
	# promptsubst
	# pushdignoredups
	# pushdminus
)

setopt $OPTIONS[@]

fpath+=($HOME/.config/zsh/functions)

CONFIG_DIR=$HOME/.config
ZSH_CONFIG_DIR=$CONFIG_DIR/zsh

FILES_TO_SOURCE=()
FILES_TO_SOURCE+=(
	$ZSH_CONFIG_DIR/aliases
	$ZSH_CONFIG_DIR/environment
	$ZSH_CONFIG_DIR/zsh-unplugged # extremely minimal "package manager"
	$HOME/.iterm2_shell_integration.zsh
)

if [ "$system_type" = "Darwin" ]; then
	FILES_TO_SOURCE+=(
		$HOMEBREW_PREFIX/opt/nvm/nvm.sh
		$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm
	)
fi

for file in "${FILES_TO_SOURCE[@]}"; do
	if [ -s $file ]; then
		source "$file"
	else
		echo "WARNING: $file is empty or does not exist."
	fi
done

# Load functions
fpath+=("$ZSH_CONFIG_DIR/functions")

FUNCS_TO_AUTOLOAD=()
FUNCS_TO_AUTOLOAD+=(
	f
	fshow
	show-fpath
	take
	tre
	touchp
	unbuff
	promptinit
	compinit
)

if [ "$system_type" = "Darwin" ]; then
	FUNCS_TO_AUTOLOAD+=(
		brew-visit
		ql
	)
fi

autoload -Uz $FUNCS_TO_AUTOLOAD && compinit && promptinit
prompt pure

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh && source <(fzf --zsh)

if [ "$system_type" = "Darwin" ]; then
	[ -f $HOME/.config/op/plugins.sh ] && source ~/.config/op/plugins.sh
	[ -e $HOME/.iterm2_shell_integration.zsh ] && source $HOME/.iterm2_shell_integration.zsh

	# is this macos-only?
	# [ -f /opt/homebrew/opt/git-extras/share/git-extras/git-extras-completion.zsh ] && source /opt/homebrew/opt/git-extras/share/git-extras/git-extras-completion.zsh

	if [ -d /Applications/ShellHistory.app/Contents/Helpers ]; then
		# adding shhist to PATH, so we can use it from Terminal
		export PATH="${PATH}:/Applications/ShellHistory.app/Contents/Helpers"

		# creating an unique session id for each terminal session
		__shhist_session="${RANDOM}"

		# prompt function to record the history
		__shhist_prompt() {
			local __exit_code="${?:-1}"
			\history -D -t "%s" -1 | sudo --preserve-env --user ${SUDO_USER:-${LOGNAME}} shhist insert --session ${TERM_SESSION_ID:-${__shhist_session}} --username ${LOGNAME} --hostname $(hostname) --exit-code ${__exit_code} --shell zsh
			return ${__exit_code}
		}

		# integrating prompt function in prompt
		precmd_functions=(__shhist_prompt $precmd_functions)
	fi
fi

$HOME/.iterm2/it2check
export TERMINAL_IS_ITERM2=$?
if [ $TERMINAL_IS_ITERM2 -eq 0 ]; then
	iterm2_print_user_vars() {
		it2git
	}
fi

eval "$(zoxide init --cmd cd zsh)"
[[ "$(command -v thefuck)" ]] && eval $(thefuck --alias)

# This is for Linux. Why bash? I dunno. Whatever.
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

if [ "$system_type" = "Darwin" ]; then
	. $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi
