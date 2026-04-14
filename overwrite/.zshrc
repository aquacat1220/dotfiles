# Lines configured by zsh-newuser-install.
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -e
# End of lines configured by zsh-newuser-install.

# Initiate starship with Znap.
eval "$(starship init zsh)"
# End of lines for starship.

# Initiate autocomplete.
# znap source marlonrichert/zsh-autocomplete
autoload -U compinit; compinit
# End of lines for autocomplete.

# Ensure menu shows up even when we only have a single option.
zmodload zsh/complist

function _aqua_complete() {
    _complete "$@"
    compadd  -V aqua -2 -E 1
}

zstyle ':completion:*' completer _aqua_complete
zstyle ':completion:*' menu yes select=0
# End of lines for single-option menus.

# Configure autocomplete key bindings.
bindkey              '^I' menu-complete
bindkey "$terminfo[kcbt]" reverse-menu-complete
# End of lines for autocomplete keybind.