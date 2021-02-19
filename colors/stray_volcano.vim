" ======================================================================
" File: stray_volcano.vim
" Author: zyprex
" Description: vim colorscheme
" origins lay in mushroom.vim
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
let g:colors_name = "stray_volcano"

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
"n-brown p-purple or pink
let s:k0={'gui': '#000000', 'cterm': '000' }
let s:k1={'gui': '#080808', 'cterm': '232' }
let s:k2={'gui': '#121212', 'cterm': '233' }
let s:k3={'gui': '#1c1c1c', 'cterm': '234' }
let s:k4={'gui': '#262626', 'cterm': '235' }
let s:k5={'gui': '#303030', 'cterm': '236' }
let s:k6={'gui': '#383738', 'cterm': '237' }
let s:k7={'gui': '#4e4e4e', 'cterm': '239' }
let s:k8={'gui': '#87875f', 'cterm': '101' }

let s:w0={'gui': '#ffffff', 'cterm': '015' }
let s:w1={'gui': '#878787', 'cterm': '102' }

let s:n0={'gui': '#af5f00', 'cterm': '130' }
let s:n1={'gui': '#af5f5f', 'cterm': '131' }
let s:n2={'gui': '#af8700', 'cterm': '136' }
let s:n3={'gui': '#d7af00', 'cterm': '178' }
let s:n4={'gui': '#d78700', 'cterm': '172' }
let s:n5={'gui': '#d78787', 'cterm': '174' }
let s:n6={'gui': '#ff8700', 'cterm': '208' }
let s:n7={'gui': '#ff875f', 'cterm': '209' }
let s:n8={'gui': '#ffaf5f', 'cterm': '215' }
let s:n9={'gui': '#ffaf87', 'cterm': '216' }

let s:p0={'gui': '#5f005f', 'cterm': '053' }
let s:p1={'gui': '#875f5f', 'cterm': '095' }
let s:p2={'gui': '#875f87', 'cterm': '096' }
let s:p3={'gui': '#af87ff', 'cterm': '141' }
let s:p4={'gui': '#d75f5f', 'cterm': '167' }
let s:p5={'gui': '#af5f5f', 'cterm': '131' }
let s:p6={'gui': '#ff87ff', 'cterm': '213' }
let s:p7={'gui': '#ffd7ff', 'cterm': '225' }

let s:g0={'gui': '#005f00', 'cterm': '022' }
let s:g1={'gui': '#008700', 'cterm': '028' }
let s:g2={'gui': '#5f5f00', 'cterm': '058' }
let s:g3={'gui': '#355735', 'cterm': '065' }
let s:g4={'gui': '#7bab00', 'cterm': '106' }

let s:b0={'gui': '#005faf', 'cterm': '025' }
let s:b1={'gui': '#5f87af', 'cterm': '067' }
let s:b2={'gui': '#5fd7af', 'cterm': '079' }

let s:r0={'gui': '#5f0000', 'cterm': '052' }
let s:r1={'gui': '#870000', 'cterm': '088' }

let s:m0={'gui': '#af00af', 'cterm': '127' }

"}}}
"-UI {{{
call s:h('SpecialKey', {'fg': s:p3})
call s:h('NonText' ,   {'fg': s:k6})
hi! link EndOfBuffer NonText

call s:h('Normal', {'fg': s:w1, 'bg': s:k0})

if has('multi_byte_ime')
  call s:h('Cursor',   {'fg': s:k0, 'bg': s:w1})
  call s:h('CursorIM', {'fg': s:k0, 'bg': s:m0})
else
  call s:h('Cursor', {'fg': s:k0, 'bg': s:w1})
endif
call s:h('CursorLine',  {'bg': s:k1})
hi! link CursorColumn CursorLine

call s:h('Visual',    {'bg': s:k5})
call s:h('Search',    {'fg': s:n5, 'bg': s:k6})
call s:h('IncSearch', {'fg': s:k7, 'bg': s:n3})
hi! link WildMenu IncSearch

call s:h('StatusLine',   {'fg': s:n9, 'bg': s:k5, 'attr': 'bold'})
call s:h('StatusLineNC', {'fg': s:n5, 'bg': s:k2})
hi! link TabLineFill StatusLineNC
hi! link TabLine     StatusLineNC
hi! link TabLineSel  StatusLine

call s:h('VertSplit',  {'fg': s:n5, 'bg': s:n0})
call s:h('SignColumn', {'bg': s:k2})
call s:h('CursorLineNr', {'fg': s:n9, 'bg': s:k5})
hi! link FoldColumn   SignColumn
hi! link LineNr       SignColumn

call s:h('Folded',    {'fg': s:n0, 'bg': s:k2})
call s:h('Directory', {'fg': s:p1, 'attr': 'bold'})
call s:h('Title',     {'fg': s:n7, 'attr': 'bold'})
hi! link MoreMsg  Title
hi! link Question Title
hi! link ModeMsg  Title

call s:h('ErrorMsg', {'fg': s:p4, 'bg': s:k5})
hi! link WarningMsg ErrorMsg
hi! link ColorColumn ErrorMsg

call s:h('MatchParen',  {'bg': s:k5})
call s:h('Pmenu',       {'fg': s:n0, 'bg': s:k2})
call s:h('PmenuSel',    {'fg': s:n6, 'bg': s:k7})
call s:h('PmenuThumb',  {'bg': s:g2})
call s:h('PmenuSBar',   {'bg': s:n6})

call s:h('SpellBad',    {'sp': s:r1, 'attr': 'undercurl'})
call s:h('SpellCap',    {'sp': s:m0, 'attr': 'undercurl'})
call s:h('SpellRare',   {'sp': s:n3, 'attr': 'undercurl'})
call s:h('SpellLocal',  {'sp': s:b2, 'attr': 'undercurl'})

call s:h('Conceal',  {'fg': s:k4, 'bg':s:k0})
"}}}
"-Generic Syntax {{{
"group-name

call s:h('Comment', {'fg': s:g3})

call s:h('Constant', {'fg': s:n0})
hi! link Boolean Constant

call s:h('String', {'fg': s:g4})
hi! link Character String

call s:h('Identifier', {'fg': s:n1})
call s:h('Function',   {'fg': s:n1})

call s:h('Statement', {'fg': s:n2})
call s:h('Operator',  {'fg': s:b1})
call s:h('PreProc',   {'fg': s:p2})
call s:h('Type',      {'fg': s:b1})

call s:h('Underlined', {'fg': s:m0, 'attr': 'underline'})
call s:h('Delimiter',  {'fg': s:p3})

call s:h('Number', {'fg': s:n0, 'attr': 'bold'})
hi! link Float Number

hi! link Special SpecialKey
hi! link SpecialChar SpecialKey
hi! link Error ErrorMsg

call s:h('Todo', {'fg': s:p6, 'bg': s:k3})
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
