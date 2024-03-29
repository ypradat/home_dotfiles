"""
"""     PLUGIN
"""
""""""""""""""""""""""""

" Install recommendations for Vundle
" filetype off is overruled afterwards
set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

autocmd BufNewFile *.txt :write

"   Required
"
""""""""""""""""""""""""

Plugin 'VundleVim/Vundle.vim'

"   Essential
"
""""""""""""""""""""""""

"Plugin 'mileszs/ack.vim'                                                  " Search tools as grep (brew install ack bee)
Plugin 'scrooloose/nerdtree'                                              " Nerdtree
Plugin 'terryma/vim-multiple-cursors'                                     " Multiple selection
Plugin 'Valloric/YouCompleteMe'                                           " Autocompletion
Plugin 'SirVer/ultisnips'                                                 " Snippets engine
Plugin 'honza/vim-snippets'                                               " Core of snippets (separated from the engine)
Plugin 'ervandew/supertab'                                                " Supertab to combine youcompleteme and ultisnips
Plugin 'Chiel92/vim-autoformat'                                           " To easily format code
Plugin 'vim-airline/vim-airline'                                          " Powerline
Plugin 'tpope/vim-fugitive'                                               " Github
Plugin 'lervag/vimtex'                                                    " Vimtex is the most up-to-date for Latex
Plugin 'godlygeek/tabular'                                                " Tabularize
Plugin 'vim-scripts/indentpython.vim'                                     " Python indentation
Plugin 'vim-python/python-syntax'                                         " Python syntax highlighting
Plugin 'vim-syntastic/syntastic'                                          " Syntax highlighting
Plugin 'nvie/vim-flake8'                                                  " Python PEP8 style guide (install flake8 bee)
Plugin 'ryanoasis/vim-devicons'                                           " Add icons to plugins
Plugin 'tiagofumo/vim-nerdtree-syntax-highlight'                          " Add colors to icons
Plugin 'Yggdroot/indentLine'                                              " Vertical lines indentation
Plugin 'dpelle/vim-LanguageTool'                                          " Grammar syntax check
Plugin 'easymotion/vim-easymotion'                                        " Jumps around the document with ease
Plugin 'chrisbra/csv.vim'                                                 " Additional support for csv files
Plugin 'JuliaEditorSupport/julia-vim'                                     " Julia
Plugin 'jalvesaq/vimcmdline'                                              " Send command to tmux pane
Plugin 'jalvesaq/Nvim-R'                                                  " Vim support to edit R-code
Plugin 'christoomey/vim-tmux-navigator'                                   " Navigation between vim and tmux
Plugin 'vim-pandoc/vim-pandoc'                                            " Integrate with pandoc document converter
Plugin 'vim-pandoc/vim-pandoc-syntax'                                     " Syntax support for pandoc
Plugin 'vim-pandoc/vim-rmarkdown'                                         " Vim support R Markdown
Plugin 'JamshedVesuna/vim-markdown-preview'                               " Markdown preview (install grip)
Plugin 'sbdchd/neoformat'                                                 " Vim plugin for formatting code
Plugin 'raingo/vim-matlab'                                                " Vim support for editing Matlab scripts
Plugin 'https://github.com/snakemake/snakemake.git', {'rtp': 'misc/vim/'} " Vim support for snakemake

call vundle#end()

" Correct indentation
source $VIMRUNTIME/macros/matchit.vim

filetype plugin on
filetype indent on
syntax enable

""""""""""""""""""""""""
"""
"""     HYPERPARAMETERS
"""
""""""""""""""""""""""""

" leader
let mapleader      = "\\"
let maplocalleader = "\\"

" edit and source vimrc file
nnoremap <leader>ev :vsplit $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>

" copy to system clipboard
noremap <Leader>y "+y
" paste from system clipboard
noremap <Leader>p "+p

" Use backspace
set backspace=indent,eol,start

" tabs manager
nnoremap th  :tabfirst<CR>
nnoremap tk  :tabnext<CR>
nnoremap tj  :tabprev<CR>
nnoremap tl  :tablast<CR>
nnoremap tn :tabnew<CR>
nnoremap td :tabclose<CR>
nnoremap tm  :tabm<Space>
hi TabLineFill ctermfg=DarkGray

