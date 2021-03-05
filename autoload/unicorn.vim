" ======================================================================
" File: unicorn.vim
" Author: zyprex
" Description: show output content in ephemeral buffer
" Last Modified: February 18, 2021
" ======================================================================
" key       | val              | mean
" fn_out    | [type,fn,[args]] | type=fun,cmd,sys
" range     | [L1,L2]          | cut range L1 to L2
" filter    | fnref            | filter items
" map       | fnref            | replace in all items
" sort      | fnref            | sort order
" matchlist | [[hl,where]]     | match keywords
" ex_pre    | [cmd]            | execute cmd before buffer open
" ex_end    | [cmd]            | execute cmd after buffer open
" fn_pre    | [fnref]          | execute func before buffer open
" fn_end    | [fnref]          | execute func after buffer open

" com! -nargs=1 -complete=command UCmd call unicorn#cmd('<args>')
" com! UgitStatus call unicorn#git('status')
" com! UgitReflog call unicorn#git('reflog')
" com! UgitDiff call unicorn#git('diff', 'set ft=diff')
" com! UgitBranch call unicorn#git('branch --all')
" com! UgitGraph call unicorn#git('log --all --graph --abbrev-commit --pretty=format:"%h %s <%an %ce> [%cr] %d"')
" com! UgitLog call unicorn#git('log')
" com! UFileList  call unicorn#filelist()
" com! -nargs=1 UWebclipQuword call unicorn#webclip('quword', '<args>')
" com! -nargs=1 UWebclipWordnet call unicorn#webclip('wordnet', '<args>')

let s:uni_bname = '<<-unicorn->>'
let s:meat = []
let s:no_out = 1
"UNICORN: core
func! s:getcmdout(fno) "{{{
  if a:fno[0] == 'fun'
    let s:meat = call(a:fno[1],get(a:fno,2,[]))
  elseif a:fno[0] == 'cmd'
    let s:meat = split(execute(a:fno[1]),"\n")
  elseif a:fno[0] == 'sys'
    let s:meat = systemlist(a:fno[1][1:])
  endif
endfunc "}}}
func! s:cutRange(n) "{{{
  if len(a:n) == 1
    if a:n[0] > 0
      let s:meat = s:meat[ a:n[0] : ]
    elseif a:n[0] < 0
      let s:meat = s:meat[ : a:n[0] ]
    endif
  elseif len(a:n) == 2
    let s:meat = s:meat[ a:n[0] : a:n[1] ]
  endif
endfunc "}}}
func! s:openBuffer(op) "{{{
  " function <SNR>34_openBuffer(op)
  if !bufexists(s:uni_bname)
    let bufnr = bufadd(s:uni_bname)
    call bufload(bufnr)
  endif
  let bwn = bufwinnr(s:uni_bname)
  if bwn != -1
    exe bwn "wincmd w"
  elseif bufname('%') != s:uni_bname
    try
      exe a:op.' '.s:uni_bname
    catch /.*/
      echo v:exception
      return
    endtry
  endif
  silent setl bufhidden buftype=nofile ft=
endfunc "}}}
func! s:renderMatch(mats) "{{{
  for m in a:mats
    call matchadd(m[0],m[1])
  endfor
endfunc "}}}
func! s:setcmdout() "{{{
  silent %d _
  let s:no_out = 0
  call setline(1,s:meat[0])
  call append(1,s:meat[1:])
endfunc "}}}
func! s:unicornRun(state) "{{{
  let st = a:state
  call s:getcmdout(get(st,'fn_out'))
  let cut = get(st,'range',[])
  if cut!=[]
    call s:cutRange(cut)
  endif
  let filterFn = get(st,'filter','')
  if filterFn!=''
    call filter(s:meat,function(filterFn))
  endif
  let mapFn = get(st,'map','')
  if mapFn!=''
    call map(s:meat, function(mapFn))
  endif
  let sortFn = get(st,'sort','')
  if sortFn!=''
    call sort(s:meat, sortFn)
  endif
  if s:meat == []
    let s:no_out = 1
    return
  endif
  let ex_pre = get(st,'ex_pre',[])
  if ex_pre!=[]
    exe join(ex_pre,'|')
  endif
  let fn_pre = get(st,'fn_pre',[])
  if fn_pre!=[]
    for fn in fn_pre
      call call(fn,[])
    endfor
  endif
  call s:openBuffer(get(st,'open','sb'))
  mapclear <buffer>
  call clearmatches()
  let matches = get(st,'matchlist',[])
  if matches != []
    call s:renderMatch(matches)
  endif
  call s:setcmdout()
  let ex_end = get(st,'ex_end',[])
  if ex_end!=[]
    exe join(ex_end,'|')
  endif
  let fn_end = get(st,'fn_end',[])
  if fn_end!=[]
    for fn in fn_end
      call call(fn,[])
    endfor
  endif
endfunc "}}}

"UNICORN: cmd
let s:cmd_out = {'fn_out':['cmd','']}
func! unicorn#cmd(cmd) "{{{
  let cmd = s:cmd_out
  if a:cmd[0] == '!'
    let cmd.fn_out[0] = 'sys'
  endif
  let cmd.fn_out[1] = a:cmd
  call s:unicornRun(cmd)
endfunc "}}}
"UNICORN: git
let s:git_out = {
      \'fn_out':['sys',''],
      \'ex_end':['set ft=gitlog','resize 20']
      \}
func! unicorn#git(subcmd,...) "{{{
  let gitcmd = s:git_out
  let gitcmd.fn_out[1] = '!git '.a:subcmd
  call s:unicornRun(gitcmd)
  if s:no_out == 0 && a:0 > 0
    exe join(a:000,'|')
  endif
endfunc "}}}

