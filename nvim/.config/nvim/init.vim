scriptencoding utf-8
" {{{ Plugins
call plug#begin('~/.config/nvim/plugged')

Plug 'neomake/neomake'
Plug 'neovim/nvim-lspconfig'
" Plug 'ervandew/supertab'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
" Plug '~/projects/webcomplete/src/vim-plugin'

Plug 'zchee/deoplete-jedi'
Plug 'carlitux/deoplete-ternjs'
Plug 'clojure-vim/async-clj-omni'
Plug 'Shougo/neco-syntax'
Plug 'artur-shaik/vim-javacomplete2'
" Plug 'airblade/vim-rooter'
" for global config
Plug 'editorconfig/editorconfig-vim'
Plug 'subnut/nvim-ghost.nvim', {'do': ':call nvim_ghost#installer#install()', 'on': []}

Plug 'mileszs/ack.vim'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

" Commenter
Plug 'tpope/vim-commentary'
Plug 'mbbill/undotree'

" Code snippets
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

""" Clojure
Plug 'guns/vim-clojure-static', {'for': 'clojure'}
Plug 'tpope/vim-fireplace', {'for': 'clojure'}
" Bundle 'kien/rainbow_parentheses.vim'
Plug 'tpope/vim-leiningen', {'for': 'clojure'}

""" Android
Plug 'hsanson/vim-android'

" Haskell
Plug 'neovimhaskell/haskell-vim', {'for': 'haskell'}

Plug 'jceb/vim-orgmode'
" wiki
Plug 'fcpg/vim-waikiki'
Plug 'mattn/calendar-vim'
Plug 'vim-scripts/utl.vim' " Universal Text Linking
Plug 'dhruvasagar/vim-table-mode'

""" Prose
Plug 'junegunn/goyo.vim'
Plug 'junegunn/limelight.vim'
Plug 'vim-scripts/LanguageTool'
Plug 'kana/vim-textobj-user'
Plug 'reedes/vim-textobj-quote', {'for': ['text', 'markdown', 'tex']}
Plug 'reedes/vim-textobj-sentence', {'for': ['text', 'markdown', 'tex']}
Plug 'reedes/vim-litecorrect', {'for': ['text', 'markdown', 'tex']}
Plug 'reedes/vim-wordy', {'for': ['text', 'markdown', 'tex']}
Plug 'reedes/vim-pencil', {'for': ['text', 'markdown']}
Plug 'reedes/vim-lexical', {'for': ['text', 'markdown', 'tex']}
Plug 'ron89/thesaurus_query.vim'
Plug 'dbmrq/vim-ditto', {'for': ['text', 'markdown', 'tex']}
Plug 'reedes/vim-wheel', {'for': ['text', 'markdown', 'tex']}

Plug 'vim-pandoc/vim-pandoc'
Plug 'vim-pandoc/vim-pandoc-syntax'


""" Latex 
Plug 'xuhdev/vim-latex-live-preview', {'for': 'tex'}
Plug 'lervag/vimtex', {'for': 'tex'}

