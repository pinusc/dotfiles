typeset -gU cdpath fpath mailpath path
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"

# Set the the list of directories that cd searches.
# cdpath=(
#   $cdpath
# )

# Set the list of directories that Zsh searches for programs.
path=(
  $HOME/bin
  $HOME/bin/*
  # /usr/local/heroku/bin
  /usr/local/{bin,sbin}
  # $(ruby -rubygems -e "puts Gem.user_dir")/bin
  $path
)
export GOPATH="$HOME/.local/share/go"

export VISUAL=nvim
export EDITOR="$VISUAL"

export BUP_DIR="$XDG_DATA_HOME/bup"
