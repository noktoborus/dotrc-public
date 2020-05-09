if has("eval") && has("autocmd")
  function! ShowGitBlame()
    let current = expand('%')
    let hname = system('sha1sum ' . current. '| cut "-d " -f1')
    let cline = line('.')

    let fname = "/". join(split(tempname(), "/")[:-2], "/")
    let fname = fname . "/" . substitute(hname, ' ', '_', 'g')
    let fname = split(fname, '\n')[0]

    if filereadable(fname)
      silent execute "tabnew " . fname
      setlocal noswapfile
      setlocal nomodifiable
      execute cline
    else
      let content = split(system("git blame " . current), "\n")

      if len(content) == 1
        echo content
        return
      endif

      silent execute "tabnew " . fname
      setlocal noswapfile
      setlocal modifiable
      0 put = content
      0
      silent write!
      setlocal nomodifiable
      execute cline
    endif
  endfunction
  command! Blame call ShowGitBlame()


	function! ShowManPage(cmdpage)
		let page = a:cmdpage
		let fname = "/". join (split (tempname (), "/")[:-2], "/")
		let fname = fname . "/" . substitute (page, ' ', '_', 'g') . ".man"
		if filereadable (fname)
			silent execute "tabnew " . fname
		else
			let content = split (system ("man " . page), "\n")
			if len (content) > 1
				silent execute "tabnew " . fname
				setlocal noswapfile
				setlocal modifiable
				0 put = content
				0
				if search ("\e")
					silent %s/\e\[\d*m//g
				endif
				0
				silent write!
				setlocal syntax=man
				setlocal nomodifiable
			else
				echo content[0]
			endif
		endif
	endfun
	command! -nargs=+ -complete=command Man call ShowManPage(<q-args>)
"	map <C-h> <Esc>:Man 
"	imap <C-h> <Esc>:Man 
"	vmap <C-h> <Esc>:Man 

	function! MakeNewCodeHS()
		let fname = bufname ('%')
		0 put ='-- file: ' . fname
		put ='-- vim: ft=haskell ff=unix fenc=utf-8'
		put =''
	endfun

	function! MakeNewCodePY()
		let fname = bufname ('%')
		let module = substitute(bufname('%'), "\.py$", "", "")
		0 put ='#!/usr/bin/env python'
		put ='# -*- coding: utf-8 -*'
		put ='# vim: ft=python ff=unix fenc=utf-8 cc=120 et ts=4'
		put ='# file: ' . fname
		put ='\"\"\"'
		put ='.. module: ' . module
		put =''
		put =''
		put =''
		put ='\"\"\"'
		put =''
	endfun

	function! MakeNewCodeCPP()
		0 put ='/* vim: ft=cpp ff=unix fenc=utf-8'
		put =' */'
		put =''
		put ='#include <iostream>'
		put =''
		put ='int main(int argc, char *argv[])'
		put ='{'
		put ='	return 0;'
		put ='}'
	endfun

	function! MakeNewCodeC()
		let fname = bufname ('%')
		let fnameh = substitute(bufname('%'), "\.c$", ".h", "")
		0 put ='/* vim: ft=c ff=unix fenc=utf-8 ts=2 sw=2 et'
		put =' * file: ' . fname
		put =' */'

		if (filereadable(fnameh))
			put ='#include \"' . fnameh . '\"'
		else
			put ='#include <stdio.h>'
			put ='#include <stdlib.h>'
			put ='#include <stdint.h>'
			put ='#include <stdbool.h>'
			put ='#include <string.h>'
			put ='#include <unistd.h>'
			put =''
			put ='int'
			put ='main(int argc, char *argv[])'
			put ='{'
			put =''
			put ='	return EXIT_SUCCESS;'
			put ='}'
		end
	endfun

	function! MakeNewCodeCH(type, ext)
		"let ddeee = system ("echo -n `date +%s`")
		let ddeee = strftime ("%s")
		let fname = bufname ('%')
		let nfname = toupper (fname)
		let ext = toupper (a:ext)
		let nfname = substitute (nfname, '\.' . ext, "", "g")
		let nfname = substitute (nfname, '[\.|/]', "_", "g")
		let ddeee = '_' . nfname . '_' . ddeee . "_" . ext . "_"

		0 put ='/* vim: ft=' . a:type . ' ff=unix fenc=utf-8 ts=2 sw=2 et'
		put =' * file: ' . fname
		put =' */'
		put ='#ifndef ' . ddeee
		put ='#define ' . ddeee
		put =''
		put =''
		put ='#endif /* ' . ddeee . ' */'
	endfun

	function! MakeNewCodeMakefile()
		let fname = bufname ('%')
		0 put ='# vim: ft=make ff=unix fenc=utf-8'
		put ='# file: ' . fname
		put ='LIBS='
		put ='CFLAGS=-Wall -Werror -pedantic -std=c99'
		put ='BIN=./'
		put ='SRC='
		put =''
		put ='all: ${BIN}'
		put ='	${BIN}'
		put =''
		put ='${BIN}: ${SRC}'
		put ='	${CC} -o ${BIN} ${CFLAGS} ${SRC} ${LIBS}'
	endfun
	
	function! MakeNewCodeSHell()
		let fname = bufname ('%')
		0 put ='#!/bin/sh'
		put ='# vim: ft=sh ff=unix fenc=utf-8'
		put ='# file: ' . fname
		put =''
		put =''
	endfunction

	function! MakeNewCodeHtml()
		let fname = bufname ('%')
		0 put ='<!DOCTYPE html>'
		put ='<!-- vim: ft=html ff=unix fenc=utf-8'
		put =' file: ' . fname
		put ='-->'
		put ='<html>'
		put ='	<head>'
		put ='		<meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\" />'
		put ='		<meta name=\"Template\" content=\"vim: html/' . strftime ('%c') . '\" />'
		put ='		<title>' . fname . '</title>'
		put ='	</head>'
		put ='	<body>'
		put ='		hellows!'
		put ='	</body>'
		put ='</html>'
	endfunction

	function! MakeNewCodeTextile()
		let tz = strftime ("%z")
		let timedate = strftime ("%F %T ") . tz[:2] . ":" . tz[3:]
		0 put ='---'
		put ='layout: posts'
		put ='date: ' . timedate
		put ='title:'
		put ='description:'
		put ='---'
		put =''
		put =''
	endfunction

	function! MakeNewCmake()
		0 put ='# vim: ft=cmake:et:ts=2:ff=unix:fenc=utf-8:'
		put ='cmake_minimum_required(VERSION 3.0.2)'
		put =''
		set expandtab "et
		set tabstop=2 "ts
	endfunction

	function! MakeNewClishXML()
		let fname = bufname ('%')
		let vname = substitute (fname, 'qos_\(.*\).xml', '\1', '')
		0 put ='<?xml version=\"1.0\" encoding=\"UTF-8\"?>'
		put ='<CLISH_MODULE xmlns=\"http://clish.sourceforge.net/XMLSchema\"'
		put ='              xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"'
		put ='              xsi:schemaLocation=\"http://clish.sourceforge.net/XMLSchema'
        put ='                     http://clish.sourceforge.net/XMLSchema/clish.xsd\">'
		put ='    <!-- ' . vname . ' -->'
		put ='    <VIEW name=\"qos_module_' . vname . '\">'
		put ='    </VIEW>'
		put ='</CLISH_MODULE>'

		set expandtab
		set tabstop=4
		set list
	endfunction

	function! ReadBinaryWithAny()
		" URL: http://vir.homelinux.org/blog/archives/141-quick-hack-to-unite-vim-and-objdump.html
		"
		if 0 == match(getline(1), "\\(^.ELF\\|!<arch>\\)")
			execute "%!objdump -DwC %"
			setlocal ft=objdasm
		elseif 0 == match(getline(1), "SQLite format 3")
			execute "%!sqlite3 % .dump"
			setlocal ft=sql
		else
			return
		endif
		setlocal ro
		setlocal nomodifiable
		setlocal noswapfile
		"setlocal nowrite
	endfunction

	function! ReadExif()
		execute "%!exiftool %; echo '---------------------------------'; xxd -g4 %"
		setlocal ro
		setlocal nomodifiable
		setlocal ft=xxd
	endfunction

	function! ChopLinesInBuf()
		let curpos = getpos (".")
		0
		if search ("[ \t]$")
			0
			%s/[ \t]*$//
		endif
		call setpos (".", curpos)
	endfun
	
	autocmd BufNewFile qos_*.xml call MakeNewClishXML ()
	autocmd BufNewFile,BufRead /etc/lighttpd/*.conf,lighttpd.conf setf lighttpd 
	autocmd BufRead,BufNewFile /etc/nginx/*,/usr/local/nginx/conf/* if &ft == '' | setf nginx | endif 
	autocmd BufRead,BufNewFile *.sieve setf sieve
	"autocmd BufWritePre *.c,*.cpp,*.cxx,Makefile,*.sh,*.h,*.hpp,*.html,*.xhtml,*.textile call ChopLinesInBuf ()
	autocmd BufNewFile *.cmake,CMakeLists.txt call MakeNewCmake ()
	autocmd BufNewFile *.sh call MakeNewCodeSHell ()
	autocmd BufNewFile *.c call MakeNewCodeC ()
	autocmd BufNewFile *.cpp,*.cc call MakeNewCodeCPP()
	autocmd BufNewFile *.h call MakeNewCodeCH ("c", "h")
	autocmd BufNewFile *.hpp call MakeNewCodeCH ("cpp", "hpp")
	autocmd BufNewFile *.html,*.xhtml call MakeNewCodeHtml ()
	autocmd BufNewFile *.hs call MakeNewCodeHS ()
	autocmd BufNewFile *.py call MakeNewCodePY ()
	autocmd BufNewFile Makefile call MakeNewCodeMakefile ()
	autocmd BufNewFile [0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]-*.textile call MakeNewCodeTextile ()
	autocmd BufRead,BufNewFile [0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]-*.textile setf jekyll-textile
	autocmd BufRead,BufNewFile *.dis setf objdasm
	autocmd BufRead,BufNewFile *.ael setf ael
	autocmd BufReadPost,FileReadPost *.[jJ][pP][eE][gG],*.[jJ][pP][gG],*.[pP][nN][gG],*.[bB][mM][pP] silent call ReadExif ()
	autocmd BufReadPost,FileReadPost * silent call ReadBinaryWithAny()
	autocmd BufNewFile,BufRead *.ini,*/.hgrc,*/.hg/hgrc setf ini

	fun! <SID>check_pager_mode()
		if exists("g:loaded_less") && g:loaded_less
			" we're in vimpager / less.sh / man mode
			set laststatus=0
			set ruler
			set nolist
			set noswapfile
			set colorcolumn&
		endif
	endfun
	autocmd VimEnter * :call <SID>check_pager_mode()

	" iptables syntax
	au BufNewFile,BufRead * if getline(1) =~ '^#!.*iptables-restore' ||
			\ getline(1) =~ '^# Generated by iptables-save' ||
			\ getline(1) =~ '^# Firewall configuration written by' |
			\ set ft=iptables | endif

	silent function! GitBranch()
		return "None"
	endfunction

	silent function! GetEncInfo()
		if len (&fileencoding)
			return "F: " . &fileencoding
		else
			return "B: " . &encoding
		endif
	endfunction

	set laststatus =2
	"set statusline =%<%1*(%M%R)%f(%F)%=\ [Branch:\ %{GitBranch()}]\ [%{GetEncInfo()}]\ [%n]%1*%-19(%2*\ %02c(%p%%)\ %1*%)%O'%3*%02b%1*'
	set statusline =%<%1*(%M%R)%f(%F)%=\ [%{GetEncInfo()}]\ [%n]%1*%-19(%2*\ %02c(%p%%)\ %1*%)%O'%3*%02b%1*'
endif

set visualbell

set listchars=tab:>\ ,trail:.,extends:>
set list
set modeline
set modelines =5
set errorformat =%A%f:%l:\ %m,%-Z%p^,%-C%.%#
set nocompatible
set showcmd
set ruler
set nocompatible
set nocp
set hlsearch
set showmatch
set incsearch
set bs =2
set nowrap
set nu
set nobackup
set hidden
set ch =1
set sessionoptions =curdir,buffers,tabpages
set title
set titlestring =%t%(\ %m%)%(\ %r%)%(\ %h%)%(\ %w%)%(\ (%{expand(\"%:p:~:h\")})%)\ -\ VIM
set confirm
set shortmess =fimnrxoOtTI
set pastetoggle =<F12>

" Indent
set shiftwidth =2
set tabstop =2
set softtabstop =2
set smarttab
set expandtab

set smartindent
set cindent

hi CursorLine   cterm=NONE ctermbg=darkred ctermfg=white guibg=darkred guifg=white
hi CursorColumn cterm=NONE ctermbg=darkred ctermfg=white guibg=darkred guifg=white
nnoremap <Leader>c :set cursorline! cursorcolumn!<CR>

set fileencodings=utf-8,cp1251,koi8-r,iso-8859-15
if version >= 703
	set colorcolumn =80
endif

if has("autocmd")
	syntax on
	filetype plugin on
	filetype indent on
endif

" au BufNewFile,BufRead *.s set ft=asmMIPS syntax=asm
" au BufNewFile,BufRead *.c,*.C,*.h,*.H set expandtab cin
" au BufNewFile,BufRead *.c,*.C,*.h,.*.h set backup
" map <C-l> <Esc>:marks<CR>
" map ; <Esc>:set list!<CR>
" map . <Esc>:set number!<CR>

"map	<silent> <C-x>	<ESC>:nohlsearch<CR>
"map	<C-x>	<esc>:w<cr>
"imap	<C-x>	<esc>:w<cr>

"map	<C-w>	<esc>:q<cr>
map	<C-o>	:tabe 

"map	<C-right>	:tabnext<cr>
"map	<C-right>	<esc>:tabnext<cr>
"map	<C-left>	:tabprev<cr>
"imap	<C-left>	<esc>:tabprev<cr>

map	<silent>	<C-p>	:tabprev<cr>
map	<silent>	<C-n>	:tabnext<cr>

map	<F1>	<nop>
imap	<F1>	<nop>
vmap	<F1>	<nop>

imap <C-f> <C-x><C-o>

" clipboard
vmap <C-c> "+yi
imap <C-v> <Esc>"+gPi

"map	<	:<gv<cr>
"map	>	:>gv<cr>

" CTRL + Up
map Oa	<up>
imap Oa	<up>
vmap Oa	<up>
" CTRL + Down
map Ob	<down>
imap Ob	<down>
vmap Ob	<down>
" CTRL +  Left
map Od	<left>
imap Od	<left>
vmap Od	<left>
" CTRL + Right
map Oc	<right>
imap Oc	<right>
vmap Oc	<right>


" TagList
map <F4> :TlistToggle<cr>
imap <F4> :TlistToggle<cr>
let Tlist_Show_One_File = 1 " Displaying tags for only one file~
let Tlist_Exist_OnlyWindow = 1 " if you are the last, kill yourself
let Tlist_Use_Right_Window = 1 " split to the right side of the screen
let Tlist_Sort_Type = "order" " sort by order or name
let Tlist_Display_Prototype = 0 " do not show prototypes and not tags in the taglist window.
let Tlist_Compart_Format = 1 " Remove extra information and blank lines from the taglist window.
let Tlist_GainFocus_On_ToggleOpen = 1 " Jump to taglist window on open.
let Tlist_Display_Tag_Scope = 1 " Show tag scope next to the tag name.
let Tlist_Close_On_Select = 1 " Close the taglist window when a file or tag is selected.
let Tlist_Enable_Fold_Column = 0 " Don't Show the fold indicator column in the taglist window.
let Tlist_WinWidth = 40

colorscheme elflord
hi	User3 term=inverse,bold ctermbg=darkgrey ctermfg=brown guibg=#18163e guifg=#8145df
hi	User2 term=inverse,bold ctermbg=darkgrey ctermfg=grey guibg=#19163e guifg=#5b5b75
hi	User1 term=inverse ctermbg=darkgrey ctermfg=darkblue guibg=#0d0c22 guifg=#3b3879
"hi	ColorColumn ctermbg=lightgrey guibg=#0d0c22
hi	ColorColumn ctermbg=darkgrey guibg=#0d0c22

hi	TabLine term=bold cterm=bold ctermfg=darkblue
"ctermbg=black
hi	TabLineFill term=bold cterm=bold
"ctermfg=black ctermbg=black
hi	TabLineSel	term=bold cterm=bold ctermfg=white

set guifont =Monospace\ 12
set guipty

"set ttymouse =xterm2
"set mouse =a
"set mousemodel =popup
"set mousehide

set backupdir =~/.tmp/vim,/tmp/
set directory =~/.tmp/vim,/tmp/
set wildmenu
set wcm=<Tab>
menu Encoding.koi8-r :e ++enc=koi8-r<CR>
menu Encoding.windows-1251 :e ++enc=cp1251<CR>
menu Encoding.cp866 :e ++enc=cp866<CR>
menu Encoding.utf-8 :e ++enc=utf8<CR>

compiler gcc
map <C-K>	:make<CR>
vmap <C-K>	<Esc>:make<CR>
imap <C-K>	<Esc>:make<CR>

"
" Utilites
"

" convert hex-ASCII editing ( http://www.darksmile.net/software/.vimrc.html
function! Fxxd()
	let c=getline(".")
	if c =~ '^[0-9a-f]\{7}:'
		if exists ("b:syntaxlast")
			execute "setlocal syntax =" . b:syntaxlast
		endif
		:%!xxd -r
	else
		if exists ("b:current_syntax")
			let b:syntaxlast = b:current_syntax
		endif
		setlocal syntax =xxd
		":%!xxd -g2 -c 10
		:%!xxd -g4
	endif
endfunction
map Ss :call Fxxd()<CR>

" source ~/.vim/word_complete.vim"
"

