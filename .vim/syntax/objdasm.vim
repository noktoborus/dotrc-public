" Vim syntax file
" Language:	objdump -D output
" Maintainer:	syndrowm <syndrowm@gmail.com>
" Last Change:	2010 Aug 11
" URL: http://vir.homelinux.org/objdasm.vim
" This is really just a modified version of syntax/asm.vim
" Have fun reversing.
" Modified by Matthias Kretz <kretz@kde.org> to look a little nicer for my
" tastes

" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

syn case ignore
syn match asmLabel            "[a-z_][a-z0-9_]*:"he=e-1
syn match asmIdentifier               "[a-z_][a-z0-9_]*"


" Various #'s as defined by GAS ref manual sec 3.6.2.1
" Technically, the first decNumber def is actually octal,
" since the value of 0-7 octal is the same as 0-7 decimal,
" I prefer to map it as decimal:
syn match decNumber		"0\+[1-7]\=[\t\n$,; ]"
syn match decNumber		"[1-9]\d*"
syn match octNumber		"0[0-7][0-7]\+"
syn match hexNumber		"0[xX][0-9a-fA-F]\+"
syn match binNumber		"0[bB][0-1]*"
syn match addressNum		"[0-9a-fA-F]\+:"
syn match machine		"[0-9a-fA-F][0-9a-fA-F] \+"
syn match jumps			"j[a-z]\+"
syn match jumps			"jmpq"
syn match jumps			"retq"
syn match jumps			"leaveq"
syn match calls			"callq\?"
syn match alerts		"\*\*\+[a-zA-Z0-9]\+"

syn match xmmRegister		"xmm1\?[0-9]"
syn match stackPointer		"[er]sp"
syn match framePointer		"[er]bp"
syn match instructionPtr	"[er]ip"
syn match register		"%[a-z0-9]\+"

syn match asmSpecialComment	";\*\*\*.*"
syn match asmComment		";.*"hs=s+1
syn match asmComment		"#.*"hs=s+1

syn match asmInclude		"\.include"
syn match asmCond		"\.if"
syn match asmCond		"\.else"
syn match asmCond		"\.endif"
syn match asmMacro		"\.macro"
syn match asmMacro		"\.endm"

syn match asmDirective		"\.[a-z][a-z]\+"


syn case match

" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_asm_syntax_inits")
  if version < 508
    let did_asm_syntax_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  " The default methods for highlighting.  Can be overridden later
  HiLink asmSection	Special
  HiLink asmLabel	Label
  HiLink asmComment	Comment
  HiLink asmDirective	Statement

  HiLink asmInclude	Include
  HiLink asmCond	PreCondit
  HiLink asmMacro	Macro

  HiLink hexNumber	Type
  HiLink decNumber	Number
  HiLink octNumber	Number
  HiLink binNumber	Number
  HiLink machine 	Number	

  HiLink asmSpecialComment Comment
  HiLink asmType	Type

  HiLink jumps		PreProc
  HiLink calls		PreProc
  HiLink addressNum	WarningMsg
  HiLink alerts		VisualNOS
  "hi addressNum	ctermfg=brown	


  " My default color overrides:
  hi asmSpecialComment ctermfg=red
  "hi asmIdentifier ctermfg=cyan
  hi asmType ctermfg=brown
  hi register ctermfg=yellow
  "hi xmmRegister ctermfg=red
  "hi framePointer ctermfg=yellow
  hi instructionPtr ctermfg=green

  delcommand HiLink
endif

let b:current_syntax = "asm"

" vim: ts=8
