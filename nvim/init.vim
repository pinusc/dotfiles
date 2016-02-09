set number
filetype off                  " required

imap jj <Esc>

call plug#begin('~/.config/nvim/plugged')
" let Vundle manage Vundle, required
Plug 'gmarik/Vundle.vim'

Plug 'scrooloose/syntastic'
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" for global config
Plug 'editorconfig/editorconfig-vim'

" Commenter
Plug 'tomtom/tcomment_vim'
" Code snippets
Plug 'ervandew/supertab'
" Plugin 'msanders/snipmate.vim'
" Track the engine.
Plug 'SirVer/ultisnips'

" Snippets are separated from the engine. Add this if you want them:
Plug 'honza/vim-snippets'

Plug 'bling/vim-airline'
Plug 'vim-airline/vim-airline-themes'
set laststatus=2
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1


""" Clojure
Plug 'guns/vim-clojure-static'
Plug 'tpope/vim-fireplace'
" Bundle 'kien/rainbow_parentheses.vim'
Plug 'tpope/vim-leiningen'

"Editing parentesi
Plug 'guns/vim-sexp'
Plug 'tpope/vim-sexp-mappings-for-regular-people' 
"Parentesi arcobaleno
" Plugin 'oblitum/rainbow'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
let g:gitgutter_enabled = 0
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'

Plug 'klen/python-mode'
Plug 'kchmck/vim-coffee-script'

"Solarized
Plug 'altercation/vim-colors-solarized'
"Base16
Plug 'chriskempson/base16-vim'


"File browser
Plug 'scrooloose/nerdtree'
Plug 'amiorin/vim-project'
" fuzzy file finder
Plug 'kien/ctrlp.vim'
" quick file movement
Plug 'Lokaltog/vim-easymotion'
"Cool start screen
Plug 'mhinz/vim-startify'


" completion
function! BuildYCM(info)
  if a:info.status == 'installed' || a:info.force
    !./install.sh
  endif
endfunction
Plug 'Valloric/YouCompleteMe', { 'do': function('BuildYCM') }


"AWESOME TAGS!!!
" Plugin 'majutsushi/tagbar'
" Plugin 'lukaszkorecki/CoffeeTags'

" All of your Plugins must be added before the following line
call plug#end()    

map <f2> :NERDTreeToggle<cr>

"""autocomplete. Don't change it! Rope is sloooooow.
augroup vimrc
  au bufreadpre * setlocal foldmethod=indent
  au bufwinenter * if &fdm == 'indent' | setlocal foldmethod=manual | endif
augroup end
" python-mode
" activate rope
" keys:
" k             show python docs
" <ctrl-space>  rope autocomplete
" <ctrl-c>g     rope goto definition
" <ctrl-c>d     rope show documentation
" <ctrl-c>f     rope find occurrences
" <leader>b     set, unset breakpoint (g:pymode_breakpoint enabled)
" [[            jump on previous class or function (normal, visual, operator modes)
" ]]            jump on next class or function (normal, visual, operator modes)
" [m            jump on previous class or method (normal, visual, operator modes)
" ]m            jump on next class or method (normal, visual, operator modes)
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
        " required

filetype plugin indent on    " required
set t_Co=256
"colorscheme
" hi LineNr ctermfg=yellow
set background=dark
colorscheme base16-eighties
let base16colorspace=256  " Access colors present in 256 colorspace
syntax enable
" hi CursorLineNr term=bold ctermfg=Yellow gui=bold guifg=Yellow

"segui file corrente
" function! ExecuteCurrentFile()
" 	if &filetype == "python"
" 		:!clear; python %
" 	elseif &filetype == "java"
" 		:!reset; java %:r
" 	elseif &filetype == "c"
" 	       :!reset; make; ./start.sh
" 	endif
" endfunction
"
" function! CompileCurrentFile()
"     if &filetype == "c"
"         :!reset; ./compile.sh
" endfunction
" nnoremap <leader>\e :call ExecuteCurrentFile()
" nnoremap <leader>\c :call CompileCurrentFile()
"
augroup vimrc_autocmds
	autocmd!
	" highlight characters past column 80
	autocmd FileType python highlight Excess ctermbg=DarkGrey guibg=Black
	autocmd FileType python match Excess /\%80v.*/
	autocmd FileType python set nowrap
	augroup END
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlPBuffer'
let g:NERDCustonDelimiters = {
\ 'python': {'right': '# '}}

" Display TODO
nnoremap <leader>TODO :vimgrep TODO **/*.py

" Autoreload vimrc
"augroup myvimrc
"    au!
"    au BufWritePost .vimrc,_vimrc,vimrc,.gvimrc,_gvimrc,gvimrc so $MYVIMRC | if has('gui_running') | so $MYGVIMRC | endif
"augroup END
"Syntax Highliting

" Tab split more comodo
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" let g:rainbow_active = 1


let g:startify_bookmarks = ['~/Dropbox/programming/exercises/projecteuler', '~/.config/nvim/init.vim']
let g:startify_list_order = [
    \ ['   These are my bookmarks:'],
    \ 'bookmarks',
    \ ['   My most recently', '   used files'],
    \ 'files',
    \ ['   My most recently used files in the current directory:'],
    \ 'dir',
    \ ['   These are my sessions:'],
    \ 'sessions',
    \ ]

let g:startify_custom_header =
      \ map(split(system('fortune -c | cowthink -f $(find /usr/share/cows -type f | shuf -n 1)'), '\n'), '"   ". v:val') + ['','']



autocmd Filetype java set makeprg=javac\ %
autocmd Filetype c set makeprg=make
autocmd Filetype c set foldmethod=syntax

set errorformat=%A%f:%l:\ %m,%-Z%p^,%-C%.%#
" map <F9> :make<Return>:copen<Return>
map <F9> :lclose<Return>
map <F10> :cprevious<Return>
map <F11> :cnext<Return>
map <F5> :!java %:r
set shiftwidth=4
set expandtab
" set autoindent


" ---------------------------------------------------------------------------
"  Automagic Clojure folding on defn's and defmacro's
"
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

autocmd FileType clojure call TurnOnClojureFolding()

" set title
set title
set titleold=urxvt
autocmd BufEnter * let &titlestring = expand("%:t")

" make YCM compatible with UltiSnips (using supertab)
let g:ycm_key_list_select_completion = ['<C-n>', '<Down>']
let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>']
let g:SuperTabDefaultCompletionType = '<C-n>'

" better key bindings for UltiSnipsExpandTrigger
let g:UltiSnipsExpandTrigger = "<tab>"
let g:UltiSnipsJumpForwardTrigger = "<tab>"
let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"

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
