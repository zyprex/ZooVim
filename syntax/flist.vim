if exists("b:current_syntax")
  finish
endif
syn sync fromstart
syn spell notoplevel

syn match FListDir /^.*\/$/
syn match FListTmp /\(\<tags\>\|^.*\(.tmp\|\~\)$\)/

hi def link FListDir Directory
hi def link FListTmp NonText

let b:current_syntax='flist'
