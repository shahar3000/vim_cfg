set nocompatible			" Be iMproved, required

call plug#begin('~/.vim/plugged')
Plug 'tpope/vim-fugitive'		" Use git from inside vim
Plug 'inkarkat/vim-ingo-library'	" Prerequisite of the mark plugin
Plug 'inkarkat/vim-mark'		" Mark words instances
Plug 'hari-rangarajan/CCTree'		" Show call tree
Plug 'jnurmine/Zenburn'			" Colorscheme
Plug 'scrooloose/nerdtree'		" File explorer
Plug 'shahar3000/lightline.vim'		" Status/tab line plugin
Plug 'justinmk/vim-syntax-extra'	" Improve C syntax presentation
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
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
			\ ['cocstatus'],
		\ ],
	\ },
	\ 'inactive' : {
		\ 'left': [
			\ ['readonly', 'filename', 'modified'],
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
		\ 'cocstatus': 'coc#status',
	\ },
	\ 'component': {
	\ },
	\ 'subseparator' : {
		\ 'left': '',
		\ 'right': '',
	\ },
\ }

function! NerdTreeToggle()
	if empty(expand("%")) || g:NERDTree.IsOpen()
		:NERDTreeToggle
	else
		:NERDTreeFind
	endif
endfunction

" Use tab for trigger completion with characters ahead and navigate.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
	let col = col('.') - 1
	return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
if exists('*complete_info')
	inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
	imap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

" Use auocmd to force lightline update.
autocmd User CocStatusChange,CocDiagnosticChange call lightline#update()

" COC commands
" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> <leader>g <Plug>(coc-definition)
nmap <silent> <leader>c <Plug>(coc-references)

nmap <silent> <leader><space>g <C-W><C-V> <Plug>(coc-definition)
nmap <silent> <leader><space>c <C-W><C-V> <Plug>(coc-references)

nmap <silent> <leader><space><space>g <C-W><C-S> <Plug>(coc-definition)
nmap <silent> <leader><space><space>c <C-W><C-S> <Plug>(coc-references)

" Use T to show documentation in preview window.
nnoremap <silent> T :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)
" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')
" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call CocAction('fold', <f-args>)
" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR :call CocAction('runCommand', 'editor.action.organizeImport')

" Mappings using CoCList:
" Show all diagnostics.
nnoremap <silent> <space>a :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent> <space>e :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent> <space>c :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent> <space>o :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent> <space>s :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <space>j :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent> <space>p :<C-u>CocListResume<CR>

" FZF commands
nmap <Leader>p :Files<CR>
nmap <leader>b :Buffers<CR>
nmap <leader>w :Windows<CR>
nmap <leader>T :Tags<CR>
nmap <leader>BT :BTags<CR>
nmap <leader>C :Commits<CR>
nmap <leader>BC :BCommits<CR>
nmap <leader>L :Lines<CR>
nmap <leader>BL :BLines<CR>

nmap <F2> :Rg<CR>
nmap <F3> :Rg <C-R>=expand("<cword>")<CR><CR>

" Build ctags index
nmap <F9> :!ctags -R .<CR>

" File exploring toggling
nmap <F10> :call NerdTreeToggle()<CR>

" Build and load custom cscope index
nmap <F12> :call CustomIndex()<CR>
