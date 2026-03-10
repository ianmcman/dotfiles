source /usr/share/cachyos-zsh-config/cachyos-config.zsh

# Dotfiles management via bare git repo
alias config='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias dotsync='bash $HOME/scripts/dotfiles-sync.sh push'
alias dotlog='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME log --oneline'

# History
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS

# Environment
export EDITOR=micro
export VISUAL=micro
export PATH="$HOME/.local/bin:$PATH"

# Common aliases
alias ll='ls -lh'
alias la='ls -lAh'
alias ..='cd ..'
alias ...='cd ../..'