" buffers manager
"nnoremap bn :bnext<CR>
"nnoremap bp :bprev<CR>

" comment
autocmd FileType vim nnoremap <buffer> <localleader>c I"<esc>
autocmd FileType vim vnoremap <buffer> <localleader>c <C-v>I"<esc>

" line number options
set numberwidth=4
set number
set nornu
set encoding=utf-8
set termencoding=utf-8

" text width options
set textwidth=120
set wrap

" indent options
" shiftwidth governs identation via >> or <<
" if expandtab it uses space bytes (\x20) alone
" if noexpandtab it uses combination of space and tab (\x09) bytes
set tabstop=8
set softtabstop=4
set shiftwidth=4

" move lines
nnoremap ,- ddp
nnoremap ,= ddkkp

" insert blank lines
nnoremap <silent>qj :set paste<CR>m`o<Esc>``:set nopaste<CR>
nnoremap <silent>qk :set paste<CR>m`O<Esc>``:set nopaste<CR>

" upper case word
inoremap <leader>= <esc>viwUeab
nnoremap <leader>= viwUeb

" new paragraph
nnoremap ,o o<esc>o<esc>ki

" navigate
nnoremap ,j }
nnoremap ,k {

" quit insert mode
inoremap jk <esc>

" replace currently selected text with default register
" without yanking it
vnoremap p "_dP

" quote a word using double quotes
nnoremap <leader>q ciw"<C-R>""<esc>bb
vnoremap <leader>q c"<C-r>""<esc>bb

" add backticks around a word
nnoremap <leader>e ciw`<esc>pa`<esc>
vnoremap <leader>e c`<esc>pa`<esc>

" set colorcolumn=+1
set hlsearch
set incsearch

set tags=./tags;,tags;./.git/tags;,.git/tags;
nnoremap <C-]> :tjump <C-R><C-W><CR>
cnoreabbrev t tjump
nmap <C-$> <C-]>
noremap <silent> <Space> :nohlsearch<Bar>:echo<CR>

" maximize window
nnoremap <leader>a <C-W>_<C-W><Bar>

" Escape terminal mode
:tnoremap <Esc> <C-\><C-n>

" Grammar checker
let g:languagetool_jar='/LanguageTool-4.4-SNAPSHOT/languagetool-commandline.jar'

" YouCompleteMe
let g:ycm_server_keep_logfiles=1
let g:ycm_server_log_level='debug'
let g:ycm_global_ycm_extra_conf='~/.vim/bundle/YouCompleteMe/third_party/ycmd/.ycm_extra_conf.py'
let g:ycm_confirm_extra_conf = 0
nnoremap <leader>jd :YcmCompleter GoTo<CR>

" Spell checker
hi clear SpellBad
hi SpellBad cterm=underline

" print output shell command to vim command line
command! -complete=shellcmd -nargs=+ Sh call s:RunShellCommand(<q-args>)
function! s:RunShellCommand(cmdline)
    echo system(a:cmdline)
endfunction

" remove all trailing whitespaces on file save
" see https://vim.fandom.com/wiki/Remove_unwanted_spaces
autocmd BufWritePre * :%s/\s\+$//e

"   CUSTOM FUNCTIONS
"
""""""""""""""""""""""""

" fill rest of line with characters
function! FillLine( str )
    " set tw to the desired total length
    let tw = &textwidth
    if tw==0 | let tw = 80 | endif
    " strip trailing spaces first
    .s/[[:space:]]*$//
    " calculate total number of 'str's to insert
    let reps = (tw - col("$")) / len(a:str)
    " insert them, if there's room, removing trailing spaces (though forcing
    " there to be one)
    if reps > 0
        .s/$/\=(' '.repeat(a:str, reps))/
    endif
endfunction"

nnoremap fi :call FillLine( '=' )<CR>

