if exists("b:current_syntax")
  finish
endif
syn sync fromstart
syn spell notoplevel
"git log --all --graph --abbrev-commit --pretty=format:"%h %s <%an %ce> [%cr] %d"
syn match GitLogHash   /\(^[* /|\\]*\)\@<=[a-z0-9]\+/
syn match GitLogEmail  /\s<.*@\S\+>/
syn match GitLogTime   /\s\[.*\]/
syn match GitLogBranch /\s(.*)$/
syn match GitLogHead   /\(HEAD ->\|HEAD@{\d\+}\)/

hi def link GitLogHash   Identifier
hi def link GitLogEmail  Title
hi def link GitLogTime   Define
hi def link GitLogBranch Keyword
hi def link GitLogHead   Constant

let b:current_syntax='gitlog'
