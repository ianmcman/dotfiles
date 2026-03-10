source /usr/share/cachyos-zsh-config/cachyos-config.zsh

# Dotfiles management via bare git repo
alias config='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias dotsync='bash $HOME/scripts/dotfiles-sync.sh push'
