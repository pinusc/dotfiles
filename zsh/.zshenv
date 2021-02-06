export EDITOR='nvim'
export VISUAL='nvim'
export MAIL="$HOME/mail"
export PAGER='less'
# export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export PDF_VIEWER='zathura'
export BROWSER='/usr/bin/qutebrowser'
# export TERM="rxvt-unicode-256color"
# export LESS='-F -g -i -M -R -S -w -X -z-4'

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"

export TEXMFHOME="$HOME/.local/share/texmf"
export QT_STYLE_OVERRIDE=kvantum

typeset -gU cdpath fpath mailpath path

# Set the the list of directories that cd searches.
# cdpath=(
#   $cdpath
# )

# Set the list of directories that Zsh searches for programs.
path=(
  $HOME/bin
  $HOME/bin/*
  $HOME/.local/bin
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

export NNN_FIFO=/tmp/nnn.fifo
export NNN_TRASH=1
export NNN_OPENER="$HOME/.config/nnn/plugins/nuke"
export NNN_PLUG='f:finder;o:fzopen;p:preview-tabbed;t:preview-tui;d:dragdrop;m:mediainf;s:suedit;v:nmount'
export NNN_BMS='d:~/docs;m:/mnt;d:~/downloads/;D:/data;p:/data/pics'
export NNN_COLORS='1234'
export NNN_FCOLORS='0101030d000e0e0101050501'
