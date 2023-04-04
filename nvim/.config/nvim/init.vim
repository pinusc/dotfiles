scriptencoding utf-8
" {{{ Plugins
call plug#begin('~/.config/nvim/plugged')

Plug 'neomake/neomake'
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

Plug 'Shougo/neco-syntax'
" Plug 'airblade/vim-rooter'
" for global config
Plug 'editorconfig/editorconfig-vim'
Plug 'subnut/nvim-ghost.nvim', {'do': ':call nvim_ghost#installer#install()', 'on': []}

Plug 'mfussenegger/nvim-dap' " Debug Adapter Protocol
Plug 'mfussenegger/nvim-dap-python'
Plug 'rcarriga/nvim-dap-ui'

Plug 'nvim-lua/plenary.nvim'  " telescope dependency
Plug 'nvim-telescope/telescope.nvim'
Plug 'junegunn/fzf'

" Commenter
Plug 'tpope/vim-commentary'
Plug 'mbbill/undotree'


" Completion
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
" snippets completion
Plug 'quangnguyen30192/cmp-nvim-ultisnips'

" Code snippets
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

""" Clojure
Plug 'guns/vim-clojure-static', {'for': 'clojure'}
Plug 'liquidz/vim-iced', {'for': 'clojure'}
" Plug 'clojure-vim/async-clj-omni', {'for': 'clojure'}
Plug 'tpope/vim-leiningen', {'for': 'clojure'}

""" Android
Plug 'hsanson/vim-android'

Plug 'nvim-orgmode/orgmode'

" " wiki
" Plug 'fcpg/vim-waikiki'
" Plug 'mattn/calendar-vim'
" Plug 'vim-scripts/utl.vim' " Universal Text Linking
" Plug 'dhruvasagar/vim-table-mode'

""" Prose
Plug 'junegunn/goyo.vim'
Plug 'junegunn/limelight.vim'
Plug 'vim-scripts/LanguageTool'
Plug 'kana/vim-textobj-user'
Plug 'reedes/vim-textobj-quote', {'for': ['text', 'markdown', 'tex']}
Plug 'reedes/vim-textobj-sentence', {'for': ['text', 'markdown', 'tex']}
Plug 'reedes/vim-litecorrect', {'for': ['text', 'markdown', 'tex']}
Plug 'reedes/vim-wordy', {'for': ['text', 'markdown', 'tex']}
Plug 'reedes/vim-lexical', {'for': ['text', 'markdown', 'tex']}
Plug 'ron89/thesaurus_query.vim'
Plug 'dbmrq/vim-ditto', {'for': ['text', 'markdown', 'tex']}
Plug 'reedes/vim-wheel', {'for': ['text', 'markdown', 'tex']}

Plug 'vim-pandoc/vim-pandoc'
Plug 'vim-pandoc/vim-pandoc-syntax'

Plug 'elkowar/yuck.vim', {'for': ['yuck']}


""" Latex 
Plug 'lervag/vimtex', {'for': 'tex'}

""" Vue
Plug 'posva/vim-vue', {'for': 'vue'}

""" Todo.txt
Plug 'freitass/todo.txt-vim'


"Editing parentesi
Plug 'windwp/nvim-autopairs'
Plug 'guns/vim-sexp', { 'for': 'clojure' }
Plug 'tpope/vim-sexp-mappings-for-regular-people', { 'for': 'clojure' }
Plug 'p00f/nvim-ts-rainbow'

"Parentesi arcobaleno
" UnPlugin 'oblitum/rainbow'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-sensible'

" Plug 'klen/python-mode', { 'for': 'python' }
" Plug 'tmhedberg/SimpylFold', { 'for': 'python' }

