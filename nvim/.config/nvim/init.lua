-- vim: foldmethod=marker tabstop=4 expandtab

-- {{{ Basic Config
vim.g.python3_host_prog = '/usr/bin/python' -- so that pynvim not necessary in venvs
-- vim.o.t_Co = 16
-- vim.o.background = dark
vim.o.number = true
-- vim.o.filetype = false
-- vim.filetype plugin indent on
vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.undolevels = 10000
vim.o.history = 10000
vim.o.undofile = true

vim.o.conceallevel=0
vim.o.concealcursor=""
vim.o.foldtext = ""

-- vim.cmd.syntax("enable")
-- vim.o.errorformat = '%A%f:%l:\ %m,%-Z%p^,%-C%.%#'
vim.o.shiftwidth = 4
vim.o.expandtab = true
-- vim.o.colorcolumn = 81


-- let &t_ZH="\e[3m"
-- let &t_ZR="\e[23m"
-- vim.o.fillchars = "fold:="

-- command completion
vim.o.wildmode = "longest,list,full"
vim.o.wildmenu = true

vim.o.foldmethod = "expr"
vim.o.foldexpr = "nvim_treesitter#foldexpr()"

vim.g.netrw_liststyle = 3
vim.g.netrw_winsize = 15

-- {{{ Statusline 
vim.cmd([[
  function! GitBranch()
    return system("git rev-parse --abbrev-ref HEAD 2>/dev/null | tr -d '\n'")
  endfunction
  
  function! StatuslineGit()
    let l:branchname = GitBranch()
    return strlen(l:branchname) > 0?'  '.l:branchname.' ':''
  endfunction
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
  set statusline+=\ %{StatuslineGit()}
]])

-- }}}
-- }}}

-- {{{ Plugins
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "

require("lazy").setup({
    -- essentials
    "neovim/nvim-lspconfig",
    {"nvim-treesitter/nvim-treesitter", build = ":TSUpdate"},
    -- {{{ completion
    { 
        "hrsh7th/nvim-cmp", 
        event = { "InsertEnter", "CmdlineEnter" },
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            -- "hrsh7th/cmp-vsnip",
            "quangnguyen30192/cmp-nvim-ultisnips"

        },
        config = function()
            local has_words_before = function()
                unpack = unpack or table.unpack
                local line, col = unpack(vim.api.nvim_win_get_cursor(0))
                return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
            end

            local feedkey = function(key, mode)
                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
            end

            local cmp = require('cmp')
            local cmp_ultisnips_mappings = require("cmp_nvim_ultisnips.mappings")
            cmp.setup {
                snippet = {
                    expand = function(args)
                        vim.fn["UltiSnips#Anon"](args.body)
                    end,
                },
                sources = {
                    { name = 'nvim_lsp' },
                    { name = "ultisnips" },
                    { name = "papis" },
                    {
                        name = 'buffer',
                        option = {
                            get_bufnrs = function()
                                return vim.api.nvim_list_bufs()
                            end
                        }
                        -- if above is too slow, only load from visible buffers
                        -- option = {
                        --     get_bufnrs = function()
                        --         local bufs = {}
                        --         for _, win in ipairs(vim.api.nvim_list_wins()) do
                        --             bufs[vim.api.nvim_win_get_buf(win)] = true
                        --         end
                        --         return vim.tbl_keys(bufs)
                        --     end
                        -- }

                    },
                    -- more sources
                },
                -- recommended configuration for <Tab> people:
                mapping = {
                    ["<Tab>"] = cmp.mapping(
                        function(fallback)
                            cmp_ultisnips_mappings.expand_or_jump_forwards(fallback)
                        end,
                        { "i", "s", --[[ "c" (to enable the mapping in command mode) ]] }
                    ),
                    ["<S-Tab>"] = cmp.mapping(
                        function(fallback)
                            cmp_ultisnips_mappings.jump_backwards(fallback)
                        end,
                        { "i", "s", --[[ "c" (to enable the mapping in command mode) ]] }
                    ),
                },
            }

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

        end
    },
    -- }}}
    -- theme
    -- {
    --     "pinusc/term.vim",
    --     lazy = false, -- make sure we load this during startup if it is your main colorscheme
    --     priority = 1000, -- make sure to load this before all the other start plugins
    --     config = function()
    --         -- load the colorscheme here
    --         -- vim.cmd([[colorscheme term]])
    --     end,
    -- },
    -- {
    --     'eddyekofo94/gruvbox-flat.nvim',
    --     lazy = false,
    --     priority = 1000,
    --     enabled = true,
    --     config = function()
    --         vim.g.gruvbox_flat_style = "hard"
    --         vim.g.gruvbox_flat_style = "dark"
    --         vim.cmd([[
    --         colorscheme gruvbox-flat
    --         ]])
    --     end,
    -- },
    { 
        "ellisonleao/gruvbox.nvim", 
        priority = 1000, 
        lazy = false,
    },
    -- {
    --     "folke/tokyonight.nvim",
    --     lazy = false,
    --     priority = 1000,
    --     opts = {},
    -- },
    "mhinz/vim-startify",
    -- debugging
    "mfussenegger/nvim-dap", -- Debug Adapter Protocol
    "mfussenegger/nvim-dap-python",
    {"rcarriga/nvim-dap-ui", dependencies = {"nvim-neotest/nvim-nio"}},
    -- utils
    "mbbill/undotree",
    "tpope/vim-vinegar",
    "mbbill/undotree",
    "nvim-lua/plenary.nvim", --telescope dependency
    "nvim-telescope/telescope.nvim",
    "junegunn/fzf",
    "chrisbra/Recover.vim", -- diff when swap file found
    "ggandor/leap.nvim", -- sneak
    "mg979/vim-visual-multi", --{'branch': 'master"}
    "sunaku/tmux-navigate",
    "tpope/vim-unimpaired",
    "tpope/vim-surround",
    "tpope/vim-repeat",
    "tpope/vim-sensible",
    "echasnovski/mini.icons",
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        init = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
            vim.keymap.set('n', '<Leader>?', ':WhichKey<CR>')
        end,
        opts = {
            -- your configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
        },
        dependencies = {
            "echasnovski/mini.icons"
        }
    },
    -- lispy parenthesis
    {
        'windwp/nvim-autopairs',
        event = "InsertEnter",
        config = true
        -- use opts = {} for passing setup options
        -- this is equivalent to setup({}) function
    },
    "guns/vim-sexp", -- { 'for': 'clojure" }
    "tpope/vim-sexp-mappings-for-regular-people", -- { 'for': 'clojure" }
    -- git
    {
        "NeogitOrg/neogit",
        dependencies = {
            "nvim-lua/plenary.nvim",         -- required
            "sindrets/diffview.nvim",        -- optional - Diff integration

            -- Only one of these is needed, not both.
            "nvim-telescope/telescope.nvim", -- optional
        },
        config = true
    },
    "airblade/vim-gitgutter",

    -- snippets
    
    {
        lazy = false,
        "SirVer/ultisnips", 
        dependencies = {
            "honza/vim-snippets",
        },
        init = function()
            vim.g.UltiSnipsExpandTrigger='<C-e>'
        end
    },
    -- ultisnips has a performance issue with nvim-cmp
    -- until it is solved, I will use vsnip
    -- and forgo my custom tex snippets in the ultisnips folder
    -- {
    --     "hrsh7th/vim-vsnip",
    --     dependencies = {
    --         "rafamadriz/friendly-snippets"
    --     }
    -- },
    -- language support
    "hsanson/vim-android",
    "stevearc/vim-arduino",
    "nvim-orgmode/orgmode",
    "vim-pandoc/vim-pandoc",
    "vim-pandoc/vim-pandoc-syntax",
    "mattn/emmet-vim",
    "guns/vim-clojure-static",
    "liquidz/vim-iced",
    "tpope/vim-leiningen",
    {
        "lervag/vimtex",
        lazy = false,     -- we don't want to lazy load VimTeX
        -- tag = "v2.15", -- uncomment to pin to a specific release
        init = function()
            -- VimTeX configuration goes here, e.g.
            vim.g.vimtex_view_method = "zathura"
        end
    },
    {
        "pmizio/typescript-tools.nvim",
        dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
        opts = {},
    },
    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {
            keywords = {
                TODO = { color = "warning" },
            },
            highlight = {
                pattern = [[.*<(KEYWORDS)\s*]],
            }
        }
    },
    -- prose
    "junegunn/goyo.vim",
    "junegunn/limelight.vim",
    "vim-scripts/LanguageTool",
    "kana/vim-textobj-user",
    "reedes/vim-textobj-quote",
    "reedes/vim-textobj-sentence",
    "reedes/vim-litecorrect",
    "reedes/vim-wordy",
    "reedes/vim-lexical",
    "ron89/thesaurus_query.vim",
    "dbmrq/vim-ditto",
    "reedes/vim-wheel",

    -- papis/citations
    {
        "jghauser/papis.nvim",
        dependencies = {
            "kkharji/sqlite.lua",
            "MunifTanjim/nui.nvim",
            "pysan3/pathlib.nvim",
            "nvim-neotest/nvim-nio",
            -- if not already installed, you may also want:
            -- "nvim-telescope/telescope.nvim",
            -- "hrsh7th/nvim-cmp",

        },
        config = function()
            require("papis").setup({
                -- Your configuration goes here
            })
        end,
    },

    -- org and more
    "dhruvasagar/vim-table-mode",


    -- Jupyter
    -- This setup requires `pip install --user jupytext qtconsole`
    -- Afterwards, just opening .ipynb files should convert them correctly
    -- To execute cells, run `jupytext qtconsole` in a terminal (disown it too)
    -- Then run :JupyterConnect in vim
    -- Now pressing alt+Enter on a cell will run it and move to the next one
    {
        'jupyter-vim/jupyter-vim',
        init = function()
            vim.cmd([[
            let g:jupytext_enable = 1
            let g:jupytext_fmt = 'py:percent'
            let g:jupytext_filetype_map = {
            \    'py:percent': 'python.ipynb',
            \    'R:percent': 'R.ipynb'
            \ }
            let g:jupyter_highlight_cells = 0
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
            ]])
        end,
    },
    -- '~/.config/nvim/plugged/jupyter-vim',
    'goerz/jupytext.vim',
    -- '~/.config/nvim/plugged/vim-textobj-hydrogen',
    'jpalardy/vim-slime',
    'hanschen/vim-ipython-cell',
})

--[[
" {{{ Jupytext

call textobj#user#map('hydrogen', {
\  '-': {
\    'move-n': '}',   
\    'move-p': '{',   
\    }
\  })

let g:pymode_motion = 0

" }}}
--]]

local palette = require('gruvbox').palette
require("gruvbox").setup({
    contrast = "hard";
    transparent_mode = true,
    overrides = {

        Search = { bg = palette.dark0, fg = palette.light2 },
        SignColumn = {bg = palette.dark0_hard},
        StatusLine = {fg = palette.dark1, bold = true},
        StatusLineNC = {fg = palette.dark0_soft},
        Folded = {bg = palette.dark0_soft},
        ["@method.call"] = {bold = false},
    }
})
vim.o.background = "dark" -- or "light" for light mode
vim.cmd([[colorscheme gruvbox]])

--[[
"neomake/neomake"

"Shougo/neco-syntax"
" for global config

" Code snippets

""" Clojure

" Plug 'clojure-vim/async-clj-omni', {'for': 'clojure'}

" " wiki
" Plug 'fcpg/vim-waikiki'
" Plug 'mattn/calendar-vim'
" Plug 'vim-scripts/utl.vim' " Universal Text Linking
" Plug 'dhruvasagar/vim-table-mode'

""" Prose


""" Latex 
"lervag/vimtex', {'for': 'tex"}
"posva/vim-vue', {'for': 'vue"}

""" Todo.txt
"freitass/todo.txt-vim"

"Editing parentesi

" Jupyter
" This setup requires `pip install --user jupytext qtconsole`
" Afterwards, just opening .ipynb files should convert them correctly
" To execute cells, run `jupytext qtconsole` in a terminal (disown it too)
" Then run :JupyterConnect in vim
" Now pressing alt+Enter on a cell will run it and move to the next one
" Plug 'jupyter-vim/jupyter-vim'
"~/.config/nvim/plugged/jupyter-vim"
"goerz/jupytext.vim"
"~/.config/nvim/plugged/vim-textobj-hydrogen"
" Plug 'jpalardy/vim-slime', { 'for': 'python' }
" Plug 'hanschen/vim-ipython-cell', { 'for': 'python' }


--]]

-- }}}


