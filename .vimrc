"====== plugins =====

"download plugins under specified directory
call plug#begin('~/.vim/plugged')

"Declare list of plugins

Plug 'lervag/vimtex'
let g:tex_flavor='latex'
let g:vimtex_view_method = 'zathura'
set conceallevel=2

Plug 'SirVer/UltiSnips'
let g:UltiSnipsExpandTrigger='<tab>'
let g:UltiSnipsJumpForwardTrigger='<tab>'
let g:UltiSnipsJumpBackwardTrigger='<s-tab>'
let g:UltiSnipsUsePythonVersion=3
let g:UltiSnipsSnippetsDir='~/.vim/UltiSnips'
let g:UltiSnipsSnippetDirectories=['~/.vim/UltiSnips']
let g:UltiSnipsEditSplit='context'

Plug 'vimwiki/vimwiki'
let g:vimwiki_list = [{'path':'~/nas/vimwiki/',
                      \ 'syntax': 'markdown', 'ext': '.md'}]

"Theming related plugins
Plug 'morhetz/gruvbox'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

call plug#end()

set encoding=utf-8

set fileencoding=utf-8

set spelllang=de_at,en_gb
"Correct the lastest spelling mistake when pressing <C-l>
inoremap <C-l> <c-g>u<Esc>[s1z=`]a<c-g>u

filetype plugin on

"====== ui-config =====
colorscheme gruvbox
set background=dark
let g:airline_powerline_fonts = 1
let g:airline_theme = 'gruvbox'



" show line numbers
set number relativenumber

" show command in bottom bar
set showcmd

" highlight matching [{()}]
set showmatch

syntax enable

" Set background to terminal background (for transparency)
hi Normal ctermbg=NONE

set expandtab
set shiftwidth=2
set softtabstop=2
