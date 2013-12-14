" GrepTasks.vim: Grep for tasks and TODO markers.
"
" DEPENDENCIES:
"   - ingo/msg.vim autoload script
"
" Copyright: (C) 2012-2013 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS
"   1.01.006	24-Jul-2013	FIX: Use the rules for the /pattern/ separator
"				as stated in :help E146.
"   1.01.005	14-Jun-2013	Use ingo/msg.vim.
"   1.00.004	27-Aug-2012	To avoid that spaces in the optional pattern
"				have to be escaped, do not first split off the
"				firstArgument, but do a (mostly-correct) parsing
"				for the /pattern/ on the entire arguments.
"   1.00.003	26-Aug-2012	Don't use <f-args> and don't expand /
"				fnameescape the file globs; as <q-args>, they
"				are passed in in unescaped form; we just need to
"				extract the optional /pattern/ first argument
"				and unescape it. However, there's a Vim bug (in
"				7.3 at least) that mistakenly unescapes # and %.
"   1.00.002	25-Aug-2012	FIX: Pattern delimiters must be identical
"				characters; otherwise, stuff like \# is
"				interpreted as an (empty) pattern.
"				FIX: Must pass _all_ (joined) arguments, not
"				just a:0.
"	001	25-Aug-2012	file creation; split off autoload script

function! GrepTasks#Grep( count, grepCommand, pattern, ... )
    let l:pattern = printf(g:GrepTasks_PatternTemplate, a:pattern)
    try
	execute (a:count ? a:count : '') . a:grepCommand '/' . escape(l:pattern, '/') . '/' . g:GrepTasks_GrepFlags a:0 ? a:1 : ''
    catch /^Vim\%((\a\+)\)\=:E/
	call ingo#msg#VimExceptionMsg()
    endtry
endfunction

function! GrepTasks#FileGrep( count, grepCommand, arguments )
    let [l:pattern, l:fileglobs] = ['', a:arguments]

    let l:optionalPatternMatch = matchlist(a:arguments, '^\([[:alnum:]\\"|]\@![\x00-\xFF]\)\(.\{-}\)\%(\%(^\|[^\\]\)\%(\\\\\)*\\\)\@<!\1\%(\%(^\|[^\\]\)\%(\\\\\)*\\\)\@<! \(.*\)$')
    if ! empty(l:optionalPatternMatch)
	let [l:pattern, l:fileglobs] = l:optionalPatternMatch[2:3]

	" Unescape the regexp delimiter.
	let l:pattern = substitute(l:pattern, '\%(\%(^\|[^\\]\)\%(\\\\\)*\\\)\@<!\\' . l:optionalPatternMatch[1], l:optionalPatternMatch[1], 'g')
    endif

    call GrepTasks#Grep(a:count, a:grepCommand, l:pattern, l:fileglobs)
endfunction

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
