"
"   You will have to restart vim for this to take effect.  In any case
"   it is a good idea to read ":he new-filetype" so that you know what
"   is going on, and why the above lines work.
"
"   Written originally by Dominic Mitchell, Jan 2006.
"   happygiraffe.net
"
"   Modified by Aaron Bieber, May 2007.
"   blog.aaronbieber.com
"
"   Modified by Tim Harper, July 2008 - current
"   tim.theenchanter.com
" @(#) $Id$

if version < 600
    syntax clear
elseif exists("b:current_syntax")
    finish
endif

" Textile commands like "h1" are case sensitive, AFAIK.
syn case match

" Textile syntax: <http://textism.com/tools/textile/>
syn match txtRootIds    "^[^\:]*:" contained
syn region txtRootHeader matchgroup=txtRootHeaderStart start="\%1l---$" end="^---$" contains=txtRootIds

syn match txtHitagsIds  " endhighlight \| highlight \| include " contained
syn region txtHitags matchgroup=txtHitagsStart start="{%" end="%}" oneline contains=txtHitagsIds

" Inline elements.
syn match txtEmphasis    /_[^_]\+_/
syn match txtBold        /\*[^*]\+\*/
syn match txtCite        /??.\+??/
syn match txtDeleted     /-[^-]\+-/
syn match txtInserted    /+[^+]\++/
syn match txtSuper       /\^[^^]\+\^/
syn match txtSub         /\~[^~]\+\~/
syn match txtSpan        /%[^%]\+%/
syn match txtFootnoteRef /\[[0-9]\+]/
syn match txtCode        /@[^@]\+@/

" Block elements.
syn match txtHeader     /^h1\(\((\(\a\+\|[0-9]\+\|#\)\+)\)\|\({\(\a\+\|[0-9]\+\|:\|#\)\+}\)\|\(\[\a\+\]\)\)\{0,3}\./
syn match txtHeader2    /^h2\(\((\(\a\+\|[0-9]\+\|#\)\+)\)\|\({\(\a\+\|[0-9]\+\|:\|#\)\+}\)\|\(\[\a\+\]\)\)\{0,3}\./
syn match txtHeader3    /^h[3-6]\(\((\(\a\+\|[0-9]\+\|#\)\+)\)\|\({\(\a\+\|[0-9]\+\|:\|#\)\+}\)\|\(\[\a\+\]\)\)\{0,3}\./
syn match txtBlockquote /^bq\(\((\(\a\+\|[0-9]\+\|#\)\+)\)\|\({\(\a\+\|[0-9]\+\|:\|#\)\+}\)\|\(\[\a\+\]\)\)\{0,3}\./
syn match txtBlockquote /^p\(\((\(\a\+\|[0-9]\+\|#\)\+)\)\|\({\(\a\+\|[0-9]\+\|:\|#\)\+}\)\|\(\[\a\+\]\)\)\{0,3}\./
syn match txtFootnoteDef    /^fn[0-9]\+\(\((\(\a\+\|[0-9]\+\|#\)\+)\)\|\({\(\a\+\|[0-9]\+\|:\|#\)\+}\)\|\(\[\a\+\]\)\)\{0,3}\./
syn match txtListBullet     /\v^\*+ /
syn match txtListBullet2    /\v^(\*\*)+ /
syn match txtListNumber     /\v^#+ /
syn match txtListNumber2    /\v^(##)+ /

syn cluster txtBlockElement contains=txtHeader,txtBlockElement,txtFootnoteDef,txtListBullet,txtListNumber


" Everything after the first colon is from RFC 2396, with extra
" backslashes to keep vim happy...  Original:
" ^(([^:/?#]+):)?(//([^/?#]*))?([^?#]*)(\?([^#]*))?(#(.*))?
"
" Revised the pattern to exclude spaces from the URL portion of the
" pattern. Aaron Bieber, 2007.
syn match txtLink /"[^"]\+":\(\([^:\/?# ]\+\):\)\?\(\/\/\([^\/?# ]*\)\)\?\([^?# ]*\)\(?\([^# ]*\)\)\?\(#\([^ ]*\)\)\?/

syn cluster txtInlineElement contains=txtEmphasis,txtBold,txtCite,txtDeleted,txtInserted,txtSuper,txtSub,txtSpan

if version >= 508 || !exists("did_txt_syn_inits")
    if version < 508
        let did_txt_syn_inits = 1
        command -nargs=+ HiLink hi link <args>
    else
        command -nargs=+ HiLink hi def link <args>
    endif
    HiLink txtFootnoteRef Comment

    HiLink txtHeader Title
    HiLink txtHeader2 Question
    HiLink txtHeader3 Statement
    HiLink txtBlockquote Comment
    HiLink txtFootnoteDef Comment
    HiLink txtListBullet Operator
    HiLink txtListBullet2 Constant
    HiLink txtListNumber Operator
    HiLink txtListNumber2 Constant
    HiLink txtLink String
    HiLink txtCode Identifier
    HiLink txtRootHeader Title
    HiLink txtRootHeaderStart Comment
    HiLink txtRootIds Identifier

    HiLink txtHitagsStart Comment
    HiLink txtHitags String
    HiLink txtHitagsIds Identifier

    hi def txtEmphasis term=underline cterm=underline gui=italic
    hi def txtBold term=bold cterm=bold gui=bold

    delcommand HiLink
endif

" vim: set ai et sw=4 :
