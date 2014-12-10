set number
set tabstop=2
set shiftwidth=2
set expandtab
set autoindent
set laststatus=2
set ambiwidth=double
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
set undodir=~/.vim/undo
set undofile

nmap <ESC><ESC> ;nohlsearch<CR><ESC>
nnoremap ; :
set virtualedit=block
set backspace=indent,eol,start
set list
set listchars=tab:›\ ,eol:\ ,trail:~

set fileencodings=utf-8
set fileformats=unix,dos
set encoding=utf-8
set fileformat=unix

if !1 | finish | endif

if has('vim_starting')
  if &compatible
    set nocompatible
  endif
  set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

call neobundle#begin(expand('~/.vim/bundle/'))
NeoBundleFetch 'Shougo/neobundle.vim'
NeoBundle 'scrooloose/nerdtree'
NeoBundle 'airblade/vim-gitgutter'
NeoBundle 'itchyny/lightline.vim'
NeoBundle 'w0ng/vim-hybrid'
NeoBundle 'marijnh/tern_for_vim', {'build': {'others': 'npm install'}}
NeoBundle has('lua') ? 'Shougo/neocomplete' : 'Shougo/neocomplcache'
NeoBundle 'scrooloose/syntastic'
call neobundle#end()

if neobundle#is_installed('neocomplete')
  let g:neocomplete#enable_at_startup = 1
  let g:neocomplete#enable_ignore_case = 1
  let g:neocomplete#enable_smart_case = 1
  if !exists('g:neocomplete#keyword_patterns')
    let g:neocomplete#keyword_patterns = {}
  endif
  let g:neocomplete#keyword_patterns._ = '\h\w*'
  let g:neocomplete#force_overwrite_completefunc=1
  inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
  inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<S-TAB>"
elseif neobundle#is_installed('neocomplcache')
  let g:neocomplcache_enable_at_startup = 1
  let g:neocomplcache_enable_ignore_case = 1
  let g:neocomplcache_enable_smart_case = 1
  if !exists('g:neocomplcache_keyword_patterns')
    let g:neocomplcache_keyword_patterns = {}
  endif
  let g:neocomplcache_keyword_patterns._ = '\h\w*'
  let g:neocomplcache_enable_camel_case_completion = 1
  let g:neocomplcache_enable_underbar_completion = 1
  let g:neocomplcache_force_overwrite_completefunc=1
  inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
  inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<S-TAB>"
endif

let s:bundle = neobundle#get('syntastic')
function! s:bundle.hooks.on_source(bundle)
  let g:syntastic_check_on_open = 0
  let g:syntastic_check_on_wq = 0
  let g:syntastic_auto_loc_list = 1
  let g:syntastic_loc_list_height = 5
endfunction

syntax enable
set background=dark
colorscheme hybrid

filetype plugin indent on

au BufWritePost * mkview
autocmd BufReadPost * loadview

NeoBundleCheck

