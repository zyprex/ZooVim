" ======================================================================
" File: bar.vim
" Author: zyprex
" Description: versatile status line
" -- usage --
" (1) highlight should be put after the 'syntax enable' and 'color' command
"       call bar#Highlight()
"       call bar#HighlightNC()
" (2) use "%!" expression
"       aug BAR
"         au!
"         au BufEnter * setl stl=%!bar#StatusLine(\'ac\')
"         au BufLeave * setl stl=%!bar#StatusLine(\'nc\')
"         au FileType qf setl stl=%!bar#StatusLine(\'ac\')
"       aug END
" Last Modified: February 09, 2021
" ======================================================================
set noshowmode
" define var -- bar widget{{{
let s:BAR = [
      \{'name':'git_branch_name',
      \ 'ac':['BARblue' ,'bar#GitBranchName()'],
      \ 'nc':['BARNblue','bar#GitBranchName()'],
      \},
      \{'name':'mode',
      \ 'ac':['BARDynamic' ,'bar#Mode()'],
      \ 'nc':['StatusLineNC' ,'printf(" ")'],
      \},
      \{'name':'buffer_number',
      \ 'ac':['','bar#Bufnr()'],
      \ 'nc':['','bar#Bufnr()'],
      \},
      \{'name':'truncate','ac':['','%<'], 'nc':['','%<'],},
      \{'name':'file_name',
      \ 'ac':['',' %f '],
      \ 'nc':['',' %f '],
      \},
      \{'name':'modified_flag',
      \ 'ac':['BARred' ,'&mod?"[+]":&ma?"":"[-]"'],
      \ 'nc':['BARNred','&mod?"[+]":&ma?"":"[-]"'],
      \},
      \{'name':'readonly_flag',
      \ 'ac':['BARyellow' ,'&ro?"[RO]":""'],
      \ 'nc':['BARNyellow','&ro?"[RO]":""'],
      \},
      \{'name':'qf_title',
      \ 'ac':['','bar#QFTitle()'],
      \ 'nc':['','bar#QFTitle()'],
      \},
      \{'name':'file_info',
      \ 'ac':['BARgreen' ,'bar#FileInfo()'],
      \ 'nc':['BARNgreen','bar#FileInfo()'],
      \},
      \{'name':'file_size',
      \ 'ac':['BARgreen' ,'bar#FileSize()'],
      \ 'nc':['BARNgreen','bar#FileSize()'],
      \},
      \{'name':'truncate','ac':['','%<'], 'nc':['','%<'],},
      \{'name':'protocol',
      \ 'ac':['BARcyan' ,'bar#ShowProtocol()'],
      \ 'nc':['BARNcyan','bar#ShowProtocol()'],
      \},
      \{'name':'sp','ac':['','%='],'nc':['','%='],},
      \{'name':'extra_status',
      \ 'ac':['BARpurple' ,'bar#ExtraState()'],
      \ 'nc':['BARNpurple','bar#ExtraState()'],
      \},
      \{'name':'file_encoding',
      \ 'ac':['','&fenc=="utf-8"?"":toupper(&fenc)." "'],
      \ 'nc':['','&fenc=="utf-8"?"":toupper(&fenc)." "'],
      \},
      \{'name':'bom',
      \ 'ac':['','&bomb?" BOM ":""'],
      \ 'nc':['','&bomb?" BOM ":""'],
      \},
      \{'name':'previewwindow',
      \ 'ac':['','&pvw?" [Prev] ":""'],
      \ 'nc':['','&pvw?" [Prev] ":""'],
      \},
      \{'name':'file_type',
      \ 'ac':['','&ft!="help"?&ft:" "'],
      \ 'nc':['','&ft!="help"?&ft:" "'],
      \},
      \{'name':'line_percent',
      \ 'ac':['','bar#LinePercent()','4'],
      \ 'nc':['','bar#LinePercent()','4'],
      \},
      \{'name':'line_col',
      \ 'ac':['','%5l:%-2v'],
      \ 'nc':['','%5l:%-2v'],
      \},
      \{'name':'file_format',
      \ 'ac':['','col(".")==col("$")-1?&ff=="dos"?"\r\n":&ff=="unix"?"\n":"\r":"  "'],
      \ 'nc':['','col(".")==col("$")-1?&ff=="dos"?"\r\n":&ff=="unix"?"\n":"\r":"  "'],
      \},
      \]
