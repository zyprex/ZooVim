" ======================================================================
" File: stray_arctic.vim
" Author: zyprex
" Description: vim colorscheme
" origins lay in spacegray.vim
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
let g:colors_name = "stray_arctic"

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
"p-purple or pink

let s:k0={'gui':'#000000', 'cterm':'000'}
let s:k1={'gui':'#080808', 'cterm':'232'}
let s:k2={'gui':'#141617', 'cterm':'233'}
let s:k3={'gui':'#111314', 'cterm':'233'}
let s:k4={'gui':'#111314', 'cterm':'233'}
let s:k5={'gui':'#171717', 'cterm':'233'}
let s:k6={'gui':'#1C1C1C', 'cterm':'234'}
let s:k7={'gui':'#1C1F20', 'cterm':'234'}
let s:k8={'gui':'#252525', 'cterm':'235'}
let s:k9={'gui':'#333233', 'cterm':'236'}
let s:k10={'gui':'#303030', 'cterm':'236'}
let s:k11={'gui':'#303537', 'cterm':'237'}
let s:k12={'gui':'#3A3A3A', 'cterm':'237'}
let s:k13={'gui':'#404040', 'cterm':'238'}
let s:k14={'gui':'#444444', 'cterm':'238'}
let s:k15={'gui':'#3E4853', 'cterm':'239'}
let s:k16={'gui':'#6C6C6C', 'cterm':'242'}

let s:w0={'gui':'#FFFFFF', 'cterm':'015'}
let s:w1={'gui':'#808080', 'cterm':'008'}
let s:w2={'gui':'#7C7F88', 'cterm':'102'}
let s:w3={'gui':'#BCBCBC', 'cterm':'250'}
let s:w4={'gui':'#B3B8C4', 'cterm':'251'}
let s:w5={'gui':'#D0D0D0', 'cterm':'252'}

let s:p0={'gui':'#5F005F', 'cterm':'053'}
let s:p1={'gui':'#B294BB', 'cterm':'139'}
let s:p2={'gui':'#A57A9E', 'cterm':'139'}

let s:g0={'gui':'#005F5F', 'cterm':'023'}
let s:g1={'gui':'#95B47B', 'cterm':'108'}
let s:g2={'gui':'#5F8787', 'cterm':'066'}
let s:g3={'gui':'#5F875F', 'cterm':'065'}

let s:b0={'gui':'#00005F', 'cterm':'017'}
let s:b1={'gui':'#7D8FA3', 'cterm':'103'}
let s:b2={'gui':'#85A7A5', 'cterm':'109'}
let s:b3={'gui':'#8ABEB7', 'cterm':'109'}
let s:b4={'gui':'#8FAFD7', 'cterm':'110'}
let s:b5={'gui':'#81A2BE', 'cterm':'067'}
let s:b6={'gui':'#5FAFAF', 'cterm':'073'}
let s:b7={'gui':'#4C5966', 'cterm':'060'}
let s:b8={'gui':'#515F6A', 'cterm':'066'}
let s:b9={'gui':'#5F5F87', 'cterm':'060'}

let s:y0={'gui':'#FFAF00', 'cterm':'214'}
let s:y1={'gui':'#E8A973', 'cterm':'173'}
let s:y2={'gui':'#E5C078', 'cterm':'179'}

let s:r0={'gui':'#5F0000', 'cterm':'052'}
let s:r1={'gui':'#FF2A1F', 'cterm':'196'}
let s:r2={'gui':'#AF5F5F', 'cterm':'131'}
let s:r3={'gui':'#CC6666', 'cterm':'167'}
let s:r4={'gui':'#C5735E', 'cterm':'173'}

let s:c5={'gui':'#008080', 'cterm':'006'}
"}}}
"-UI {{{
call s:h('SpecialKey', {'fg': s:b7})
call s:h('NonText' ,   {'fg': s:k15})
hi! link EndOfBuffer NonText

call s:h('Normal', {'fg': s:w4, 'bg': s:k0})