"UNICORN: file
" ++ file list handle function ++ {{{
func! s:dirFirst(i1, i2)
  return isdirectory(a:i2) - isdirectory(a:i1)
endfunc
func! s:dirSlash(k, v)
  return isdirectory(a:v) ? a:v.'/' : a:v
endfunc
func! s:refreshFlist()
  let s:meat = sort(map(readdir('.'),function('s:dirSlash')),'s:dirFirst')
endfunc
func! s:flistKeymaps()
  nnoremap<buffer> <LeftRelease> :call unicorn#filelistEnter()<cr>
  nnoremap<buffer> <CR> :call unicorn#filelistEnter()<cr>
  nnoremap<buffer> <BS> :call unicorn#filelistUp()<cr>
endfunc
"}}}
func! unicorn#filelistUp() "{{{
  cd ..
  call s:refreshFlist()
  call s:setcmdout()
  pwd
endfunc "}}}
func! unicorn#filelistEnter() "{{{
  let fnam = getline('.')
  if fnam[-1:] == '/'
    if isdirectory(fnam)
      let dir = getcwd().'/'.fnam
    else
      call mkdir(fnam,"p")
      let dir = getcwd().'/'.fnam
      echon '[new] '
    endif
    exe 'cd '.dir
    call s:refreshFlist()
    call s:setcmdout()
    echon dir
  else
    let op_dict = {'e':'wincmd p|e ','v':'vsplit','s':'split','t':'tabe','p':'pedit',}
    echohl MoreMsg
    echon "[(e)dit (v)split (s)plit (t)ab (p)review]:"
    echohl None
    let op = get(op_dict, nr2char(getchar()),'')
    redraw
    if op!=''
      exe op.' '.fnam
    endif
  endif
endfunc "}}}
let s:file_out = {
      \ 'fn_out':['fun','readdir',['.']],
      \ 'open':'vert sb',
      \ 'ex_pre':['set splitright'],
      \ 'fn_pre':['s:refreshFlist'],
      \ 'ex_end':['set nosplitright nowrap ft=flist','vert resize 30'],
      \ 'fn_end':['s:flistKeymaps'],
      \}
func! unicorn#filelist() "{{{
  call s:unicornRun(s:file_out)
endfunc "}}}

"UNICORN: webclip
func! s:convSpecChar(idx, val) "{{{
  "https://www.w3.org/TR/html4/charset.html
  let v = a:val
  "character entity reference
  let cer = { '&amp;'  :'\&', '&nbsp;' :' ',
        \'&bull;' :'•', '&middot;' :'·',
        \'&quot;' :'"', '&apos;' :"'",
        \'&lt;'   :'<', '&gt;'   :'>',
        \'&lsquo;':'‘', '&rsquo;':'’',
        \'&ldquo;':'“', '&rdquo;':'”',
        \'&laquo;':'«', '&raquo;':'»',
        \'&mdash;':'—', '&ndash;':'–',
        \'&hellip;':'…',
        \}
  for [key,val] in items(cer)
    let v = substitute(v, key, val, 'g')
  endfor
  "numeric character reference &#\d\{3,4};
  let ncr = matchstrpos(v , '&#\d\{1,4};')
  while ncr[0] != ''
    let pos = ncr[1]
    let ch  = nr2char(ncr[0][2:-2])
    if ch == '&' |let ch = '\&'| endif
    let v   = substitute(v ,ncr[0] ,ch , 'g')
    let ncr = matchstrpos(v, '&#\d\{1,4};', pos+1)
  endwhile
  let ncr = matchstrpos(v , '&#x\x\{1,4};')
  while ncr[0] != ''
    let pos = ncr[1]
    let ch  = nr2char('0'.ncr[0][2:-2])
    if ch == '&' |let ch = '\&'| endif
    let v   = substitute(v ,ncr[0] ,ch , 'g')
    let ncr = matchstrpos(v, '&#x\x\{1,4};', pos+1)
  endwhile
  let v = substitute(v, '<!\[CDATA\[',' ','g')
  let v = substitute(v, '\]\]>'      ,' ','g')
  return v
endfunc "}}}
func! s:purifyContent()
  call filter(s:meat,'v:val!=""')
  call map(s:meat,function("s:convSpecChar"))
endfunc
func! s:clearHtmlTags(k, v) "{{{
  let ret = trim(substitute(a:v ,'<[^<>]*>','','g'))
  let ret = substitute(ret,'\s\{4,}',' ','g')
  return ret
endfunc "}}}
let s:webclip_cmd = 'curl --silent'
let s:webclip_url = {
      \ 'quword': {'url':'https://www.quword.com/w/%s','range':[202],},
      \ 'wordnet':{'url':'http://wordnetweb.princeton.edu/perl/webwn?sub=Search+WordNet&o2=1&o0=1&o8=1&o1=1&o7=&o5=&o9=&o6=&o3=&o4=1&h=00000000&s=%s','range':[74]},
      \}
let s:webclip_out = {
      \ 'fn_out':['sys',''],
      \ 'ex_end': ['resize 15'],
      \ 'open': 'sb',
      \ 'map': 's:clearHtmlTags',
      \ 'fn_pre': ['s:purifyContent'],
      \}
func! unicorn#webclip(which,query) "{{{
  let webclip = s:webclip_out
  let webclip.matchlist = [['Keyword','\<'.a:query.'\>']]
  let cmd = s:webclip_cmd . ' "' . substitute(s:webclip_url[a:which].url,'%s',a:query,'').'"'
  let range = get(s:webclip_url[a:which],'range',[])
  if range!=[]
    let webclip.range = range
  endif
  let webclip.fn_out[1] = cmd
  call s:unicornRun(webclip)
endfunc "}}}
" vim:fen:fdm=marker:nowrap:ts=2:
