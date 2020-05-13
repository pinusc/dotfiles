export EDITOR='nvim'
export VISUAL='nvim'
export MAIL="$HOME/mail"
export PAGER='less'
export PDF_VIEWER='zathura'
export BROWSER='/usr/bin/qutebrowser'
# export TERM="rxvt-unicode-256color"
# export LESS='-F -g -i -M -R -S -w -X -z-4'

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"

typeset -gU cdpath fpath mailpath path

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
export COOKIECUTTER_CONFIG="$XDG_CONFIG_HOME/cookiecutter"

export BUP_DIR="$XDG_DATA_HOME/bup"

export GPODDER_HOME="$HOME/.gpodder/"
export GPODDER_DOWNLOAD_DIR="$HOME/music/podcasts"
