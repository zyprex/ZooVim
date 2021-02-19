" ======================================================================
" File: stray_dark.vim
" Author: zyprex
" Description: vim colorscheme basic
" origins lay in ...
" Last Modified: September 16, 2020
" ======================================================================
"-Preamble {{{
set background=dark
" Reset syntax highlighting
hi clear
if exists("syntax_on")
  syntax reset
endif

" Declare theme name
let g:colors_name = "stray_dark"

" check vim version
if v:version < 800
  echoerr "Sorry, vim version 8 is required."
  finish
endif
if has('termguicolors')
  set termguicolors
else
  set t_Co=256
endif
"}}}
"-Utility Function {{{
function! s:h(group, style)
  exe "highlight" a:group
        \ "guifg="   (has_key(a:style, "fg")    ? a:style.fg.gui   : "NONE")
        \ "guibg="   (has_key(a:style, "bg")    ? a:style.bg.gui   : "NONE")
        \ "guisp="   (has_key(a:style, "sp")    ? a:style.sp.gui   : "NONE")
        \ "ctermfg=" (has_key(a:style, "fg")    ? a:style.fg.cterm : "NONE")
        \ "ctermbg=" (has_key(a:style, "bg")    ? a:style.bg.cterm : "NONE")
        \ "gui="     (has_key(a:style, "attr")  ? a:style.attr     : "NONE")
        \ "cterm="   (has_key(a:style, "attr")  ? a:style.attr     : "NONE")
endfunction
"}}}
"-The colors {{{
"r-red g-green b-blue y-yellow c-cyan w-white k-black m-magenta
let s:k0 = {'gui':'#000000','cterm':'000'}
let s:k1 = {'gui':'#121212','cterm':'233'}
let s:k2 = {'gui':'#262626','cterm':'235'}
let s:k3 = {'gui':'#3a3a3a','cterm':'237'}
let s:k4 = {'gui':'#606060','cterm':'241'}
let s:k5 = {'gui':'#808080','cterm':'008'}

let s:w0 = {'gui':'#ffffff','cterm':'015'}
let s:w1 = {'gui':'#dadada','cterm':'253'}
let s:w2 = {'gui':'#c6c6c6','cterm':'251'}
let s:w3 = {'gui':'#a8a8a8','cterm':'248'}
let s:w4 = {'gui':'#949494','cterm':'246'}
let s:w5 = {'gui':'#c0c0c0','cterm':'007'}

let s:c5 = {'gui':'#008080','cterm':'006'}

let s:g0 = {'gui':'#00ff00','cterm':'010'}
let s:g6 = {'gui':'#87af87','cterm':'107'}

let s:b0 = {'gui':'#0000ff','cterm':'012'}
let s:b1 = {'gui':'#005fff','cterm':'027'}
let s:b3 = {'gui':'#00dfff','cterm':'045'}

let s:r0 = {'gui':'#ff0000','cterm':'009'}
let s:r4 = {'gui':'#5f0000','cterm':'052'}

let s:y0 = {'gui':'#ffff00','cterm':'011'}
let s:y1 = {'gui':'#ffaf00','cterm':'214'}
let s:y5 = {'gui':'#808000','cterm':'003'}

let s:m0 = {'gui':'#ff00ff','cterm':'013'}
let s:m2 = {'gui':'#df5fff','cterm':'170'}

"}}}
"-UI {{{
call s:h('SpecialKey', {'fg': s:m2})
call s:h('NonText' ,   {'fg': s:k1})
hi! link EndOfBuffer NonText

call s:h('Normal', {'fg': s:k5, 'bg': s:k0})

if has('multi_byte_ime')
  call s:h('Cursor',   {'fg': s:k0, 'bg': s:w0})
  call s:h('CursorIM', {'fg': s:k0, 'bg': s:m0})
else
  call s:h('Cursor', {'fg': s:k0, 'bg': s:w4})
endif
call s:h('CursorLine',  {'bg': s:k3})
hi! link CursorColumn CursorLine

call s:h('Visual',    {'attr': 'reverse'})
call s:h('Search',    {'fg': s:k0, 'bg': s:k5})
call s:h('IncSearch', {'fg': s:k0, 'bg': s:g0})
hi! link WildMenu IncSearch

call s:h('StatusLine',   {'fg': s:w1, 'bg': s:k3, 'attr': 'bold'})
call s:h('StatusLineNC', {'fg': s:w4, 'bg': s:k2})
hi! link TabLineFill StatusLineNC
hi! link TabLine     StatusLineNC
hi! link TabLineSel  StatusLine

