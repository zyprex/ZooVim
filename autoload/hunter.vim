" ======================================================================
" File: hunter.vim
" Author: zyprex
" Description: hunter for faster jump search without annoyed highlight
" -- usage --
"  (1) the repeat way is different from original ';' ','
"        ';' always go forward,  ',' always go backward
"  (2) use command toggle default map
"        let g:hunter_max_clue_default = 2
"        com! HunterRun  call hunter#mapAll()
"        com! HunterStop call hunter#unmapAll()
"  (3) or map your own key
"        call hunter#map("sf" , "forward",  "jump_chr_st")
" Last Modified: February 19, 2021
" ======================================================================
if !exists('g:hunter_max_clue_default')
  let g:hunter_max_clue_default=5
endif
let s:last_str=''
let s:last_end=0
func! hunter#forward(type, toend) "{{{ 
  let cline = line('.')
  let ccol  = col('.')
  let str = s:hunterGetStr(a:type, '>')
  if str == ''|return|endif
  let s:last_str = str
  let str = '\C\V'.str
  let npos = matchstrpos(getline('.'),str,ccol)
  if npos[0] == '' "next positon didn't find in current line
    let npos = matchstrpos(getline(cline+1,'$'),str)
  endif
  let cs = a:toend != -1 ? a:toend : s:last_end "char shift to
  let s:last_end = cs "save last to end state
  if len(npos)==3 && npos[0]!=''     "match at current line
    call setpos('.',[0,cline          ,npos[1+cs]-cs+1,-1])
  elseif len(npos)==4 && npos[0]!='' "match at below line
    call setpos('.',[0,cline+npos[1]+1,npos[2+cs]-cs+1,-1])
  else
    return
  endif
endfunc "}}}
func! hunter#backward(type, toend) "{{{
  let cline = line('.')
  let ccol  = col('.')
  let str = s:hunterGetStr(a:type, '<')
  if str == ''|return|endif
  let s:last_str = str
  let str = '\C\V'.str
  let left_chrs = getline('.')[:ccol-2] "exclude char under cursor
  let npos = s:matchstrposLastStr(left_chrs,str)
  if npos[0]=='' || (npos[1] == 0) "a special case
    let above_lines = reverse(getline(1,cline-1))
    let npos = s:matchstrposLast(above_lines,str)
  endif
  "echo npos call getchar()
  let cs = a:toend != -1 ? a:toend : s:last_end "char shift to
  let s:last_end = cs "save last to end state
  if len(npos)==3 && npos[0]!=''     "match at current line
    call setpos('.',[0,cline          ,npos[1+cs]-cs+1,-1])
  elseif len(npos)==4 && npos[0]!='' "match at above line
    call setpos('.',[0,cline-npos[1]-1,npos[2+cs]-cs+1,-1])
  else
    return
  endif
endfunc "}}}
func! s:hunterGetStr(type, direct) "{{{
  echo ''
  return a:type == 2 ? s:hunterGetInput(a:direct) :
       \ a:type == 1 ? nr2char(getchar()) :
       \               s:last_str " a:type == 0
endfunc "}}}
func! s:hunterGetInput(direct) "{{{
  let cline = line('.')
  let ccol  = col('.')
  let pat = '\(\%'.a:direct.ccol.'c\%'.cline.
        \ 'l\|\%'.a:direct.cline.'l\)'
  let str = ''
  let imax = g:hunter_max_clue_default
  let mid  = -1
  while len(str) < imax
    let mid = matchadd('IncSearch','\V'.pat.str)
    redraw
    echo 'hunter ['.len(str).'/'.imax.'] '.str
    let a    = nr2char(getchar())
    if     a=="\<C-M>" |break
    elseif a=="\<ESC>" |break
    elseif a=="\<C-K>" |let imax+=1
    elseif a=="\<C-U>" |let str=''
    elseif a=="\<C-J>" |let imax=imax<0?0:imax-1
    elseif a=="\<C-H>" |let str=str[:-2]
    elseif a==""       |let str=str[:-2]
    else               |let str.=a
    endif
    call matchdelete(mid)
    let mid = -1
  endwhile
  redraw
  echo 'hunter ['.len(str).'/'.imax.'] '.str
  if mid != -1
    call matchdelete(mid)
  endif
  return str
endfunc "}}}
func! s:matchstrposLastStr(str,pat) "{{{
  let ret = []
  let cnt = 1
  let ret = matchstrpos(a:str,a:pat,0,cnt)
  while ret[0]!='' "a match
    let cnt+=1
    let ret = matchstrpos(a:str,a:pat,0,cnt)
  endwhile
  let cnt-=1 "last match
  let ret = matchstrpos(a:str,a:pat,0,cnt)
  return ret
endfunc "}}}
func! s:matchstrposLast(str,pat) "{{{
  let ret = []
  let cnt = 1
  if type(a:str) == v:t_string
    let ret = s:matchstrposLastStr(a:str,a:pat)
  elseif type(a:str) == v:t_list
    let ret = matchstrpos(a:str,a:pat,0,cnt)
    if ret[0]!='' "a match line in list
      let idx   = ret[1]
      let mline = a:str[idx]
      let ret   = s:matchstrposLastStr(mline,a:pat)
      call insert(ret,idx,1) "keep same format
    endif
  endif
  return ret
endfunc "}}}
function! hunter#map(key, dir, code) "{{{
  "'repeat'           :[0,-1],
  "'jump_char_start'  :[1, 0],
  "'jump_char_end'    :[1, 1],
  "'jump_string_start':[2, 0],
  "'jump_string_end'  :[2, 1],
  let l:hunter_group_keymaps_code = {
        \'repeat'     :[0,-1],
        \'jump_chr_st':[1, 0],
        \'jump_chr_ed':[1, 1],
        \'jump_str_st':[2, 0],
        \'jump_str_ed':[2, 1],
        \}
  let code = join(get(l:hunter_group_keymaps_code, a:code),',')
  let key  = a:key
  let dir  = a:dir
  exe printf("onoremap<silent> %s :call hunter#%s(%s)<CR>", key, dir , code)
  exe printf("nnoremap<silent> %s :norm m`<CR>:call hunter#%s(%s)<CR>", key, dir , code)
  exe printf("xnoremap<silent> %s <ESC>:norm m`<CR>:call hunter#%s(%s)\\|norm m>gv<CR>"
        \, key, dir, code)
endfunction "}}}
function! hunter#mapAll() "{{{
  call hunter#map(";" , "forward",  "repeat")
  call hunter#map("ss", "forward",  "jump_str_st")
  call hunter#map("sS", "forward",  "jump_str_ed")
  call hunter#map("f" , "forward",  "jump_chr_st")
  call hunter#map("t" , "forward",  "jump_chr_ed")
  call hunter#map("," , "backward", "repeat")
  call hunter#map("SS", "backward", "jump_str_st")
  call hunter#map("Ss", "backward", "jump_str_ed")
  call hunter#map("F" , "backward", "jump_chr_st")
  call hunter#map("T" , "backward", "jump_chr_ed")
endfunction "}}}
function! hunter#unmapAll() "{{{
  for i in split("; , ss SS sS Ss f F t T")
    exe "unmap ".i
  endfor
endfunction "}}}

" vim:fen:fdm=marker:nowrap:ts=2:fen