if has('multi_byte_ime')
  call s:h('Cursor',   {'fg': s:k0, 'bg': s:w0})
  call s:h('CursorIM', {'fg': s:k0, 'bg': s:r1})
else
  call s:h('Cursor', {'fg': s:k0, 'bg': s:w4})
endif
call s:h('CursorLine',  {'bg': s:k10, 'sp': s:k10})
hi! link CursorColumn CursorLine

call s:h('Visual',    {'bg': s:k13, 'sp': s:k13})
call s:h('Search',    {'fg': s:w0, 'bg': s:b8})
call s:h('IncSearch', {'fg': s:k2, 'bg': s:r2})
hi! link WildMenu IncSearch

call s:h('StatusLine',   {'fg': s:w4, 'bg': s:k11, 'attr': 'bold'})
call s:h('StatusLineNC', {'fg': s:w2, 'bg': s:k7})
hi! link TabLineFill StatusLineNC
hi! link TabLine     StatusLineNC
hi! link TabLineSel  StatusLine

call s:h('VertSplit',  {'fg': s:w0, 'bg': s:k14})
call s:h('SignColumn', {'fg': s:w4, 'bg': s:k2})
call s:h('CursorLineNr', {'fg': s:w1, 'bg': s:k2})
hi! link FoldColumn   SignColumn
hi! link LineNr       SignColumn

call s:h('Folded',    {'fg': s:k16, 'bg': s:k6})
call s:h('Directory', {'fg': s:b6})
call s:h('Title',     {'fg': s:w0})
hi! link MoreMsg  Title
hi! link ModeMsg  Title
hi! link Question Title

call s:h('ErrorMsg', {'fg': s:r4})
hi! link WarningMsg ErrorMsg
hi! link ColorColumn ErrorMsg

call s:h('MatchParen',  {'fg': s:y2, 'bg': s:k6})
call s:h('Pmenu',       {'fg': s:y1, 'bg': s:k5})
call s:h('PmenuSel',    {'fg': s:k0, 'bg': s:c5})
call s:h('PmenuThumb',  {'bg': s:k5})
call s:h('PmenuSBar',   {'fg': s:k0, 'bg': s:k9})

call s:h('SpellBad',    {'sp': s:r0, 'attr': 'undercurl'})
call s:h('SpellCap',    {'sp': s:b0, 'attr': 'undercurl'})
call s:h('SpellRare',   {'sp': s:p0, 'attr': 'undercurl'})
call s:h('SpellLocal',  {'sp': s:g0, 'attr': 'undercurl'})

call s:h('Conceal',  {'fg': s:w1, 'bg':s:k0})
"}}}
"-Generic Syntax {{{
"group-name

call s:h('Comment', {'fg': s:b8})

call s:h('Constant', {'fg': s:r4})
hi! link Boolean Constant

call s:h('String', {'fg': s:g1})
hi! link Character String

call s:h('Identifier', {'fg': s:y2})
call s:h('Function',   {'fg': s:r3})

call s:h('Statement', {'fg': s:p2})
call s:h('Operator',  {'fg': s:p2})
call s:h('PreProc',   {'fg': s:b2})
call s:h('Type',      {'fg': s:y2})

call s:h('Underlined', {'fg': s:g2, 'attr': 'underline'})
call s:h('Delimiter',  {'fg': s:b1})

call s:h('Number', {'fg': s:r4})
hi! link Float Number

hi! link Special SpecialKey
hi! link SpecialChar SpecialKey
hi! link Error ErrorMsg

call s:h('Todo', {'fg': s:w0, 'attr': 'bold,italic,underline'})
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
call s:h('DiffAdd',    {'fg': s:k1, 'bg': s:g2})
call s:h('DiffChange', {'fg': s:k0, 'bg': s:k12})
call s:h('DiffDelete', {'fg': s:k1, 'bg': s:r3})
call s:h('DiffText',   {'fg': s:b9})

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
