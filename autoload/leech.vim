" ======================================================================
" File: leech.vim
" Author: zyprex
" Description: extract and clip a piece of text from website
" this plugin need 'curl' support!
" -- usage --
" let g:leech_root_tmp_dir=$HOME.'/.cache/leech_files'
" com! -nargs=+ LeechWordNet call leech#wordnet("<args>")
" com! -nargs=+ LeechQuword  call leech#quword("<args>")
" Last Modified: October 03, 2020
" ======================================================================

if !executable("curl")
  finish
endif

if !exists("g:leech_root_tmp_dir")
  let g:leech_root_tmp_dir=$HOME.'/.cache/leech_files'
endif

let s:lch_dict = {
      \ 'wordnet':['wordnet','http://wordnetweb.princeton.edu/perl/webwn?sub=Search+WordNet&o2=1&o0=1&o8=1&o1=1&o7=&o5=&o9=&o6=&o3=&o4=1&h=00000000&s=%s'],
      \ 'quword' :['quword', 'https://www.quword.com/w/%s'],
      \}
let s:curl_param='curl --silent --connect-timeout 10 --output'
let s:query_word=''

"Leech: core
func! s:LeechInit(q) "{{{
  let str = a:q[0]
  let url = a:q[1]
  let s:lch_state={
        \'name'      : str,
        \'url'       : url,
        \'words_dir' : g:leech_root_tmp_dir.'/'.str.'.local',
        \'htmls_dir' : g:leech_root_tmp_dir.'/'.str.'.local/.raw',
        \'fn_output' : 's:'.str.'_output',
        \'fn_parser' : 's:'.str.'_parser',
        \}
endfunc "}}}
func! s:LeechSuck(query_dict,word) "{{{
  if a:word == ''
    return
  endif
  call s:LeechInit(a:query_dict)
  let s:query_word = a:word
  let url          = substitute(s:lch_state.url, '%s', a:word, '')
  let word_file    = s:lch_state.words_dir .'/'. a:word
  if filereadable(word_file) "just use history result
    call call(s:lch_state.fn_output,[word_file])
    return
  endif
  call mkdir(s:lch_state.htmls_dir,"p")
  let html_file = s:lch_state.htmls_dir.'/'.a:word
  if filereadable(html_file) "check download html file
    if call(s:lch_state.fn_parser,[html_file])
      call call(s:lch_state.fn_output,[word_file])
    endif
    return
  endif
  let cmd = join([s:curl_param,html_file,url])
  silent exe '!'.cmd
  if call(s:lch_state.fn_parser,[html_file])
    call call(s:lch_state.fn_output,[word_file])
  endif
endfunc "}}}

"WordNet:
func! s:wordnet_output(file) "{{{
  exe '6sp '.a:file.' |1'
  let w:wordnet_mid  = [matchadd('Underlined', '\<'.s:query_word.'\>', 11)]
  let w:wordnet_mid += [matchadd('Type', "<[a-z.]*>", 10)]
  let w:wordnet_mid += [matchadd('Statement', "[^^](.*)", 10)]
  let w:wordnet_mid += [matchadd('String', '".*"', 10)]
endfunc "}}}
func! s:wordnet_parser(file) "{{{
  let content = readfile(a:file)
  if content == []
    echo 'Your search did not return any results.'
    return 0
  endif
  let start   = match(content, '<div class="key">Display options') "74
  let content = content[start:]
  if start   != 0 "cut garbage html source file to save disk space
    call writefile(content, a:file)
  endif
  if content[0]=='</html>'
    call writefile([], a:file)
    echo 'Your search did not return any results.'
    return 0
  endif
  call map(content,function('s:clear_html_tags'))
  call map(content,function('s:wordnet_format_after'))
  let ret = [ content[0][match(content[0],'"',0,2)+2:] ]
  for i in content[1:]
    if i != ''
      let ret += [i]
    endif
  endfor
  call s:save_result(ret)
  return 1
endfunc "}}}
func! s:wordnet_format_after(idx, val) "{{{
  let s = substitute(a:val, '&lt;', '<', 'g')
  let s = substitute(s    , '&gt;', '>', 'g')
  let s = substitute(s    , 'S: (\a\+)', '', 'g')
  if s[0] == '<'
    let s = '(0)'.s
  endif
  return s
endfunc "}}}
func! leech#wordnet(word) "{{{
  call s:LeechSuck(s:lch_dict.wordnet, a:word)
endfunc "}}}

"Quword:
func! s:quword_output(file) "{{{
  exe '6sp '.a:file.' |1'
  let w:wordnet_mid  = [matchadd('Underlined', '\c\<'.s:query_word.'\>', 11)]
  let w:wordnet_mid += [matchadd('Type', '\C\(CET[468]\|TEM[468]\|IELTS\|GRE\|TOEFL\|考 研\)', 10)]
  let w:wordnet_mid += [matchadd('Statement', '\(使用频率:\|星级词汇:\|记忆方法\|中文词源\|英语词源\|权威例句\)', 10)]
  "let w:wordnet_mid += [matchadd('String', '".*"', 10)]
endfunc "}}}
func! s:quword_parser(file) "{{{
  let content = readfile(a:file)
  if content == []
    echo "对不起，没有查询到该单词"
    return 0
  endif
  let start   = match(content,'yd-content')
  let end     = match(content,'col-sm-4', start)
  let content = content[start:end]
  if start   != 0 "cut garbage html source file to save disk space
    call writefile(content, a:file)
  endif
  call map(content,function('s:quword_format_before'))
  call map(content,function('s:clear_html_tags'))
  call map(content,function('s:quword_format_after'))
  call map(content,'trim(v:val)')
  call filter(content,'v:val != ""')
  "split ^@ and join *
  let content_string = execute('echo join(content,"\n")')
  let content_string = substitute(content_string,'\n\*','*','g')
  let c = split(content_string,"\n")
  if c[-1] == '暂无相关例句'
    call writefile([],a:file)
    echo "对不起，没有查询到该单词"
    return 0
  endif
  call s:save_result(c)
  return 1
endfunc "}}}
func! s:quword_format_after(idx, val) "{{{
  let s = substitute(a:val, '&[lr]aquo;', '', 'g')
  let s = substitute(s    , '1 / \d\+', '', 'g')
  let s = substitute(s    , '\[ '.s:query_word.' 造句 \]', '', 'g')
  return s
endfunc "}}}
func! s:quword_format_before(idx, val) "{{{
  let s = substitute(a:val, '<\/d[dtl]>', "\n", 'g')
  let s = substitute(s    , '<span class="glyphicon glyphicon-star">', '*', 'g')
  return s
endfunc "}}}
func! leech#quword(word) "{{{
  call s:LeechSuck(s:lch_dict.quword, a:word)
endfunc "}}}

"COMMON:
func! s:save_result(val) "{{{
  call writefile( a:val, s:lch_state.words_dir .'/'. s:query_word)
endfunc "}}}
func! s:clear_html_tags(idx, val) "{{{
  return substitute(a:val,'<[^<>]*>','','g')
endfunc "}}}

" vim:fen:fdm=marker:nowrap:ts=2:fen
