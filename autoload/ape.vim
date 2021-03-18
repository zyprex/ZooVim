" ======================================================================
" File: ape.vim
" Author: zyprex
" Description: Auto Pop menu & ins-complete Enhanced for native vim
" -- usage --
" [optional configure]
"  let g:ape_pop_char=2
" aug ApeDefWay
"   au!
"   au! BufEnter *.md let b:ape_compl_ways = ["\<C-P>","\<C-X>s"]
" aug END
" [recommend configure]
" inoremap <expr> <Tab>   ape#do(0)
" inoremap <expr> <S-Tab> ape#do(1)
" com! ApeEnablePop call ape#enablePopMenu(1)
" com! ApeDisablePop call ape#enablePopMenu(0)
" aug ApePopMenu
"   au!
"   au CursorHoldI * call ape#popMenu()
" aug END
" Last Modified: March 04, 2021
" ======================================================================
set complete=.,w,b,u,t,i,k,s,d
set completeopt=menuone,noinsert,noselect,popup
if has('popupwin')
  set completepopup=highlight:Pmenu,align:menu,border:off
endif
let s:ape_compl_ways = [
      \ "\<C-P>",
      \ "\<C-X>\<C-L>",
      \ "\<C-X>\<C-V>",
      \ "\<C-X>\<C-F>",
      \ "\<C-X>\<C-O>",
      \ "\<C-X>\<C-U>",
      \ "\<C-X>s",
      \]
"APE_TAB:
func! ape#do(rev) "{{{
  let m =  getline('.')[:col('.')-1]
  if m =~ '^\s*$'
    return "\<Tab>"
  endif
  return "\<C-G>\<C-Y>".s:nextWay(m,a:rev)
endfunc "}}}
func! s:nextWay(m,rev) "{{{
  let s:ways = get(b:,"ape_compl_ways",s:ape_compl_ways)
  call s:ignoreWay(glob(matchstr(a:m,'\S\+$')."*"), "\<C-X>\<C-F>")
  call s:ignoreWay(&spell,"\<C-X>s")
  call s:ignoreWay(&omnifunc,"\<C-X>\<C-O>")
  call s:ignoreWay(&completefunc,"\<C-X>\<C-U>")
  let idx = index(s:ways, get(b:,"ape_this_ways",""))
  let idx = s:calcIdx(len(s:ways),idx,a:rev)
  let b:ape_this_ways = s:ways[idx]
  echo b:ape_this_ways
  return b:ape_this_ways
endfunc "}}}
func! s:calcIdx(len,i,rev) "{{{
  let i = a:i
  if a:rev == 0
    let i = (i+1) % a:len
  else
    let i -= 1
    if i < 0
      let i = a:len - 1
    endif
  endif
  return i
endfunc "}}}
func! s:ignoreWay(cond,way) "{{{
  if empty(a:cond)
    call filter(s:ways,'v:val !~ a:way')
  endif
endfunc "}}}

"APE_POP_MENU:
func! ape#popMenu() "{{{
  if pumvisible() || col('.') == 1
    return
  endif
  if match(getline('.')[:col('.')-2]
        \, get(b:,"ape_pop_cond_regx", '\k\{2}$')) != -1
    call feedkeys(get(b:,'ape_this_ways',"\<C-P>"),'n')
  endif
endfunc "}}}
func! ape#enablePopMenu(en) "{{{
  if a:en==1
    aug ApePopMenu
      au!
      au CursorHoldI * call ape#popMenu()
    aug END
  elseif a:en==0
    aug ApePopMenu | au! | aug END
  endif
endfunc "}}}
"APE_COMP_FUNC:
func! s:shorten(str,maxlen) "{{{
  if len(a:str) > a:maxlen
    return strcharpart(a:str, 0, a:maxlen-1).'…'
  endif
  return a:str
endfunc "}}}
func! ape#completeTags(findstart, base) "{{{
  if a:findstart != 0
    let line = getline('.')
    let start = col('.') - 1
    while start > 0 && line[start - 1] =~ '\k'
      let start -= 1
    endwhile
    return start
  else
    let tlist = taglist('^'.a:base, expand('%:p'))
    for tag_item in tlist
      let m_item = {
            \ 'word' : tag_item['name'],
            \ 'kind' : tag_item['kind'],
            \ 'icase': 1,
            \}
      let m_item.abbr = s:shorten(tag_item.name, 20)
      let tmenu = get(tag_item, 'type','').get(tag_item, 'typeref','')
      if tmenu != ''
        let m_item.menu = s:shorten(substitute(tmenu,'^typename:','',''), 20)
      endif
      let m_item.info = trim(tag_item['cmd'][2:-3])
      if complete_add(m_item) == 0
        return []
      endif
      if complete_check()
        return []
      endif
    endfor
  endif
  return []
endfunc "}}}
" vim:fen:fdm=marker:nowrap:ts=2:
