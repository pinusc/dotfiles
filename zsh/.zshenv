export EDITOR='nvim'
export VISUAL='nvim'
export MAIL="$HOME/mail"
command -v bat &>/dev/null && export PAGER='bat --paging=always'
command -v bat &>/dev/null && export MANPAGER="sh -c 'col -bx | bat -l man -p'"
command -v bat &>/dev/null && export MANROFFOPT="-c"
command -v bat &>/dev/null && export SYSTEMD_PAGER="bat -l syslog -p'"
export PDF_VIEWER='zathura'
export BROWSER="$HOME/bin/qutebrowser"
# export TERM="rxvt-unicode-256color"
export TERMINAL="/usr/local/bin/st"
# export LESS='-F -g -i -M -R -S -w -X -z-4'

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_DATA_DIRS="$XDG_DATA_HOME:/usr/local/share/:/usr/share/"
export XDG_DATA_DIR="$XDG_DATA_HOME:/usr/local/share/:/usr/share/"
export XDG_SCREENSHOTS_DIR="$HOME/shots"
export GSETTINGS_SCHEMA_DIR="/usr/share/glib-2.0/schemas"

export TEXMFHOME="$HOME/.local/share/texmf"
export QT_QPA_PLATFORMTHEME=qt5ct
export TMPDIR="$HOME/tmp"

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
  $HOME/usr/local/{bin,sbin}
  # $(ruby -rubygems -e "puts Gem.user_dir")/bin
  $HOME/.emacs.d/bin
  $HOME/.local/lib/perl5/bin
  $HOME/.local/share/cargo/bin
  $HOME/.config/nvim/plugged/vim-iced/bin
  $path
)

export GOPATH="$HOME/.local/share/go"
export CARGO_HOME="$HOME/.local/share/cargo"
export COOKIECUTTER_CONFIG="$XDG_CONFIG_HOME/cookiecutter"

export BUP_DIR="$XDG_DATA_HOME/bup"

export GPODDER_HOME="$HOME/.gpodder/"
export GPODDER_DOWNLOAD_DIR="$HOME/music/podcasts"

export BAT_PAGER="less"

export NNN_FIFO=/tmp/nnn.fifo
export NNN_TRASH=1
# export NNN_OPENER="$HOME/.config/nnn/plugins/nuke"
export NNN_OPENER="xdg-open"
export NNN_PLUG='f:finder;z:autojump;o:fzopen;p:preview-tabbed;t:preview-tui;d:dragdrop;m:mediainf;s:suedit;v:nmount'
export NNN_BMS='d:~/docs;m:/mnt;d:~/downloads/;D:/data;p:/data/pics'
export NNN_COLORS='1234'
export NNN_FCOLORS='0101030d000e0e0101050501'


# PATH="/home/pinusc/.local/bin/perl5/bin${PATH:+:${PATH}}"; export PATH;
PERL5LIB="/home/pinusc/.local/lib/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="/home/pinusc/.local/lib/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"/home/pinusc/.local/lib/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/home/pinusc/.local/lib/perl5"; export PERL_MM_OPT;
BABASHKA_PRELOADS="(require '[selmer.parser :refer [<<]])"
export BABASHKA_PRELOADS;

export ANTHROPIC_API_KEY="$(cat ~/.local/share/ANTHROPIC_API_KEY)"
export DEEPSEEK_API_KEY="$(cat ~/.local/share/DEEPSEEK_API_KEY)"
export OPENAI_API_KEY="$(cat ~/.local/share/OPENAI_API_KEY)"
export DICTIONARY_API_KEY="$(cat ~/.local/share/DICTIONARYAPI_API_KEY)"

export PYTHON_KEYRING_BACKEND=keyring.backends.null.Keyring # poetry fails on ssh otherwise

source "$HOME/.config/user-dirs.dirs"

# umu stuff
export WINEPREFIX="$HOME/games/umu/"
export PROTONPATH="GE-Proton"

export MANGOHUD=1