call s:h('VertSplit',  {'fg': s:w0, 'bg': s:k1})
call s:h('SignColumn', {'fg': s:w5, 'bg': s:k1})
call s:h('CursorLineNr', {'fg': s:y1, 'bg': s:k2})
hi! link FoldColumn   SignColumn
hi! link LineNr       SignColumn

call s:h('Folded',    {'fg': s:k4, 'bg': s:k2})
call s:h('Directory', {'fg': s:b1, 'attr': 'bold'})
call s:h('Title',     {'fg': s:g0, 'attr': 'bold'})
hi! link MoreMsg  Title
hi! link ModeMsg  Title
hi! link Question Title

call s:h('ErrorMsg', {'fg': s:w0, 'bg': s:r4})
hi! link WarningMsg ErrorMsg
hi! link ColorColumn ErrorMsg

call s:h('MatchParen',  {'bg': s:k4})
call s:h('Pmenu',       {'fg': s:w4, 'bg': s:k1})
call s:h('PmenuSel',    {'fg': s:k0, 'bg': s:w4})
call s:h('PmenuThumb',  {'bg': s:k1})
call s:h('PmenuSBar',   {'bg': s:k1})

call s:h('SpellBad',    {'sp': s:r0, 'attr': 'undercurl'})
call s:h('SpellCap',    {'sp': s:b0, 'attr': 'undercurl'})
call s:h('SpellRare',   {'sp': s:y0, 'attr': 'undercurl'})
call s:h('SpellLocal',  {'sp': s:g0, 'attr': 'undercurl'})

call s:h('Conceal',  {'fg': s:k2, 'bg':s:k0})
"}}}
"-Generic Syntax {{{
"group-name

call s:h('Comment', {'fg': s:y5})

call s:h('Constant', {'fg': s:w4})
hi! link Boolean Constant

call s:h('String', {'fg': s:g6})
hi! link Character String

call s:h('Identifier', {'fg': s:w2, 'attr': 'bold'})
call s:h('Function',   {'fg': s:w3, 'attr': 'bold'})

call s:h('Statement', {'fg': s:w1, 'attr': 'bold'})
call s:h('Operator',  {'fg': s:w0})
call s:h('PreProc',   {'fg': s:c5})
call s:h('Type',      {'fg': s:w3, 'attr': 'italic'})

call s:h('Underlined', {'fg': s:b3, 'attr': 'underline'})
call s:h('Delimiter',  {'fg': s:w2})

call s:h('Number', {'fg': s:k5, 'attr': 'bold'})
hi! link Float Number

hi! link Special SpecialKey
hi! link SpecialChar SpecialKey
hi! link Error ErrorMsg

call s:h('Todo', {'fg': s:y0, 'attr': 'bold,underline'})
"}}}
" -Highlights -- Help {{{
hi! link helpExample         String
hi! link helpHeadline        Title
hi! link helpSectionDelim    Comment
hi! link helpHyperTextEntry  Statement
hi! link helpHyperTextJump   Underlined
hi! link helpURL             Underlined
"}}}
"-Highlights -- Diff {{{
let s:da = {'gui':'#00ff5f', 'cterm': '047'}
let s:dd = {'gui':'#df5faf', 'cterm': '169'}
let s:dc = {'gui':'#005fff', 'cterm': '027'}
let s:dl = {'gui':'#ffff87','cterm':'228','attr':'italic'}
call s:h('DiffAdd',    {'fg': s:da, 'bg': s:k0})
call s:h('DiffChange', {'fg': s:dc, 'bg': s:k0})
call s:h('DiffDelete', {'fg': s:dd, 'bg': s:k0})
call s:h('DiffText',   {'fg': s:dl})

hi! link DiffAdded   DiffAdd
hi! link DiffChanged DiffChange
hi! link DiffRemoved DiffDelete
hi! link DiffLine    DiffText
hi! link diffSubname   diffLine

hi! link diffOnly      Constant
hi! link diffIdentical Constant
hi! link diffDiffer    Constant
hi! link diffBDiffer   Constant
hi! link diffIsA       Constant
hi! link diffNoEOL     Constant
hi! link diffCommon    Constant
hi! link diffComment   Constant
"}}}

" vim:fen:fdm=marker:nowrap:ts=2:fen
