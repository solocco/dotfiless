# .bashrc

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

export FZF_DEFAULT_OPTS="
	--color=fg:#908caa,bg:#191724,hl:#ebbcba
	--color=fg+:#e0def4,bg+:#26233a,hl+:#ebbcba
	--color=border:#403d52,header:#31748f,gutter:#191724
	--color=spinner:#f6c177,info:#9ccfd8,separator:#403d52
	--color=pointer:#c4a7e7,marker:#eb6f92,prompt:#908caa"

export TERMINAL='st'
export EDITOR='neovim'
export PATH="$HOME/.local/bin:$PATH"

#alias
alias v='nvim'
alias rel="xrdb merge /home/cid/xresources && kill -USR1 $(pidof st)"
alias q='xbps-query -Rs'
alias u='sudo xbps-install -Su'
alias i='sudo xbps-install -S'
alias c='sudo xbps-remove -o && sudo xbps-remove -O'
alias d='sudo xbps-remove'
alias ls='lsd --color=auto'
alias lh='lsd -hl'
alias s='source ~/.bashrc'
alias cat='bat --style=plain --theme=GitHub'
alias p='sudo poweroff'
alias r='sudo reboot'
alias mi='sudo make install'
alias mc='make clean'
alias l='lsd -al'
alias ll='lsd -a'
alias lb='lsblk'
