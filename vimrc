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
Plug 'jreybert/vimagit'

" orgmode plugins
Plug 'preservim/tagbar'
Plug 'tpope/vim-speeddating'		" Allows to modify timestamps
Plug 'vim-scripts/utl.vim'		" Allows to modify urls
Plug 'inkarkat/vim-SyntaxRange'		" Add syntax to code blocks
Plug 'chrisbra/NrrwRgn'			" Narrow the region in order to focus
Plug 'jceb/vim-orgmode'			" Manage notes

Plug 'vimwiki/vimwiki'


Plug 'rhysd/vim-clang-format'


Plug 'vim-utils/vim-ruby-fold'
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
set splitright				" Open new vertical split window right to current window
set splitbelow				" Open new horizontal split window below to current window
set mmp=5000

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
		if exists('*CscopeLoadDB')
			call CscopeLoadDB()
		endif
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

"autocmd VimEnter,ColorScheme * hi! link CocFloating CocHintFloat
"" Use tab for trigger completion with characters ahead and navigate.
"inoremap <silent><expr> <TAB>
"      \ coc#pum#visible() ? coc#pum#next(1):
"      \ CheckBackspace() ? "\<Tab>" :
"      \ coc#refresh()
"inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"
"
"" Make <CR> to accept selected completion item or notify coc.nvim to format
"" <C-g>u breaks current undo, please make your own choice.
"inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
"                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
"
"function! CheckBackspace() abort
"  let col = col('.') - 1
"  return !col || getline('.')[col - 1]  =~# '\s'
"endfunction
"
"" Use <c-space> to trigger completion.
"if has('nvim')
"  inoremap <silent><expr> <c-space> coc#refresh()
"else
"  inoremap <silent><expr> <c-@> coc#refresh()
"endif




set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: There's always complete item selected by default, you may want to enable
" no select by `"suggest.noselect": true` in your configuration file.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice.
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif
















" Use auocmd to force lightline update.
autocmd User CocStatusChange,CocDiagnosticChange call lightline#update()

" COC commands
" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gr <Plug>(coc-references)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)

nmap <silent> g<space>d <C-W><C-V> <Plug>(coc-definition)
nmap <silent> g<space>r <C-W><C-V> <Plug>(coc-references)
nmap <silent> g<space>y <C-W><C-V> <Plug>(coc-type-definition)
nmap <silent> g<space>i <C-W><C-V> <Plug>(coc-implementation)

nmap <silent> g<space><space>d <C-W><C-S> <Plug>(coc-definition)
nmap <silent> g<space><space>r <C-W><C-S> <Plug>(coc-references)
nmap <silent> g<space><space>y <C-W><C-S> <Plug>(coc-type-definition)
nmap <silent> g<space><space>i <C-W><C-S> <Plug>(coc-implementation)


function! s:show_documentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
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


" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Mappings using CoCList:
" Show all diagnostics.
nnoremap <silent> <space>a :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent> <space>e :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent> <space>c :<C-u>CocList commands<cr>
" Find symbol in current document.
nnoremap <silent> <space>o :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent> <space>s :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <space>j :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent> <space>p :<C-u>CocListResume<CR>
" Apply AutoFix to problem on the current line.
nnoremap <silent> <leader>qf  <Plug>(coc-fix-current)
" Use T to show documentation in preview window.
nnoremap <silent> T :call <SID>show_documentation()<CR>

" FZF
let g:fzf_layout = { 'down': '60%' }
" See https://github.com/junegunn/fzf.vim/issues/358#issuecomment-841665170
let $FZF_DEFAULT_OPTS="--preview-window 'right:55%'
	\ --bind ctrl-y:preview-up,ctrl-e:preview-down,
	\ctrl-b:preview-page-up,ctrl-f:preview-page-down,
	\ctrl-u:preview-half-page-up,ctrl-d:preview-half-page-down,ctrl-p:toggle-preview"

