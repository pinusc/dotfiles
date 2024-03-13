
" autocorrect
" force top correction on most recent misspelling
imap <C-l> <Esc>[s2z=`]a
nmap <C-l> [s1z=``

" linewise paste
nnoremap <leader>p m`o<ESC>p``
nnoremap <leader>P m`O<ESC>p``

" terminal
tnoremap <Esc> <C-\><C-n>?\$<CR>

" window select
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

" bearable defaults
imap jk <Esc>
imap kj <Esc>
map <leader><tab> :e #<cr>

" error window
map <F9> :lclose<Return>
map <F10> :cprevious<Return>
map <F11> :cnext<Return>

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
map <leader>e :Lexplore<cr><cr>
map <leader>s :Sexplore<cr><cr>
map <leader>u :UndotreeToggle<CR>
map <leader>h :nohlsearch<CR>
map <leader>ji :call cursor(0, 1)<cr>:call search("import")<cr>

" Display TODO
nnoremap <leader>TODO :vimgrep TODO **/*.py

" make
map <F5> :!make<cr>
