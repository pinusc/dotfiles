" vim: foldmethod=marker
scriptencoding utf-8

" {{{ General 
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

" }}}
"
" {{{ Sessions
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

" {{{ Mappings 

" other bindings
nnoremap <C-q> :center 80<cr>hhv0r=0r#A<space><esc>40A=<esc>d80<bar>
nnoremap <C-s> yypVr=k
" nnoremap <C-h> :.,$!pandoc -f markdown -t html<cr>
" nnoremap <C-p> :.,$!pandoc -f markdown -t html<cr>
" vnoremap <C-h> :'<,'>$!pandoc -f markdown -t html<cr>
" vnoremap <C-p> :'<,'>$!pandoc -f markdown -t html<cr>

nmap <Leader>r <cmd>!%:p<CR>


" }}}

" {{{ Neomake
" let g:neomake_tex_enabled_makers=['proselint']
" let g:neomake_open_list = 2
" call neomake#configure#automake('w')
" function! StartMakeView()
"     NeomakeSh! make view
"     augroup makeview
"         au!
"         autocmd CursorHold,CursorHoldI,BufWritePost <buffer> :NeomakeSh! make
"     augroup END
"     redraw!
" endfunction

" command! StartMakeView call StartMakeView()

" }}}
"
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

let g:python_host_prog = '/usr/bin/python'
let g:python2_host_prog = '/usr/bin/python2'
let g:python3_host_prog = '/usr/bin/python3'

" }}}

" {{{ Plugin Specific
set statusline+=%#warningmsg#
set statusline+=%*
set laststatus=2

" {{{ Git Gutter
let g:gitgutter_enabled = 1
let g:gitgutter_sign_added = '·'
let g:gitgutter_sign_modified = '·'
let g:gitgutter_sign_removed = '·'
let g:gitgutter_sign_removed_first_line = '·'
let g:gitgutter_sign_modified_removed = '·'
" }}}

" {{{ Visual Multi
let g:VM_default_mappings = 0
let g:VM_maps = {}
let g:VM_maps["Add Cursor Down"] = '<M-Down>'
let g:VM_maps["Add Cursor Up"] = '<M-Up>'
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
let g:tex_flavor='xelatex'
let g:tex_conceal=''
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
    \   '-xelatex',
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

" inoremap <expr><tab> pumvisible() ? "\<C-n>" : "\<TAB>"
" inoremap <expr><s-tab> pumvisible() ? "\<C-p>" : "\<TAB>"

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

