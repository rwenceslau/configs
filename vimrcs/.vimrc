" init vundle
set rtp+=~/.vim/bundle/Vundle.vim/
call vundle#rc()

" vundle packages
Bundle 'gmarik/vundle'
Bundle 'vim-ruby/vim-ruby'
Bundle 'ervandew/supertab'
Bundle 'bronson/vim-trailing-whitespace'
Bundle 'pangloss/vim-javascript'
Bundle 'kchmck/vim-coffee-script'
Bundle 'ctrlp.vim'
Bundle 'ZoomWin'
Bundle 'matchit.zip'
Bundle 'tComment'
Bundle 'tristen/vim-sparkup'
Bundle 'plasticboy/vim-markdown'
Bundle 'kballard/vim-swift'
Bundle 'mustache/vim-mustache-handlebars'
Bundle 'slim-template/vim-slim'
Bundle 'fatih/vim-go'
Bundle 'tpope/vim-fugitive'
Bundle 'mileszs/ack.vim'
Bundle 'puppetlabs/puppet-syntax-vim'
Bundle 'jiangmiao/simple-javascript-indenter'
Bundle 'mxw/vim-jsx'
Bundle 'burnettk/vim-angular'
Bundle 'othree/html5.vim'
Bundle 'flazz/vim-colorschemes'
Bundle 'elixir-lang/vim-elixir'
Bundle 'briancollins/vim-jst'
Bundle 'jszakmeister/vim-togglecursor'
Bundle 'vim-airline/vim-airline'
Bundle 'airblade/vim-gitgutter'
Bundle 'rking/ag.vim'
Bundle 'Chun-Yang/vim-action-ag'
Bundle 'jparise/vim-graphql'
Bundle 'w0rp/ale'
Bundle 'hzchirs/vim-material'

" take in an extra file from the local directory if necessary
if filereadable(glob(".vimrc.local"))
  source .vimrc.local
endif

" vim options
let g:go_version_warning = 0
filetype plugin indent on
syntax on
cabbr te tabedit
colorscheme molokai
set expandtab
set nocompatible
set laststatus=2
set tabstop=4
set shiftwidth=4
set showtabline=4
set number
set wrap
set backspace=0
set t_Co=256
set colorcolumn=210 " red line and over is error
set textwidth=0
set hlsearch
set cursorline

" turn off vim-markdown folding
let g:vim_markdown_folding_disabled=1

" enforce purity
noremap  <Up> <Nop>
noremap  <Down> <Nop>
noremap  <Left> <Nop>
noremap  <Right> <Nop>

set ts=4 sw=4

" ag-vim shortcut
map <Leader>f gagiw

" set nonumber
highlight Normal ctermbg=None

autocmd FileType yaml setlocal ai ts=4 sw=4 et