" Jupyter
" This setup requires `pip install --user jupytext qtconsole`
" Afterwards, just opening .ipynb files should convert them correctly
" To execute cells, run `jupytext qtconsole` in a terminal (disown it too)
" Then run :JupyterConnect in vim
" Now pressing alt+Enter on a cell will run it and move to the next one
" Plug 'jupyter-vim/jupyter-vim'
Plug '~/.config/nvim/plugged/jupyter-vim'
Plug 'goerz/jupytext.vim'
Plug '~/.config/nvim/plugged/vim-textobj-hydrogen'
" Plug 'jpalardy/vim-slime', { 'for': 'python' }
" Plug 'hanschen/vim-ipython-cell', { 'for': 'python' }

Plug 'mattn/emmet-vim'

"Base16
Plug 'pinusc/term.vim'

" tmux integration
Plug 'sunaku/tmux-navigate'

"Cool start screen
Plug 'mhinz/vim-startify'
" Plug 'justinmk/vim-sneak'
Plug 'ggandor/leap.nvim'
Plug 'mg979/vim-visual-multi', {'branch': 'master'}

" Better recover
Plug 'chrisbra/Recover.vim'

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
set conceallevel=0
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

function! SynStack()
    if !exists("*synstack")
        return
    endif
    echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc

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


syntax enable
set errorformat=%A%f:%l:\ %m,%-Z%p^,%-C%.%#
set shiftwidth=4
set expandtab
set colorcolumn=81

" set title
" set titleold=urxvt
" augroup title
"     au!
"     autocmd BufEnter * let &titlestring = expand("%:t")
" augroup end

let &t_ZH="\e[3m"
let &t_ZR="\e[23m"
set fillchars=fold:\ 
" }}}

" {{{ Completion (nvim-cmp)

lua <<EOF
  -- Set up nvim-cmp.
  local cmp = require'cmp'

  cmp.setup({
    snippet = {
      expand = function(args)
        vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
      end,
    },
    window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
    },
   mapping = {
        ["<Tab>"] = cmp.mapping({
            c = function()
                if cmp.visible() then
                    cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
                else
                    cmp.complete()
                end
            end,
            i = function(fallback)
                if cmp.visible() then
                    cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
                elseif vim.fn["UltiSnips#CanJumpForwards"]() == 1 then
                    vim.api.nvim_feedkeys(t("<Plug>(ultisnips_jump_forward)"), 'm', true)
                else
                    fallback()
                end
            end,
            s = function(fallback)
                if vim.fn["UltiSnips#CanJumpForwards"]() == 1 then
                    vim.api.nvim_feedkeys(t("<Plug>(ultisnips_jump_forward)"), 'm', true)
                else
                    fallback()
                end
            end
        }),
        ["<S-Tab>"] = cmp.mapping({
            c = function()
                if cmp.visible() then
                    cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
                else
                    cmp.complete()
                end
            end,
            i = function(fallback)
                if cmp.visible() then
                    cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
                elseif vim.fn["UltiSnips#CanJumpBackwards"]() == 1 then
                    return vim.api.nvim_feedkeys( t("<Plug>(ultisnips_jump_backward)"), 'm', true)
                else
                    fallback()
                end
            end,
            s = function(fallback)
                if vim.fn["UltiSnips#CanJumpBackwards"]() == 1 then
                    return vim.api.nvim_feedkeys( t("<Plug>(ultisnips_jump_backward)"), 'm', true)
                else
                    fallback()
                end
            end
        }),
        ['<Down>'] = cmp.mapping(cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }), {'i'}),
        ['<Up>'] = cmp.mapping(cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }), {'i'}),
        ['<C-n>'] = cmp.mapping({
            c = function()
                if cmp.visible() then
                    cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
                else
                    vim.api.nvim_feedkeys(t('<Down>'), 'n', true)
                end
            end,
            i = function(fallback)
                if cmp.visible() then
                    cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
                else
                    fallback()
                end
            end
        }),
        ['<C-p>'] = cmp.mapping({
            c = function()
                if cmp.visible() then
                    cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
                else
                    vim.api.nvim_feedkeys(t('<Up>'), 'n', true)
                end
            end,
            i = function(fallback)
                if cmp.visible() then
                    cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
                else
                    fallback()
                end
            end
        }),
        ['<C-e>'] = cmp.mapping({ 
            i = function() 
                if vim.fn["UltiSnips#CanExpandSnippet"]() == 1 then
                    vim.fn["UltiSnips#ExpandSnippet"]()
                else
                    cmp.mapping.close()
                end
            end
        }),
        ['<CR>'] = cmp.mapping({
            i = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false }),
            -- c = function(fallback)
            --     if cmp.visible() then
            --         cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
            --     else
            --         fallback()
            --     end
            -- end
        }),
    },
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'ultisnips' }, -- For ultisnips users.
    }, {
      { name = 'buffer' },
    })
  })

  -- Set configuration for specific filetype.
  -- cmp.setup.filetype('gitcommit', {
  --   sources = cmp.config.sources({
  --     { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
  --   }, {
  --     { name = 'buffer' },
  --   })
  -- })

  -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' }
    }
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
  })
  --cmp.event:on(
  --  'confirm_done',
  --  cmp_autopairs.on_confirm_done()
  --)
