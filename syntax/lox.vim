:if exists("b:current_syntax")
:  finish
:endif

" keywords
syn keyword loxKeyword class fun var print
syn keyword loxKeyword for while return

" booleans
syn keyword loxBoolean true false

" constants
syn keyword loxConstant nil

" functions
syn keyword loxFunctionStatement fun nextgroup=loxFunction skipwhite
syn match loxFunction	"\h\w*" display contained

" operators
syn match loxOperator "\v\*"
syn match loxOperator "\v\+"
syn match loxOperator "\v\-"
syn match loxOperator "\v/"
syn match loxOperator "\v\="
syn match loxOperator "\v!"

" conditionals
syn keyword loxConditional if else and or else

" numbers
syn match loxNumber "\v\-?\d*(\.\d+)?"

" strings
syn region loxString start="\v\"" end="\v\""

" comments
syn match loxComment "\v//.*$"

hi def link loxKeyword Keyword
hi def link loxBoolean Boolean
hi def link loxConstant Constant
hi def link loxFunction Function
hi def link loxFunctionStatement Statement
hi def link loxOperator Operator
hi def link loxConditional Conditional
hi def link loxNumber Number
hi def link loxString String
hi def link loxComment Comment

:let b:current_syntax = "lox"