""" Vue
Plug 'posva/vim-vue', {'for': 'vue'}

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
Plug 'tmhedberg/SimpylFold', { 'for': 'python' }

Plug 'mattn/emmet-vim'

"Base16
Plug 'pinusc/term.vim'

"Cool start screen
Plug 'mhinz/vim-startify'
" Plug 'easymotion/vim-easymotion'
Plug 'justinmk/vim-sneak'
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
nmap Y y$

" mostly for latex
set conceallevel=1
set concealcursor=""

" command completion
set wildmode=longest,list,full
set wildmenu

set t_Co=16
set background=dark
colorscheme term

set undolevels=10000         " use many levels of undo
set history=10000

if has('persistent_undo')
    set undofile 
endif 

" auto close location list when switching buffers
augroup lostcontext
  au!
  autocmd BufWinEnter quickfix nnoremap <silent> <buffer> q :cclose<cr>:lclose<cr>
  autocmd BufEnter * if (winnr('$') == 1 && &buftype ==# 'quickfix' ) | bd | q | endif
augroup END

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
"IMPORTANT: Please read through the instructions at least once completely before actually following them to avoid any problems because you missed something!
     hi StartifyPath ctermfg=243
" endfunction


let g:indentLine_char = '│'

syntax enable
set errorformat=%A%f:%l:\ %m,%-Z%p^,%-C%.%#
set shiftwidth=4
set expandtab
set colorcolumn=81

set title
set titleold=urxvt
augroup title
    au!
    autocmd BufEnter * let &titlestring = expand("%:t")
augroup end

let &t_ZH="\e[3m"
let &t_ZR="\e[23m"
set fillchars=fold:\ 
" }}}

" {{{ LSP
" lua require'lspconfig'.denols.setup{}

lua << EOF
local nvim_lsp = require('lspconfig')

-- Use an on_attach function to only map the following keys 
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  --Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=false }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space><space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space><space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<space><space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  buf_set_keymap("v", '<space>f', '<ESC><cmd>lua vim.lsp.buf.range_formatting()<CR>', opts)
  buf_set_keymap("n", '<space><space>f', '<ESC><cmd>lua vim.lsp.buf.range_formatting()<CR>', {noremap=false})

end

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = { "denols", "pylsp" }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    }
  }
end

nvim_lsp["pylsp"].setup {
    filetypes = { "python", "python.ipynb" }
}
local border = {
      {"┌", "FloatBorder"},
      {"─", "FloatBorder"},
      {"┐", "FloatBorder"},
      {"│", "FloatBorder"},
      {"┘", "FloatBorder"},
      {"─", "FloatBorder"},
      {"└", "FloatBorder"},
      {"│", "FloatBorder"},
}

-- LSP settings (for overriding per client)
local handlers =  {
  ["textDocument/hover"] =  vim.lsp.with(vim.lsp.handlers.hover, {border = border}),
  ["textDocument/signatureHelp"] =  vim.lsp.with(vim.lsp.handlers.signature_help, {border = border }),
}

-- To instead override globally
local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
  opts = opts or {}
  opts.border = opts.border or border
  return orig_util_open_floating_preview(contents, syntax, opts, ...)
end


vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = false,
    signs = true,
    update_in_insert = false,
    underline = false
  }
)
-- show diagnostics on hover only
vim.o.updatetime = 250
vim.cmd [[autocmd! CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false, border=border})]]
EOF

" }}}

" {{{ Treesitter
lua <<EOF
require'nvim-treesitter.configs'.setup {
    ensure_installed = "all", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
    highlight = {
        enable = true,              -- false will disable the whole extension
        disable = { "c", "rust", "markdown" },  -- list of language that will be disabled
        -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
        -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
        -- Using this option may slow down your editor, and you may see some duplicate highlights.
        -- Instead of true it can also be a list of languages
        additional_vim_regex_highlighting = false,
    },
    indent = {
        enable = true,
    },
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = "<C-p>",
            node_incremental = "<C-p>",
        },
    },
    rainbow = {
        enable = true,
        -- disable = { "jsx", "cpp" }, list of languages you want to disable the plugin for
        extended_mode = false, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
        max_file_lines = nil, -- Do not enable for files with more than n lines, int
        -- colors = {}, -- table of hex strings
        -- termcolors = {} -- table of colour name strings
    },
}
EOF
" }}}

" {{{ Mappings 
" Display TODO
nnoremap <leader>TODO :vimgrep TODO **/*.py

" autocorrect
" force top correction on most recent misspelling
imap <C-l> <Esc>[s1z=`]a
nmap <C-l> [s1z=``

" linewise paste
nnoremap <leader>p m`o<ESC>p``
nnoremap <leader>P m`O<ESC>p``


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
"
tnoremap <A-h> <C-\><C-n><C-w>h
tnoremap <A-j> <C-\><C-n><C-w>j
tnoremap <A-k> <C-\><C-n><C-w>k
tnoremap <A-l> <C-\><C-n><C-w>l
nnoremap <A-h> <C-w>h
nnoremap <A-j> <C-w>j
nnoremap <A-k> <C-w>k
nnoremap <A-l> <C-w>l
" additional window mappings to avoid conflict with sexp
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
imap jk <Esc>
map <f2> :NERDTreeToggle<cr>
let mapleader = "\<Space>"
let maplocalleader = "\<Space>\<Space>"

" file bindings
map <leader>w :w<CR>
map <leader>W :Gw<CR>
map <leader>qq :q<CR>
map <leader>qa :qa<CR>
map <leader>Q :q!<CR>
map <leader>x :x<CR>
nnoremap <leader>cd :lcd %:p:h<CR>:pwd<CR>
nnoremap <leader>cD :cd %:p:h<CR>:pwd<CR>

" find bindings
map <leader><tab> :e #<cr>
map <leader>e :Explore<cr><cr>
map <leader>s :Sexplore<cr><cr>
map <leader>v :Vexplore<cr><cr>
map <leader>u :UndotreeToggle<CR>
map <leader>h :nohlsearch<CR>
map <leader>ji :call cursor(0, 1)<cr>:call search("import")<cr>

" git bindings
map <leader>gs :Git<cr>
map <leader>gc :Git commit<cr>
map <leader>gr :Git rebase<cr>
map <leader>gl :Gclog<cr>
map <leader>gb :Git_blame<cr>
map <leader>gw :Gwrite<cr>

" other bindings
nnoremap <C-q> :center 80<cr>hhv0r=0r#A<space><esc>40A=<esc>d80<bar>
nnoremap <C-s> yypVr=k
" nnoremap <C-h> :.,$!pandoc -f markdown -t html<cr>
" nnoremap <C-p> :.,$!pandoc -f markdown -t html<cr>
" vnoremap <C-h> :'<,'>$!pandoc -f markdown -t html<cr>
" vnoremap <C-p> :'<,'>$!pandoc -f markdown -t html<cr>

function! StartMakeView()
    NeomakeSh! make view
    augroup makeview
        au!
        autocmd CursorHold,CursorHoldI,BufWritePost <buffer> :NeomakeSh! make
    augroup END
    redraw!
endfunction

command! StartMakeView call StartMakeView()

nmap ; <cmd>Telescope buffers<CR>
nmap <Leader>f <cmd>Telescope find_files<CR>
nmap <Leader>F <cmd>Telescope git_files<CR>
nmap <Leader>' <cmd>Telescope oldfiles<CR>
nmap <Leader>t <cmd>Telescope current_buffer_tags<CR>
nmap <Leader>T <cmd>Telescope tags<CR>
nmap <Leader>p <cmd>Telescope registers<CR>
map <leader>/ <cmd>Telescope live_grep<CR>
lua << EOF
local actions = require('telescope.actions')
require('telescope').setup{
defaults = {
    mappings = {
        i = {
            -- To disable a keymap, put [map] = false
            -- So, to not map "<C-n>", just put
            ["<C-n>"] = false,
            ["<C-p>"] = false,
            ["<C-k>"] = actions.move_selection_previous,
            ["<C-j>"] = actions.move_selection_next,

            -- Otherwise, just set the mapping to the function that you want it to be.
            ["<C-i>"] = actions.select_horizontal,

            -- Add up multiple actions
            ["<cr>"] = actions.select_default + actions.center,
            ["<esc>"] = actions.close,
            },
        },
    }
}
EOF

" sessions
let g:session_dir = $HOME . '/.config/nvim/sessions/'
function! FindProjectName()
  let s:name = getcwd()
  if !isdirectory('.git')
    let s:name = substitute(finddir('.git', '.;'), '/.git', '', '')
  end
  if s:name !=? '' 
    let s:name = matchstr(s:name, '.*', strridx(s:name, '/') + 1)
  end
  return s:name
endfunction

" Sessions only restored if we start Vim without args.
function! RestoreSession(name)
  if a:name !=? '' 
      echo g:session_dir . a:name
    if filereadable(g:session_dir . a:name)
      execute 'source ' . g:session_dir . a:name
    end
  end
endfunction

" Sessions only saved if we start Vim without args.
function! SaveSession(name)
  if a:name !=? '' 
    execute 'mksession! ' . g:session_dir . a:name
  end
endfunction

" Restore and save sessions.
if argc() == 0
    augroup session
        autocmd VimEnter * nested call RestoreSession(FindProjectName())
        autocmd VimLeave * nested call SaveSession(FindProjectName())
    augroup END
end

" }}}

" {{{ Filetype specific
"
let g:org_heading_shade_leading_stars = 1

augroup vimrc
    au bufwinenter setlocal foldmethod=manual
augroup end

augroup vimrc
    au BufReadPre * setlocal foldmethod=indent
    au BufWinEnter * if &fdm == 'indent' | setlocal foldmethod=marker | endif
augroup END

" use this variable to remember initial src dir
let g:startcwd = getcwd()
function! SetupJava()
  " let l:path=system("echo -n \"$CLASSPATH:$(git rev-parse --show-toplevel)\"")
  let l:path=system("echo -n \"$CLASSPATH:" . g:startcwd . "\"")
  " echom l:path
  let g:neomake_java_javac_classpath = l:path.'/src/'
endfunction


augroup java
    au!
    autocmd FileType java setlocal omnifunc=javacomplete#Complete
    autocmd Filetype java setlocal foldmethod=syntax
    " foldnestmax=2 folds classes and methods but not inner blocks
    autocmd Filetype java setlocal foldnestmax=2
    autocmd Filetype java set makeprg=make
    " autocmd Filetype let g:neomake_java_javac_classpath = 'src'
    autocmd Filetype java call SetupJava()
augroup END

let g:pencil#conceallevel = 0
" Prose {{{
function! Prose()
  let g:textobj#quote#educate = 0
  let g:pencil#wrapModeDefault = 'soft'
  let g:pencil#conceallevel = 0
  set keywordprg=dict\ -s\ substring
  " let g:lexical#thesaurus = ['~/.config/nvim/thesaurus/mthesaur.txt',]
  " let g:lexical#dictionary_key = '<c-d>'
  " let g:lexical#dictionary = ['/usr/share/dict/words',]
  nnoremap <c-t> :OnlineThesaurusCurrentWord<CR>
  call pencil#init()
  call lexical#init()
  call litecorrect#init()
  call textobj#quote#init()
  call textobj#sentence#init()

  " manual reformatting shortcuts
  nnoremap <buffer> <silent> Q gqap
  xnoremap <buffer> <silent> Q gq
  nnoremap <buffer> <silent> <leader>Q vapJgqap

  " replace common punctuation
  iabbrev <buffer> << «
  iabbrev <buffer> >> »

  let g:languagetool_jar = '/usr/share/java/languagetool/languagetool-commandline.jar'
endfunction

function! PandocPreview() 
    autocmd BufWritePost <buffer> silent execute "!pandoc % -o %:r.pdf &"
    write
    execute "!zathura %:r.pdf &"
endfunction

command! -nargs=0 PandocPreview call PandocPreview()

function! UpdateWordCount()
    exe "normal! gg"
    call search("\\.\\.\\.")
    exe "normal! V"
    call search("Word Count")
    exe "normal! k"
    let d = wordcount()
    " for [key, value] in items(d)
    "     echo key . ': ' . value
    " endfor
    let words = d.visual_words
    exe "%s/Word Count:.*/Word Count: " . words . "/"
    exe "normal! V"
endfunction
command! -nargs=0 UpdateWordCount call UpdateWordCount()

" automatically initialize buffer by file type
augroup prose
    au!
    autocmd FileType markdown,mkd,text,rst call Prose()
augroup END

" invoke manually by command for other file types
command! -nargs=0 Prose call Prose()
" }}}

" {{{ Clojure 
"  Automagic Clojure folding on defn's and defmacro's
if !exists ('*GetClojureFold')
    function GetClojureFold()
        if getline(v:lnum) =~? '^\s*(defn.*\s'
            return '>1'
        elseif getline(v:lnum) =~? '^\s*(defmacro.*\s'
            return '>1'
        elseif getline(v:lnum) =~? '^\s*(defmethod.*\s'
            return '>1'
        elseif getline(v:lnum) =~? '^\s*$'
            let my_cljnum = v:lnum
            let my_cljmax = line('$')

            while (1)
                let my_cljnum = my_cljnum + 1
                if my_cljnum > my_cljmax
                    return '<1'
                endif

                let my_cljdata = getline(my_cljnum)

                " If we match an empty line, stop folding
                if my_cljdata =~? '^$'
                    return '<1'
                else
                    return '='
                endif
            endwhile
        else
            return '='
        endif
    endfunction

    function TurnOnClojureFolding()
        setlocal foldexpr=GetClojureFold()
        setlocal foldmethod=expr
    endfunction
endif

" }}} Clojure

augroup fold
    au!
    autocmd Filetype c set foldmethod=syntax
    autocmd Filetype python setlocal foldmethod=expr
    autocmd Filetype help,startify,clojure :IndentLinesDisable
    autocmd FileType clojure call TurnOnClojureFolding()
    autocmd FileType clojure IndentLinesDisable
augroup END
    
let g:python_host_prog = '/usr/bin/python'
let g:python2_host_prog = '/usr/bin/python2'
let g:python3_host_prog = '/usr/bin/python3'

let g:neomake_python_enabled_makers = ['pylama']

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

" {{{ Latex
let g:vimtex_view_method='zathura'
let g:vimtex_quickfix_mode=0
let g:vimtex_fold_enabled=1
let g:tex_flavor='latex'
let g:tex_conceal='abdmg'
let g:neomake_tex_enabled_makers=[]
let g:vimtex_doc_handlers=['Texdoc_zathura']

let g:vimtex_compiler_latexrun = {
            \ 'backend' : 'nvim',
            \ 'background' : 1,
            \ 'build_dir' : '',
            \ 'options' : [
            \   '-verbose-cmds',
            \   '-shell-escape',
            \   '--latex-args="-synctex=1"',
            \ ],
            \}

let g:vimtex_compiler_latexmk = {
    \ 'options' : [
    \   '-pdf',
    \   '-shell-escape',
    \   '-verbose',
    \   '-file-line-error',
    \   '-synctex=1',
    \   '-interaction=nonstopmode',
    \ ],
    \}

" lifted from vimtex/doc.vim with a change to open texdoc in zathura
function! Texdoc_zathura(context) abort " 
  if !has_key(a:context, 'selected')
    call vimtex#doc#make_selection(a:context)
  endif

  if empty(a:context.selected) | return | endif

  if get(a:context, 'ask_before_open', 1)
    call vimtex#echo#formatted([
          \ 'Open documentation for ',
          \ ['VimtexSuccess', a:context.selected], ' [y/N]? '
          \])

    let l:choice = nr2char(getchar())
    if l:choice ==# 'y'
      echon 'y'
    else
      echohl VimtexWarning
      echon l:choice =~# '\w' ? l:choice : 'N'
      echohl NONE
      return
    endif
  endif

  let l:os = vimtex#util#get_os()
  let l:url = 'http://texdoc.net/pkg/' . a:context.selected

  silent execute '!zathura ' . l:url . ' &'

  redraw!
endfunction


" }}}

" {{{ Pymode
let g:pymode_rope = 0

" documentation
let g:pymode_doc = 1
let g:pymode_doc_key = 'k'

"linting
let g:pymode_lint = 0
" auto check on save
let g:pymode_lint_write = 0

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
let g:pymode_folding = 0
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
augroup Emmet
    au!
    autocmd FileType html,css,scss,vue EmmetInstall
    autocmd FileType html,css,scss imap <buffer> <TAB> <plug>(emmet-expand-abbr)
augroup END

let g:NERDCustonDelimiters = {
            \ 'python': {'right': '# '}}

call deoplete#custom#source('ultisnips', 'matchers', ['matcher_fuzzy'])

let g:deoplete#enable_at_startup = 1
let g:UltiSnipsExpandTrigger='<C-e>'
let g:UltiSnipsJumpForwardTrigger='<tab>'
let g:UltiSnipsJumpBackwardTrigger='<s-tab>'

inoremap <expr><tab> pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr><s-tab> pumvisible() ? "\<C-p>" : "\<TAB>"

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

let g:sneak#s_next = 1

" {{{ GhostText
augroup nvim_ghost_user_autocommands
  au User www.reddit.com,www.stackoverflow.com set filetype=markdown
  au User *github.com set filetype=markdown
  au User code.earthengine.google.com set filetype=javascript
  " au User code.earthengine.google.com lua vim.lsp.callbacks["textDocument/publishDiagnostics"] = function() end
augroup END

command! GhostSStart call plug#load('nvim-ghost.nvim')

" }}}

" {{{ Mappings 
" Display TODO
nnoremap <leader>TODO :vimgrep TODO **/*.py

" autocorrect
" force top correction on most recent misspelling
imap <C-l> <Esc>[s1z=`]a
nmap <C-l> [s1z=``

" linewise paste
nnoremap <leader>p m`o<ESC>p``
nnoremap <leader>P m`O<ESC>p``


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
"
tnoremap <A-h> <C-\><C-n><C-w>h
tnoremap <A-j> <C-\><C-n><C-w>j
tnoremap <A-k> <C-\><C-n><C-w>k
tnoremap <A-l> <C-\><C-n><C-w>l
nnoremap <A-h> <C-w>h
nnoremap <A-j> <C-w>j
nnoremap <A-k> <C-w>k
nnoremap <A-l> <C-w>l
" additional window mappings to avoid conflict with sexp
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
imap jk <Esc>
map <f2> :NERDTreeToggle<cr>
let mapleader = "\<Space>"
let maplocalleader = "\<Space>\<Space>"

" file bindings
map <leader>w :w<CR>
map <leader>W :Gw<CR>
map <leader>qq :q<CR>
map <leader>qa :qa<CR>
map <leader>Q :q!<CR>
map <leader>x :x<CR>
nnoremap <leader>cd :lcd %:p:h<CR>:pwd<CR>
nnoremap <leader>cD :cd %:p:h<CR>:pwd<CR>

" find bindings
map <leader><tab> :e #<cr>
map <leader>e :Explore<cr><cr>
map <leader>s :Sexplore<cr><cr>
map <leader>v :Vexplore<cr><cr>
map <leader>u :UndotreeToggle<CR>
map <leader>h :nohlsearch<CR>
map <leader>ji :call cursor(0, 1)<cr>:call search("import")<cr>

" git bindings
map <leader>gs :Gstatus<cr>
map <leader>gc :Gcommit<cr>
map <leader>gr :Grebase<cr>

" other bindings
nnoremap <C-q> :center 80<cr>hhv0r=0r#A<space><esc>40A=<esc>d80<bar>
nnoremap <C-s> yypVr=k
" nnoremap <C-h> :.,$!pandoc -f markdown -t html<cr>
" nnoremap <C-p> :.,$!pandoc -f markdown -t html<cr>
" vnoremap <C-h> :'<,'>$!pandoc -f markdown -t html<cr>
" vnoremap <C-p> :'<,'>$!pandoc -f markdown -t html<cr>

function! StartMakeView()
    NeomakeSh! make view
    augroup makeview
        au!
        autocmd CursorHold,CursorHoldI,BufWritePost <buffer> :NeomakeSh! make
    augroup END
    redraw!
endfunction

command! StartMakeView call StartMakeView()


" fzf mappings
let g:fzf_command_prefix = 'Fzf'

command! -bang -nargs=* FzfRg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always --smart-case '.shellescape(<q-args>), 1,
  \   <bang>0 ? fzf#vim#with_preview('up:60%')
  \           : fzf#vim#with_preview('right:50%:hidden', '?'),
  \   <bang>0)

nmap ; :FzfBuffers<CR>
nmap <leader>; :FzfHistory<CR>
nmap <Leader>f :FzfGFiles<CR>
nmap <Leader>F :FzfFiles<CR>
nmap <Leader>' :FzfFiles<CR>
nmap <Leader>t :FzfBTags<CR>
nmap <Leader>T :FzfTags<CR>
map <leader>/ :FzfRg!<CR>
map <leader>gl :FzfCommits<CR>
augroup fzf-bind
    au!
    autocmd FileType fzf tmap <buffer> <esc> <c-g>
augroup END

function! s:neigh_sink(file)
    if filereadable(a:file)
        execut 'e' . a:file
    endif
    if isdirectory(a:file)
          let command = 'find ' . a:file . ' -maxdepth 1'

          call fzf#run({
                \ 'source': command,
                \ 'sink':  function('s:neigh_sink'),
                \ 'options': '-m -x +s',
                \ 'down':  '40%' })
    endif
endfunction

function! s:fzf_neighbouring_files()
  let current_file =expand('%')
  let cwd = fnamemodify(current_file, ':p:h')
  " let command = 'cat <(find ' . cwd . ' -maxdepth 1) <(echo ..)'
  let command = 'echo ..; find ' . cwd . ' -maxdepth 1'

  call fzf#run({
        \ 'source': command,
        \ 'sink':  function('s:neigh_sink'),
        \ 'options': '-m -x +s',
        \ 'down':  '40%' })
endfunction

command! FZFNeigh call s:fzf_neighbouring_files()

" sessions
let g:session_dir = $HOME . '/.config/nvim/sessions/'
function! FindProjectName()
  let s:name = getcwd()
  if !isdirectory('.git')
    let s:name = substitute(finddir('.git', '.;'), '/.git', '', '')
  end
  if s:name !=? '' 
    let s:name = matchstr(s:name, '.*', strridx(s:name, '/') + 1)
  end
  return s:name
endfunction

" Sessions only restored if we start Vim without args.
function! RestoreSession(name)
  if a:name !=? '' 
      echo g:session_dir . a:name
    if filereadable(g:session_dir . a:name)
      execute 'source ' . g:session_dir . a:name
    end
  end
endfunction

" Sessions only saved if we start Vim without args.
function! SaveSession(name)
  if a:name !=? '' 
    execute 'mksession! ' . g:session_dir . a:name
  end
endfunction

" Restore and save sessions.
if argc() == 0
    augroup session
        autocmd VimEnter * nested call RestoreSession(FindProjectName())
        autocmd VimLeave * nested call SaveSession(FindProjectName())
    augroup END
end

" }}}

" {{{ Statusline 

set laststatus=2
set statusline=
" set statusline+=\ %*
set statusline+=\ %f%(\ %h%)%(\ %m%)
set statusline+=%=
" set statusline+=\ %{LinterStatus()}
set statusline+=\ [%l:%c\ %p%%]
set statusline+=\ %{FugitiveHead()}

" }}}
