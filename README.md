Install notes
=============
To execute, run `gnu stow** + each of the desired directories. This directory should be placed directly under $HOME

1. Fonts 
--------
**Gohufont** and **Nerdfonts Gohufont** are all that's needed. 

2. Deps
-------
### General
- offlineimap

### Bspwm dependencies
- xsetroot (cursor on desktop)
- breeze-gtk (cursor theme)
- sxhkd
- feh
- compton
- xautolock
- redshift

### Panel dependencies
- bash-fuzzy-clock

### Emacs dependencies
- Minimap Font (TTF) [github](https://github.com/davestewart/minimap-font) 
- shellcheck
- mu (for mu4e)
- wordnet-cli (Aur), provides *wn*, used by *synosaurus*

### Vim
- Deoplete deps:
    - shellcheck
    - tern (through npm)
- Neomake deps:
    - shellcheck
    - vint (through pip vim-vint)
    - python-pyflakes
    - flake8
    - python-pylint
    - eslint
    - tidy (html)

### zsh
- AUR/antibody
- community/
- fortune
- cowsay

### sudo visudo
- Add line "Defaults !lecture,tty_tickets,!fqdn,insults"
