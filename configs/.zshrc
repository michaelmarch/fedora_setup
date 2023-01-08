# TODO: explain the key binds
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word
bindkey -s "^[[1;3C" ""
bindkey -s "^[[1;3D" ""
bindkey "\e[3~" delete-char
bindkey "\e[3;5~" kill-word
bindkey "^H" backward-kill-word
bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line

export STARSHIP_CONFIG=$HOME/.config/starship/starship.toml
export HISTFILE=$HOME/.zsh_history
export HISTSIZE=1000
export SAVEHIST=1000

eval "$(starship init $SHELL)"

alias ls='lsd -Fl'
alias ll='ls -A'
alias grep='grep --color'
