# NOTE:
# This file needs to be placed in $HOME so it is sourced for any
# ZSH session, being a login or non-login interactive shell

# Explicitly set XDG environment variables
export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export XDG_DATA_HOME=$HOME/.local/share
export XDG_STATE_HOME=$HOME/.local/state

# Make sure that all above directories are present
xdg_paths=($XDG_CONFIG_HOME $XDG_CACHE_HOME $XDG_DATA_HOME $XDG_STATE_HOME)
for dir in $xdg_paths; do
	mkdir -p $dir
done

# Do the same for the configuration files of ZSH
export ZDOTDIR=$XDG_CONFIG_HOME/zsh