""""""""""""""""""""""""""""
"""
"""     PLUGIN CONFIGURATION
"""
""""""""""""""""""""""""""""

"   BASIC
"
""""""""""""""""""""""""
" Colors vim-easymotion
hi EasyMotionTarget ctermbg=none ctermfg=red
hi EasyMotionTarget2First ctermbg=none ctermfg=red
hi EasyMotionTarget2Second ctermbg=none ctermfg=red

" Nvim-R options
let g:R_rconsole_width  = winwidth(0) - 130

" Fold
let g:SimpylFold_docstring_preview=1
set foldmethod=indent
set foldlevel=99

" YCM + Ultisnips + Dev-icons
let g:ycm_key_list_select_completion                = ['<C-n>', '<Down>']
let g:ycm_key_list_previous_completion              = ['<C-p>', '<Up>']
let g:SuperTabDefaultCompletionType                 = '<C-n>'

" Deactivate YCM ID completion
let g:ycm_min_num_of_chars_for_completion=99

let g:UltiSnipsListSnippets                         = "<C-w>"
let g:UltiSnipsEditSplit                            = 'tabdo'

" Ultisnips trigger and jump
let g:UltiSnipsExpandTrigger                        = "<tab>"
let g:UltiSnipsJumpForwardTrigger                   = "<tab>"
let g:UltiSnipsJumpBackwardTrigger                  = "<s-tab>"
let g:ycm_autoclose_preview_window_after_completion = 1
noremap <F8> :Automat<CR>

" Vim airline
let g:airline#extensions#tabline#enabled = 1

" Ack
cnoreabbrev A Ack!
nnoremap <C-S> :Ack! <C-R><C-W><CR>
au FileType qf setlocal colorcolumn=0
let g:ack_mappings = {
      \  'v': '<C-W><CR><C-W>L<C-W>p<C-W>J<C-W>p',
      \ 'gv': '<C-W><CR><C-W>L<C-W>p<C-W>J' }

" CtrlP + ctags
noremap <C-Y> :CtrlPTag<CR>

" Trick for copy-pasting between vim panes
vnoremap <C-c> :w! /tmp/.vimbuffer<CR>
nnoremap <C-a> :r /tmp/.vimbuffer<CR>

"   vimcmdline
"
""""""""""""""""""""""""

" Plugin for sending lines from Vim to a command line interpreter (e.g python, R or julia interpreters) in an external terminal
" emulator

" vimcmdline
let cmdline_map_start          = '<LocalLeader>rf' " start interpreter
let cmdline_map_quit           = '<LocalLeader>rq' " quit interpreter
let cmdline_map_send_and_stay  = '<LocalLeader>l'  " send line and stay
let cmdline_map_send           = '<LocalLeader>d'  " send selection in visual mode
let cmdline_map_source_fun     = '<LocalLeader>aa' " send file
let cmdline_map_send_paragraph = '<LocalLeader>pp' " send paragraph
let cmdline_map_send_block     = '<LocalLeader>b'

" vimcmdline options
let cmdline_vsplit      = 1                 " Split the window vertically
let cmdline_term_height = 15                " Initial height of interpreter window or
let cmdline_term_width  = winwidth(0) - 130 " Initial width of interpreter window or pane
let cmdline_tmp_dir     = '/tmp'            " Temporary directory to save files
let cmdline_outhl       = 0                 " Syntax highlight the output
let cmdline_auto_scroll = 1                 " Keep the cursor at the end of terminal

" add a filetype:app pair for each lanugage
let cmdline_app = {}

"   Pandoc Settings
"
""""""""""""""""""""""""

let g:pandoc#formatting#textwidth=120
let g:pandoc#command#use_message_buffers=1
let g:pandoc#keyboard#blacklist_submodule_mappings=['checkboxes']


"   Markdown
"
""""""""""""""""""""""""

" au FileType markdown setlocal com=fb:*,fb:-,fb:+,n:> fo=tcqln
let g:vim_markdown_folding_style_pythonic=1

" For markdown preview, you need to brew install grip
let vim_markdown_preview_hotkey='<C-p>'
let vim_markdown_preview_github=1
let vim_markdown_preview_browser='Safari'
let vim_markdown_preview_toggle=1


au BufNewFile,BufRead *.md
    \ set tabstop=4 |
    \ set softtabstop=4 |
    \ set shiftwidth=4 |
    \ set textwidth=120 |
    \ set colorcolumn=+1 |
    \ set fo+=t |
    \ set expandtab |
    \ set autoindent |
    \ set fileformat=unix


"   Nerdtree + Dev-icons
"
""""""""""""""""""""""""

" To open NERDTree automatically when vim starts up if no files were specified
" autocmd StdinReadPre * let s:std_in=1
" autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

" To open NERDTree automatically when vim starts up
if has('gui_running')
    autocmd VimEnter * NERDTree
endif

" To close vim if the only window left open is NERDTree
autocmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTree")
    \ && b:NERDTree.isTabTree()) | q | endif

highlight link NERDTreeExecFile Type
let NERDTreeIgnore                          = ['\.pyc$', '\~$'] " ignored files
let NERDTreeMinimalUI                       = 1                 " no help line
let NERDTreeDirArrows                       = 1                 " display arrows instead of ascii
let NERDTreeWinSize                         = 45                " NERDTree size
let NERTreeMapJumperNextSibling             = '<shift-J>'
let NERTreeMapJumperPrevSibling             = '<shift-K>'
let g:WebDevIconsUnicodeDecorateFolderNodes = 1
let g:DevIconsEnableFoldersOpenClose        = 1
let g:WebDevIconsNerdTreeAfterGlyphPadding  = ' '

" Add icons to ipynb
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols          = {}       " needed
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['ipynb'] = ''
let s:yellow                                                       =          " F09F17 "
let g:NERDTreeExtensionHighlightColor                              = {}       " needed
let g:NERDTreeExtensionHighlightColor['ipynb']                     = s:yellow

nnoremap <silent> <leader><Space> :NERDTreeToggle<CR>

inoremap <silent> <leader><Space> <Esc>:NERDTreeToggle<CR>


"   Vimtex
"
""""""""""""""""""""""""

"" Syntax checker settings
set shellslash
let g:tex_flavor='latex'
let g:tex_conceal = ""
let g:syntastic_tex_checkers=['lacheck']
let g:syntastic_tex_lacheck_quiet_messages = { 'regex': '\Vpossible unwanted space at' }

"" Use skim viewer
"" From vimtex doc: forward search should just work. Backward search must be configure in skim
let g:vimtex_view_method='skim'

"" Set to 1 to make Skim have focus after command: VimtexView
let g:vimtex_view_skim_activate=1

" let g:vimtex_viewer_general='open -a Preview'
" let g:vimtex_view_method='general'

"" Configure latexmk compiler
let g:vimtex_compiler_method='latexmk'

"" Comments
""   -dvi Generate a dvi version of the document. Causes a warning from hyperref package
""        if loaded with breaklinks option. Do not use -dvi option.
""   'build_dir'
""      The output-directory option of latexmk
""   'callback'
""      If enable, tells latexmk to run vimtex#compiler#callback after compilation
""   'continuous'
""      If enabled, run latexmk in continuous mode i.e with -pvc argument
function! Callback(msg)
    let l:m = matchlist(a:msg, '\vRun number (\d+) of rule ''(.*)''')
    if !empty(l:m)
	echomsg l:m[2] . ' (' . l:m[1] . ')'
    endif
endfunction

"let g:vimtex_compiler_latexmk = {
"    \ 'callback'   : 1,
"    \ 'continuous' : 1,
"    \ 'hooks'      : [function('Callback')],
"    \ 'options'    : [
"    \   '-pdf',
"    \   '-auxdir=build',
"    \   '-outdir=build',
"    \   '-pdflatex=lualatex',
"    \   '-synctex=1',
"    \   '-shell-escape',
"    \   '-interaction=nonstopmode',
"    \ ],
"    \}

let g:vimtex_compiler_latexmk = {
    \ 'out_dir'    : 'build',
    \ 'callback'   : 1,
    \ 'continuous' : 1,
    \ 'executable' : 'latexmk',
    \ 'hooks'      : [function('Callback')],
    \ 'options'    : [
    \   '-pdf',
    \   '-verbose',
    \   '-file-line-error',
    \   '-pdflatex=lualatex',
    \   '-synctex=1',
    \   '-shell-escape',
    \   '-interaction=nonstopmode',
    \ ],
    \}

"let g:vimtex_compiler_latexmk_engines = {
"    \ '_'                : '-pdf',
"    \ 'pdfdvi'           : '-pdfdvi',
"    \ 'pdfps'            : '-pdfps',
"    \ 'pdflatex'         : '-pdf',
"    \ 'luatex'           : '-lualatex',
"    \ 'lualatex'         : '-lualatex',
"    \ 'xelatex'          : '-xelatex',
"    \ 'context (pdftex)' : '-pdf -pdflatex=texexec',
"    \ 'context (luatex)' : '-pdf -pdflatex=context',
"    \ 'context (xetex)'  : '-pdf -pdflatex=''texexec --xtx''',
"    \}

"" Enable automatic completion with youcompleteme
if !exists('g:ycm_semantic_triggers')
    let g:ycm_semantic_triggers = {}
endif

au VimEnter * let g:ycm_semantic_triggers.tex=g:vimtex#re#youcompleteme


"""""""""""""""""""""""""""""""
"""
"""     FILETYPES CONFIGURATION
"""
"""""""""""""""""""""""""""""""