-- {{{ LSP
local nvim_lsp = require('lspconfig')

-- Use an on_attach function to only map the following keys 
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  --Enable completion triggered by <c-x><c-o>
  -- buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=false }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>?', '<cmd>lua vim.diagnostic.set_loclist()<CR>', opts)
  buf_set_keymap("v", '<space>f', '<ESC><cmd>lua vim.lsp.buf.range_formatting()<CR>', opts)

  require("which-key").register({
      ["<leader><leader>"] = {
          name = "+lsp",
      }
  })
  buf_set_keymap('n', '<leader><leader>D', '<Cmd>lua vim.lsp.buf.declaration()<CR>', 
    {noremap=true,silent=false,desc="declaration"})
  buf_set_keymap('n', '<leader><leader>d', '<Cmd>lua vim.lsp.buf.definition()<CR>', 
    {noremap=true,silent=false,desc="definition"})
  buf_set_keymap('n', '<leader><leader>r', '<cmd>lua vim.lsp.buf.references()<CR>', 
    {noremap=true,silent=false,desc="references"})
  buf_set_keymap('n', '<leader><leader>i', '<cmd>lua vim.lsp.buf.implementation()<CR>', 
    {noremap=true,silent=false,desc="implementation"})
  buf_set_keymap('n', '<leader><leader>K', '<Cmd>lua vim.lsp.buf.hover()<CR>', 
    {noremap=true,silent=false,desc="hover"})
  buf_set_keymap('n', '<leader><leader>k', '<cmd>lua vim.lsp.buf.signature_help()<CR>', 
    {noremap=true,silent=false,desc="signature help"})
  buf_set_keymap('n', '<leader><leader>]d', '<cmd>lua vim.diagnostic.goto_next()<CR>', 
    {noremap=true,silent=false,desc="next diagnostic"})
  buf_set_keymap('n', '<leader><leader>[d', '<cmd>lua vim.diagnostic.goto_next()<CR>', 
    {noremap=true,silent=false,desc="previous diagnostic"})
  buf_set_keymap("n", '<leader><leader>f', '<ESC><cmd>lua vim.lsp.buf.range_formatting()<CR>', 
    {noremap=false,silent=false,desc="range formatting"})
  buf_set_keymap("v", '<leader><leader>f', '<ESC><cmd>lua vim.lsp.buf.range_formatting()<CR>', 
    {noremap=false,silent=false,desc="range formatting"})
  buf_set_keymap('n', '<leader><leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', 
    {noremap=true,silent=false,desc="type definition"})
  buf_set_keymap('n', '<leader><leader>r', '<cmd>lua vim.lsp.buf.rename()<CR>', 
    {noremap=true,silent=false,desc="rename"})
  buf_set_keymap('n', '<leader><leader>a', '<cmd>lua vim.lsp.buf.code_action()<CR>', 
    {noremap=true,silent=false,desc="code action"})
end

-- LSP completions (nvim-lsp)
-- Set up lspconfig.
local cmp_capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
--
-- bashls requires extra/bash-language-server
-- perlls requires `cpan Perl::LanguageServer`
local servers = {"pylsp", "typescript-tools", "bashls", "perlls" }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    capabilities = cmp_capabilities,
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    },
    diagnostics = {
        update_in_insert = false,
    }
  }
