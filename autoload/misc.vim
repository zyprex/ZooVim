" ======================================================================
" File: misc.vim
" Author: zyprex
" Description: a collection of function to enhance vim's function
" -- usage --
" "surroundOnion"
" nnoremap - :call  misc#surroundOnion('nd')<CR>
" vnoremap - :call  misc#surroundOnion('vd')<CR>
" nnoremap g+ :call misc#surroundOnion('nW')<CR>
" nnoremap + :call  misc#surroundOnion('nw')<CR>
" vnoremap + :call  misc#surroundOnion('vv')<CR>
" "comment"
" com! -range Comment <line1>,<line2>call misc#comment()
" "for some reason ctrl+/ can't be map, but in terminal it's same as ctrl+_"
" nnoremap<silent> gcc :call misc#comment()<CR>
" "range operation [N]gc comment/uncomment line"
" nnoremap<expr><silent> gc misc#commentRange()
" xnoremap<expr><silent> gc misc#commentRange()
" "indentAt"
" com! -range -nargs=* I call misc#indentAt(<line1>, <line2>, '<args>', ' ')
" "directCd"
" com! DirectCd call misc#directCd()
" "ftconf"
" com! FtConf call misc#ftconf()
" "filedo"
" com! FiledoRename call misc#filedo("rename")
" com! FiledoCopy call misc#filedo("copy")
" com! FiledoDelete call misc#filedo("delete")
" com! FiledoRmdir call misc#filedo("rmdir")
" com! FiledoMkdir call misc#filedo("mkdir")
" "indentRuler"
" com! IndentRuler call misc#indentRuler()
" Last Modified: February 13, 2021
" ======================================================================

"Improved Edit: {{{
"----------------------------------------
" Name: surroundOnion{{{
" Description: surrounds everything
" Requires:
" Type: function nnoremap vnoremap
"----------------------------------------
function! misc#surroundOnion(mode)
  let pairs = {'<':'>','[':']','(':')','{':'}'}
  let PAIRs = {'>':'<',']':'[',')':'(','}':'{'}
  let modmp = {
        \'nd':['norm F'    , 'xf'    , 'x'],
        \'nw':['norm wbi'  , 'ea'  , 'b'],
        \'nW':['norm WBi'  , 'Ea'  , 'B'],
        \'vv':['norm `<i', '`>la', 'gvolol'],
        \'vd':['norm `<hx`>xgvohoh',  '', ''],
        \}
  echo a:mode."..."
  let sym = nr2char(getchar())
  if sym == ''|return|endif
  let rhs = get(pairs, sym, sym)
  let lhs = get(PAIRs, sym, sym)
  if lhs != sym
    let sur = [lhs, sym]
  elseif rhs != sym
    let sur = [sym, rhs]
  else
    let sur = [sym, sym]
  endif
  if modmp[a:mode][1] == ''
    let sur = ['','']
  endif
  exe modmp[a:mode][0] .sur[0]
    \.modmp[a:mode][1] .sur[1] .modmp[a:mode][2]
endfunction
"}}}
"----------------------------------------
" Name: comment{{{
" Description: quick comment
" Requires:
" Type: function command nnoremap xnoremap inoremap
"----------------------------------------
function! misc#comment() "{{{
  let line = getline(".")
  if line =~ '^\s*$' |return |endif
  let indent_space = matchstr(line,'^\s*')
let comstr = {
\'c':'/* */',
\'go':'//',
\'sh':'#',
\'cpp':'//',
\'zsh':'#',
\'vim':'"',
\'lua':'--',
\'css':'/* */',
\'html':'<!-- -->',
\'java':'//',
\'rust':'//',
\'conf':'#',
\'make':'#',
\'ruby':'#',
\'perl':'#',
\'yaml':'#',
\'python':'#',
\'dosini':';',
\'dosbatch':'::',
\'markdown':'<!-- -->',
\'javascript':'//',
\'autohotkey':';',
\}
  if !has_key(comstr,&filetype)
    echo "comment symbol not set for *." . &filetype
    return
  endif
  let com = split(get(comstr, &filetype))
  let lhs = escape(com[0],"/*")
  if len(com) == 1
    if line =~ "^\\s*".lhs." .*"
      let line = substitute(line, "^\\s*".lhs." ", indent_space,"g")
    else
      let line = substitute(line, "^\\s*", indent_space.lhs." ","g")
    endif
  else
    let rhs = escape(com[1],"/*")
    if line =~ "^\\s*".lhs." .* ".rhs
      let line = substitute(line, "^\\s*".lhs." ", indent_space,"g")
      let line = substitute(line, " ".rhs."$", "","g")
    else
      let line = substitute(line, "^\\s*", indent_space.lhs." ","g")
      let line = substitute(line, "$", " ".rhs,"g")
    endif
  endif
  call setline(".", line)
