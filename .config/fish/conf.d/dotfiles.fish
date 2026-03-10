# Dotfiles management via bare git repo
alias config='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

# Manual sync alias
alias dotsync='bash $HOME/scripts/dotfiles-sync.sh push'

# Show recent auto-sync commits
alias dotlog='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME log --oneline'
