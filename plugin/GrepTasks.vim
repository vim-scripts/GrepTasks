" GrepTasks.vim: Grep for tasks and TODO markers.
"
" DEPENDENCIES:
"   - GrepTasks.vim autoload script
"   - GrepHere plugin for :GrepHere command
"   - GrepCommands plugin for :ArgGrep, :BufGrep, :WinGrep, :TabGrep commands
"
" Copyright: (C) 2012 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS
"   1.00.005	26-Aug-2012	Use <q-args>; due to its escaping, <f-args> is
"				fundamentally flawed for use with arbitrary
"				filespecs.
"   1.00.004	25-Aug-2012	Change g:GrepTasks_JumpToFirst to more general
"				g:GrepTasks_GrepFlags.
"	003	04-May-2012	Rename :GrepTasks to :VimGrepTasks to make it
"				clear which syntax for {file} is used.
"	002	20-Mar-2012	Support optional /{pattern}/ for :GrepTasks.
"	001	19-Mar-2012	file creation

" Avoid installing twice or when in unsupported Vim version.
if exists('g:loaded_GrepTasks') || (v:version < 700)
    finish
endif
let g:loaded_GrepTasks = 1

"- configuration ---------------------------------------------------------------

if ! exists('g:GrepTasks_PatternTemplate')
    let g:GrepTasks_PatternTemplate =  '\C\<\%(FIXME\|TODO\|XXX\)\>:\?.*\&.*%s'
endif
if ! exists('g:GrepTasks_GrepFlags')
    let g:GrepTasks_GrepFlags = 'gj'
endif


"- commands --------------------------------------------------------------------

command! -bang -count -nargs=? -complete=expression GrepHereTasks call GrepTasks#Grep(<count>, 'GrepHere', <q-args>)
command! -bang -count -nargs=? -complete=expression ArgGrepTasks  call GrepTasks#Grep(<count>, 'ArgGrep', <q-args>)
command! -bang -count -nargs=? -complete=expression BufGrepTasks  call GrepTasks#Grep(<count>, 'BufGrep', <q-args>)
command! -bang -count -nargs=? -complete=expression WinGrepTasks  call GrepTasks#Grep(<count>, 'WinGrep', <q-args>)
command! -bang -count -nargs=? -complete=expression TabGrepTasks  call GrepTasks#Grep(<count>, 'TabGrep', <q-args>)
command! -bang -count -nargs=+ -complete=file       VimGrepTasks  call GrepTasks#FileGrep(<count>, 'vimgrep', <q-args>)

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