endfunction "}}}
func! misc#commentRange(...) "{{{
  if v:count
    return ":call misc#comment()\<CR>"
  endif
  let &operatorfunc="misc#commentDo"
  return 'g@'
endfunc "}}}
func! misc#commentDo(...) "{{{
  let s = getpos("'[")
  let e = getpos("']")
  exe s[1].','.e[1].'call misc#comment()'
endfunc "}}}
"}}}
"----------------------------------------
" Name:  indentAt {{{
" Description:  indent at given char
" Requires:
" Type: function command
"---------------------------------------
function! misc#indentAt(l1, l2, pat, pad)
  let pat = a:pat == '' ? '=' : a:pat
  let l1  = a:l1     "begin on this line
  let l2  = a:l2     "end on this line
  let st  = col('.') "match start col
  if l1 == l2          "when no range given
    let l2 = line('$') "match as much as possible
  endif
  let maxlen = 0
  let l_list = []
  while (1)
    let line  = getline(l1)
    let [m_str, s_pos, e_pos] = matchstrpos(line, pat, st)
    if m_str == '' || l1 > l2
      break
    endif
    let l1     += 1
    let lh_str  = line[:s_pos-1]
    let rh_str  = line[e_pos:]
    let l_list += [[lh_str, m_str, rh_str]]
    let maxlen  = len(lh_str) > maxlen ? len(lh_str) : maxlen
    "echo [[lh_str, mstr, rh_str]]
  endwhile
  let l1 = a:l1 - 1
  let lines = []
  for i in l_list
    let l1 += 1
    let pad_len = maxlen - len(i[0])
    if pad_len == 0
      continue
    endif
    let pad = ''
    for n in range(pad_len)
      let pad .= a:pad
    endfor
    call setline(l1, join([i[0],pad,i[1],i[2]], ''))
  endfor "exe a:l1','(l2-1).'norm ==' 
endfunction "}}}
"----------------------------------------
" Name: getVisualRegion{{{
" Description: get visually selected text
" Requires:
" Type: function xnoremap
"----------------------------------------
function! misc#getVisualRegion()
  let [line_start, column_start] = getpos("'<")[1:2]
  let [line_end, column_end]     = getpos("'>")[1:2]
  let lines = getline(line_start, line_end)
  if len(lines) == 0 | return '' | endif
  let lines[-1] = lines[-1][: column_end - (&selection == 'inclusive' ? 1 : 2)]
  let lines[0]  = lines[0][column_start - 1:]
  return join(lines, "\n")
endfunction"}}}
"}}}

"Improved File Manager: {{{
"----------------------------------------
" Name: directCd{{{
" Description: go direct to directory
" Requires:
" Type: function command
"----------------------------------------
function! misc#directCd() abort
  let path = getcwd()
  let cnt  = 1
  echon path
  echo ''
  for i in range(len(path))
    if path[i] =~# '[/\\]'
      echon cnt
      let cnt += 1
    else
      echon ' '
    endif
  endfor
  let path_end = matchstrpos(path,'[/\\]',0,nr2char(getchar()))[1]
  call chdir(path[:path_end])
  redraw
  echon path[:path_end]
endfunction "}}}
"----------------------------------------
" Name: ftconf{{{
" Description: go to ftplugin dir
" Requires:
" Type: function command
"----------------------------------------
func! misc#ftconf() abort
  let paths = split(globpath(&rtp,"ftplugin"),"\n")
  for i in range(len(paths))
    echo '#'.i.' '.paths[i]
  endfor
  let path = get(paths,nr2char(getchar()),'.')
  exe 'cd '.path
  redraw
  echo 'cd '.path
endfunc "}}}
"----------------------------------------
" Name:  filedo{{{
" Description: basic file operation
" Requires:
" Type: function
"---------------------------------------
func! misc#filedo(do)
  if a:do == "rename"
    let n=input("new name for [".expand("%")."]:")
    if n!=""
      call rename(expand("%"),n)
      exe "e ".n
    endif
  elseif a:do == "copy"
    let n=input("copy to dir(end with /):","","dir")
    if n!=""
      exe "saveas ".n.expand("%")
      echo "switch to copy file buf"
    endif
  elseif a:do == "delete"
    call delete(expand("%"))
    echohl ErrorMsg
    echo "[".expand("%")."] deleted, rewrite to undo."
    echohl None
  elseif a:do == "rmdir"
    let ret = delete(input('rmdir:','','dir'),'d')
    if ret==-1
      echohl ErrorMsg
      echo "dir '".expand("%")."' delete failed"
      echohl None
    endif
  elseif a:do == "mkdir"
    let n=input("new dir name:")
    call mkdir(n,"p")
    redraw
    echon "mkdir ".n
  endif
endfunc "}}}
"}}}

"Improved Interface: {{{
"----------------------------------------
" Name:  indentRuler{{{
" Description: simple indent line reference
" Requires: +conceal feature
" Type: function
"----------------------------------------
function! misc#indentRuler()
  if exists("s:mcid_list") && s:mcid_list != [] "delete match
    for i in s:mcid_list
      call matchdelete(i)
    endfor
    let s:mcid_list = []
    if has('conceal')|set conceallevel=0|endif
    return
  endif
  let s:mcid_list = [] "store the match_id
  let level = &tabstop
  let deep = 16
  "better with +conceal support
  if has('conceal')
    if &conceallevel == 0|set conceallevel=1|endif "show sign
    for i in range(level,level*deep,level)
      let mcid = matchadd("Conceal",'^\s\{'.i.'\}\zs\s',10,-1,{"conceal":"¦"})
      let s:mcid_list += [mcid]
    endfor
  else
    for i in range(level,level*deep,level)
      let mcid = matchadd( "Conceal", "^\s\{".i."\}\zs\s" )
      let s:mcid_list += [mcid]
    endfor
  endif
