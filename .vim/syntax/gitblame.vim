" Vim syntax file
" Language: git blame syntax

if version >= 600
  if exists("b:current_syntax")
    finish
  endif
else
  syntax clear
endif

syn region gitHead start='^' end=')' oneline
syn match gitHash '^[0-9a-f]\+' contained containedin=gitHead nextgroup=gitHeadDate
syn match gitHeadDate '\d\{4\}-\d\{2\}-\d\{2\} \d\{2\}:\d\{2\}:\d\{2\} +\d\{4\}' contained containedin=gitHead nextgroup=gitHeadLineNo skipwhite
syn match gitHeadLineNo '\d\+' contained

hi def link gitHash       Identifier
hi def link gitHeadLineNo Special
hi def link gitHeadDate   Number
hi def link gitHead       Label

let b:current_syntax = "gitblame"
