" ======================================================================
" File: task.vim
" Author: zyprex
" Description: Run A Task asynchronized
"  you can use '%' '%<' with shell command
" -- usage --
" com! -nargs=+ -complete=shellcmd Task call task#run('<args>')
" com! TaskLog call task#log()
" Last Modified: February 13, 2021
" ======================================================================
let g:task_log = []
func! task#callback(...)
  call setqflist([],'a',{'lines':[a:2]})
endfunc
func! task#exit_cb(...)
  let s:task_exitcode = a:2
endfunc
func! task#close_cb(...) "{{{
  let s:task_tm = reltimefloat(reltime()) - s:task_tm
  let s:qf_title =
        \  join(job_info(g:task_id)['cmd'])
        \. ' | EXIT: '. s:task_exitcode
        \. ' | TIME: '. printf("%.2f",s:task_tm)
  call setqflist([],'a',{'title': s:qf_title})
  let prompt = s:qf_title.' ('.strftime('%T',localtime()).')'
  let g:task_log += [prompt]
  echo strcharpart(prompt, 0, v:echospace)
  exe len(getqflist()) > 0  ? len(getqflist()).'copen' : 'cclose'
endfunc "}}}
func! task#run(cmd) "{{{
  let cmd = a:cmd
  let cmd = substitute(cmd,'%<',escape(expand('%<'),' \'),'g')
  let cmd = substitute(cmd,'%',escape(expand('%:p'),' \'),'g')
  let g:task_id  = job_start(cmd, {
          \ 'callback': 'task#callback',
          \ 'exit_cb' : 'task#exit_cb',
          \ 'close_cb': 'task#close_cb',
          \ 'timeout': 1800*1000,
        \})
  let s:task_tm = reltimefloat(reltime())
  call setqflist([],'r')
endfunc "}}}
func! task#log() "{{{
  for log in g:task_log
    echo log
  endfor
endfunc "}}}

" vim:fen:fdm=marker:nowrap:ts=2:
