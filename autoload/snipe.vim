" ======================================================================
" File: snipe.vim
" Author: zyprex
" Description: my code snippet engine
" -- usage --
"  [ include other snipe ]
"  write first line '>> a.lib.snipe' , this will read file `a.lib.snip`
"  , mutiple files split in space, if you don't want this function,
"  keep the first line blank.
"  [ placeholder ]
"  start with '@' end with ';', the '@;' may not work fine in some
"  occasion, I encourage you to use '@ ;'. if you want to literal '@', ';'
"  , use '\' to escape them.
"  placeholder will be moved when you triger a snippet expand.
"  [ eval vim expression ]
"  use '@=<expression>;' to yield '@<result>;'
"  e.g. before '@=echo 123;' after '@123;'
"  [ recommend configure ]
" let g:snipe_dir = '~/.vim/_snipe'
" inoremap<silent> <C-E> :call snipe#fly()<CR>
" inoremap<silent> <C-D> :call snipe#Forward()<CR>
" inoremap<silent> <C-S> :call snipe#Backward()<CR>
" snoremap<silent> <C-D> :call snipe#Forward()<CR>
" snoremap<silent> <C-S> :call snipe#Backward()<CR>
" xnoremap<silent> <C-D> :call snipe#Forward()<CR>
" xnoremap<silent> <C-S> :call snipe#Backward()<CR>
" com! Snipe call snipe#open()
" com! -nargs=+ -complete=custom,snipe#list SnipeLoad call snipe#load('<args>')
"  \| echo g:snipe_import
" com! SnipeReset let g:snipe_import = []
" Last Modified: February 17, 2021
" ======================================================================
if !exists('g:snipe_dir')
  let g:snipe_dir = '~/.vim/_snipe'
endif
let g:snipe_import = []
let s:inl = 0
let s:keyword = ''
let s:partA = ''
let s:partB = ''
let s:anchor_mode = 'gh'
"Trigger: -> getWD
func! s:getWD() "{{{
  let line = getline('.')
  let start = col('.') - 1
  let mat = matchstrpos(line[:start],'\S\+$')
  if mat[1] == 0
    "start of line
    let s:partA = ''
  else
    let s:partA = line[:mat[1]-1]
  endif
  let s:partB = line[mat[2]:]
  "echo mat[0] . line[:mat[1]-1] . line[mat[2]:]
  return mat[0]
endfunc "}}}
"Processor:
func! s:checkDir() "{{{
  let dir = expand(g:snipe_dir)
  if !isdirectory(dir)
    let c = confirm("Can't find dir `".g:snipe_dir."`, create it ?","&YES\n&NO")
    if c == 1
      call mkdir(dir,"p")
    endif
    return 1
  endif
  return 0
endfunc "}}}
func! s:checkFile() "{{{
  let file = &filetype.'.snipe'
  let path = expand(g:snipe_dir).'/'.file
  if !filereadable(path)
    let c = confirm("Can't find file `".file."`, create it ?","&YES\n&NO")
    if c == 1
      exe 'sp '.path
    endif
    return 1
  endif
  return 0
endfunc "}}}
func! s:readRaw() "{{{
  let list = []
  let file = &filetype.'.snipe'
  let dir = expand(g:snipe_dir)
  let path = dir.'/'.file
  let list += readfile(path)
  if list[0][0:1] == ">>"
    for i in split(list[0])[1:]
      let list += readfile(dir.'/'.i)
    endfor
  endif
  if exists('g:snipe_import') && g:snipe_import != []
    for f in g:snipe_import
      let list += readfile(dir.'/'.f.'.snipe')
    endfor
  endif
  return list
endfunc "}}}
func! s:readSnip() "{{{
  if s:checkDir()|return []|endif
  if s:checkFile()|return []|endif
  let list = s:readRaw()
  let body = []
  for i in range(1,len(list)-1)
    if list[i-1] == '' && list[i] != ''
    \  && match(split(list[i]),'\V\^'.s:keyword.'\$') != -1
      let ln = i
      while ln<len(list)-1 && list[ln] != ''
        let ln += 1
        let body += [list[ln]]
      endwhile
      return body[:-2]
    endif
  endfor
  return []
endfunc "}}}
func! s:expRet(exp) "{{{
  return a:exp[0] == '!' ? system(a:exp[1:])[:-2] : execute(a:exp,"")[1:]
endfunc "}}}
func! s:evalString(k,v) "{{{
  let string = a:v
  let cnt  = 0
  let p1 = -1
  let p2 = -1
  while(1)
    let p1 = match(string,'@=',p1+1)
    let p2 = match(string,';',p2+1)
    if p1 == -1 || p2 == -1
      break
    endif
    let exp = string[p1+2:p2-1]
    let str = s:expRet(exp)
    let string = string[:p1] . str . string[p2:]
  endwhile
  return string
endfunc "}}}
func! s:evalSnip() "{{{
  return map(s:body,function('s:evalString'))
endfunc "}}}
func! s:clrAnchor(k,v) "{{{
  let str = ' '.a:v
  let p1 = -1
  let p2 = -1
  let p1 = match(str,'@',p1+1)
  let p2 = match(str,';',p2+1)
  while p1 != -1 && p2 != -1
    let str = str[:p1-1] . str[p1+1:p2-1] . str[p2+1:]
    let p1 = match(str,'@',p1+1)
    let p2 = match(str,';',p2+1)
  endwhile
  "beign of line shift
  return str[1:]
endfunc "}}}
func! s:genJmpList() "{{{
  let tmp = copy(s:body)
  let p1 = -1
  let p2 = -1
  let base = line('.')
  let b:snipe_jmp_list = []
  for i in range(len(tmp))
    let str = tmp[i]
    let p1 = match(str,'@',p1+1)
    let p2 = match(str,';',p2+1)
    let cnt = 0
    while p1 != -1 && p2 != -1
      let lnum = base + i
      "when has escaped char before placeholder
      "we should use `s:countEscape` to rectified
      "the column
      let col = p1 - cnt*2 - s:countEscape(str[:p1-1])
      let len = p2-p1-2
      let b:snipe_jmp_list += [[lnum,col,len]]
      let p1 = match(str,'@',p1+1)
      let p2 = match(str,';',p2+1)
      let cnt += 1
    endwhile
  endfor
  call map(s:body,function('s:clrAnchor'))
endfunc "}}}
func! s:countEscape(str) "{{{
  let str = a:str
  let c = 0
  let m = match(str,'\(¬\|®\)',0)
  while m != -1
    let c += 1
    let m = match(str,'\(¬\|®\)',m+1)
  endwhile
  return c/2
endfunc "}}}
func! s:convertEscape() "{{{
   call map(s:body,"substitute(v:val,'\\\\@','®','g')")
   call map(s:body, "substitute(v:val,'\\\\;','¬','g')")
endfunc "}}}
func! s:revertEscape() "{{{
   call map(s:body,"substitute(v:val,'®','\\@','g')")
   call map(s:body, "substitute(v:val,'¬',';','g')")
endfunc "}}}
"Executor:
func! s:forwardAdjust(pos) "{{{
  let diffcol = col('$') - b:snipe_line_len
  "if b:snipe_jmp_list[a:pos][2] <= -1 return endif
  let b:snipe_jmp_list[a:pos][2] += diffcol
  let cur = b:snipe_jmp_list[a:pos]
  for i in range(a:pos,len(b:snipe_jmp_list)-1)
    let next = b:snipe_jmp_list[i]
    if next[0] != cur[0]
      break
    endif
    if i > a:pos
      let b:snipe_jmp_list[i][1] += diffcol
    endif
  endfor
endfunc "}}}
func! s:backwardAdjust(pos) "{{{
  let diffcol = col('$') - b:snipe_line_len
  "if b:snipe_jmp_list[a:pos][2] <= -1 return endif
  let b:snipe_jmp_list[a:pos][2] += diffcol