end

nvim_lsp["pylsp"].setup {
    on_attach = on_attach,
    filetypes = { "python", "python.ipynb" },
    settings = {
        pylsp = {
            plugins = {
                pyflakes = { enabled = false, },
                pycodestyle = { enabled = false, },
                flake8 = { enabled = true, },
                pylint = { enabled = true, }
            }
        }
    }
}
vim.lsp.set_log_level("debug")

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
vim.o.updatetime = 300
vim.cmd [[autocmd! CursorHold * lua vim.diagnostic.open_float(nil, {focus=false, border=border})]]
-- }}}

-- {{{ TreeSitter
require'nvim-treesitter.configs'.setup {
    ensure_installed = {"c", "latex", "vim", "lua", "html", "python", "clojure", "markdown", "bash", "scheme"}, -- one of "all", "maintained" (parsers with maintainers), or a list of languages
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
-- }}}

-- {{{ Startify
vim.cmd([[
let g:startify_bookmarks = [{'v': '~/.config/nvim/init.lua'}, {'t': '~/docs/notes/todo.txt'}, {'n': '~/docs/notes/QuickNote.md'}]
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
]])
-- }}}

-- {{{ DAP 
-- require('dap-python').setup('~/.local/share/virtualenvs/debugpy/bin/python')
require('dap-python').setup('python3')

local dap = require('dap')
dap.adapters.firefox = {
  type = 'executable',
  command = 'node',
  args = {os.getenv('HOME') .. '/build/vscode-firefox-debug/dist/adapter.bundle.js'},
}

dap.configurations.typescript = {
  {  
  name = 'Debug with Firefox',
  type = 'firefox',
  request = 'attach',
  -- reAttach = true,
url = 'http://localhost:3000',
webRoot = '${workspaceFolder}',
log= {
    fileName= "${workspaceFolder}/log.txt",
    fileLevel= {
        default= "Debug"
    }
}
  -- firefoxExecutable = '/usr/bin/firefox'
  }
}
dap.configurations.typescriptreact = dap.configurations.typescript

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
require("which-key").add({
    {"<leader>d", group = "debug"}
})

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


-- }}}

-- {{{ Plugins

-- leap
require('leap').add_default_mappings()

-- {{{ Telescope
local actions = require('telescope.actions')
require("which-key").add({
    {"<leader>t", group = "telescope"}
})
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


-- remember to edit which-key bindings too!
vim.cmd([[
nmap <Leader>; <cmd>Telescope buffers<CR>
nmap <Leader>f <cmd>Telescope find_files<CR>
nmap <Leader>F <cmd>Telescope git_files<CR>
nmap <Leader>' <cmd>Telescope oldfiles<CR>
nmap <Leader>p <cmd>Telescope registers<CR>
map <leader>/ <cmd>Telescope current_buffer_fuzzy_find<CR>

nmap <Leader>th <cmd>Telescope oldfiles<CR>
nmap <Leader>tT <cmd>Telescope tags<CR>
nmap <Leader>tt <cmd>Telescope lsp_document_symbols<CR>
nmap <Leader>tq <cmd>Telescope quickfix<CR>
nmap <Leader>td <cmd>Telescope diagnostics<CR>
nmap <Leader>tr <cmd>Telescope lsp_references<CR>
" git
nmap <Leader>tgc <cmd>Telescope git_commits<CR>
nmap <Leader>tgs <cmd>Telescope git_status<CR>
nmap <Leader>tgS <cmd>Telescope git_stash<CR>
map <leader>t/ <cmd>Telescope live_grep<CR>

nmap <Leader>g <cmd>Neogit<CR>

function! ListNotes()
:Telescope find_files search_dirs=['/home/pinusc/docs/notes/']
endfunction
command! Notes call ListNotes()
]])
-- }}}
-- }}}

-- {{{ Filetype specific

vim.cmd([[
augroup mail
    autocmd FileType mail setlocal textwidth=0 spell
augroup END
    ]])

-- {{{ Orgmode
vim.g.org_heading_shade_leading_stars = 1
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
-- }}}
-- }}}
--
-- Neovide
if vim.g.neovide then
    vim.o.guifont = "GohuFont:h14"
    vim.g.neovide_scale_factor = 0.5
end

-- Load other stuff

-- Load legacy vimL config
local vimrc = vim.fn.stdpath("config") .. "/vimrc.vim" vim.cmd.source(vimrc)
-- Load mappings file
local mappings = vim.fn.stdpath("config") .. "/mappings.vim" 
vim.cmd.source(mappings)

