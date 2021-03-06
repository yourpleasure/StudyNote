" An example for a vimrc file.
"
" Maintainer:   Bram Moolenaar <Bram@vim.org>
" Last change:  2016 Jun 21
"
" To use it, copy it to
"     for Unix and OS/2:  ~/.vimrc
"         for Amiga:  s:.vimrc
"  for MS-DOS and Win32:  $VIM\_vimrc
"       for OpenVMS:  sys$login:.vimrc

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
    finish
endif

" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible
filetype off
set encoding=utf-8
if has('python3')
    silent! python3 1
endif

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
Plugin 'xolox/vim-misc.git'
Plugin 'xolox/vim-lua-ftplugin.git'
Plugin 'vim-scripts/taglist.vim.git'
Plugin 'vim-scripts/cscope.vim.git'
Plugin 'vim-scripts/ctags.vim'
Plugin 'chr4/nginx.vim'
Plugin 'tomasr/molokai'
Plugin 'Valloric/YouCompleteMe'
Plugin 'kien/rainbow_parentheses.vim'
Plugin 'derekwyatt/vim-scala'
Plugin 'vim-scripts/JavaScript-Indent'
Plugin 'scrooloose/nerdtree'
Plugin 'tfnico/vim-gradle'
Plugin 'ryanoasis/vim-devicons'
Plugin 'w0rp/ale'
Plugin 'dbeniamine/cheat.sh-vim'
Plugin 'dscleaver/sbt-quickfix'
Plugin 'majutsushi/tagbar'
Plugin 'vim-scripts/bash-support.vim'
Plugin 'raymond-w-ko/vim-lua-indent'
Plugin 'godlygeek/tabular'
Plugin 'plasticboy/vim-markdown'
Plugin 'suan/vim-instant-markdown'
Plugin 'fatih/vim-go'
Plugin 'python-mode/python-mode'
Plugin 'airblade/vim-gitgutter'
Plugin 'jiangmiao/auto-pairs'
Plugin 'Chiel92/vim-autoformat'
Plugin 'Vimjas/vim-python-pep8-indent'
Plugin 'nvie/vim-flake8'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'tpope/vim-fugitive'
Plugin 'mileszs/ack.vim'
Plugin 'tpope/vim-surround'
Plugin 'Yggdroot/indentLine'
call vundle#end()
let mapleader = "-"
" allow backspacing over everything in insert mode
set backspace=indent,eol,start
set nofoldenable
filetype plugin on
runtime macros/matchit.vim
if has("vms")
    set nobackup        " do not keep a backup file, use versions instead
else
    set nobackup        " keep a backup file (restore to previous version)
    set undofile        " keep an undo file (undo changes after closing)
    set undodir=$HOME/.vim/undodir
    set undolevels=100
endif
set history=50      " keep 50 lines of command line history
set ruler       " show the cursor position all the time
set showcmd     " display incomplete commands
set incsearch       " do incremental searching
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
map <C-F12> :!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .<CR>
set showmatch
set noerrorbells
set visualbell
set number
set relativenumber

augroup numbertoggle
    autocmd!
    autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
    autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
augroup END

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" Don't use Ex mode, use Q for formatting
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" In many terminal emulators the mouse works just fine, thus enable it.
" if has('mouse')
"   set mouse=a
" endif

" Switch syntax highlighting on when the terminal has colors or when using the
" GUI (which always has colors).
if &t_Co > 2 || has("gui_running")
    syntax on

    " Also switch on highlighting the last used search pattern.
    set hlsearch

    " I like highlighting strings inside C comments.
    let c_comment_strings=1
endif
set fileencodings=utf-8,bg18030,gbk

" Only do this part when compiled with support for autocommands.
if has("autocmd")

    " Enable file type detection.
    " Use the default filetype settings, so that mail gets 'tw' set to 72,
    " 'cindent' is on in C files, etc.
    " Also load indent files, to automatically do language-dependent indenting.
    filetype plugin indent on

    " Put these in an autocmd group, so that we can delete them easily.
    augroup vimrcEx
        au!

        " For all text files set 'textwidth' to 78 characters.
        autocmd FileType text setlocal textwidth=78

        " When editing a file, always jump to the last known cursor position.
        " Don't do it when the position is invalid or when inside an event handler
        " (happens when dropping a file on gvim).
        autocmd BufReadPost *
                    \ if line("'\"") >= 1 && line("'\"") <= line("$") |
                    \   exe "normal! g`\"" |
                    \ endif

    augroup END

else

    set autoindent      " always set autoindenting on

endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
    command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
                \ | wincmd p | diffthis
endif

if has('langmap') && exists('+langnoremap')
    " Prevent that the langmap option applies to characters that result from a
    " mapping.  If unset (default), this may break plugins (but it's backward
    " compatible).
    set langnoremap
endif
" Add optional packages.
"
" The matchit plugin makes the % command work better, but it is not backwards
" compatible.
" if has('syntax') && has('eval')
"   packadd matchit
" endif

" go support
let g:tagbar_type_go = {
            \ 'ctagstype' : 'go',
            \ 'kinds'     : [
            \ 'p:package',
            \ 'i:imports:1',
            \ 'c:constants',
            \ 'v:variables',
            \ 't:types',
            \ 'n:interfaces',
            \ 'w:fields',
            \ 'e:embedded',
            \ 'm:methods',
            \ 'r:constructor',
            \ 'f:functions'
            \ ],
            \ 'sro' : '.',
            \ 'kind2scope' : {
            \ 't' : 'ctype',
            \ 'n' : 'ntype'
            \ },
            \ 'scope2kind' : {
            \ 'ctype' : 't',
            \ 'ntype' : 'n'
            \ },
            \ 'ctagsbin'  : 'gotags',
            \ 'ctagsargs' : '-sort -silent'
            \ }

" NERD tree
let NERDChristmasTree=0
let NERDTreeWinSize=30
let NERDTreeChDirMode=2
set wildignore+=*.pyc,*.o,*.obj,*.svn,*.swp,*.class,*.hg,*.DS_Store,*.min.*,.git,*.a,*.mo,*.la,*.so,*.jpg,*.png,*.pdf,*.gif

let NERDTreeRespectWildIgnore=1
let NERDTreeShowBookmarks=1
let NERDTreeWinPos="left"
" Automatically open a NERDTree if no files where specified
autocmd vimenter * if !argc() | NERDTree | endif
" Close vim if the only window left open is a NERDTree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
" Open a NERDTree
nmap <F5> :NERDTreeToggle<cr>
nmap <F6> :NERDTreeFind<cr>
" Tagbar
let g:tagbar_width=35
let g:tagbar_autofocus=1
nmap <F7> :TagbarToggle<cr>

let g:pymode_python = "python3"

" configure syntastic syntax checking to check on open as well as save
" set statusline+=%#warningmsg#
" set statusline+=%{SyntasticStatuslineFlag()}
" set statusline+=%{FugitiveStatusline()}
" set statusline+=%*
let g:ale_sign_column_always = 1
let g:ale_set_highlights = 0
let g:ale_sign_error = '✗'
let g:ale_sign_warning = '⚠'
let g:ale_statusline_format = ['✗ %d', '⚠ %d', '✔ OK']
let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
set laststatus=2
" let g:ale_lint_on_enter = 0
let g:alt_set_quickfix = 1
function! LinterStatus() abort
    let l:counts = ale#statusline#Count(bufnr(''))

    let l:all_errors = l:counts.error + l:counts.style_error
    let l:all_non_errors = l:counts.total - l:all_errors

    return l:counts.total == 0 ? 'OK' : printf(
    \   '%dW %dE',
    \   all_non_errors,
    \   all_errors
    \)
