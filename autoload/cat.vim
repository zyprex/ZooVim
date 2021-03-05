" ======================================================================
" File: cat.vim
" Author: zyprex
" Description: let the cat out of the bag, vim command complete for
" external program
" -- usage --
" com! -nargs=+ -complete=customlist,cat#git G !git <args>
" com! -nargs=+ -complete=customlist,cat#pandoc Pandoc !pandoc <args>
" Last Modified: February 19, 2021
" ======================================================================
" :command-completion-custom

func! cat#git(A,C,P) "{{{
  let mcm = 'G'
  let list = []
  "*{branch}
  if a:A =~# '\*\S*$' 
    let list = filter(systemlist('git branch --all'),"v:val =~ a:A[1:]")
    call map(list,'substitute(v:val,"* ","","g")')
    call map(list,'substitute(v:val,"/"," ","g")')
    call map(list,'substitute(v:val,"\\s*remotes\\s*","","g")')
  "@{commit_id}
  elseif a:A =~# '@\S*$'
    let list = filter(systemlist('git log --pretty=format:"%h"')
          \,"v:val =~ a:A[1:]")
  "#{tag}
  elseif a:A =~# '#\S*$'
    let list = filter(systemlist('git tag'),"v:val =~ a:A[1:]")
  "-{subcmd}
  elseif a:A =~# '-\S*$'
    let cmd = substitute(a:C,mcm,'git','')
    let cmd = cmd[:match(a:C,'^\s*git\s\+[-a-z]\+')]
    let line = filter(systemlist(cmd.' -h'),"v:val =~ '^\\s\\{4}'")
    for i in line
      let s = split(i)
      if s[0][-1:] == ','
        let list += [s[0][:-2]]
        let list += [s[1]]
      else
        let list += [s[0]]
      endif
    endfor
    call filter(list,"v:val =~ a:A[1:]")
  "{cmd}
  elseif a:C[:a:P] =~# '^\s*'.mcm.'\s\+\S*$'
    let list = map(filter(systemlist('git help -a'),"v:val =~ '^\\s\\{3}'")
          \,"matchstr(v:val,'[-a-z]\\+',3)")
    call filter(list,"v:val =~ '^'.a:A")
  "{file}
  else
    let list = glob("**",1,1)
    call filter(list,"v:val =~ '^'.a:A")
  endif
  return list
endfunc "}}}
func! cat#pandoc(A,C,P) "{{{
  let list = []
  if a:A =~# '-\S*$'
    let line = systemlist('pandoc -h')
    let pat = '\( -\w \| --[-=|\[\]:a-z]\+\)'
    for i in line
      let cnt = 1
      let m = matchstrpos(i,pat,0,cnt)
      while m[0]!=''
        let list += [trim(m[0])]
        let cnt += 1
        let m = matchstrpos(i,pat,0,cnt)
      endwhile
    endfor
    call filter(list,"v:val =~ '^'.a:A")
  else
    let list = map(readdir('.',{n->n!~'^\.git$'})
          \,'isdirectory(v:val)?v:val."/":v:val')
    call filter(list,"v:val =~ '^'.a:A")
  endif
  return list
endfunc "}}}

" vim:fen:fdm=marker:nowrap:ts=2:
