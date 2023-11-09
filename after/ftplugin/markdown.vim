command! -bang -nargs=* VimWikiRg
	\ call fzf#vim#grep(
	\ 'rg --line-number --no-heading --color=always --type md --smart-case -- ' . shellescape(<q-args>) . ' /workplace/vimwiki/src',
	\ 1,
	\ fzf#vim#with_preview(),
	\ <bang>0)

noremap <leader>t :VimWikiRg :[\-a-zA-Z0-9]+:<CR>
set spell
