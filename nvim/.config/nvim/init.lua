-- vim: foldmethod=marker

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
    "editorconfig/editorconfig-vim",
    -- {{{ completion
    { 
        "hrsh7th/nvim-cmp", 
        event = { "InsertEnter", "CmdlineEnter" },
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",

        },
        config = function()
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
                                print("visible")
                                cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
                            elseif vim.fn["UltiSnips#CanJumpForwards"]() == 1 then
                                vim.api.nvim_feedkeys(t("<Plug>(ultisnips_jump_forward)"), 'm', true)
                            else
                                print("fallback")
                                print(fallback)
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
                    -- { name = 'ultisnips' }, -- For ultisnips users.
                }, {
                        { name = 'buffer' },
                    })
            })

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
    {
        "pinusc/term.vim",
        lazy = false, -- make sure we load this during startup if it is your main colorscheme
        priority = 1000, -- make sure to load this before all the other start plugins
        config = function()
            -- load the colorscheme here
            vim.cmd([[colorscheme term]])
        end,
    },
    "mhinz/vim-startify",
    -- debugging
    "mfussenegger/nvim-dap", -- Debug Adapter Protocol
    "mfussenegger/nvim-dap-python",
    "rcarriga/nvim-dap-ui",
    -- utils
    "mbbill/undotree",
    "tpope/vim-commentary",
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
    -- lispy parenthesis
    "windwp/nvim-autopairs",
    "guns/vim-sexp", -- { 'for': 'clojure" }
    "tpope/vim-sexp-mappings-for-regular-people", -- { 'for': 'clojure" }
    -- git
    "tpope/vim-fugitive",
    "airblade/vim-gitgutter",
    -- snippets
    
    -- ultisnips has a performance issue with nvim-cmp
    -- until it is solved, I will use vsnip
    -- and forgo my custom tex snippets in the ultisnips folder
    -- {
    --     lazy = false,
    --     "SirVer/ultisnips", 
    --     dependencies = {
    --         "honza/vim-snippets",
    --     },
    --     init = function()
    --         vim.g.UltiSnipsExpandTrigger='<C-e>'
    --     end
    -- },
    -- language support
    {
        "hrsh7th/vim-vsnip",
        dependencies = {
            "rafamadriz/friendly-snippets"
        }
    }
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
        "pmizio/typescript-tools.nvim",
        dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
        opts = {},
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
})


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

-- {{{ Basic Config
vim.o.t_Co = 16
vim.o.background = dark
vim.o.number = true
vim.o.filetype = false
-- vim.filetype plugin indent on
vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.undolevels = 10000
vim.o.history = 10000
vim.o.undofile = true

vim.o.conceallevel=0
vim.o.concealcursor=""

vim.cmd.syntax("enable")
-- vim.o.errorformat = '%A%f:%l:\ %m,%-Z%p^,%-C%.%#'
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.o.colorcolumn = 81

-- let &t_ZH="\e[3m"
-- let &t_ZR="\e[23m"
-- vim.o.fillchars = "fold:="

-- command completion
vim.o.wildmode = "longest,list,full"
vim.o.wildmenu = true

vim.o.foldmethod = "expr"
vim.o.foldexpr = "nvim_treesitter#foldexpr()"

vim.g.netrw_liststyle = 3

-- {{{ Statusline 
vim.cmd([[
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
]])

-- }}}
-- }}}

-- {{{ Completion (nvim-cmp)
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


-- Use buffer source for `/`.
cmp.setup.cmdline('/', {
    completion = { autocomplete = false },
    sources = {
        -- { name = 'buffer' }
        { name = 'buffer', opts = { keyword_pattern = [=[[^[:blank:]].*]=] } }
    }
})

-- Use cmdline & path source for ':'.
cmp.setup.cmdline(':', {
    completion = { autocomplete = false },
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
-- }}}

-- {{{ LSP
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
local servers = {"pylsp" }
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
-- }}}

-- {{{ TreeSitter
require('orgmode').setup_ts_grammar()

require'nvim-treesitter.configs'.setup {
    ensure_installed = {"c", "latex", "vim", "lua", "html", "python", "clojure"}, -- one of "all", "maintained" (parsers with maintainers), or a list of languages
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
]])
-- }}}

-- {{{ DAP 
require('dap-python').setup('~/.local/share/virtualenvs/debugpy/bin/python')
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

vim.cmd([[
nmap <Leader>; <cmd>Telescope buffers<CR>
nmap <Leader>f <cmd>Telescope find_files<CR>
nmap <Leader>F <cmd>Telescope git_files<CR>
nmap <Leader>' <cmd>Telescope oldfiles<CR>
nmap <Leader>t <cmd>Telescope current_buffer_tags<CR>
nmap <Leader>T <cmd>Telescope tags<CR>
nmap <Leader>p <cmd>Telescope registers<CR>
map <leader>/ <cmd>Telescope current_buffer_fuzzy_find<CR>
map <leader><leader>/ <cmd>Telescope live_grep<CR>


function! ListNotes()
:Telescope find_files search_dirs=['/home/pinusc/docs/notes/']
endfunction
command! Notes call ListNotes()
]])
-- }}}
-- }}}

-- {{{ Filetype specific

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

-- Load other stuff

-- Load legacy vimL config
local vimrc = vim.fn.stdpath("config") .. "/vimrc.vim" vim.cmd.source(vimrc)
-- Load mappings file
local mappings = vim.fn.stdpath("config") .. "/mappings.vim" 
vim.cmd.source(mappings)

