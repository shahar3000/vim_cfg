" Give more space for displaying messages.
setlocal cmdheight=2

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
setlocal updatetime=300

" Don't pass messages to |ins-completion-menu|.
setlocal shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
setlocal signcolumn=yes