endfunction "}}}
"----------------------------------------
" Name:  hlcword{{{
" Description: highlight word under cursor
" Requires:
" Type: function autocmd
"----------------------------------------
" iskeyword
function! misc#hlcword()
  if g:misc__hlcword_enable == 0
    return
  endif
  if getline('.')[col('.')-1] !~ '\k'
    exe 'match none'
    return
  endif
  let syn_group = synIDattr(synIDtrans(synID(line("."), col("."), 1)), "name")
  let hi_group  = ["Statement", "Comment", "Type", "PreProc", "Delimiter" ]
  if (index(hi_group, syn_group) == -1)
    exe printf('match CursorLine /\V\<%s\>/', escape(expand('<cword>'), '/\'))
  else
    exe 'match none'
  endif
endfunction "}}}
"----------------------------------------
" Name:  guiFontSize{{{
" Description: change guifontsize
" Requires:
" Type: function
"---------------------------------------
function! misc#guiFontSize()
  if !has("gui_running") | return | endif
  let gfsize    = matchstr(&guifont     , '\d\+')
  let newgfsize = input("guifont size:" , gfsize)
  if newgfsize != ''
    let &guifont     = substitute(&guifont    , gfsize, newgfsize,"")
    let &guifontwide = substitute(&guifontwide, gfsize, newgfsize,"")
  endif
endfunction "}}}
"----------------------------------------
" Name:  htmlTagConceal "{{{
" Description: hide html tag markdown mark
"        for text readability
" Requires: +conceal
" Type: function
"---------------------------------------
function! misc#htmlTagConceal()
  if !has('conceal')
    return
  endif
  if exists('s:mc_id1')
    call matchdelete(s:mc_id1)
    unlet s:mc_id1
    set conceallevel=0
    return
  endif
  let s:mc_id1 = matchadd('Conceal','<[^<>]*>')
  set conceallevel=2
  set concealcursor=n
endfunction "}}}
"----------------------------------------
" Name: immersiveMode{{{
" Description: switch immersive mode
" Requires:
" Type: function
"----------------------------------------
function! misc#immersiveMode()
  if &laststatus==2 && &showtabline==1
    set ls=0 stal=1 nu nornu ruler
  elseif &laststatus==0 && &showtabline==1
    set ls=0 stal=0 nonu nornu ruler
  elseif &laststatus==0 && &showtabline==0
    set ls=2 stal=1 nu rnu noruler
  endif
endfunction "}}}
"}}}

"Improved Tool: {{{
"----------------------------------------
" Name: cue{{{
" Description: echo group mapkeys hints
" Requires: global var
" var format: [[list],[list]]
"  = [['(k)', '(name)', '(cmd1)','(cmd2)',...]]
" Type: function
"----------------------------------------
function! misc#cue(list, ...)
  let hi1 = get(a:000, 0, "MoreMsg")
  let hi2 = get(a:000, 1, "Include")
  let id_list=[]
  for i in a:list
    exe 'echohl '.hi1.'|echon i[0]|echohl '.hi2.'|echon ":" i[1] " "'
    let id_list+=[i[0]]
  endfor
  echohl None
  let k=nr2char(getchar())
  redraw
  let id = index(id_list,k)
  if id == -1|echo ''|return|endif
  for cmd in a:list[id][2:]
    try
      exe cmd
    catch /^Vim\%((\a\+)\)\=:E/ " catch all Vim errors
      echo v:exception
    endtry
  endfor
endfunction "}}}
"----------------------------------------
" Name:  toggler{{{
" Description:
" Requires:
" Type: function
"---------------------------------------
func! misc#toggler(opt)
  let tog = {
        \"wrap":[],
        \"paste":[],
        \"spell":[],
        \"cul":[],
        \"cuc":[],
        \"acd":[],
        \"so":[99,0],
        \"cole":[1,0],
        \"ve":["all",""],
        \"hitest":["so $VIMRUNTIME/syntax/hitest.vim"],
        \}
  let a = get(tog, a:opt, ["!"])
  if a != ["!"]
    if len(a)==0
      exe "set ".a:opt."!"
      exe "echo &".a:opt
    elseif len(a)==1
      exe a[0]
      echo a[0]
    elseif len(a)==2
      let next = execute("echo &".a:opt)[1:] == a[0] ? a[1] :a[0]
      exe "set ".a:opt."=". next
      echo "set ".a:opt."=". next
    endif
  endif
endfunc "}}}
"----------------------------------------
" Name: autoPages autoPageDo{{{
" Description: auto reader
" Requires:
" Type: function
"----------------------------------------
let g:auto_page_latch=1
function! misc#autoPages(wait_ms)
  if !has("timers") | return | endif
  let g:auto_page_latch=g:auto_page_latch==0?1:0
  set guicursor+=n:hor15-blinkon0
  call timer_start(a:wait_ms, 'im#AutoPageDo',{'repeat':-1})
endfunction
func! misc#autoPageDo(ap_timer_id)
  if g:auto_page_latch==1
    call timer_stop(a:ap_timer_id)
    set guicursor-=n:hor15-blinkon0
    echo "AutoPages Stopped"
  else
    if line('.')==line('$') && col('.')>=col('$')-1
      call timer_stop(a:ap_timer_id)
      let g:auto_page_latch=1
      set guicursor-=n:hor15-blinkon0
      echo "AutoPages Reach EOF!"
    elseif line('.')==line('w$') && col('.')>=col('$')-1 && line('.')!=line('$')
      call feedkeys("zt\<c-e>",'n')
    elseif col('.') >= col('$') -1
      call setpos('.', [0, line('.')+1, 1, 0, 1])
    else
      call setpos('.', [0, line('.'), col('.')+1, 0, 1])
      exec "redraws"
      echo "AutoPages Running..."
    endif
  endif
endfunc "}}}
"----------------------------------------
" Name: reloadPlugin{{{
" Description: reload all plugin
" Requires:
" Type: function
"---------------------------------------
function! misc#reloadPlugin()
  ru! plugin/**/*.vim
  exe "so ".globpath(&rtp,"ftplugin/".&ft."/*")
endfunction "}}}
"----------------------------------------
" Name: baseConv{{{
" Description: convert between
" binary octonary decimal hexadecimal
" Requires:
" Type: function
"----------------------------------------
"10 8 0x78 98 0b10 0x37
function! misc#baseConv(base)
  let save_cursor = getcurpos()
  let cw = expand('<cword>')
  if cw =~? '\X[^0xX]\X' | return | endif   " match regex and ignore case
  let fmc=''
  if     a:base==?'x'|let fmc='#x'
  elseif a:base==?'d'|let fmc='d'
  elseif a:base==?'o'|let fmc='#o'
  elseif a:base==?'b'|let fmc='#010b' |endif
  exec 's/'.cw.'/\=printf("%'.fmc.'",submatch(0))/g'
  call setpos('.', save_cursor)
endfunction "}}}
"}}}

" vim:fen:fdm=marker:nowrap:ts=2:
