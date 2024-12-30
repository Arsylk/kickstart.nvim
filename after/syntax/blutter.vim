" String handling
syn region asmString start=+"+ skip=+\\\\\|\\"+ end=+"+ oneline


" Assembly syntax
match asmPcode /r[0-9]\+/
syn match asmComment /;.*$/
syn match asmLabel /\v[\s]*[a-zA-Z0-9_]+:/
syn match asmOffset /\/\/ *0[xX][0-9a-fA-F]\+:/
syn match asmMemory /\[[-zA-Z0-9_,#\s+-]+\]/
syn match asmAddress "-\=\<\d\+L\=\>\|0[xX][0-9a-fA-F]\+\>"
syn keyword asmRegister x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 x18 x19 x20 x21 x22 x23 x24 x25 x26 x27 x28 x29 x30 x31 x32 w0 w1 w2 w3 w4 w5 w6 w7 w8 w9 w10 w11 w12 w13 w14 w15 w16 w17 w18 w19 w20 w21 w22 w23 w24 w25 w26 w27 w28 w29 w30 w31 w32 fp lr
syn keyword asmInstruction ldr mov stp cmp b\.ls b\.ne bl ret add ldp ubfx sub stur tbnz tbz sbfiz ldur str
syn match asmFunction /\w\+\s*(\_.\{-})/

syn match asmBraces "[{}\[\]]"
syn match asmParens "[()]"

" Highlighting
hi def link asmString String
hi def link asmInstruction Keyword
hi def link asmRegister Label
hi def link asmOffset Delimiter
hi def link asmPcode Character
hi def link asmComment Comment
hi def link asmMemory Special
hi def link asmAddress Number
hi def link asmLabel Type
hi def link asmFunction Function

let b:current_syntax = "blutter"
