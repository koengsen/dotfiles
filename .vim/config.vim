" -----------------
" UTF-8 Encoding Stuff
" -----------------
if has("multi_byte")
  if &termencoding == ""
    let &termencoding = &encoding
  endif
  set encoding=utf-8
  setglobal fileencoding=utf-8
  set fileencodings=ucs-bom,utf-8,latin1
endif

" -----------------
" Color
" -----------------
set guifont=Monaco\ for\ Powerline:h12
set nu
"set background=dark
"colorscheme railscasts

"baycomb
"bensday
"blackboard
"codeschool
"darkburn
"darkspectrum
"native
"railscasts

" -----------------
" Behaviors
" -----------------
syntax enable
set backspace=indent,eol,start
set ts=4
set sw=4
set guioptions-=r
set guioptions-=R
set guioptions-=l
set guioptions-=LS

let mapleader = ","
"set scrolloff=3
set visualbell
"set cursorline
set ttyfast
set ruler
set backspace=indent,eol,start
set laststatus=2
"set relativenumber
set ignorecase
set smartcase
set nobomb

" search highlighting
set incsearch
set showmatch
set hlsearch

" clear search results
nnoremap <leader><space> :noh<cr>

set wrap
set textwidth=79
set formatoptions=qrn1
set colorcolumn=120

" split windows
nnoremap <leader>w <C-w>v<C-w>l
nmap <leader>u :UltiSnipsEdit<CR>

" map .spec to coffee filetype
au Bufread,BufNewFile *.spec set filetype=coffee
