syntax on
filetype plugin indent on

"Get the 2-space YAML as the default when hit carriage return after the colon
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab

set is hlsearch ai ic scs
nnoremap <esc><esc> :nohls<cr>