endfunction
set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [POS=%l,%v][%p%%]\ %{strftime(\"%d/%m/%y\ -\ %H:%M\")}\ %{LinterStatus()}

" cscope
if filereadable("cscope.out")
    cs add cscope.out
elseif $CSCOPE_DB != ""
    cs add $CSCOPE_DB
endif

" ctags
map <F12> :!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .<cr>

" nginx syntax
au BufRead,BufNewFile /usr/local/openresty/nginx/conf/* if &ft == '' | setfiletype nginx | endif

" YCM
let g:ycm_confirm_extra_conf = 0
let g:ycm_global_ycm_extra_conf = '~/.ycm_extra_conf.py'

" quickfix
nnoremap <F3> :cp<cr>
nnoremap <F4> :cn<cr>

" Rainbow Parentheses
let g:rbpt_colorpairs = [
            \ ['brown',       'RoyalBlue3'],
            \ ['Darkblue',    'SeaGreen3'],
            \ ['darkgray',    'DarkOrchid3'],
            \ ['darkgreen',   'firebrick3'],
            \ ['darkcyan',    'RoyalBlue3'],
            \ ['darkred',     'SeaGreen3'],
            \ ['darkmagenta', 'DarkOrchid3'],
            \ ['brown',       'firebrick3'],
            \ ['gray',        'RoyalBlue3'],
            \ ['darkmagenta', 'DarkOrchid3'],
            \ ['Darkblue',    'firebrick3'],
            \ ['darkgreen',   'RoyalBlue3'],
            \ ['darkcyan',    'SeaGreen3'],
            \ ['darkred',     'DarkOrchid3'],
            \ ['red',         'firebrick3'],
            \ ]
let g:rbpt_max            = 16
let g:rbpt_loadcmd_toggle = 0
au VimEnter * RainbowParenthesesToggle
au Syntax * RainbowParenthesesLoadRound
au Syntax * RainbowParenthesesLoadSquare
au Syntax * RainbowParenthesesLoadBraces

let g:airline_powerline_fonts = 1
let g:airline#extensions#ale#enabled = 1

let g:arckprg = 'ag --nogroup --nocolor --column'
"
" vim study test
"TEST
inoremap <c-d> <esc>ddO
inoremap <c-U> <esc>viwUea
nnoremap <c-U> viwUel
nnoremap <leader>ev :vsplit $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>
iabbrev @@ lixu19890724@163.com
iabbrev ssig Gao Liang<cr>lixu19890724@163.com
nnoremap <leader>" viw<esc>a"<esc>hbi"<esc>lel
nnoremap <leader>' viw<esc>a'<esc>hbi'<esc>lel
nnoremap <leader>( viw<esc>a(<esc>hbi)<esc>lel
nnoremap <leader>{ viw<esc>a{<esc>hbi}<esc>lel
nnoremap <leader>[ viw<esc>a[<esc>hbi]<esc>lel
nnoremap <leader>a" :%s/^/"/<cr>:%s/$/"/<cr>
nnoremap <leader>I 0gg<cr>VG<cr>I
inoremap jk <esc>
nnoremap <Up> <nop>
nnoremap <Down> <nop>
nnoremap <Left> <nop>
nnoremap <Right> <nop>
augroup filetype_abbr
    autocmd!
    autocmd FileType python nnoremap <buffer> <leader>c I# <esc>
    autocmd FileType sh nnoremap <buffer> <leader>c I" <esc>
    autocmd FileType python :iabbrev <buffer> iff if:<left>
augroup END

augroup autoformat
    autocmd BufWrite *.py :Autoformat
augroup END

onoremap p i(
onoremap b /return<cr>
onoremap in( :<c-u>normal! f(vi(<cr>
onoremap il( :<c-u>normal! F)vi(<cr>
nnoremap <leader>line :%s/$/,/<cr>:%j<cr>:s/ //g<cr>:s/,$//<cr>
nnoremap <leader>line2 :%s/^/"/g<cr>:%s/$/"/g<cr>:%s/$/,/<cr>:%j<cr>:s/ //g<cr>:s/,$//<cr>
nnoremap <leader>line3 :%s/^/("/g<cr>:%s/$/")/g<cr>:%s/$/,/<cr>:%j<cr>:s/ //g<cr>:s/,$//<cr>
nnoremap <leader>ta :%s/\|//g<cr>:%s/^ \+//<cr>:%s/ \+$//<cr>:%s/ \+/\t/g<cr>