"}}}
" define var -- mode map{{{
let s:modemap = {
      \'n'  : ['N'  , ['','']],
      \'niI': ['N'  , ['','']],
      \'niR': ['N'  , ['','']],
      \'niV': ['N'  , ['','']],
      \'v'  : ['V'  , ['cyan','cyan']],
      \'V'  : ['V-L', ['cyan','cyan']],
      \'' : ['V-B', ['cyan','cyan']],
      \'s'  : ['S'  , ['blue','blue']],
      \'S'  : ['S-L', ['blue','blue']],
      \'' : ['S-B', ['blue','blue']],
      \'i'  : ['I'  , ['green','green']],
      \'ic' : ['I-C', ['green','green']],
      \'ix' : ['I-X', ['green','green']],
      \'R'  : ['R'  , ['red','red']],
      \'Rc' : ['R'  , ['red','red']],
      \'Rv' : ['R'  , ['red','red']],
      \'Rx' : ['R'  , ['red','red']],
      \'c'  : ['C'  , ['yellow','yellow']],
      \'cv' : ['C'  , ['yellow','yellow']],
      \'ce' : ['C'  , ['yellow','yellow']],
      \'t'  : ['T'  , ['magenta','magenta']],
      \}
"}}}

func! bar#QFTitle() "{{{
  let qf_title = getqflist({'title':1})['title']
  if qf_title == ':setqflist()'
    let qf_title = ''
  endif
  return &ft == 'qf' ? qf_title : ''
endfunc "}}}
function! bar#StatusLine(active) "{{{
  let state = ''
  for i in s:BAR
    let state .= s:BARJoin(i,a:active)
  endfor
  return state
endfunction "}}}
func! s:BARJoin(dict,key) "{{{
  let color  = get(a:dict[a:key],0,'')
  let func   = get(a:dict[a:key],1,'')
  let format = get(a:dict[a:key],2,'')
  let ret    = ''
  if func !~ '%[<=a-zA-Z-0-9]'
    let ret = '%'.format.'{'.func.'}'
  else
    let ret = func
  endif
  if color != ''
    let ret = '%#'.color.'#'.ret.'%*'
  endif
  return ret
endfunc "}}}
func! bar#Highlight() "{{{
  hi! BARblue   ctermfg=Black ctermbg=Blue     guifg=Black guibg=#005FFF
  hi! BARred    ctermfg=Black ctermbg=Red      guifg=Black guibg=#FF5F00
  hi! BARgreen  ctermfg=Black ctermbg=Green    guifg=Black guibg=#00A700
  hi! BARyellow ctermfg=Black ctermbg=Yellow   guifg=Black guibg=#D7D700
  hi! BARpurple ctermfg=Black ctermbg=Magenta  guifg=Black guibg=#9c27b0
  hi! BARcyan   ctermfg=White ctermbg=Darkcyan guifg=White guibg=#007777
endfunc "}}}
func! bar#HighlightNC() "{{{
  hi BARNred    ctermfg=Black ctermbg=DarkRed      guifg=Black guibg=#8D0000
  hi BARNblue   ctermfg=Black ctermbg=DarkBlue     guifg=Black guibg=#003099
  hi BARNgreen  ctermfg=Black ctermbg=DarkGreen    guifg=Black guibg=#007700
  hi BARNyellow ctermfg=Black ctermbg=DarkYellow   guifg=Black guibg=#997700
  hi BARNpurple ctermfg=Black ctermbg=DarkMagenta  guifg=Black guibg=#722772
  hi BARNcyan   ctermfg=Black ctermbg=Darkcyan     guifg=Black guibg=#009688
endfunc "}}}
func! bar#Bufnr() "{{{
  let bufid  = bufnr(expand('%'))
  let winid  = bufwinnr(bufid)
  let wincnt = winnr('$')
  if wincnt > 1 "more than one windows
    return '<'.winid.','.bufid.'>'
  else
    return '<'.bufid.'>'
  endif
endfunc "}}}
func! bar#FileInfo() "{{{
  if line('.') != 1 |return ''|endif
  let fname=expand('%')
  let ftime=getftime(fname)
  if ftime==-1 |return ''|endif
  let tpast=localtime()-ftime
  let htime=tpast<60           ? '~'.tpast             .'sec'   :
          \ tpast<60*60        ? '~'.tpast/60          .'min'   :
          \ tpast<60*60*24     ? '~'.tpast/60/60       .'hour'  :
          \ tpast<60*60*24*7   ? '~'.tpast/60/60/24    .'day'   :
          \ tpast<60*60*24*7*4 ? '~'.tpast/60/60/24/7  .'week'  :
          \ tpast<60*60*24*365 ? '~'.tpast/60/60/24/7/4.'month' :
          \                      '~'.tpast/60/60/24/365.'year'
  let fperm=getfperm(fname)
  let ftime=strftime("%Y/%b/%d %H:%M ", ftime)
  return '|'.ftime.htime.'|'.fperm.'|'.line('$').'L|'
