let mapleader =","

if ! filereadable(system('echo -n "${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/plug.vim"'))
  echo "Downloading junegunn/vim-plug to manage plugins..."
  silent !mkdir -p ${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/
  silent !curl "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim" > ${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/plug.vim
  autocmd VimEnter * PlugInstal Nerd Fontl
endif

" Plugins {{{
call plug#begin(system('echo -n "${XDG_CONFIG_HOME:-$HOME/.config}/nvim/plugged"'))
" Plug 'tpope/vim-surround'
Plug 'tmsvg/pear-tree'
Plug 'sheerun/vim-polyglot'
Plug 'octol/vim-cpp-enhanced-highlight'
Plug 'preservim/nerdtree'
Plug 'morhetz/gruvbox'
Plug 'ryanoasis/vim-devicons'
Plug 'vim-airline/vim-airline-themes'
Plug 'honza/vim-snippets'
Plug 'vim-python/python-syntax'
Plug 'junegunn/fzf.vim'
Plug 'ludovicchabant/vim-gutentags'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'dart-lang/dart-vim-plugin'
Plug 'thosakwe/vim-flutter'
Plug 'rhysd/vim-clang-format'
" Plug 'junegunn/goyo.vim'
" Plug 'PotatoesMaster/i3-vim-syntax'
" Plug 'jreybert/vimagit'
" Plug 'lukesmithxyz/vimling'
" Plug 'vimwiki/vimwiki'
Plug 'bling/vim-airline'
Plug 'tpope/vim-commentary'
" Plug 'kovetskiy/sxhkd-vim'
" Plug 'ap/vim-css-color'
" Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
" Plug 'Chiel92/vim-autoformat'
" Plug 'Shougo/neosnippet.vim'
" Plug 'Shougo/neosnippet-snippets'
call plug#end()
" }}}

" Plugins settings {{{
  " Airline {{{
    let g:airline#extensions#tabline#enabled = 1
  " }}}
  " Deoplete {{{
    " let g:deoplete#enable_at_startup = 1
  " }}}
  " Nerdtree {{{
    let NERDTreeShowHidden = 1
  " }}}
  " Coc {{{
    inoremap <silent><expr> <TAB>
        \ pumvisible() ? coc#_select_confirm() :
        \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
        \ <SID>check_back_space() ? "\<TAB>" :
        \ coc#refresh()

    " Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
    " position. Coc only does snippet and additional edit on confirm.
    if exists('*complete_info')
        inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
    else
            imap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
    endif

    function! s:check_back_space() abort
      let col = col('.') - 1
      return !col || getline('.')[col - 1]  =~# '\s'
    endfunction

    " let g:coc_snippet_next = '<tab>'
    "}}}
  "Flutter {{{
    let g:flutter_show_log_on_run = 1
  "}}}
    " }}}

" General settings {{{
set nu
set nocompatible
filetype plugin indent on
syntax on
set hidden
colorscheme gruvbox
set smartindent
set tabstop=4
set shiftwidth=4
set expandtab
set cursorline
set nobackup
set nowritebackup
set updatetime=300
set shortmess+=c
" set signcolumn=yes
set termguicolors
set splitbelow splitright
set wildmenu
set wildmode=longest,list,full
set go=a
set mouse=a
set nohlsearch
set clipboard+=unnamedplus
" }}}

" Remove trailing whitespaces on save {{{
autocmd BufWritePre * %s/\s\+$//e
" }}}

" Filetype settings {{{
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
" }}}

" Utils {{{
" Function to get current filesize
function! FileSize()
  let bytes = getfsize(expand('%:p'))
  if (bytes >= 1024)
      let kbytes = bytes / 1024
  endif
  if (exists('kbytes') && kbytes >= 1024)
      let mbytes = kbytes / 1024
  endif
  if bytes <= 0
     return '0'
  endif
  if (exists('mbytes'))
      return mbytes . 'MB'
  elseif (exists('kbytes'))
      return kbytes . 'KB'
  else
      return bytes . 'B '
  endif
endfunction
" }}}

" Shortcuts {{{
" Nerd tree
map <leader>n :NERDTreeToggle<CR>
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" }}}

" vim: ts=2 sw=2 et
