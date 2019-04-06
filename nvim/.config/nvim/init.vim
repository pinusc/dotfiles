" {{{ Plugins
call plug#begin('~/.config/nvim/plugged')

Plug 'neomake/neomake'
" Plug 'ervandew/supertab'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
" Plug '~/projects/webcomplete/src/vim-plugin'

Plug 'zchee/deoplete-jedi'
Plug 'carlitux/deoplete-ternjs'
Plug 'clojure-vim/async-clj-omni'
Plug 'Shougo/neco-syntax'
" for global config
Plug 'editorconfig/editorconfig-vim'

Plug 'mileszs/ack.vim'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

" Commenter
Plug 'tpope/vim-commentary'

Plug 'dhruvasagar/vim-table-mode'

" Code snippets
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

""" Clojure
Plug 'guns/vim-clojure-static', {'for': 'clojure'}
Plug 'tpope/vim-fireplace', {'for': 'clojure'}
" Bundle 'kien/rainbow_parentheses.vim'
Plug 'tpope/vim-leiningen', {'for': 'clojure'}

""" Prose
Plug 'junegunn/goyo.vim'
Plug 'junegunn/limelight.vim'
Plug 'vim-scripts/LanguageTool'
Plug 'kana/vim-textobj-user'
Plug 'reedes/vim-textobj-quote', {'for': ['text', 'markdown', 'tex']}
Plug 'reedes/vim-textobj-sentence', {'for': ['text', 'markdown', 'tex']}
Plug 'reedes/vim-litecorrect', {'for': ['text', 'markdown', 'tex']}
Plug 'reedes/vim-wordy', {'for': ['text', 'markdown', 'tex']}
Plug 'reedes/vim-pencil', {'for': ['text', 'markdown', 'tex']}
Plug 'reedes/vim-lexical', {'for': ['text', 'markdown', 'tex']}
Plug 'beloglazov/vim-online-thesaurus'
Plug 'dbmrq/vim-ditto', {'for': ['text', 'markdown', 'tex']}
Plug 'reedes/vim-wheel', {'for': ['text', 'markdown', 'tex']}

