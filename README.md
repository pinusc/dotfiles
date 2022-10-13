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
- mpv + mpv-mpris

### Panel dependencies
- bash-fuzzy-clock
- perl-net-dbus

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
- envrc

### sudo visudo
- Add line "Defaults !lecture,tty_tickets,!fqdn,insults"
    
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

###nnn plugins
Run

    $ curl -Ls https://raw.githubusercontent.com/jarun/nnn/master/plugins/getplugs | sh

Dependencies:
- aur/dragon-drag-and-drop
- viu

### media
MPD scrobbling: install `aur/mpdas` and run `$ systemctl --user enable mpdas`
Set up mpv interface