" commands
nmap <Leader>p :Files<CR>
nmap <leader>b :Buffers<CR>
nmap <leader>w :Windows<CR>
nmap <leader>T :Tags<CR>
nmap <leader>BT :BTags<CR>
nmap <leader>C :Commits<CR>
nmap <leader>BC :BCommits<CR>
nmap <leader>L :Lines<CR>
nmap <leader>BL :BLines<CR>
nmap <leader>bl :BLines <C-R>=expand("<cword>")<CR><CR>

command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --line-number --hidden --no-heading --color=always --smart-case -- '.shellescape(<q-args>), 1,
  \   fzf#vim#with_preview(), <bang>0)

command! -bang -nargs=* FGrep
	\ call fzf#vim#grep(
	\	'git grep --line-number --no-heading --color=always -- '.shellescape(<q-args>), 0,
	\	fzf#vim#with_preview({'dir': systemlist('git rev-parse --show-toplevel')[0]}), <bang>0)

nmap <F2> :call coc#float#close_all()<CR>
nmap <F3> :Rg<CR>
nmap <F4> :Rg <C-R>=expand("<cword>")<CR><CR>
nmap <F5> :FGrep<CR>
nmap <F6> :FGrep <C-R>=expand("<cword>")<CR><CR>



" Open current year org file
" nmap <F7> :tabe /Volumes/workplace/notes/2022.org<CR>
nmap <F7> ,wt:silent VimwikiAll2HTML<CR>:silent !open /workplace/vimwiki/site_html/index.html<CR>:q<CR>:redraw!<CR>

nmap <F8> :Gvdiffsplit<CR>

" Build ctags index
nmap <F9> :!ctags -R .<CR><CR>

" File exploring toggling
nmap <F10> :call NerdTreeToggle()<CR>

" Build and load custom cscope index
nmap <F12> :call CustomIndex()<CR>

nmap gb :Git blame<CR>
nmap gs :vertical G show<CR>

command! -nargs=1 Rv silent :e scp://Asgard/<args>
nmap <Leader>q :tabe<CR>:Rv /tmp/vim-command.output<CR>

nmap <leader>a qaq:execute "g/" . expand("<cword>"). "/y A"<CR>:tabe<CR>"ap:w!/tmp/vim-command.output<CR>

" Org configuration
let g:org_agenda_files=['/Volumes/workplace/notes/2022.org']
let g:utl_cfg_hdl_scm_http_system = "silent !open -a \"Google Chrome\" '%u'"
let g:org_todo_keywords = [
	\ ['TODO(t)', '|', 'DONE(d)'],
\ ]



filetype plugin on
" need to install https://github.com/WnP/vimwiki_markdown
" css comes from https://raw.githubusercontent.com/markdowncss/retro/master/css/retro.css
" To set style run "pygmentize -S zenburn -f html -a .codehilite > style.css"
" To view available styles run "pygmentize -L style"
let g:vimwiki_list = [{
	\ 'path': '/workplace/vimwiki/src',
	\ 'syntax': 'markdown',
	\ 'path_html': '/workplace/vimwiki/site_html/',
	\ 'custom_wiki2html': 'vimwiki_markdown',
	\ 'template_path': '/workplace/vimwiki/templates/',
	\ 'template_default': 'default',
	\ 'template_ext': '.tpl',
	\ 'auto_tags': 1,
	\ 'auto_generate_tags': 1,
	\ 'ext': '.md'}]
let g:tagquery_ctags_file = '/workplace/vimwiki/.vimwiki_tags'






autocmd VimEnter * highlight link CocSemClass CocSemType
autocmd VimEnter * highlight link CocSemStruct CocSemType
autocmd VimEnter * highlight link CocSemMacro Macro
autocmd VimEnter * highlight link CocSemEnumMember Constant

let g:clang_format#command = '/usr/local/bin/clang-format'
let g:clang_format#detect_style_file = 1
nmap <Leader>F :ClangFormatAutoToggle<CR>


nmap <leader>a qaq:execute "g/" . expand("<cword>"). "/y A"<CR>:tabe<CR>"ap