""" Latex 
Plug 'xuhdev/vim-latex-live-preview'
Plug 'lervag/vimtex'

"Editing parentesi
Plug 'guns/vim-sexp', { 'for': 'clojure' }
Plug 'tpope/vim-sexp-mappings-for-regular-people', { 'for': 'clojure' }
"Parentesi arcobaleno
" UnPlugin 'oblitum/rainbow'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-sensible'

Plug 'klen/python-mode', { 'for': 'python' }

Plug 'mattn/emmet-vim'

"Base16
Plug 'pinusc/term.vim'

"Cool start screen
Plug 'mhinz/vim-startify'
Plug 'easymotion/vim-easymotion'
Plug 'terryma/vim-multiple-cursors'
Plug 'Yggdroot/indentLine'

call plug#end()    
" }}}

" {{{ General 
set number
filetype off
filetype plugin indent on
set ignorecase
set smartcase

set t_Co=16
set background=dark
colorscheme term

" let base16colorspace=256
" colorscheme base16-vim

" if filereadable(expand("~/.vimrc_background"))
"   let base16colorspace=256
"   source ~/.vimrc_background
" endif

" augroup on_change_colorschema
"   autocmd!
"   autocmd ColorScheme * call s:base16_customize()
" augroup END

" function! s:base16_customize() abort
"     call Base16hi("LineNr", g:base16_gui02, g:base16_gui00, g:base16_cterm02, g:base16_cterm00, "", "")
"     call Base16hi("Folded", g:base16_gui03, g:base16_gui00, g:base16_cterm03, g:base16_cterm00, "italic", "")
"     call Base16hi("FoldColumn", g:base16_gui0C, g:base16_gui00, g:base16_cterm0C, g:base16_cterm00, "", "")
"     call Base16hi("GitGutterAdd", g:base16_gui0B, g:base16_gui00, g:base16_cterm0B, g:base16_cterm00, "", "")
"     call Base16hi("GitGutterChange", g:base16_gui0D, g:base16_gui00, g:base16_cterm0D, g:base16_cterm00, "", "")
"     call Base16hi("GitGutterDelete", g:base16_gui08, g:base16_gui00, g:base16_cterm08, g:base16_cterm00, "", "")
"     call Base16hi("GitGutterChangeDelete", g:base16_gui0E, g:base16_gui01, g:base16_cterm0E, g:base16_cterm01, "", "")
"     call Base16hi("htmlItalic", g:base16_gui05, g:base16_gui00, g:base16_cterm05, g:base16_cterm00, "italic", "italic")
"     call Base16hi("htmlBold", g:base16_gui05, g:base16_gui00, g:base16_cterm05, g:base16_cterm00, "bold", "bold")
"     hi StartifySection ctermfg=1
"     hi StartifyHeader ctermfg=4
"     hi StartifyPath ctermfg=243
" endfunction


let g:indentLine_char = '│'

syntax enable
set errorformat=%A%f:%l:\ %m,%-Z%p^,%-C%.%#
set shiftwidth=4
set expandtab

set title
set titleold=urxvt
autocmd BufEnter * let &titlestring = expand("%:t")

let &t_ZH="\e[3m"
let &t_ZR="\e[23m"
highlight Comment cterm=italic
" }}}

" {{{ Filetype specific

augroup vimrc
    au bufwinenter setlocal foldmethod=manual
augroup end

augroup vimrc_autocmds
    autocmd!
    " highlight characters past column 80
    autocmd FileType python highlight Excess ctermbg=DarkGrey guibg=Black
    autocmd FileType python match Excess /\%80v.*/
    autocmd FileType python set nowrap
augroup END

augroup vimrc
    au BufReadPre * setlocal foldmethod=indent
    au BufWinEnter * if &fdm == 'indent' | setlocal foldmethod=marker | endif
augroup END

autocmd Filetype java set makeprg=javac\ %
autocmd Filetype c set makeprg=make
autocmd Filetype c set foldmethod=syntax
autocmd Filetype help,startify :IndentLinesToggle

let g:pencil#conceallevel = 0
" Prose {{{
function! Prose()
  let g:textobj#quote#educate = 0
  let g:pencil#wrapModeDefault = 'soft'
  let g:pencil#conceallevel = 0
  let g:lexical#thesaurus = ['~/.config/nvim/thesaurus/mthesaur.txt',]
  let g:lexical#dictionary_key = '<leader>d'
  let g:lexical#dictionary = ['/usr/share/dict/words',]
  nnoremap <leader>t :OnlineThesaurusCurrentWord<CR>
  call pencil#init()
  call lexical#init()
  call litecorrect#init()
  call textobj#quote#init()
  call textobj#sentence#init()

  " manual reformatting shortcuts
  nnoremap <buffer> <silent> Q gqap
  xnoremap <buffer> <silent> Q gq
  nnoremap <buffer> <silent> <leader>Q vapJgqap

  " force top correction on most recent misspelling
  nnoremap <buffer> <c-s> [s1z=<c-o>
  inoremap <buffer> <c-s> <c-g>u<Esc>[s1z=`]A<c-g>u

  " replace common punctuation
  iabbrev <buffer> << «
  iabbrev <buffer> >> »

  let g:languagetool_jar = '/usr/share/java/languagetool/languagetool-commandline.jar'
endfunction

" automatically initialize buffer by file type
autocmd FileType markdown,mkd,text,rst call Prose()

" invoke manually by command for other file types
command! -nargs=0 Prose call Prose()
" }}}

" {{{ Clojure 
"  Automagic Clojure folding on defn's and defmacro's
if !exists ('*GetClojureFold')
    function GetClojureFold()
        if getline(v:lnum) =~ '^\s*(defn.*\s'
            return ">1"
        elseif getline(v:lnum) =~ '^\s*(defmacro.*\s'
            return ">1"
        elseif getline(v:lnum) =~ '^\s*(defmethod.*\s'
            return ">1"
        elseif getline(v:lnum) =~ '^\s*$'
            let my_cljnum = v:lnum
            let my_cljmax = line("$")

            while (1)
                let my_cljnum = my_cljnum + 1
                if my_cljnum > my_cljmax
                    return "<1"
                endif

                let my_cljdata = getline(my_cljnum)

                " If we match an empty line, stop folding
                if my_cljdata =~ '^$'
                    return "<1"
                else
                    return "="
                endif
            endwhile
        else
            return "="
        endif
    endfunction

    function TurnOnClojureFolding()
        setlocal foldexpr=GetClojureFold()
        setlocal foldmethod=expr
    endfunction
endif

autocmd FileType clojure call TurnOnClojureFolding()
" }}} Clojure

" }}}

" {{{ Plugin Specific
set statusline+=%#warningmsg#
set statusline+=%*
set laststatus=2

let g:gitgutter_enabled = 1
let g:gitgutter_sign_added = '·'
let g:gitgutter_sign_modified = '·'
let g:gitgutter_sign_removed = '·'
let g:gitgutter_sign_removed_first_line = '·'
let g:gitgutter_sign_modified_removed = '·'


" {{{ Pymode
let g:pymode_rope = 0

" documentation
let g:pymode_doc = 1
let g:pymode_doc_key = 'k'

"linting
let g:pymode_lint = 1
let g:pymode_lint_checker = "pyflakes,pep8"
" auto check on save
let g:pymode_lint_write = 1

" support virtualenv
let g:pymode_virtualenv = 1

" enable breakpoints plugin
let g:pymode_breakpoint = 1
let g:pymode_breakpoint_key = '<leader>b'

" syntax highlighting
let g:pymode_syntax = 0
let g:pymode_syntax_all = 0
let g:pymode_syntax_indent_errors = g:pymode_syntax_all
let g:pymode_syntax_space_errors = g:pymode_syntax_all

" don't autofold code
let g:pymode_folding = 1 
" }}} 

" {{{ Startify
let g:startify_bookmarks = [{'s': '~/docs/school/'}, {'b': '~/bin'}, {'p': '~/projects/'}, {'v': '~/.config/nvim/init.vim'}]
let g:startify_list_order = [
            \ ['   Bookmarks:'],
            \ 'bookmarks',
            \ ['   My most recently', '   used files'],
            \ 'files',
            \ ['   My most recently used files in the current directory:'],
            \ 'dir',
            \ ['   These are my sessions:'],
            \ 'sessions',
            \ ]

function! s:filter_header(lines) abort
    let longest_line   = max(map(copy(a:lines), 'strwidth(v:val)'))
    let centered_lines = map(copy(a:lines),
                \ 'repeat(" ", (&columns / 2) - (longest_line / 2)) . v:val')
    return centered_lines
endfunction
let g:startify_fortune_use_unicode = 1
let g:startify_custom_header =
            \ map(split(system('fortune -c | cowthink -f $(find /usr/share/cows -type f | shuf -n 1)'), '\n'), '"   ". v:val') + ['','']

let g:startify_custom_header = s:filter_header(startify#fortune#cowsay())
" }}}

"autocmd FileType html,css imap <tab> <plug>(emmet-expand-abbr)
let g:user_emmet_install_global = 0
autocmd FileType html,css,scss EmmetInstall
autocmd FileType html,css,scss imap <buffer> <TAB> <plug>(emmet-expand-abbr)

let g:NERDCustonDelimiters = {
            \ 'python': {'right': '# '}}

call deoplete#custom#source('ultisnips', 'matchers', ['matcher_fuzzy'])

let g:deoplete#enable_at_startup = 1
let g:UltiSnipsExpandTrigger="<C-e>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"

inoremap <expr><tab> pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr><s-tab> pumvisible() ? "\<C-p>" : "\<TAB>"

if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif

aug omnicomplete 
    au!
    au FileType css,sass,scss,stylus,less setl omnifunc=csscomplete#CompleteCSS
    au FileType html,htmldjango,jinja,markdown setl omnifunc=emmet#completeTag
    au FileType javascript,jsx setl omnifunc=tern#Complete
    au FileType python setl omnifunc=pythoncomplete#Complete
    au FileType xml setl omnifunc=xmlcomplete#CompleteTags
aug END

let g:neomake_open_list = 2
call neomake#configure#automake('w')

let g:netrw_liststyle = 3

" }}}

" {{{ Mappings 
" Display TODO
nnoremap <leader>TODO :vimgrep TODO **/*.py

" Tab split more comodo
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

tnoremap <Esc> <C-\><C-n>?\$<CR>
"
" map <F9> :make<Return>:copen<Return>
map <F9> :lclose<Return>
map <F10> :cprevious<Return>
map <F11> :cnext<Return>
map <F5> :!java %:r
" for unimparied
" nmap < [
" nmap > ]
" omap < [
" omap > ]
" xmap < [
" xmap > ]

" to move by screeen line
" :noremap <Up> gk
" :noremap! <Up> <C-O>gk
" :noremap <Down> gj
" :noremap! <Down> <C-O>gj
" the following are optional, to move by file lines using Alt-arrows
" :noremap <M-k> gk
" :noremap <M-j> gj
" :noremap <M-Up> k
" :noremap <M-Down> j
"
:tnoremap <A-h> <C-\><C-n><C-w>h
:tnoremap <A-j> <C-\><C-n><C-w>j
:tnoremap <A-k> <C-\><C-n><C-w>k
:tnoremap <A-l> <C-\><C-n><C-w>l
:nnoremap <A-h> <C-w>h
:nnoremap <A-j> <C-w>j
:nnoremap <A-k> <C-w>k
:nnoremap <A-l> <C-w>l
imap jk <Esc>
map <f2> :NERDTreeToggle<cr>
let mapleader = "\<Space>"
map <leader>w :w<CR>
map <leader>q :q<CR>
map <leader>Q :q!<CR>
map <leader>x :x<CR>
map <leader>e :Explore<CR>
map <leader>s :Sexplore<CR>
map <leader>v :Vexplore<CR>
map <leader>u :UndotreeToggle<CR>
nmap <Leader>' :Files<CR>
map <leader>/ :nohlsearch<CR>
nnoremap <C-q> :center 80<cr>hhv0r=0r#A<space><esc>40A=<esc>d80<bar>
nnoremap <C-h> :.,$!pandoc -f markdown -t html<cr>
nnoremap <C-p> :.,$!pandoc -f markdown -t html<cr>

function! StartMakeView()
    NeomakeSh! make view
    autocmd CursorHold,CursorHoldI,BufWritePost <buffer> :NeomakeSh! make
    redraw!
endfunction

command! StartMakeView call StartMakeView()


" fzf mappings
nmap ; :Buffers<CR>
nmap <Leader>t :Files<CR>
nmap <Leader>r :Tags<CR>

" }}}

" {{{ Statusline 

set laststatus=2
set statusline=
set statusline+=%#User1#\ %l
set statusline+=\ %*
set statusline+=\ ‹‹
set statusline+=\ %f\ %*
set statusline+=\ ››
set statusline+=\ %m
set statusline+=%#User2#\ %F
set statusline+=%=
" set statusline+=\ %{LinterStatus()}
set statusline+=\ ‹‹
set statusline+=\ %{strftime('%R',getftime(expand('%')))}
set statusline+=\ ::
set statusline+=\ %n
set statusline+=\ ››\ %*

" }}}
