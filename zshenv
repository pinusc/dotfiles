typeset -gU cdpath fpath mailpath path

# Set the the list of directories that cd searches.
# cdpath=(
#   $cdpath
# )

# Set the list of directories that Zsh searches for programs.
path=(
  $HOME/bin
  /usr/local/heroku/bin
  /usr/local/{bin,sbin}
  $HOME/.dotfiles/bin
  $(ruby -rubygems -e "puts Gem.user_dir")/bin
  $path
)