endfunc "}}}
func! bar#FileSize() "{{{
  if line('.')!=line('$')
    return ''
  endif
  let fsize = getfsize(expand('%'))
  if fsize <= 0
    return ''
  endif
  let size = fsize < 1024        ? fsize.'bytes' :
        \ fsize < 1024*1024      ? printf('%.1f', fsize/1024.0).'k' :
        \ fsize < 1024*1024*1024 ? printf('%.1f', fsize/1024.0/1024.0).'m' :
        \ printf('%.1f', fsize/1024.0/1024.0/1024.0).'g'
  return ' '.size.' '
endfunc "}}}
func! bar#Mode() "{{{
  let mode = get(s:modemap, mode(v:true), mode())
  call bar#ModeColor(mode[1])
  return printf(len(mode[0])>1?"%s":"%3s ", mode[0])
endfunc "}}}
func! bar#ModeColor(color) "{{{
  let ori_hi  = split(execute('hi StatusLine'))
  let term_fg = match(ori_hi,'ctermfg',2)
  let gui_fg  = match(ori_hi,'guifg',2)
  if a:color[0]!=''
    let ori_hi[term_fg] = 'ctermfg='.a:color[0]
    let ori_hi[gui_fg]  = 'guifg='  .a:color[1]
  endif
  exe 'hi BARDynamic ' join(ori_hi[2:])
endfunc "}}}
func! bar#ExtraState() "{{{
  let exstate = []
  if &paste          |let exstate+=['paste']|endif
  if &virtualedit!=''|let exstate+=['vedit']|endif
  if &buftype!=''    |let exstate+=[&bt]    |endif
  if &conceallevel   |let exstate+=[(&cole==1?"c":"c".&cole)]|endif
  return exstate != [] ? '|'.join(exstate,'|').'|' : ''
endfunc "}}}
func! bar#LinePercent() "{{{
  let cline = line('.') "current line
  let tline = line('$') "total line
  let per   = l:cline * 100 / l:tline
  let ret   = l:cline == 1       ? 'BOL' :
            \ l:cline == l:tline ? 'EOF' :
            \ l:per   == 25      ? '1/4' :
            \ l:per   == 50      ? '1/2' :
            \ l:per   == 75      ? '3/4' :
            \ l:per.'%'
  return ret
endfunc "}}}
func! bar#GitHeadName(git_head_file) "{{{
  let head = readfile(a:git_head_file)[0]
  if match(head,"/") == -1
    return strcharpart(head, 0, 7)
  else
    return split(head,"/")[2]
  endif
endfunc "}}}
func! bar#GitBranchName() "{{{
  let sp = has('win32') || has('win64') ? '\\' : '/'
  let sp_pattern = sp.'[^'.sp.']'.'*$' "echo sp_pattern
  let cpath = expand('%:p:h') "let cpath = '/usr/bin/what/ever'
  let cpath = fnameescape(cpath)
  let last_cnt = match(cpath,sp,1) "count last sp positon
  let git_path = cpath.sp.'.git'
  if isdirectory(git_path)
    return bar#GitHeadName(git_path.sp."HEAD")
  else
    let sp_pos = len(cpath)
    while sp_pos > last_cnt && sp_pos > 1
      let sp_pos = match(cpath,sp_pattern)
      let cpath = cpath[:sp_pos-1] "echo cpath.sp.'.git'
      let git_path = cpath.sp.'.git'
      if isdirectory(git_path)
        return bar#GitHeadName(git_path.sp."HEAD")
      endif
    endwhile
  endif
  return ''
endfunc "}}}
func! bar#ShowProtocol() "{{{
  "let proto = getline(search("^[a-zA-Z].*[^:]\S*$",'bcnW'))
  if col('.') != 1 |return ''| endif
  let proto_list = {
        \'vim':['^fun','^endf'],
        \'c':['\(^[A-Za-z_].*(\|union\|enum\|struct\|typedef\)','^}.*'],
        \'cpp':['\(^[A-Za-z_].*(\|union\|enum\|struct\|typedef\|class\)','^}.*'],
        \}
  let start = get(proto_list,&ft,'')[0]
  let end = get(proto_list,&ft,'')[1]
  if start == '' && end == ''
    return ''
  endif
  let lnum = search(start,'bcnW')
  if lnum == 0 "line with proto start not found
    return ''
  endif
  let lend = search(end  ,'bnW', lnum)
  if lnum < lend "out of start end range
    return ''
  endif
  let lbwc  = line('.') - lnum "line backward count
  let lcnt  = lbwc ? '¦'.lnum.'↑'.lbwc.'¦' : ''
  let slen  = 40
  let proto = getline(lnum)
  let proto = len(proto)>=slen ? strpart(proto,0,slen-2).'…' : proto
  return 'ø '.proto.' '.lcnt
endfunc "}}}

" vim:fen:fdm=marker:nowrap:ts=2:
