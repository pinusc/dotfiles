Install notes
=============
To execute, run `gnu stow` + each of the desired directories. This directory should be placed directly under $HOME

1. Fonts 
--------
**Fontawesome**, the icon font, is at version 4.7.0; version 5 and above breaks the configuration AND icons are uglier. Just keep it 4.7.0; pacman with ttf-font-awesome has that version (add it to pacman.conf under IgnorePkg), but if hard to downgrade on newer installations, just download the ttf from the website. 

2. Deps
-------

### Bspwm dependencies
- xsetroot (cursor on desktop)
- breeze-gtk (cursor theme)
- sxhkd
- feh
- compton
- xautolock
- redshift

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
    
3. Setup commands
-----------------
- Enable Emacs daemon: `systemctl --user enable --now emacs`

4. Server setup
---------------
Run 
    
    $ scp bash/.* aliases/.* servername