" Bash
"

" comment/uncomment
au FileType sh nnoremap <buffer> <localleader>c I#<esc>
au FileType sh vnoremap <buffer> <localleader>c <C-v>I#<esc>
au FileType sh nnoremap <buffer> <localleader>v mm0xx`m

au BufNewFile,BufRead *.sh
    \ set tabstop=2 |
    \ set softtabstop=2 |
    \ set shiftwidth=2 |
    \ set textwidth=120 |
    \ set colorcolumn=+1 |
    \ set expandtab |
    \ set autoindent |
    \ set fileformat=unix


"""""""""""""""""""""""

" Latex
"
"""""""""""""""""""""""

" comment/uncomment
au FileType tex nnoremap <buffer> <localleader>c I%<esc>
au FileType tex vnoremap <buffer> <localleader>c <C-v>I%<esc>
au FileType tex nnoremap <buffer> <localleader>v mm0xx`m

au FileType tex inoremap { {}<esc>i
au FileType tex nnoremap <leader>b diwi\textbf{<esc>pi<Right>}<esc>
au FileType tex vnoremap <leader>b xi\textbf{<esc>pi<Right>}<esc>
au FileType tex nnoremap <leader>e diwi\emph{<esc>pi<Right>}<esc>
au FileType tex vnoremap <leader>e xi\emph{<esc>pi<Right>}<esc>
au FileType tex nnoremap <leader>i diwi\textit{<esc>pi<Right>}<esc>
au FileType tex vnoremap <leader>i xi\textit{<esc>pi<Right>}<esc>
au FileType tex nnoremap <leader>t diwi\texttt{<esc>pi<Right>}<esc>
au FileType tex vnoremap <leader>t xi\texttt{<esc>pi<Right>}<esc>
au FileType tex nnoremap <leader>u diwi\underline{<esc>pi<Right>}<esc>
au FileType tex vnoremap <leader>u xi\underline{<esc>pi<Right>}<esc>
au FileType tex nnoremap <leader>g diwi\gls{<esc>pi<Right>}<esc>
au FileType tex vnoremap <leader>g xi\gls{<esc>pi<Right>}<esc>
au FileType tex nnoremap <leader>p diwi\glspl{<esc>pi<Right>}<esc>
au FileType tex vnoremap <leader>p xi\glspl{<esc>pi<Right>}<esc>
au FileType tex nnoremap <leader>G diwi\Gls{<esc>pi<Right>}<esc>
au FileType tex vnoremap <leader>G xi\Gls{<esc>pi<Right>}<esc>
au FileType tex nnoremap <leader>x diwi\idx{<esc>pi<Right>}<esc>
au FileType tex vnoremap <leader>x xi\idx{<esc>pi<Right>}<esc>

au FileType tex setlocal shiftwidth=2
au FileType tex setlocal spell
au FileType tex set formatoptions=troqaw

"" This incantation means whenever we're working with a TeX file, append to the texZone
"" definition the region between \begin{lstlisting} and \end{lstlisting}.

au Filetype tex syntax region texZone start='\\begin{minted}' end='\\end{minted}'
au Filetype tex syntax region texZone start='\\begin{mintinline}{' end='}'

"" IMPORTANT: grep will sometimes skip displaying the file name if you
"" search in a single file. This will confuse Latex-Suite. Set your grep
"" program to always generate a file-name.

set grepprg=grep\ -nH\ $*

au BufNewFile,BufRead *.tex
    \ set tabstop=2 |
    \ set softtabstop=2 |
    \ set shiftwidth=2 |
    \ set textwidth=120 |
    \ set colorcolumn=+1 |
    \ set expandtab |
    \ set autoindent |
    \ set fileformat=unix

" Matlab
"
"""""""""""""""""""""""

" set matlab filetype
augroup filetypedetect
  au! BufRead,BufNewFile *.m, set filetype=matlab
augroup END

" integration of the mlint Matlab code checker
autocmd BufEnter *.m    compiler mlint

au BufNewFile,BufRead *.m
    \ set tabstop=4 |
    \ set softtabstop=4 |
    \ set shiftwidth=4 |
    \ set textwidth=120 |
    \ set expandtab |
    \ set autoindent |
    \ set fileformat=unix

" comment
autocmd FileType matlab nnoremap <buffer> <localleader>c I% <esc>0
autocmd FileType matlab vnoremap <buffer> <localleader>c <C-v>I% <esc>0

" Python
"
""""""""""""""""""""""""
" Specify ipython interpreter for vimcmdline plugin
let cmdline_app["python"] = "ipython"

" There is an issue with syntax checking so deactivate  Python file
let g:syntastic_mode_map = { 'passive_filetypes': ['python'] }

" to remove classic <up> and <down> behaviour, paste in YCM/autoload/ycm.vim
" SetUpKeysMapping function :
"silent! exe 'inoremap <expr> <down> pumvisible() ? "\<c-e>\<down>" : "\<down>"'
"silent! exe 'inoremap <expr> <up> pumvisible() ? "\<c-e>\<up>" : "\<up>"'
"

" UltiSnips
let g:ultisnips_python_style = "numpy"

" comment
autocmd FileType python nnoremap <buffer> <localleader>c I# <esc>0
autocmd FileType python vnoremap <buffer> <localleader>c <C-v>I# <esc>0

" uncomment
autocmd FileType python nnoremap <buffer> <localleader>v mm0xx`m
autocmd FileType python vnoremap <buffer> <localleader>v <C-v>lx

"" switch to previously used window
imap <silent> <leader>w <Esc><C-W><C-P>
nmap <silent> <leader>w <C-W><C-P>
vmap <silent> <leader>w <Esc><C-W><C-P>

let g:python_highlight_all=1
let g:flake8_show_in_file=1 " show markers
let g:matters_python = ['yapf'] " need to pip install yapf
let g:matter_yapf_style = 'pep8'

au BufNewFile,BufRead *.py
    \ set tabstop=4 |
    \ set softtabstop=4 |
    \ set shiftwidth=4 |
    \ set textwidth=120 |
    \ set colorcolumn=+1 |
    \ set expandtab |
    \ set autoindent |
    \ set fileformat=unix

" R
"
"""""""""""""""""""""""
augroup filetypedetect
  autocmd! BufNewFile,BufRead *.[rRsS] setfiletype r
  autocmd! BufNewFile,BufRead *.[rR]history setfiletype r
  autocmd! BufNewFile,BufRead *.[rR]md setfiletype rmarkdown
augroup END

" R assign from Nvim-R
" a single _ makes _ while another _ makes <-
let R_assign=2

" tags for navigating in R files
" use ctags -R . to create tags in current folder
let g:tagbar_type_r = {
    \ 'ctagstype' : 'r',
    \ 'kinds'     : [
        \ 'f:Functions',
        \ 'g:GlobalVariables',
        \ 'v:FunctionVariables',
    \ ]
\ }

" in order to have R from asdf run correctly with Nvim-R plugin,
" one needs to respecify the R version in use
" autocmd FileType r <silent> !asdf local R 3.6.2

" open documentation in horizontal split
let g:R_nvimpager="horizontal"

autocmd FileType r nmap <silent> <localleader>ry :call RAction("class")<CR>
autocmd FileType r vmap <silent> <localleader>ry :call RAction("class", "v")<CR>
autocmd FileType r nmap <silent> <localleader>vd :call RAction("dim")<CR>
autocmd FileType r vmap <silent> <localleader>vd :call RAction("dim", "v")<CR>

" other Nvim-R configs
let g:markdown_fenced_languages = ['r', 'python']
let g:rmd_fenced_languages = ['r', 'python']"

" comment
autocmd FileType r,rmarkdown nnoremap <buffer> <localleader>c I# <esc>0
autocmd FileType r,rmarkdown vnoremap <buffer> <localleader>c <C-v>I# <esc>0

" uncomment
autocmd FileType r,rmarkdown nnoremap <buffer> <localleader>v mm0xx`m
autocmd FileType r,rmarkdown vnoremap <buffer> <localleader>v <C-v>lx

au Filetype r,rmarkdown
    \ set tabstop=2 |
    \ set softtabstop=2 |
    \ set shiftwidth=2 |
    \ set textwidth=120 |
    \ set colorcolumn=+1 |
    \ set expandtab |
    \ set autoindent |
    \ set fileformat=unix

" Julia
"
"""""""""""""""""""""""
" Specify julia interpreter for vimcmdline plugin
let cmdline_app["julia"] = "julia"

augroup filetypedetect
  autocmd! BufNewFile,BufRead *.jl setfiletype julia
augroup END

" comment
autocmd FileType julia nnoremap <buffer> <localleader>c I# <esc>0
autocmd FileType julia vnoremap <buffer> <localleader>c <C-v>I# <esc>0

" uncomment
autocmd FileType julia nnoremap <buffer> <localleader>v mm0xx`m
autocmd FileType julia vnoremap <buffer> <localleader>v <C-v>lx

au Filetype julia
    \ set tabstop=4 |
    \ set softtabstop=4 |
    \ set shiftwidth=4 |
    \ set textwidth=120 |
    \ set colorcolumn=+1 |
    \ set fo+=t |
    \ set expandtab |
    \ set autoindent |
    \ set fileformat=unix


" Snakemake
"
"""""""""""""""""""""""

augroup filetypedetect
  autocmd! BufNewFile,BufRead Snakefile set filetype=snakemake
  autocmd! BufNewFile,BufRead *.snake set filetype=snakemake
  autocmd! BufNewFile,BufRead *.smk set filetype=snakemake
augroup END

" comment
autocmd FileType snakemake nnoremap <buffer> <localleader>c I# <esc>0
autocmd FileType snakemake vnoremap <buffer> <localleader>c <C-v>I# <esc>0

" uncomment
autocmd FileType snakemake nnoremap <buffer> <localleader>v mm0xx`m
autocmd FileType snakemake vnoremap <buffer> <localleader>v <C-v>lx

au Filetype snakemake
    \ set tabstop=4 |
    \ set softtabstop=4 |
    \ set shiftwidth=4 |
    \ set textwidth=120 |
    \ set colorcolumn=+1 |
    \ set fo+=t |
    \ set expandtab |
    \ set autoindent |
    \ set fileformat=unix


" Fullstack development
"
""""""""""""""""""""""""

au BufNewFile,BufRead *.js,*.css,*.html
    \ set tabstop=2 |
    \ set softtabstop=2 |
    \ set shiftwidth=2

" C code
"
""""""""""""""""""""""""
augroup c_mappings
    autocmd!
    autocmd FileType c inoremap { {}<esc>i
augroup END
