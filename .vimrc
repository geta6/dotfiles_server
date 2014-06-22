"
" Default setting
"
if filereadable("/etc/vim/vimrc")
  source /etc/vim/vimrc
endif

"
" NeoBundle
"
set nocompatible
filetype off
if has('vim_starting')
  set runtimepath+=~/.vim/bundle/neobundle.vim/
  call neobundle#rc(expand('~/.vim/bundle/'))
endif
NeoBundle 'bling/vim-airline'
NeoBundle 'thinca/vim-quickrun'
NeoBundle 'Shougo/neocomplcache'
NeoBundle 'scrooloose/nerdtree'
NeoBundle 'airblade/vim-gitgutter'
NeoBundle 'scrooloose/syntastic'
NeoBundle 'sheerun/vim-polyglot'
NeoBundle 'altercation/vim-colors-solarized'

"
" Global configuration
"
set ambiwidth=double
set laststatus=2
set showcmd
set showmatch
set matchtime=1
set ignorecase
set smartcase
set ruler
set number
set notitle
set autowrite
set hidden
set scrolloff=5
set history=1000
set autoread
set incsearch
set hlsearch
set nowrap
set t_Co=256
set wildmenu
set wildchar=<tab>
set wildmode=list:full
set wildignorecase
set complete+=k
set lazyredraw
set ttyfast
set ttyscroll=3
set cursorline
set undodir=~/.vim/view
set undofile
nmap <ESC><ESC> ;nohlsearch<CR><ESC>
augroup cch
  autocmd! cch
  autocmd WinLeave * set nocursorline
  autocmd WinEnter,BufRead * set cursorline
augroup END


"
" Indentation
"
set tabstop=2
set shiftwidth=2
set expandtab
set autoindent


"
" Key remap
"
nnoremap ; :
set virtualedit=block
set backspace=indent,eol,start
set t_kD=[3~
set list
set listchars=tab:›\ ,eol:\ ,trail:~


"
" Move to last edited line
"
au BufWritePost * mkview
autocmd BufReadPost * loadview


"
" File handling
"
set fileencodings=utf-8
set fileformats=unix,dos
set encoding=utf-8
set fileformat=unix
filetype plugin on
autocmd BufWritePre * :%s/\s\+$//ge


"
" Coloring
"
syntax enable
set background=dark
colorscheme solarized
let g:solarized_termcolors=256
let g:solarized_termtrans=1
function! ActivateInvisibleIndicator()
  hi SpecialKey cterm=NONE ctermfg=darkgray guifg=darkgray
  hi ZenkakuSpace cterm=underline ctermfg=red gui=underline guifg=#FF0000
  match ZenkakuSpace /　/
endfunction
augroup InvisibleIndicator
  autocmd!
  autocmd BufEnter * call ActivateInvisibleIndicator()
augroup END


"
" Module configuration
"
cnoremap <C-p> <Up>
cnoremap <Up>  <C-p>
cnoremap <C-n> <Down>
cnoremap <Down>  <C-n>

let g:neocomplcache_enable_at_startup = 1
let g:neocomplcache_enable_smart_case = 1
let g:neocomplcache_enable_camel_case_completion = 1
let g:neocomplcache_enable_underbar_completion = 1
let g:neocomplcache_min_syntax_length = 1

imap <C-k> <Plug>(neocomplcache_snippets_expand)
smap <C-k> <Plug>(neocomplcache_snippets_expand)
inoremap <expr><C-g> neocomplcache#undo_completion()
inoremap <expr><C-l> neocomplcache#complete_common_string()

inoremap <expr><CR> neocomplcache#smart_close_popup() . "\<CR>"
inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr><C-h> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><C-y> neocomplcache#close_popup()
inoremap <expr><C-e> neocomplcache#cancel_popup()

inoremap <expr><Up> neocomplcache#close_popup()."\<Up>"
inoremap <expr><Down> neocomplcache#close_popup()."\<Down>"
inoremap <expr><Left> neocomplcache#close_popup()."\<Left>"
inoremap <expr><Right> neocomplcache#close_popup()."\<Right>"

autocmd FileType quickrun AnsiEsc

let g:airline_enable_branch = 0
let g:airline_section_b = "%t %M"
let g:airline_section_c = ''
let s:sep = " %{get(g:, 'airline_right_alt_sep', '')} "
let g:airline_section_x =
      \ "%{strlen(&fileformat)?&fileformat:''}".s:sep.
      \ "%{strlen(&fenc)?&fenc:&enc}".s:sep.
      \ "%{strlen(&filetype)?&filetype:'no ft'}"
let g:airline_section_y = '%3p%%'
let g:airline_section_z = get(g:, 'airline_linecolumn_prefix', '').'%3l:%-2v'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#whitespace#enabled = 0

"
" Finalize
"
filetype plugin indent on
NeoBundleCheck
