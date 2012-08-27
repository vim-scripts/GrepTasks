" GrepTasks.vim: Grep for tasks and TODO markers.
"
" DEPENDENCIES:
"
" Copyright: (C) 2012 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS
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
	" v:exception contains what is normally in v:errmsg, but with extra
	" exception source info prepended, which we cut away.
	let v:errmsg = substitute(v:exception, '^Vim\%((\a\+)\)\=:', '', '')
	echohl ErrorMsg
	echomsg v:errmsg
	echohl None
    endtry
endfunction

function! GrepTasks#FileGrep( count, grepCommand, arguments )
    let [l:pattern, l:fileglobs] = ['', a:arguments]

    let l:optionalPatternMatch = matchlist(a:arguments, '^\(\i\@!\S\)\(.\{-}\)\%(\%(^\|[^\\]\)\%(\\\\\)*\\\)\@<!\1\%(\%(^\|[^\\]\)\%(\\\\\)*\\\)\@<! \(.*\)$')
    if ! empty(l:optionalPatternMatch)
	let [l:pattern, l:fileglobs] = l:optionalPatternMatch[2:3]

	" Unescape the regexp delimiter.
	let l:pattern = substitute(l:pattern, '\%(\%(^\|[^\\]\)\%(\\\\\)*\\\)\@<!\\' . l:optionalPatternMatch[1], l:optionalPatternMatch[1], 'g')
    endif

    call GrepTasks#Grep(a:count, a:grepCommand, l:pattern, l:fileglobs)
endfunction

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
