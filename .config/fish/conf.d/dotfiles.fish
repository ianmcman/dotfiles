# Dotfiles management via bare git repo
alias config='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

# Manual sync alias
alias dotsync='bash $HOME/scripts/dotfiles-sync.sh push'