EOF

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
  buf_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>?', '<cmd>lua vim.diagnostic.set_loclist()<CR>', opts)
  buf_set_keymap("v", '<space>f', '<ESC><cmd>lua vim.lsp.buf.range_formatting()<CR>', opts)
  buf_set_keymap("n", '<space><space>f', '<ESC><cmd>lua vim.lsp.buf.range_formatting()<CR>', {noremap=false})

end

-- LSP completions (nvim-lsp)
-- Set up lspconfig.
local cmp_capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = { "denols", "pylsp" }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    capabilities = cmp_capabilities,
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    }
  }
end

nvim_lsp["pylsp"].setup {
    on_attach = on_attach,
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
require('orgmode').setup_ts_grammar()

require'nvim-treesitter.configs'.setup {
    ensure_installed = "all", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
    highlight = {
        enable = true,              -- false will disable the whole extension
        disable = { "c", "rust", "markdown", "tex", "latex" },  -- list of language that will be disabled
        -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
        -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
        -- Using this option may slow down your editor, and you may see some duplicate highlights.
        -- Instead of true it can also be a list of languages
        additional_vim_regex_highlighting = {'org'},
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

nmap <Leader>; <cmd>Telescope buffers<CR>
nmap <Leader>f <cmd>Telescope find_files<CR>
nmap <Leader>F <cmd>Telescope git_files<CR>
nmap <Leader>' <cmd>Telescope oldfiles<CR>
nmap <Leader>t <cmd>Telescope current_buffer_tags<CR>
nmap <Leader>T <cmd>Telescope tags<CR>
nmap <Leader>p <cmd>Telescope registers<CR>
map <leader>/ <cmd>Telescope current_buffer_fuzzy_find<CR>
map <leader><leader>/ <cmd>Telescope live_grep<CR>
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

function! ListNotes()
    :Telescope find_files search_dirs=['/home/pinusc/docs/notes/']
endfunction
command! Notes call ListNotes()

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
lua << EOF
require('orgmode').setup({
  org_agenda_files = {'~/docs/notes/*'},
  org_default_notes_file = '~/docs/notes/notes.org',
  org_todo_keywords = {'TODO(t)', 'NEXT', 'INPROGRESS', '|', 'DONE'},
  org_todo_keyword_faces = {
    TODO = ':foreground red',
    NEXT = ':foreground yellow',
    INPROGRESS = ':foreground green',
    DONE = ':foreground gray',
  }
})
EOF

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

" Prose {{{
function! Prose()
  let g:textobj#quote#educate = 0
  set keywordprg=dict\ -s\ substring
  " let g:lexical#thesaurus = ['~/.config/nvim/thesaurus/mthesaur.txt',]
  " let g:lexical#dictionary_key = '<c-d>'
  " let g:lexical#dictionary = ['/usr/share/dict/words',]
  nnoremap <c-t> :OnlineThesaurusCurrentWord<CR>
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


function! UpdateWordCount()
    let words = system("pandoc ".. expand('%') .. " --to plain | perl -ne 'print if //../Word Count/' | wc -w")
    exe "%s/Word Count:.*/Word Count: " . trim(words) . "/"
endfunction
command! -nargs=0 UpdateWordCount call UpdateWordCount()

" automatically initialize buffer by file type
" augroup prose
"     au!
"     autocmd FileType pandoc,markdown,mkd,text,rst call Prose()
" augroup END

" invoke manually by command for other file types
command! -nargs=0 Prose call Prose()
" }}}

" {{{ Clojure 
"  Automagic Clojure folding on defn's and defmacro's

" if !exists ('*GetClojureFold')
"     function GetClojureFold()
"         if getline(v:lnum) =~? '^\s*(defn.*\s'
"             return '>1'
"         elseif getline(v:lnum) =~? '^\s*(defmacro.*\s'
"             return '>1'
"         elseif getline(v:lnum) =~? '^\s*(defmethod.*\s'
"             return '>1'
"         elseif getline(v:lnum) =~? '^\s*$'
"             let my_cljnum = v:lnum
"             let my_cljmax = line('$')

"             while (1)
"                 let my_cljnum = my_cljnum + 1
"                 if my_cljnum > my_cljmax
"                     return '<1'
"                 endif

"                 let my_cljdata = getline(my_cljnum)

"                 " If we match an empty line, stop folding
"                 if my_cljdata =~? '^$'
"                     return '<1'
"                 else
"                     return '='
"                 endif
"             endwhile
"         else
"             return '='
"         endif
"     endfunction

"     function TurnOnClojureFolding()
"         setlocal foldexpr=GetClojureFold()
"         setlocal foldmethod=expr
"     endfunction
" endif
let g:iced_enable_default_key_mappings = v:true

" }}} Clojure
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()

" augroup fold
"     au!
"     autocmd Filetype c set foldmethod=syntax
"     " autocmd Filetype python setlocal foldmethod=expr
"     autocmd FileType clojure call TurnOnClojureFolding()
" augroup END
    
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

" Visual Multi
let g:VM_default_mappings = 0
let g:VM_maps = {}
let g:VM_maps["Add Cursor Down"] = '<M-Down>'
let g:VM_maps["Add Cursor Up"] = '<M-Up>'

" {{{ dap (debug adapter protocol)
" python
lua require('dap-python').setup('~/.local/share/virtualenvs/debugpy/bin/python')


lua <<EOF
local dap, dapui = require("dap"), require("dapui")
    dapui.setup()
    dap.listeners.after.event_initialized["dapui_config"] = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated["dapui_config"] = function()
      dapui.close()
    end
    dap.listeners.before.event_exited["dapui_config"] = function()
      dapui.close()
    end
EOF

" mappings
lua <<EOF
vim.keymap.set('n', '<leader>dc', function() require('dap').continue() end, {desc = "DAP continue"})
    vim.keymap.set('n', '<leader>dn', function() require('dap').step_over() end, {desc = "DAP step over"})
    vim.keymap.set('n', '<leader>ds', function() require('dap').step_into() end, {desc = "DAP step into"})
    vim.keymap.set('n', '<leader>du', function() require('dap').step_out() end, {desc = "DAP step up (out)"})
    vim.keymap.set('n', '<Leader>db', function() require('dap').toggle_breakpoint() end, {desc = "DAP toggle breakpoint"})
    vim.keymap.set('n', '<Leader>dB', function() require('dap').set_breakpoint() end, {desc = "DAP set breakpoint"})
    vim.keymap.set('n', '<Leader>dlp', function() require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end, {desc = "DAP set breakpoint & log"})
    vim.keymap.set('n', '<Leader>dr', function() require('dap').repl.open() end, {desc = "DAP repl open"})
    vim.keymap.set('n', '<Leader>dl', function() require('dap').run_last() end, {desc = "DAP run last"})
    vim.keymap.set({'n', 'v'}, '<Leader>dh', function()
      require('dap.ui.widgets').hover()
    end, {desc = "DAP hover"})
    vim.keymap.set({'n', 'v'}, '<Leader>dp', function()
      require('dap.ui.widgets').preview()
    end, {desc = "DAP preview"})
    vim.keymap.set('n', '<Leader>df', function()
      local widgets = require('dap.ui.widgets')
      widgets.centered_float(widgets.frames)
    end, {desc = "DAP frames"})
    vim.keymap.set('n', '<Leader>ds', function()
      local widgets = require('dap.ui.widgets')
      widgets.centered_float(widgets.scopes)
    end, {desc = "DAP scopes"})
EOF
" }}}

" {{{ Jupytext
let g:jupytext_enable = 1
let g:jupytext_fmt = 'py:percent'
let g:jupytext_filetype_map = {
        \    'py:percent': 'python.ipynb',
        \    'R:percent': 'R.ipynb'
        \ }
" let g:jupyter_highlight_cells = 0

call textobj#user#map('hydrogen', {
\  '-': {
\    'move-n': '}',   
\    'move-p': '{',   
\    }
\  })

let g:pymode_motion = 0
augroup Jupytext
    au! 
    autocmd Bufenter *.ipynb let b:jupyter_kernel_type = 'python'
    autocmd Bufenter *.ipynb call jupyter#load#MakeStandardCommands()
    autocmd BufEnter *.ipynb nnoremap <buffer> <A-CR> :JupyterSendCell<CR> <bar> :call search('^# %%\( \=\[markdown]\)\@!', 'W') <bar> :norm j<CR>
    autocmd BufEnter *.ipynb nnoremap <buffer> <A-\> :JupyterSendCell<CR>
    autocmd Bufenter *.r.ipynb let g:jupytext_fmt = 'R:percent'
    autocmd Bufenter *.r.ipynb let b:jupyter_kernel_type = 'R'
    autocmd Bufenter *.r.ipynb set ft=R.ipynb
    autocmd Bufenter *.R call jupyter#load#MakeStandardCommands()
    autocmd BufEnter *.R nnoremap <buffer> <A-CR> :JupyterSendCell<CR> <bar> :call search('^# %%\( \=\[markdown]\)\@!', 'W') <bar> :norm j<CR>
    autocmd BufEnter *.R nnoremap <buffer> <A-\> :JupyterSendCell<CR>
augroup END

" }}}

" {{{ Pandoc
let g:pandoc#syntax#conceal#use=0
let g:pandoc#command#prefer_pdf=1

let g:pandoc_watch#default_output='pdf'
let g:pandoc_watch#default_args=['--citeproc']

function! PandocWatch(template='', bang='') 
    " let b:my_pandoc_template = 
    if a:template != ''
        let b:pandoc_args = '#' . a:template
    else
        let b:pandoc_args = g:pandoc_watch#default_output . ' ' . join(g:pandoc_watch#default_args)
    endif
    call pandoc#command#Pandoc(b:pandoc_args, a:bang)
    autocmd BufWritePost <buffer> silent call pandoc#command#Pandoc(b:pandoc_args, '')
endfunction

function! PandocWatchComplete(ArgLead, CmdLine, CursorPos)
    return pandoc#command#GetTemplateNames()
endfunction

command! -nargs=? -bang -complete=customlist,PandocWatchComplete PandocWatch call PandocWatch('<args>', '<bang>')

augroup pandoc_syntax
    au! BufNewFile,BufFilePre,BufRead *.md set filetype=markdown.pandoc
augroup END



" }}}

" {{{ Latex
let g:vimtex_view_method='zathura'
let g:vimtex_quickfix_mode=0
let g:vimtex_fold_enabled=1
let g:vimtex_syntax_conceal={}
let g:vimtex_syntax_conceal_default=0
let g:tex_flavor='xetex'
let g:tex_conceal=''
let g:neomake_tex_enabled_makers=['proselint']
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

aug inkscape
    autocmd FileType latex inoremap <buffer> <C-f> <Esc>: silent exec '.!inkscape-figures create "'.getline('.').'" "'.b:vimtex.root.'/figures/"'<CR><CR>:w<CR>
    autocmd FileType latex nnoremap <buffer><localleader>f : silent exec '!inkscape-figures edit "'.b:vimtex.root.'/figures/" > /dev/null 2>&1 &'<CR><CR>:redraw!<CR>
    au!
aug END

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
  let l:url = 'https://texdoc.org/serve/' . a:context.selected . '/0'

  execute '!zathura --fork <(curl ' . l:url . ')'

  " redraw!
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
let g:startify_bookmarks = [{'v': '~/.config/nvim/init.vim'}, {'t': '~/docs/notes/todo.txt'}, {'n': '~/docs/notes/QuickNote.md'}]
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
    autocmd FileType html,css,scss imap <buffer> <C-e> <plug>(emmet-expand-abbr)
augroup END

let g:NERDCustonDelimiters = {
            \ 'python': {'right': '# '}}

" most ultisnips keybindings are defined in nvim-cmp lua settings
" TLDR; dhift moves around
let g:UltiSnipsExpandTrigger='<C-e>'


" inoremap <expr><tab> pumvisible() ? "\<C-n>" : "\<TAB>"
" inoremap <expr><s-tab> pumvisible() ? "\<C-p>" : "\<TAB>"

aug omnicomplete 
    au!
    au FileType css,sass,scss,stylus,less setl omnifunc=csscomplete#CompleteCSS
    au FileType html,htmldjango,jinja,markdown setl omnifunc=emmet#completeTag
    au FileType javascript,jsx setl omnifunc=tern#Complete
    " au FileType python setl omnifunc=pythoncomplete#Complete
    au FileType xml setl omnifunc=xmlcomplete#CompleteTags
aug END

let g:neomake_open_list = 2
call neomake#configure#automake('w')

let g:netrw_liststyle = 3

lua require('leap').add_default_mappings()

" {{{ GhostText
augroup nvim_ghost_user_autocommands
  au User www.reddit.com,www.stackoverflow.com set filetype=markdown
  au User *github.com set filetype=markdown
  au User code.earthengine.google.com set filetype=javascript
  " au User code.earthengine.google.com lua vim.lsp.callbacks["textDocument/publishDiagnostics"] = function() end
augroup END

command! GhostSStart call plug#load('nvim-ghost.nvim')

" }}}

" {{{ waikiki
map <leader>a :e ~/docs/notes/index.wiki.md<CR>
map <leader>o :e ~/docs/notes/todo.txt<CR>

" let g:waikiki_default_maps = 1

let g:waikiki_roots = ['~/docs/notes/']
let g:waikiki_wiki_patterns = ['/.wiki.md/']
let g:waikiki_default_maps  = 1

function! SetupWaikikiBuffer() abort
    nmap  <buffer>  zl                    <Plug>(waikikiFollowLink)
    nmap  <buffer>  zh                    <Plug>(waikikiGoUp)
    xn    <buffer>  <LocalLeader>c        <Esc>m`g'<O```<Esc>g'>o```<Esc>``
    nmap  <buffer><silent> <LocalLeader>i :let &l:cocu = (&l:cocu==""
                \ ? "n" : "")<cr>
    setl sw=2
    setl cole=2
endfun

" augroup Waikiki
"     au!
"     autocmd User setup call SetupWaikikiBuffer()
"     au FileType markdown call SetupWaikikiBuffer()
" augroup END

" }}}

" }}}

" {{{ Statusline 

set laststatus=2
set statusline=
" set statusline+=\ %*
set statusline+=%(\ %y%)%(\ %h%)\ [%{&ff}\/%{&fenc}]
set statusline+=\ %f
set statusline+=%(\ %m%)
set statusline+=%(\ %r%)
set statusline+=%=
" set statusline+=\ %{LinterStatus()}
set statusline+=\ [%l:%c\ %p%%]
set statusline+=\ %{FugitiveHead()}

" }}}
