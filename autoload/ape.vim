" ======================================================================
" File: ape.vim
" Author: zyprex
" Description:  Autocompletion Enhanced for native vim's
"  complete-functions. Notice that all functions are optional, combined
"  them as you like.
"  -- usage --
" [recommend configure]
" "use tab to switch to next ins-complete method
" inoremap<expr> <Tab> ape#do()
" com! ApeEnable call ape#enable(1)
" com! ApeDisable call ape#enable(0)
" let g:ape_min_trig = 2
" let g:ape_chains = {
"       \"vim":['vcmd','prev','c-p','file','line'],
"       \}
" "use `autocmd` set default method in buffer, for example:
" aug ApeDefaultMethod
"   au!
"   au FileType vim let b:ape_default_method='vcmd'
" aug END
" aug ApeFtSrc
"   au!
"   au FileType * setl completefunc=ape#compl | call ape#find_src('dict')
"   \| call ape#find_src('thes')
" aug END
" Last Modified: February 15, 2021
" ======================================================================

"{{{
set complete=.,w,b,u,t,i,k,s,d
if &completeopt !~ "noinsert"
  set completeopt+=noinsert
endif
if &completeopt !~ "noselect"
  set completeopt+=noselect
endif
if &completeopt !~ "menuone"
  set completeopt+=menuone
endif
if has('popupwin')
  if &completeopt !~ "popup"
    set completeopt+=popup
    set completepopup=highlight:Pmenu,align:menu,border:off
  endif
endif
let s:ape_default_chain = [ 'c-p', 'line']
let s:ape_alias_map = {
      \ 'c-n': {'key':"\<C-N>",'name':'^n next match'},
      \ 'c-p': {'key':"\<C-P>",'name':'^p prev match'},
      \ 'next': {'key':"\<C-X>\<C-N>",'name':'^x^n next keyword'},
      \ 'prev': {'key':"\<C-X>\<C-P>",'name':'^x^p prev keyword'},
      \ 'incl': {'key':"\<C-X>\<C-I>",'name':'^x^i include'},
      \ 'defi': {'key':"\<C-X>\<C-D>",'name':'^x^d definition'},
      \ 'line': {'key':"\<C-X>\<C-L>",'name':'^x^l whole line'},
      \ 'dict': {'key':"\<C-X>\<C-K>",'name':'^x^k dictionary'},
      \ 'thes': {'key':"\<C-X>\<C-T>",'name':'^x^t thesaurus'},
      \ 'file': {'key':"\<C-X>\<C-F>",'name':'^x^f file path'},
      \ 'tags': {'key':"\<C-X>\<C-]>",'name':'^x^] tags'},
      \ 'vcmd': {'key':"\<C-X>\<C-V>",'name':'^x^v cmdline'},
      \ 'omni': {'key':"\<C-X>\<C-O>",'name':'^x^o omni'},
      \ 'user': {'key':"\<C-X>\<C-U>",'name':'^x^u user'},
      \ 'spel': {'key':"\<C-X>s",'name':'^xs spell'},
      \}
if !exists('g:ape_min_trig')
  let g:ape_min_trig = 2
endif
if exists('b:ape_default_method')
  let mkey = b:ape_default_method
  let b:ape_name = s:ape_alias_map[mkey].name
  let b:ape_key = s:ape_alias_map[mkey].key
endif
"}}}
func! ape#enable(en) "{{{
  if a:en==1
    aug ApeDo
      au!
      "show complete infor
      au CompleteChanged * call ape#doing()
      "auto popup complete menu
      au CursorHoldI * call ape#feedkey()
    aug END
  elseif a:en==0
    aug ApeDo | au! | aug END
  endif
endfunc "}}}
func! ape#do() "{{{
  if getline('.')[:col('.')-1]=~'^\s*$'
    return "\<Tab>"
  endif
  let b:ape_chain = get(get(g:,'ape_chains',{}),&ft,s:ape_default_chain)
  if len(b:ape_chain)==0
    echo ''
    return ''
  endif
  let b:ape_idx = get(b:,'ape_idx',len(b:ape_chain)-1)
  let idx = ( b:ape_idx + 1 ) % len(b:ape_chain)
  let b:ape_idx = idx
  let mkey = b:ape_chain[idx]
  let b:ape_name = s:ape_alias_map[mkey].name
  let b:ape_key = s:ape_alias_map[mkey].key
  echohl ErrorMsg
  echo b:ape_name.' no match!'
  echohl none
  return "\<C-G>\<C-Y>".b:ape_key
endfunc "}}}
func! ape#doing() "{{{
  echohl MoreMsg
  echo get(b:,'ape_name','^p default')." ".len(complete_info().items)
  echohl none
endfunc "}}}
func! ape#feedkey() "{{{
  if pumvisible()
    return
  endif
  if match(getline('.')[:col('.')-2]
        \,'\w\{'.g:ape_min_trig.',}$') !=-1
    call feedkeys(get(b:,'ape_key',"\<C-P>"),'n')
  endif
endfunc "}}}

func! ape#compl(findstart,base) "{{{
  if a:findstart != 0
    "locate the start of the word
    let line = getline('.')
    let start = col('.') - 1
    while start>0 && line[start-1]=~'\S'
      let start -= 1
    endwhile
    return start
  else
    if !exists('b:ape_feed_list')
      call ape#find_src('compl')
    endif
    return filter(copy(b:ape_feed_list), "v:val.word =~? '^'.a:base ")
  endif
endfunc "}}}
func! ape#find_src(type) "{{{
  let ape_src = get(g:,'ape_src_dir','~/.vim/_ape')
  " ~/.vim/ape/dict/
  " ~/.vim/ape/thes/
  " ~/.vim/ape/coml/ , also see complete-items
  if a:type == 'compl'
    let path = [ape_src.'/compl/'.&ft.'.compl', ape_src.'/compl/_.compl']
    let b:ape_feed_list = []
    for i in path
      let b:ape_feed_list += s:ape_feed(expand(i))
    endfor
  elseif a:type == 'dict'
    let path = [ape_src.'/dict/'.&ft.'.dict']
    exe 'setl dictionary+=' join(path,',')
  elseif a:type == 'thes'
    let path = [ape_src.'/thes/'.&ft.'.thes']
    exe 'setl thesaurus+=' join(path,',')
  endif
endfunc "}}}
func! s:ape_feed(src) "{{{
  if !filereadable(a:src)
    return []
  endif
  let line = readfile(a:src)
  let dlist = []
  for i in line[1:]
    let list = split(i,"\t")
    let dict = {}
    let dkey = split(line[0],"\t")
    for i in range(len(dkey))
      let dval = get(list,i,"")
      if dval!=""
        let dict[dkey[i]] = dval
      endif
    endfor
    if dict != {}
      let dlist += [dict]
    endif
  endfor
  return dlist
endfunc "}}}

" vim:fen:fdm=marker:nowrap:ts=2:
