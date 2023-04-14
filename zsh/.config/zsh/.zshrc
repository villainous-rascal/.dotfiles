# Use Vi editing mode
bindkey -v

# Create a zkbd compatible hash;
# to add other keys to this hash, see: man 5 terminfo
typeset -g -A key

key[Home]="${terminfo[khome]}"
key[End]="${terminfo[kend]}"
key[Insert]="${terminfo[kich1]}"
key[Backspace]="${terminfo[kbs]}"
key[Delete]="${terminfo[kdch1]}"
key[Up]="${terminfo[kcuu1]}"
key[Down]="${terminfo[kcud1]}"
key[Left]="${terminfo[kcub1]}"
key[Right]="${terminfo[kcuf1]}"
key[PageUp]="${terminfo[kpp]}"
key[PageDown]="${terminfo[knp]}"
key[Shift-Tab]="${terminfo[kcbt]}"

# Setup key accordingly
[[ -n "${key[Home]}"      ]] && bindkey -- "${key[Home]}"       beginning-of-line
[[ -n "${key[End]}"       ]] && bindkey -- "${key[End]}"        end-of-line
[[ -n "${key[Insert]}"    ]] && bindkey -- "${key[Insert]}"     overwrite-mode
[[ -n "${key[Backspace]}" ]] && bindkey -- "${key[Backspace]}"  backward-delete-char
[[ -n "${key[Delete]}"    ]] && bindkey -- "${key[Delete]}"     delete-char
[[ -n "${key[Up]}"        ]] && bindkey -- "${key[Up]}"         up-line-or-history
[[ -n "${key[Down]}"      ]] && bindkey -- "${key[Down]}"       down-line-or-history
[[ -n "${key[Left]}"      ]] && bindkey -- "${key[Left]}"       backward-char
[[ -n "${key[Right]}"     ]] && bindkey -- "${key[Right]}"      forward-char
[[ -n "${key[PageUp]}"    ]] && bindkey -- "${key[PageUp]}"     beginning-of-buffer-or-history
[[ -n "${key[PageDown]}"  ]] && bindkey -- "${key[PageDown]}"   end-of-buffer-or-history
[[ -n "${key[Shift-Tab]}" ]] && bindkey -- "${key[Shift-Tab]}"  reverse-menu-complete

# Finally, make sure the terminal is in application mode, when zle is
# active. Only then are the values from $terminfo valid.
if (( ${+terminfo[smkx]} && ${+terminfo[rmkx]} )); then
	autoload -Uz add-zle-hook-widget
	function zle_application_mode_start { echoti smkx }
	function zle_application_mode_stop { echoti rmkx }
	add-zle-hook-widget -Uz zle-line-init zle_application_mode_start
	add-zle-hook-widget -Uz zle-line-finish zle_application_mode_stop
fi

autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "$terminfo[kcuu1]" up-line-or-beginning-search # Up
bindkey "$terminfo[kcud1]" down-line-or-beginning-search # Down

# Set some utility variables for ZSH paths
CONFIG_DIR=$XDG_CONFIG_HOME/zsh
DATA_DIR=$XDG_DATA_HOME/zsh
ZSH_FUNCTIONS=$CONFIG_DIR/functions
PLUGIN_MANAGER=$CONFIG_DIR/plugin-manager

export PLUGINS_DIR=$DATA_DIR/plugins

# Expand the fpath
fpath=($ZSH_FUNCTIONS $fpath)

### Options
setopt PROMPT_SUBST
setopt HIST_VERIFY
setopt HIST_IGNORE_SPACE
setopt HIST_NO_FUNCTIONS

unsetopt NOTIFY
unsetopt BEEP
unsetopt HIST_BEEP

HISTFILE="$DATA_DIR/.history"
HISTSIZE=10000
SAVEHIST=10000

### Plugins
# Load the plugin manager's functions
[[ -d $PLUGIN_MANAGER ]] && autoload -Uz $PLUGIN_MANAGER/**/*(.) && manager_loaded=true

plugins=(
    #"romkatv/gitstatus:gitstatus.prompt.zsh"
    "zsh-users/zsh-autosuggestions"
    "zsh-users/zsh-syntax-highlighting"
)

[[ -n $manager_loaded ]] && for plugin in $plugins; do
    zsh_plugin_load $plugin
done

### Custom functions
[[ -d "$ZSH_FUNCTIONS" ]] && [[ "$(/usr/bin/ls -A $ZSH_FUNCTIONS)" ]] && autoload -Uz $ZSH_FUNCTIONS/**/*(.)

### Prompts
. $CONFIG_DIR/.zsh_prompts

### Environment variables
# NOTE: This is where the PATH is extended and exported
. $CONFIG_DIR/.zsh_variables

### Aliases
[[ -f $CONFIG_DIR/.zsh_aliases ]] && . $CONFIG_DIR/.zsh_aliases