endfunc "}}}
func! s:placeholderJmp(pos) "{{{
  "echo b:snipe_jmp_list[a:pos]
  let b:snipe_jmp_pos = a:pos
  let jlist = b:snipe_jmp_list[a:pos]
  call cursor(jlist[0],jlist[1]==0?1:jlist[1])
  if jlist[1] == 0
    "start of line
    call feedkeys("\<ESC>".s:anchor_mode,'n')
  else
    call feedkeys("\<ESC>l".s:anchor_mode,'n')
  endif
  if jlist[2] <= -1
    call feedkeys("\<ESC>i",'n')
    return
  endif
  for i in range(jlist[2])
    call feedkeys("\<right>",'n')
  endfor
  let b:snipe_line_len = col('$')
endfunc "}}}
func! s:expand(body) "{{{
   let sni = copy(a:body)
   let spc = '^\s\+$'
   if len(a:body) > 1
     if s:partA == ''
       "do nothing
     elseif s:partA !~# '^\s\+$'
       let sni = insert(sni,s:partA)
       for i in range(len(b:snipe_jmp_list))
         let b:snipe_jmp_list[i][0] += 1
       endfor
     elseif s:partA =~# '^\s\+$'
       call map(sni,'s:partA . v:val')
       for i in range(len(b:snipe_jmp_list))
         let b:snipe_jmp_list[i][1] += len(s:partA)
       endfor
     endif
     if s:partB == ''
       "do nothing
     elseif s:partB !~# '^\s\+$'
       let sni += [s:partB]
     endif
    call setline(line('.'), sni[0])
    call append(line('.') , sni[1:])
   else
     if s:partA != ''
       for i in range(len(b:snipe_jmp_list))
         let b:snipe_jmp_list[i][1] += len(s:partA)
       endfor
     endif
     let sni = [s:partA] + sni + [s:partB]
     call setline(line('.'), join(sni,""))
   endif
  if b:snipe_jmp_list == []
    return
  endif
  let b:snipe_jmp_pos = 0
  let b:snipe_line_len = col('$')
  call s:placeholderJmp(b:snipe_jmp_pos)
endfunc "}}}
"Terminator:
func! snipe#open() "{{{
  if s:checkDir() |return|endif
  if s:checkFile()|return|endif
  exe 'sp '.expand(g:snipe_dir).'/'.&ft.'.snipe'
endfunc "}}}
func! snipe#Forward() "{{{
  if !exists('b:snipe_jmp_list')
    return
  endif
  if b:snipe_jmp_list == []
    return
  endif
  call s:forwardAdjust(b:snipe_jmp_pos)
  let b:snipe_jmp_pos += 1
  call s:placeholderJmp(b:snipe_jmp_pos % len(b:snipe_jmp_list))
endfunc "}}}
func! snipe#Backward() "{{{
  if !exists('b:snipe_jmp_list')
    return
  endif
  if b:snipe_jmp_list == []
    return
  endif
  call s:backwardAdjust(b:snipe_jmp_pos)
  let b:snipe_jmp_pos -= 1
  if b:snipe_jmp_pos < 0
    let b:snipe_jmp_pos = len(b:snipe_jmp_list) -1
  endif
  call s:placeholderJmp(b:snipe_jmp_pos)
endfunc "}}}
func! snipe#fly() "{{{
  let s:keyword = s:getWD()
  let s:body = s:readSnip()
  if s:body == []
    call feedkeys('a')
    return
  endif
  call s:convertEscape()
  " echo s:body call getchar()
  call s:evalSnip()
  " echo s:body call getchar()
  call s:genJmpList()
  " echo b:snipe_jmp_list call getchar()
  call s:revertEscape()
  " echo s:body call getchar()
  call s:expand(s:body)
endfunc "}}}
func! snipe#load(args) "{{{
  let g:snipe_import += split(a:args)
endfunc "}}}
func! snipe#list(A,L,P) "{{{
  let dir = expand(g:snipe_dir)
  return join(map(glob(dir."/*.snipe",0,1),'v:val[len(dir)+1:-7]'),"\n")
endfunc "}}}
" vim:fen:fdm=marker:tw=85:nowrap:ts=2:
