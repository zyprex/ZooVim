" ======================================================================
" File: fenrir.vim {{{
" Author: zyprex
" Description: simple incremental search tools (use vim's regex)
" Find and Execute, Run In Real time
" < WARN >: 'set autochdir' may cause unexpected result, use at your own
"  discretion!
" as I known, exists of vim finder plugin are too complicated to extend,
" or heavy dependencies, so I implement my own find tools, this is not
"  support fuzzy find, but really get things done.
" -- usage --
" [ action ] (buffer and input line)
"   ctrl+m / <cr>  execute default handle
"   ctrl+i / <tab> execute another handle (if set)
" [ on input line ]
"   ctrl+[ / <ESC> / ctrl+c    exit
"   ctrl+j / ctrl+k  select line down/up
"   ctrl+n / ctrl+p  recall next/previous input
"   ctrl+h / <BS>    delete one char
"   ctrl+w           delete one word
"   ctrl+u           delete whole line
"   ctrl+]           toggle buffer wrap status
"   ctrl+q           exit but keep buffer
"   ctrl+e           enter line edit mode (bind emacs-like keys)
" [ on buffer ]
"   ctrl-c           back to input line
"
" [recommend configure]
" com! -nargs=* -complete=file Fe call fenrir#Run('<args>')
" com! -nargs=* -complete=buffer FeBuffers call fenrir#Buffers('<args>')
" com! -nargs=* -complete=file FeMRU call fenrir#MRU('<args>')
" com! -nargs=* -complete=file FeLines call fenrir#Lines('<args>')
" com! -nargs=* -complete=color FeColors call fenrir#Colors('<args>')
" com! -nargs=* -complete=command FeCommands call fenrir#Commands('<args>')
" com! -nargs=* -complete=file FeFd call fenrir#Fd('<args>')
" com! -nargs=* -complete=file FeRg call fenrir#Rg('<args>')
" com! -nargs=* -complete=file FeAg call fenrir#Ag('<args>')
" com! -nargs=* -complete=file FeCtags call fenrir#Ctags('<args>')
"
" [required CLI tools]
" fd: used to list files
" rg: ripgrep
" ag: sliver searcher
" universal ctags: index tags
" Last Modified: February 10, 2021 }}}
" ======================================================================

set acd&
let g:fenrir_hist_input = ['']
let s:fe_bname = '>>_Fenrir_>>'
let s:fe_state = {}
let s:fd_cmd = 'fd --type f --max-results=9999'
let s:rg_cmd = 'rg --vimgrep --no-line-buffered'
let s:ag_cmd = 'ag --vimgrep'
let s:ctags_cmd = 'ctags -u -n -f -'

"func! s:(str) "{{{
  "endfunc "}}}
"Fe Render:
func! s:renderPrefixClear() "{{{
  if exists("w:fenrir_rid") && w:fenrir_rid != -1
    call matchdelete(w:fenrir_rid)
    let w:fenrir_rid = -1
  endif
endfunc "}}}
func! s:renderPrefix(rx) "{{{
  let w:fenrir_rid = -1
  if a:rx != ''
    let w:fenrir_rid = matchadd('Comment',a:rx)
  endif
endfunc "}}}
func! s:hlMatchClear() "{{{
  if exists("w:fenrir_mid") && w:fenrir_mid != -1
    call matchdelete(w:fenrir_mid)
    let w:fenrir_mid = -1
  endif
endfunc "}}}
func! s:hlMatch(rx) "{{{
  let w:fenrir_mid = -1
  if a:rx != ''
    let w:fenrir_mid = matchadd('IncSearch', a:rx)
  endif
endfunc "}}}
"Fe Filter:
func! s:filterFd(str) "{{{
    return systemlist(s:fd_cmd.' '.a:str)
endfunc "}}}
func! s:filterRg(str) "{{{
    return systemlist(s:rg_cmd.' '.a:str)
endfunc "}}}
func! s:filterAg(str) "{{{
    return systemlist(s:ag_cmd.' '.a:str)
endfunc "}}}
func! s:filterCtags(str) "{{{
  let hs = copy(s:haystack)
  let needle = get(s:fe_state,"prefix","").a:str
  call filter(hs,'v:val =~# needle')
  return hs
endfunc "}}}
func! s:filterLine(str) "{{{
  let hs = copy(s:haystack)
  let needle = get(s:fe_state,"prefix","").a:str
  call filter(hs,'v:val =~# needle')
  return hs
endfunc "}}}
func! s:filterPath(str) "{{{
  let hs = copy(s:haystack)
  let needle = get(s:fe_state,"prefix","").a:str
  let s:str = a:str
  call sort(filter(hs,'v:val =~# needle'),"s:fnameFirst")
  unlet s:str
  return hs
endfunc "}}}
func! s:fnameFirst(i1,i2) "{{{
  return
  \  match(a:i2,s:str,matchstrpos(a:i2,'[^/\\]\+$')[1])
  \ -match(a:i1,s:str,matchstrpos(a:i1,'[^/\\]\+$')[1])
endfunc "}}}
func! ListBufWords(a,c,p) "{{{
  return join(uniq(sort(split(join(getbufline(bufname('.'),1,line('$'))
        \,"\n"),'\W\+'))),"\n")
endfunc "}}}
"Fe Util:
func! s:drawStatusLine() "{{{
  setl stl=%f\ %{b:fe_state.name}%=%<%{line('$')}N\ %3lL\ 
endfunc "}}}
func! s:opFile() "{{{
  echohl MoreMsg
  echon "[(v)split (s)plit (t)abe (p)edit]"
  echohl None
  let op = get({'v':'vs','s':'sp','t':'tabe','p':'pedit'}
        \,nr2char(getchar()),'')
  return op
endfunc "}}}
func! s:Rg_result_parser(r) "{{{
  let sp1 = match(a:r,':',0,1)
  let sp2 = match(a:r,':',0,2)
  let sp3 = match(a:r,':',0,3)
  let filename = a:r[0    :sp1-1]
  let lnum     = a:r[sp1+1:sp2-1]
  let col      = a:r[sp2+1:sp3-1]
  return [filename, lnum, col]
endfunc "}}}
func! s:keybindInWin(kb) "{{{
  nmapclear<buffer>
  for [k,v] in items(a:kb)
    exe 'nnoremap<buffer><silent> '.k.' :call '.v.'(getline("."))<CR>'
  endfor
  nnoremap<buffer><silent> <C-C> :call fenrir#Run(get(g:fenrir_hist_input,-1,''))<CR>
  return
endfunc "}}}
"Fe MAIN: ->create buffer ->open buffer ->set buffer property
"    ->match content ->fill buffer content ->render result
func! s:saveHist(str) "{{{
  let g:fenrir_hist_input += [a:str]
  call filter(uniq(g:fenrir_hist_input),'v:val != ""')
endfunc "}}}
func! s:bufFill(str) "{{{
  silent %d _
  call s:renderPrefixClear()
  let p = get(s:fe_state,"prefix","")
  if match(p,'%>') != -1
    call s:renderPrefix( substitute(p,">","<","") )
  else
    call s:renderPrefix(p)
  endif
  if a:str == ''
    call s:hlMatchClear()
    call setbufline(s:fe_bname,1,s:haystack)
  else
    if match(p,'%>') != -1
      call s:hlMatch(p.a:str)
    else
      call s:hlMatch(a:str)
    endif
    let lines = call(s:fe_state.filter,[a:str])
    call setbufline(s:fe_bname,1,lines)
  endif
endfunc "}}}
func! s:FenrirSeek(query) "{{{
  let str = a:query
  let cpos = getcurpos()
  let hlen = len(g:fenrir_hist_input)
  let hmax = hlen
  while (1)
    call s:bufFill(str)
    call setpos('.', cpos)
    call s:drawStatusLine()
    redraw
    echohl Identifier|echon '·>'|echohl None|echon str
    let c = nr2char(getchar())
    if c=="\<C-[>" || c=="\<Esc>" || c=="\<C-C>"
      call s:saveHist(str)
      exe bufwinnr(s:fe_bname) 'close'
      break
    elseif c=="\<C-M>" || c=="\<Tab>"
      call s:saveHist(str)
      let line = getline('.')
      exe bufwinnr(s:fe_bname) 'close'
      call call(get(s:fe_state.kbCmd,c,''),[line])
      break
    elseif c=="\<C-H>" || c=="" |let str=str[:-2]
    elseif c=="\<C-K>"|let cpos=getcurpos()|let cpos[1]-=1
    elseif c=="\<C-J>"|let cpos=getcurpos()|let cpos[1]+=1
    elseif c=="\<C-W>"|let str=str[:match(str,'\s*\S\+\s*$')-1]
    elseif c=="\<C-U>"|let str=''
    elseif c=="\<C-]>"|setl wrap!
    elseif c=="\<C-E>"|redraw
      cnoremap<buffer> <C-A> <Home>
      cnoremap<buffer> <C-B> <Left>
      cnoremap<buffer> <C-D> <Del>
      cnoremap<buffer> <C-E> <End>
      cnoremap<buffer> <C-F> <Right>
      echohl Constant
      let str=input(":>",str,"custom,ListBufWords")
      echohl None
      cmapclear<buffer>
    elseif c=="\<C-P>"
      let hlen -= 1
      let str = get(g:fenrir_hist_input,abs(hlen%hmax),'')
    elseif c=="\<C-N>"
      let hlen += 1
      let str = get(g:fenrir_hist_input, hlen%hmax,'')
    elseif c=="\<C-Q>"
      call s:saveHist(str)
      call s:keybindInWin(s:fe_state.kbWin)
      return
    else
      let str .= c
    endif
    call s:hlMatchClear()
    call s:renderPrefixClear()
  endwhile
endfunc "}}}
func! fenrir#Run(...) "{{{
  if s:fe_state == {}
    return
  endif
  if !bufexists(s:fe_bname)
    let bufnr = bufadd(s:fe_bname)
    call bufload(bufnr)
  endif
  let bwn = bufwinnr(s:fe_bname)
  if bwn != -1
    exe bwn "wincmd w"
  elseif bufname('%') != s:fe_bname
    set splitbelow
    exe "sb " s:fe_bname
    resize 10
    set nosplitbelow
    setl cul bh=hide bt=nofile
  endif
  silent %d _
  call setbufline(s:fe_bname,1,s:haystack)
  let b:fe_state = s:fe_state
  call s:FenrirSeek(join(a:000))
endfunc "}}}

"Buffers:  ->match:path ->prefix:bufnr ->handle:buf_in buf_out buf_a
func! fenrir#Buffers(...) "{{{
  let prefix_len = len(bufnr('$'))
  let prefix = '\%>'.(prefix_len+3).'c'
  let s:haystack = []
  for buf in getbufinfo()
    let bufname = buf.name
    let pre = printf('<%0'.prefix_len.'d> ', buf.bufnr)
    let s:haystack += [pre.bufname]
  endfor
  let s:fe_state = {
        \"name":"buffers",
        \"prefix":prefix,
        \"filter":"s:filterPath",
        \"kbCmd": {
          \"\<C-M>":"fenrir#buf_in",
          \"\<Tab>":"fenrir#buf_a",
          \},
        \"kbWin": {
            \"<C-M>":"fenrir#buf_out",
            \"<Tab>":"fenrir#buf_a",
          \},
        \}
  call fenrir#Run(join(a:000))
endfunc "}}}
"MRU:      ->match:path                ->handle:file_in file_out file_a
func! fenrir#MRU(...) "{{{
  let s:haystack = []
  for i in range(0, len(v:oldfiles)-1)
    if getfsize(expand(v:oldfiles[i])) > 0
      let s:haystack += [v:oldfiles[i]]
    endif
  endfor
  let s:fe_state = {
        \"name":"MRU",
        \"filter":"s:filterPath",
        \"kbCmd": {
          \"\<C-M>":"fenrir#file_in",
          \"\<Tab>":"fenrir#file_a",
          \},
        \"kbWin": {
            \"<C-M>":"fenrir#file_out",
            \"<Tab>":"fenrir#file_a",
          \},
        \}
  call fenrir#Run(join(a:000))
endfunc "}}}
"Lines:    ->match:line ->prefix:lnum  ->handle:line_jmp line_jmp_out line_mod
func! fenrir#Lines(...) "{{{
  let prefix_len = len(line('$'))
  let prefix = '\%>'.(prefix_len+3).'c'
  let s:haystack = []
  for i in range(1,line('$'))
    let pre = printf("|%".prefix_len."s|",i)
    let s:haystack += [pre . getline(i)]
  endfor
  let s:fe_state = {
        \"name":"Lines",
        \"prefix":prefix,
        \"filter":"s:filterLine",
        \"kbCmd": {
          \"\<C-M>":"fenrir#line_jmp"
          \},
        \"kbWin": {
            \"<C-M>":"fenrir#line_jmp_out",
            \"<Tab>":"fenrir#line_mod"
          \},
        \}
  call fenrir#Run(join(a:000))
endfunc "}}}
"Colors:   ->match:line                ->handle:color_set
func! fenrir#Colors(...) "{{{
  let pat = '[^/\\]\+$'
  let s:haystack = map(globpath(&rtp,'colors/*.vim',0,1)
      \ ,'matchstr(v:val,pat)[:-5]')
  let s:fe_state = {
        \"name":"Colors",
        \"filter":"s:filterLine",
        \"kbCmd": {
          \"\<C-M>":"fenrir#color_set"
          \},
        \"kbWin": {
            \"<C-M>":"fenrir#color_set"
          \},
        \}
  call fenrir#Run(join(a:000))
endfunc "}}}
"Commands: ->match:line ->prefix:args  ->handle:cmd_exe cmd_exe_out
func! fenrir#Commands(...) "{{{
  let s:haystack = []
  for i in split(execute('com'),'\n')[1:]
    let list = split(i)
    if list[0][0] =~ '\(!\||\)'
      let s:haystack += ['('.list[2].') '.list[1]]
    else
      let s:haystack += ['('.list[1].') '.list[0]]
    endif
  endfor
  let s:fe_state = {
        \"name":"Commands",
        \"prefix":'\%>4c',
        \"filter":"s:filterLine",
        \"kbCmd": {
          \"\<C-M>":"fenrir#cmd_exe"
          \},
        \"kbWin": {
            \"<C-M>":"fenrir#cmd_exe_out"
          \},
        \}
  call fenrir#Run(join(a:000))
endfunc "}}}
"Ex_fd:    ->match:Fd                ->handle:file_in file_out file_a
func! fenrir#Fd(...) "{{{
  let s:haystack = systemlist(s:fd_cmd.' '.join(a:000))
  let s:fe_state = {
        \"name":"Fd",
        \"filter":"s:filterFd",
        \"kbCmd": {
          \"\<C-M>":"fenrir#file_in",
          \"\<Tab>":"fenrir#file_a",
          \},
        \"kbWin": {
            \"<C-M>":"fenrir#file_in_out",
            \"\<Tab>":"fenrir#file_a",
          \},
        \}
  call fenrir#Run(join(a:000))
endfunc "}}}
"Ex_rg:    ->match:Rg             ->handle:grep_in grep_out grep_a
func! fenrir#Rg(...) "{{{
  let s:haystack = systemlist(s:rg_cmd.' '.join(a:000))
  let s:fe_state = {
        \"name":"Rg",
        \"prefix":'^.*\d\+:\d\+:',
        \"filter":"s:filterRg",
        \"kbCmd": {
          \"\<C-M>":"fenrir#grep_in",
          \"\<Tab>":"fenrir#grep_a",
          \},
        \"kbWin": {
          \"<C-M>":"fenrir#grep_out",
          \"<Tab>":"fenrir#grep_a",
          \},
        \}
  call fenrir#Run(join(a:000))
endfunc "}}}
"Ex_ag:    ->match:Ag             ->handle:grep_in grep_out grep_a
func! fenrir#Ag(...) "{{{
  let s:haystack = systemlist(s:ag_cmd.' '.join(a:000))
  let s:fe_state = {
        \"name":"Ag",
        \"prefix":'^.*\d\+:\d\+:',
        \"filter":"s:filterAg",
        \"kbCmd": {
          \"\<C-M>":"fenrir#grep_in",
          \"\<Tab>":"fenrir#grep_a",
          \},
        \"kbWin": {
          \"<C-M>":"fenrir#grep_out",
          \"<Tab>":"fenrir#grep_a",
          \},
        \}
  call fenrir#Run(join(a:000))
endfunc "}}}
"Ex_ctags: ->match:Ctags          ->handle:tags_in tags_out tags_a
func! fenrir#Ctags(...) "{{{
  let s:haystack = systemlist(s:ctags_cmd.' '.join(a:000))
  let s:fe_state = {
        \"name":"Ctags",
        \"filter":"s:filterCtags",
        \"kbCmd": {
          \"\<C-M>":"fenrir#tags_in",
          \"\<Tab>":"fenrir#tags_a",
          \},
        \"kbWin": {
          \"<C-M>":"fenrir#tags_out",
          \"<Tab>":"fenrir#tags_a",
          \},
        \}
  call fenrir#Run(join(a:000))
endfunc "}}}

"Handle:
func! fenrir#buf_out(line) "{{{
  wincmd p
  call s:hlMatchClear()
  exe 'b '.matchstr(a:line, '\d\+')
endfunc "}}}
func! fenrir#buf_in(line) "{{{
  exe 'b '.matchstr(a:line, '\d\+')
endfunc "}}}
func! fenrir#buf_a(line) "{{{
  let bn = matchstr(a:line,'\d\+')
  echohl MoreMsg
  echon "[(s)buffer (v)buffer (t)ab]"
  echohl None
  let op = get({'s':'sb','v':'vert sb','t':'tab sb'}
        \,nr2char(getchar()),'')
  if op != ''
    redraw|exe op.' '.bn|echo op.' '.bn
  endif
endfunc "}}}
func! fenrir#file_out(line) "{{{
  wincmd p
  call s:hlMatchClear()
  exe 'e '.a:line
endfunc "}}}
func! fenrir#file_in(line) "{{{
  exe 'e '.a:line
endfunc "}}}
func! fenrir#file_a(line) "{{{
  let op = s:opFile()
  if op != ''
    redraw|exe op.' '.a:line|echo op.' '.a:line
  endif
endfunc "}}}
func! fenrir#line_jmp_out(line) "{{{
  wincmd p
  call s:hlMatchClear()
  call fenrir#line_jmp(a:line)
endfunc "}}}
func! fenrir#line_jmp(line) "{{{
  let lnum = matchstr(a:line, '\d\+')
  let start = match(a:line,'|',1)
  let col = match(a:line,s:fe_state.prefix.g:fenrir_hist_input[-1]) - start
  call setpos('.', [0, lnum, col,0])
endfunc "}}}
func! fenrir#line_mod(line) "{{{
  let lnum = matchstr(a:line, '\d\+')
  let start = match(a:line,'|',1)
  call setbufline(bufname('#'),lnum,a:line[start+1:])
  echo 'change in line '.lnum
endfunc "}}}
func! fenrir#color_set(line) "{{{
  exe 'colo ' a:line
endfunc "}}}
func! fenrir#cmd_exe_out(line) "{{{
  wincmd p
  call s:hlMatchClear()
  call fenrir#cmd_exe(a:line)
endfunc "}}}
func! fenrir#cmd_exe(line) "{{{
  let cmd = a:line[4:]
  if a:line[1]=='0'
    exe cmd
  else
    call feedkeys(":".cmd." ")
  endif
endfunc "}}}
func! fenrir#grep_out(line) "{{{
  wincmd p
  call s:hlMatchClear()
  call fenrir#grep_in(a:line)
endfunc "}}}
func! fenrir#grep_in(line) "{{{
  let pos = s:Rg_result_parser(a:line)
  silent exe 'e '.pos[0]
  silent call cursor(pos[1],pos[2])
endfunc "}}}
func! fenrir#grep_a(line) "{{{
  let op = s:opFile()
  if op != ''
    let pos = s:Rg_result_parser(a:line)
    redraw|exe op.' '.pos[0]|echo op.' '.pos[0]
    silent call cursor(pos[1],pos[2])
  endif
endfunc "}}}
func! fenrir#tags_out(line) "{{{
  wincmd p
  call fenrir#tags_in(a:line)
endfunc "}}}
func! fenrir#tags_in(line) "{{{
  let sec = split(a:line,"\t")
  let lnum = sec[2][:-3]
  exe 'e +'.lnum.' '.sec[1]
  call cursor(lnum,match(getline('.'),sec[0])+1)
endfunc "}}}
func! fenrir#tags_a(line) "{{{
  let op = s:opFile()
  if op != ''
    let sec = split(a:line,"\t")
    let lnum = sec[2][:-3]
    redraw|exe op.' +'.lnum.' '.sec[1]|echo op.' +'.lnum.' '.sec[1]
    call cursor(lnum,match(getline('.'),sec[0])+1)
  endif
endfunc "}}}

" vim:fen:fdm=marker:nowrap:ts=2:
