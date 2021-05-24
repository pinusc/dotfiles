;; -*- mode: emacs-lisp -*-
;; This file is loaded by Spacemacs at startup.
;; It must be stored in your home directory.

(defun dotspacemacs/layers ()
  "Configuration Layers declaration.
You should not put any user code in this function besides modifying the variable
values."
  (setq-default
   ;; Base distribution to use. This is a layer contained in the directory
   ;; `+distribution'. For now available distributions are `spacemacs-base'
   ;; or `spacemacs'. (default 'spacemacs)
   dotspacemacs-distribution 'spacemacs
   ;; List of additional paths where to look for configuration layers.
   ;; Paths must have a trailing slash (i.e. `~/.mycontribs/')
   dotspacemacs-configuration-layer-path '()
   ;; List of configuration layers to load. If it is the symbol `all' instead
   ;; of a list then all discovered layers will be installed.
   dotspacemacs-configuration-layers
   '(
     typescript
     sql
     yaml
     html
     javascript
     python
     shell-scripts
     ansible ; for jinja2
     (clojure :variables
              clojure-enable-fancify-symbols t)

     emacs-lisp
     scheme
     git
     version-control
     markdown
     org
     latex
     ;; markdowm
     java
     c-c++
     rust

     erc
     pdf-tools
     spotify
     search-engine
     speed-reading

     (mu4e :variables mu4e-installation-path "/usr/share/emacs/site-lisp")
     ;; (shell :variables
     ;;        shell-default-height 30
     ;;        shell-default-position 'bottom)
     (spell-checking :variables
                     spell-checking-enable-by-default nil
                     enable-flyspell-auto-completion t
                     spell-checking-enable-auto-dictionary t)
     (auto-completion :variables
                      auto-completion-enable-help-tooltip t)
     auto-completion
     theming
     )
   ;; List of additional packages that will be installed without being
   ;; wrapped in a layer. If you need some configuration for these
   ;; packages, then consider creating a layer. You can also put the
   ;; configuration in `dotspacemacs/user-config'.
   dotspacemacs-additional-packages
   '(;; evil-lispy
     pandoc
     pandoc-mode
     yasnippet-snippets
     zeal-at-point
     evil-numbers
     evil-cleverparens
     base16-theme
     sendmail
     gnus-dired
     helm-dictionary
     sentence-highlight
     langtool
     smooth-scrolling
     synosaurus
     wordsmith-mode
     olivetti
     imenu-list
     fountain-mode
     writeroom-mode
     writegood-mode)
   ;; A list of packages and/or extensions that will not be install and loaded.
   dotspacemacs-excluded-packages '()
   ;; If non-nil spacemacs will delete any orphan packages, i.e. packages that
   ;; are declared in a layer which is not a member of
   ;; the list `dotspacemacs-configuration-layers'. (default t)
   dotspacemacs-delete-orphan-packages t))

(defun dotspacemacs/init ()
  "Initialization function.
This function is called at the very startup of Spacemacs initialization
before layers configuration.
You should not put any user code in there besides modifying the variable
values."
  ;; This setq-default sexp is an exhaustive list of all the supported
  ;; spacemacs settings.
  (setq-default
   ;; Maximum allowed time in seconds to contact an ELPA repository.
   ;; dotspacemacs-elpa-timeout 5
   ;; If non nil then spacemacs will check for updates at startup
   ;; when the current branch is not `develop'. (default t)
   dotspacemacs-check-for-update nil
   ;; One of `vim', `emacs' or `hybrid'. Evil is always enabled but if the
   ;; variable is `emacs' then the `holy-mode' is enabled at startup. `hybrid'
   ;; uses emacs key bindings for vim's insert mode, but otherwise leaves evil
   ;; unchanged. (default 'vim)
   dotspacemacs-editing-style 'vim
   ;; If non nil output loading progress in `*Messages*' buffer. (default nil)
   dotspacemacs-verbose-loading nil
   ;; Specify the startup banner. Default value is `official', it displays
   ;; the official spacemacs logo. An integer value is the index of text
   ;; banner, `random' chooses a random text banner in `core/banners'
   ;; directory. A string value must be a path to an image format supported
   ;; by your Emacs build.
   ;; If the value is nil then no banner is displayed. (default 'official)
   dotspacemacs-startup-banner 'official
   ;; List of items to show in the startup buffer. If nil it is disabled.
   ;; Possible values are: `recents' `bookmarks' `projects'.
   ;; (default '(recents projects))
   dotspacemacs-startup-lists '(recents projects)
   ;; Number of recent files to show in the startup buffer. Ignored if
   ;; `dotspacemacs-startup-lists' doesn't include `recents'. (default 5)
   dotspacemacs-startup-recent-list-size 5
   ;; Default major mode of the scratch buffer (default `text-mode')
   dotspacemacs-scratch-mode 'text-mode
   ;; List of themes, the first of the list is loaded when spacemacs starts.
   ;; Press <SPC> T n to cycle to the next theme in the list (works great
   ;; with 2 themes variants, one dark and one light)
   dotspacemacs-themes '(base16-gruvbox-dark-hard
                         base16-gruvbox-light-hard)
   ;; If non nil the cursor color matches the state color in GUI Emacs.
   dotspacemacs-colorize-cursor-according-to-state t
   ;; Default font. `powerline-scale' allows to quickly tweak the mode-line
   ;; size to make separators look not too crappy.
   dotspacemacs-default-font '("Gohu GohuFont"
                               :size 14
                               :weight normal
                               :width normal
                               :powerline-scale 1.6)
   ;; The leader key
   dotspacemacs-leader-key "SPC"
   ;; The leader key accessible in `emacs state' and `insert state'
   ;; (default "M-m")
   dotspacemacs-emacs-leader-key "M-m"
   ;; Major mode leader key is a shortcut key which is the equivalent of
   ;; pressing `<leader> m`. Set it to `nil` to disable it. (default ",")
   dotspacemacs-major-mode-leader-key ","
   ;; Major mode leader key accessible in `emacs state' and `insert state'.
   ;; (default "C-M-m")
   dotspacemacs-major-mode-emacs-leader-key "C-M-m"
   ;; These variables control whether separate commands are bound in the GUI to
   ;; the key pairs C-i, TAB and C-m, RET.
   ;; Setting it to a non-nil value, allows for separate commands under <C-i>
   ;; and TAB or <C-m> and RET.
   ;; In the terminal, these pairs are generally indistinguishable, so this only
   ;; works in the GUI. (default nil)
   dotspacemacs-distinguish-gui-tab nil
   ;; (Not implemented) dotspacemacs-distinguish-gui-ret nil
   ;; The command key used for Evil commands (ex-commands) and
   ;; Emacs commands (M-x).
   ;; By default the command key is `:' so ex-commands are executed like in Vim
   ;; with `:' and Emacs commands are executed with `<leader> :'.
   dotspacemacs-command-key ":"
   ;; If non nil `Y' is remapped to `y$'. (default t)
   dotspacemacs-remap-Y-to-y$ t
   ;; Name of the default layout (default "Default")
   dotspacemacs-default-layout-name "Default"
   ;; If non nil the default layout name is displayed in the mode-line.
   ;; (default nil)
   dotspacemacs-display-default-layout nil
   ;; If non nil then the last auto saved layouts are resume automatically upon
   ;; start. (default nil)
   dotspacemacs-auto-resume-layouts nil
   ;; Location where to auto-save files. Possible values are `original' to
   ;; auto-save the file in-place, `cache' to auto-save the file to another
   ;; file stored in the cache directory and `nil' to disable auto-saving.
   ;; (default 'cache)
   dotspacemacs-auto-save-file-location 'cache
   ;; Maximum number of rollback slots to keep in the cache. (default 5)
   dotspacemacs-max-rollback-slots 5
   ;; If non nil then `ido' replaces `helm' for some commands. For now only
   ;; `find-files' (SPC f f), `find-spacemacs-file' (SPC f e s), and
   ;; `find-contrib-file' (SPC f e c) are replaced. (default nil)
   dotspacemacs-use-ido nil
   ;; If non nil, `helm' will try to minimize the space it uses. (default nil)
   dotspacemacs-helm-resize nil
   ;; if non nil, the helm header is hidden when there is only one source.
   ;; (default nil)
   dotspacemacs-helm-no-header nil
   ;; define the position to display `helm', options are `bottom', `top',
   ;; `left', or `right'. (default 'bottom)
   dotspacemacs-helm-position 'bottom
   ;; If non nil the paste micro-state is enabled. When enabled pressing `p`
   ;; several times cycle between the kill ring content. (default nil)
   dotspacemacs-enable-paste-micro-state nil
   ;; Which-key delay in seconds. The which-key buffer is the popup listing
   ;; the commands bound to the current keystroke sequence. (default 0.4)
   dotspacemacs-which-key-delay 0.4
   ;; Which-key frame position. Possible values are `right', `bottom' and
   ;; `right-then-bottom'. right-then-bottom tries to display the frame to the
   ;; right; if there is insufficient space it displays it at the bottom.
   ;; (default 'bottom)
   dotspacemacs-which-key-position 'bottom
   ;; If non nil a progress bar is displayed when spacemacs is loading. This
   ;; may increase the boot time on some systems and emacs builds, set it to
   ;; nil to boost the loading time. (default t)
   dotspacemacs-loading-progress-bar t
   ;; If non nil the frame is fullscreen when Emacs starts up. (default nil)
   ;; (Emacs 24.4+ only)
   dotspacemacs-fullscreen-at-startup nil
   ;; If non nil `spacemacs/toggle-fullscreen' will not use native fullscreen.
   ;; Use to disable fullscreen animations in OSX. (default nil)
   dotspacemacs-fullscreen-use-non-native nil
   ;; If non nil the frame is maximized when Emacs starts up.
   ;; Takes effect only if `dotspacemacs-fullscreen-at-startup' is nil.
   ;; (default nil) (Emacs 24.4+ only)
   dotspacemacs-maximized-at-startup nil
   ;; A value from the range (0..100), in increasing opacity, which describes
   ;; the transparency level of a frame when it's active or selected.
   ;; Transparency can be toggled through `toggle-transparency'. (default 90)
   dotspacemacs-active-transparency 90
   ;; A value from the range (0..100), in increasing opacity, which describes
   ;; the transparency level of a frame when it's inactive or deselected.
   ;; Transparency can be toggled through `toggle-transparency'. (default 90)
   dotspacemacs-inactive-transparency 90
   ;; If non nil unicode symbols are displayed in the mode line. (default t)
   dotspacemacs-mode-line-unicode-symbols t
   ;; If non nil smooth scrolling (native-scrolling) is enabled. Smooth
   ;; scrolling overrides the default behavior of Emacs which recenters the
   ;; point when it reaches the top or bottom of the screen. (default t)
   dotspacemacs-smooth-scrolling t
   ;; If non nil line numbers are turned on in all `prog-mode' and `text-mode'
   ;; derivatives. If set to `relative', also turns on relative line numbers.
   ;; (default nil)
   dotspacemacs-line-numbers nil
   ;; If non-nil smartparens-strict-mode will be enabled in programming modes.
   ;; (default nil)
   dotspacemacs-smartparens-strict-mode nil
   ;; Select a scope to highlight delimiters. Possible values are `any',
   ;; `current', `all' or `nil'. Default is `all' (highlight any scope and
   ;; emphasis the current one). (default 'all)
   dotspacemacs-highlight-delimiters 'all
   ;; If non nil advises quit functions to keep server open when quitting.
   ;; (default nil)
   dotspacemacs-persistent-server t
   ;; List of search tool executable names. Spacemacs uses the first installed
   ;; tool of the list. Supported tools are `ag', `pt', `ack' and `grep'.
   ;; (default '("ag" "pt" "ack" "grep"))
   dotspacemacs-search-tools '("ag" "pt" "ack" "grep")
   ;; The default package repository used if no explicit repository has been
   ;; specified with an installed package.
   ;; Not used for now. (default nil)
   dotspacemacs-default-package-repository nil
   ;; Delete whitespace while saving buffer. Possible values are `all'
   ;; to aggressively delete empty line and long sequences of whitespace,
   ;; `trailing' to delete only the whitespace at end of lines, `changed'to
   ;; delete only whitespace for changed lines or `nil' to disable cleanup.
   ;; (default nil)
   dotspacemacs-whitespace-cleanup nil

   dotspacemacs-folding-method 'evil

   evil-insert-state-cursor '((bar . 2) "yellow")
   ))

(defun dotspacemacs/user-init ()
  "Initialization function for user code.
It is called immediately after `dotspacemacs/init', before layer configuration
executes.
 This function is mostly useful for variables that need to be set
before packages are loaded. If you are unsure, you should try in setting them in
`dotspacemacs/user-config' first."
  (setq theming-modifications '((base16-gruvbox-dark-medium
                                 (font-lock-comment-face :foreground "#877d69" :slant italic))))

  (setq langtool-java-classpath "/usr/share/languagetool:/usr/share/java/languagetool/*"))

(defun dotspacemacs/user-config ()
  "Configuration function for user code.
This function is called at the very end of Spacemacs initialization after
layers configuration.
This is the place where most of your configurations should be done. Unless it is
explicitly specified that a variable should be set before a package is loaded,
you should place your code here."
  (spacemacs/toggle-highlight-current-line-globally-off)
  (setq-default evil-escape-key-sequence "jk")
  ;; (setq-default evil-escape-delay 0.2)

  (evil-leader/set-key
    "q q" 'spacemacs/frame-killer)

  ;; (smooth-scrolling-mode 1)
  ;; (setq smooth-scroll-margin 5)

  ;; (evil-leader/set-key "m T s" 'evil-cleverparens-mode)
  ;; (evil-leader/set-key writeroom-mode "t m w" 'writeroom-toggle-mode-line)

  (add-to-list 'auto-mode-alist '("\\.boot\\'" . clojure-mode))
  (add-to-list 'magic-mode-alist '(".* boot" . clojure-mode))

  (define-key global-map (kbd "C-+") 'text-scale-increase)
  (define-key global-map (kbd "C--") 'text-scale-decrease)
  (define-key global-map (kbd "C-i") 'evil-jump-forward) 

  (defface proportional
    '((t :family "CMU Serif" :height 1.3))
    "Just sets a proportional font"
    :group 'basic-faces)

  (defface typewriter
    '((t :family "CMU Typewriter Text" :height 1.3))
    "Just sets a proportional font"
    :group 'basic-faces)

  (defun toggle-proportional ()
    (interactive)
    (buffer-face-toggle 'proportional))

  (defun toggle-typewriter ()
    (interactive)
    (buffer-face-toggle 'typewriter))

  (evil-leader/set-key
    "t T" 'toggle-typewriter) 

  (evil-leader/set-key
    "t P" 'toggle-proportional) 

  (evil-leader/set-key
    "x w t" 'synosaurus-lookup)

  (evil-leader/set-key
    "x w T" 'synosaurus-choose-and-replace)

  (evil-leader/set-key
    "h h" 'zeal-at-point)

  (defun set-proportional-face ()
    (interactive)
    (face-remap-add-relative 'default (:family "EB Garamond")))

  (defun set-monospaced-face ()
    (interactive)
    (face-remap-remove-relative '(default :family "EB Garamond")))

  (setq powerline-default-separator 'contour)

  (setq latex-enable-auto-fill nil)

  ;; (setq ispell-program-name "hunspell")
  ;; ispell-set-spellchecker-params has to be called
  ;; before ispell-hunspell-add-multi-dic will work
  ;; (ispell-set-spellchecker-params)
  ;; (ispell-hunspell-add-multi-dic "american,italiano")
  ;; (setq ispell-dictionary "en_US") 

  ;; ERQ
  (setq erc-track-exclude-types '("JOIN" "NICK" "PART" "QUIT" "MODE"
                                  "324" "329" "332" "333" "353" "477"))

  (defun startmakeview ()
    (interactive)
    (shell-command "make view &")
    (add-hook 'after-save-hook (lambda () (shell-command "make"))))
  (add-hook 'text-mode-hook 'visual-line-mode)
  (add-hook 'text-mode-hook 'synosaurus-mode)

  ;; (set-face-background 'hl-line "#202020")
  (define-fringe-bitmap 'right-curly-arrow
  [#b00000000
   #b00000000
   #b00000000
   #b00000000
   #b01110000
   #b00010000
   #b00010000
   #b00000000])
(define-fringe-bitmap 'left-curly-arrow
  [#b00000000
   #b00001000
   #b00001000
   #b00001110
   #b00000000
   #b00000000
   #b00000000
   #b00000000])

; #3c3836
  (setq browse-url-browser-function 'browse-url-generic
      engine/browser-function 'browse-url-generic
      browse-url-generic-program "firefox")
  ;; (eval-after-load 'org '(require 'org-pdfview))  
  ;; (add-to-list 'org-file-apps '("\\.pdf\\'" . (lambda (file link) (org-pdfview-open link)))) 
  ;; (add-to-list 'org-file-apps '("\\.pdf::\\([[:digit:]]+\\)\\'" . (lambda (file link) (org-pdfview-open link)))) 
  (setq org-agenda-files (list "~/docs/org"))
  (setq org-stuck-projects
        '("+project/!-MAYBE-DONE-SENT" ("NEXT") ("")
          "\\<IGNORE\\>"))
  (setq org-todo-keywords
        '((sequence "TODO" "NEXT" "|" "DONE")
          (sequence "TOWRITE" "DRAFTING" "TOREVISE" "DRAFTED" "|" "SENT")
          (sequence "HABIT" "|" "FULFILLED")
          (sequence "CONTACT" "|" "CONTACTED")))
  (setq org-todo-keyword-faces
        '(("CONTACT" . org-drawer)
          ("HABIT" . org-link)
          ("DRAFTED" . org-quote)))
  (defadvice org-archive-subtree (around my-org-archive-subtree activate)
    (let ((org-archive-location
           (if (save-excursion (org-back-to-heading)
                               (> (org-outline-level) 1))
               (concat (car (split-string org-archive-location "::"))
                       "::* "
                       (car (org-get-outline-path)))
             org-archive-location)))
      ad-do-it))
  (setq message-kill-buffer-on-exit t)
  ;; (setq mu4e-user-mail-address-list '("giuseppe@gstelluto.com" "giuseppe.stelluto@gmail.com" "logins@gstelluto.com"))
  )

;; Do not write anything past this comment. This is where Emacs will
;; auto-generate custom variable definitions.
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector
   ["#101215" "#ee3366" "#aaee66" "#ddee77" "#4477ee" "#6655ee" "#4477ee" "#aaee66"])
 '(ansi-term-color-vector
   [unspecified "#101215" "#ee3366" "#aaee66" "#ddee77" "#4477ee" "#6655ee" "#4477ee" "#aaee66"] t)
 '(custom-safe-themes
   '("a2c86b47323b625bd83d36b98fff3534ea79e234866a7d9c2255d17b55e8346f" "09eeab340cb2c07d89c083f57bd9113fd5054d60089802d76e88a50ca770bf55" "ded87400e3f01670ad87cd8a268cca04fc3a8139450922827bafacae70816181" "80abb6253edcdda4eb8f9a4686676ba65c4fe37f3885a530ce1130d82be27b26" "e7ea9a96df1837ba34cbb95bae31b8cedd00c490f395284c0169481040cd4aa9" "c614d2423075491e6b7f38a4b7ea1c68f31764b9b815e35c9741e9490119efc0" "8be07a2c1b3a7300860c7a65c0ad148be6d127671be04d3d2120f1ac541ac103" "7bef2d39bac784626f1635bd83693fae091f04ccac6b362e0405abf16a32230c" "3380a2766cf0590d50d6366c5a91e976bdc3c413df963a0ab9952314b4577299" "bffa9739ce0752a37d9b1eee78fc00ba159748f50dc328af4be661484848e476" "50ff65ab3c92ce4758cc6cd10ebb3d6150a0e2da15b751d7fbee3d68bba35a94" "eae831de756bb480240479794e85f1da0789c6f2f7746e5cc999370bbc8d9c8a" "16dd114a84d0aeccc5ad6fd64752a11ea2e841e3853234f19dc02a7b91f5d661" "4feee83c4fbbe8b827650d0f9af4ba7da903a5d117d849a3ccee88262805f40d" "45a8b89e995faa5c69aa79920acff5d7cb14978fbf140cdd53621b09d782edcf" "6daa09c8c2c68de3ff1b83694115231faa7e650fdbb668bc76275f0f2ce2a437" default))
 '(evil-want-Y-yank-to-eol t)
 '(flycheck-flake8rc ".flake8")
 '(minimap-always-recenter t)
 '(minimap-dedicated-window t)
 '(minimap-hide-fringes t)
 '(minimap-highlight-line nil)
 '(minimap-mode t)
 '(minimap-recenter-type 'middle)
 '(minimap-width-fraction 0.1)
 '(minimap-window-location 'right)
 '(org-bullets-bullet-list '("◉" "•" "◦" "*" "✸"))
 '(org-capture-templates
   '(("n" "Standard note" entry
      (file "~/docs/org/notes.org")
      "")
     ("w" "Web note" entry
      (file+olp "~/docs/org/notes.org" "Web Notes")
      "* %:annotation :website:note:
%U %?%:initial")
     ("l" "Link" entry
      (file+olp "~/docs/org/main.org" "Content Management" "Websites")
      "* %:annotation :website:
%?")))
 '(org-export-backends '(ascii html icalendar latex md odt))
 '(org-modules
   '(org-bbdb org-bibtex org-docview org-gnus org-habit org-info org-irc org-mhe org-rmail org-w3m))
 '(org-startup-indented t)
 '(package-selected-packages
   '(lv parseedn parseclj a ansible-doc company-ansible transient gherkin-mode ansible git-gutter-fringe+ git-gutter-fringe fringe-helper git-gutter+ git-gutter diff-hl zeal-at-point jinja2-mode tide typescript-mode mingus olivetti imenu-list fountain-mode yasnippet-snippets company-quickhelp langtool synosaurus smooth-scrolling minimap pandoc-mode pandoc wordsmith-mode toml-mode racer flycheck-rust disaster company-emacs-eclim eclim company-c-headers company-auctex cmake-mode clang-format cargo rust-mode auctex-latexmk auctex origami insert-shebang fish-mode company-shell helm-dictionary erc-yt erc-view-log erc-social-graph erc-image erc-hl-nicks sql-indent evil-cleverparens yaml-mode zoutline swiper web-mode tagedit slim-mode scss-mode sass-mode pug-mode helm-css-scss haml-mode emmet-mode company-web web-completion-data lispyville ivy parinfer base16-gruvbox-dark-medium-theme writeroom-mode visual-fill-column writegood-mode geiser mu4e-maildirs-extension mu4e-alert ht ac-ispell flyspell-popup spray engine-mode spotify helm-spotify-plus multi base16-theme pdf-tools tablist yapfify pyvenv pytest pyenv-mode py-isort pip-requirements live-py-mode hy-mode helm-pydoc helm-company helm-c-yasnippet fuzzy flyspell-correct-helm flyspell-correct flycheck-pos-tip pos-tip flycheck cython-mode dash-functional tern company-statistics company-anaconda company clojure-snippets clj-refactor inflections edn paredit peg cider-eval-sexp-fu cider sesman queue clojure-mode auto-yasnippet auto-dictionary auto-complete anaconda-mode pythonic web-beautify livid-mode skewer-mode simple-httpd json-mode json-snatcher json-reformat js2-refactor yasnippet multiple-cursors js2-mode js-doc coffee-mode xkcd smeargle orgit org-projectile org-category-capture org-present org-pomodoro alert log4e gntp org-mime org-download mmm-mode markdown-toc markdown-mode magit-gitflow htmlize helm-gitignore gnuplot gitignore-mode gitconfig-mode gitattributes-mode git-timemachine git-messenger git-link gh-md evil-magit magit magit-popup git-commit ghub with-editor ws-butler winum volatile-highlights vi-tilde-fringe uuidgen use-package toc-org spaceline powerline restart-emacs request rainbow-delimiters popwin persp-mode pcre2el paradox spinner org-bullets open-junk-file neotree move-text macrostep lorem-ipsum linum-relative link-hint indent-guide hungry-delete hl-todo highlight-parentheses highlight-numbers parent-mode highlight-indentation helm-themes helm-swoop helm-projectile helm-mode-manager helm-make projectile pkg-info epl helm-flx helm-descbinds helm-ag google-translate golden-ratio flx-ido flx fill-column-indicator fancy-battery eyebrowse expand-region exec-path-from-shell evil-visualstar evil-visual-mark-mode evil-tutor evil-surround evil-search-highlight-persist evil-numbers evil-nerd-commenter evil-mc evil-matchit evil-lisp-state smartparens evil-indent-plus evil-iedit-state iedit evil-exchange evil-escape evil-ediff evil-args evil-anzu anzu evil goto-chg eval-sexp-fu highlight elisp-slime-nav dumb-jump diminish define-word column-enforce-mode clean-aindent-mode bind-map bind-key auto-highlight-symbol auto-compile packed ace-link ace-jump-helm-line helm helm-core popup which-key undo-tree org-plus-contrib hydra evil-unimpaired f s dash async aggressive-indent adaptive-wrap ace-window avy))
 '(send-mail-function nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Gohu GohuFont" :foundry "Gohu" :slant normal :weight normal :height 126 :width normal))))
 '(font-lock-comment-face ((t (:foreground "#877d69" :slant italic))))
 '(minimap-active-region-background ((t (:background "gray7"))))
 '(minimap-font-face ((t (:height 30 :family "minimap"))))
 '(org-column ((t (:background "gray8"))))
 '(org-verbatim ((t (:inherit org-code))))
 '(outline-4 ((t (:inherit font-lock-type-face))))
 '(outline-5 ((t (:inherit font-lock-constant-face))))
 '(outline-6 ((t (:inherit font-lock-builtin-face))))
 '(outline-7 ((t (:inherit font-lock-string-face))))
 '(outline-8 ((t (:inherit font-lock-type-face)))))

