set nocompatible			" Be iMproved, required

call plug#begin('~/.vim/plugged')
Plug 'tpope/vim-fugitive'		" Use git from inside vim
Plug 'inkarkat/vim-ingo-library'	" Prerequisite of the mark plugin
Plug 'inkarkat/vim-mark'		" Mark words instances
Plug 'hari-rangarajan/CCTree'		" Show call tree
Plug 'jnurmine/Zenburn'			" Colorscheme
Plug 'shahar3000/taglist.vim'		" See buffer symbols
Plug 'scrooloose/nerdtree'		" File explorer
Plug 'shahar3000/lightline.vim'		" Status/tab line plugin
Plug 'justinmk/vim-syntax-extra'	" Improve C syntax presentation

" Fuzzy file search
Plug 'wincent/command-t', {
	\ 'do': 'cd ruby/command-t/ext/command-t && ruby extconf.rb && make'
\ }
call plug#end()

try
	colorscheme zenburn		" Use zenburn colorscheme
catch /^Vim\%((\a\+)\)\=:E185/
	colorscheme elflord
endtry

set switchbuf=useopen			" Open new buffer in current window
syntax on				" Turn on colorscheme color syntax
set nu					" Add line numbers
set numberwidth=5			" Number takes up to 5 spaces
set hlsearch				" Highlight search results
set incsearch				" Find search match during typing
set backspace=indent,eol,start		" Allow backspace delete lines
set ruler				" Show cursor location
let mapleader = ","			" Change mark leader char
set laststatus=2			" Always on status line
set viminfo+=n~/.vim/viminfo		" Set viminfo location inside .vim dir
set relativenumber			" Use relative numbers
set hidden				" Move between unsaved buffers

if has("autocmd")
	filetype plugin indent on
endif

" Enable using the mouse
" set mouse=a
" set ttymouse=xterm2

" Don't create backup and swap files
set nobackup
set nowritebackup
set noswapfile

" Highlight in gray extra spaces
highlight ExtraSpaces ctermbg=gray ctermfg=white
autocmd InsertEnter * match ExtraSpaces /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraSpaces /\s\+$/

" Taglist configuration
autocmd BufWritePost * :TlistUpdate	" Update taglist after saving a file
let Tlist_Show_One_File = 1		" Display tags of the active buffer only
let Tlist_WinWidth = 50			" Set taglist window width

" Search font definition
hi Search cterm=NONE ctermfg=black ctermbg=lightgreen

" Disable Background Color Erase (BCE) so that color schemes render properly when
" inside 256-color tmux and GNU screen.
" See also http://snk.tuxfamily.org/log/vim-256color-bce.html
if &term =~ '256color'
  set t_ut=
endif

" List spaces (:set list/nolist)
set listchars=eol:$,tab:>-,trail:~,extends:>,precedes:<

" Generate an index using a custom index script
function! CustomIndex()
	if filereadable("index.sh")
		call feedkeys("\<CR>")
		!bash index.sh
		call CscopeLoadDB()
		call feedkeys("\<CR>")
	else
		echo("ERROR: index.sh was not found")
	endif
endfunction

	function! LightlineFugitive()
		if exists('*FugitiveStatusline')
			return FugitiveStatusline()[5:-3]
		endif
		return ''
	endfunction

	let g:lightline = {
	\ 'colorscheme' : 'ssmatity',
	\ 'active' : {
		\ 'left': [
			\ ['mode', 'paste'],
			\ ['fugitive'],
			\ ['readonly', 'relativepath', 'modified'],
		\ ],
		\ 'right': [
			\ ['lineinfo'],
			\ ['percent'],
		\ ],
	\ },
	\ 'inactive' : {
		\ 'left': [
			\ ['filename'],
		\ ],
		\ 'right': [
			\ ['lineinfo'],
			\ ['percent'],
		\ ],
	\ },
	\ 'tabline' : {
		\ 'left': [
			\ ['tabs'],
		\ ],
		\ 'right': [],
	\ },
	\ 'component_function' : {
		\ 'fugitive': 'LightlineFugitive',
	\ },
	\ 'component': {
	\ },
	\ 'subseparator' : {
		\ 'left': '',
		\ 'right': '',
	\ },
\ }

" Binary read and write
nmap <Leader>br :%!xxd<CR> :set filetype=xxd<CR>
nmap <Leader>bw :%!xxd -r<CR> :set binary<CR> :set filetype=<CR>

" FW coding style configuration setup
function! FwSetup()
	setlocal expandtab shiftwidth=2 softtabstop=2 smartindent colorcolumn=100
	syntax keyword cType S08 U08 S16 U16 S32 U32 VU32 U64 S64 BOOLEAN
	syntax keyword Boolean TRUE FALSE
endfunction

" Linux kernel coding style configuration setup
function! LinuxKernelSetup()
	setlocal noexpandtab shiftwidth=8 tabstop=8 softtabstop=8 smartindent colorcolumn=80
	syntax keyword cType u8 u16 u32 u64 s8 s16 s32 s64 __le16 __be16 __le32 __be32 __le64 __be64
endfunction

" Set FW coding style
autocmd BufRead,BufNewFile /**/wcd_fw-dev/**/*.{c,h} call FwSetup()

" Set Linux kernel coding style
autocmd BufRead,BufNewFile /**/iwlwifi-stack-dev/**/*.{c,h} call LinuxKernelSetup()
autocmd BufRead,BufNewFile /**/iwlwifi-hostap/**/*.{c,h} call LinuxKernelSetup()

" Try to automatically load a cscope database
autocmd VimEnter * call CscopeLoadDB()

" Load cctree index
nmap <F5> :CCTreeLoadXRefDB cctree.out<CR>

" Build and load cctree index
nmap <F6> :!ccglue -S cscope.out -o cctree.out<CR>:CCTreeLoadXRefDB cctree.out<CR>

" Load cscope index
nmap <F7> :call CscopeLoadDB()<CR><CR>

" Build and load cscope index
nmap <F8> :!cscope -Rbq; ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .<CR>:call CscopeLoadDB()<CR><CR>

" Taglist toggle
nmap <F9> :TlistToggle<CR>

" File exploring toggling
nmap <F10> :NERDTreeToggle<CR>

" Open current buffer in file explorer
nmap <F11> :NERDTreeFind<CR>

" Build and load custom cscope index
nmap <F12> :call CustomIndex()<CR>
