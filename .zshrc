system_type=$(uname -s)

# Shell options
OPTIONS=(
	auto_cd
	append_history
	share_history
	histignorealldups

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

FILES_TO_SOURCE=(
	$ZSH_CONFIG_DIR/aliases
	$ZSH_CONFIG_DIR/environment
	$ZSH_CONFIG_DIR/zsh-unplugged # extremely minimal "package manager"
	$HOME/.iterm2_shell_integration.zsh
	$HOMEBREW_PREFIX/opt/nvm/nvm.sh
	$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm
)

for file in "${FILES_TO_SOURCE[@]}"; do
	if [ -s $file ]; then
		source "$file"
	else
		echo "WARNING: $file is empty or does not exist."
	fi
done

# Load functions
fpath+=("$ZSH_CONFIG_DIR/functions")

FUNCS_TO_AUTOLOAD=(
	brew-visit
	f
	fshow
	ql
	show-fpath
	take
	tre
	touchp
	unbuff
	promptinit
	compinit
)
autoload -Uz $FUNCS_TO_AUTOLOAD && compinit && promptinit
prompt pure

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh && source <(fzf --zsh)

if [ "$system_type" = "Darwin" ]; then
	[ -f $HOME/.config/op/plugins.sh ] && source ~/.config/op/plugins.sh
	[ -e $HOME/.iterm2_shell_integration.zsh ] && source $HOME/.iterm2_shell_integration.zsh
	[ -f /opt/homebrew/opt/git-extras/share/git-extras/git-extras-completion.zsh ] && source /opt/homebrew/opt/git-extras/share/git-extras/git-extras-completion.zsh
fi

$HOME/.iterm2/it2check
export TERMINAL_IS_ITERM2=$?
if [ $TERMINAL_IS_ITERM2 -eq 0 ]; then
	iterm2_print_user_vars() {
		it2git
	}
fi

eval "$(zoxide init --cmd j zsh)"
[[ "$(command -v thefuck)" ]] && eval $(thefuck --alias)
