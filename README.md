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
- mpv e mpv-mpris

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

5. Crontab
----------
For scripts that must run daily (such as tarsnap), just edit the anacron file in `anacron/.config/anacron/etc/anacrontab`. 

For more frequent scripts, we have to use crontab, which sadly can't easily be version controlled.

Here's a dump of crontab at the present time:

    @hourly /usr/sbin/anacron -s -t $HOME/.config/anacron/etc/anacrontab -S $HOME/.config/anacron/spool

Right now, it just runs anacron every hour.

6. Modules/
-----------
This folder is for programs and scripts I did not write and can't or shouldn't be installed with a package manager. When possible, I use `git submodule` to include them without cluttering my repo; however, if I have to make some changes to the original source code and the repo is small, I'll just add the files in the index and source control them. This has proven to be the easiest version; forking and modifying the source code in another repo is too cumbersome most of the time, and I don't do it  unless necessary.
