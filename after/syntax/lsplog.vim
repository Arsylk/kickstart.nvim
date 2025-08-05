" Vim syntax file
" Language: LSP Log Files
" Maintainer: Custom
" Latest Revision: 2025-07-01

if exists("b:current_syntax")
  finish
endif

" Define log level tags
syntax match lspLogStartTag '\[START\]'
syntax match lspLogWarnTag '\[WARN\]'
syntax match lspLogErrorTag '\[ERROR\]'
syntax match lspLogInfoTag '\[INFO\]'
syntax match lspLogDebugTag '\[DEBUG\]'

" Other patterns
syntax match lspLogTimestamp '\[\d\{4}-\d\{2}-\d\{2} \d\{2}:\d\{2}:\d\{2}\]'
syntax match lspLogPath '\/[a-zA-Z0-9_\-\.\/]*\.\(lua\|jar\|java\|py\|gradle\)'
syntax match lspLogException 'Exception\|Error\|WARNING\|WARN'

" Custom highlight groups for distinct colors
" Highlight groups - each log level gets its own distinct color
highlight def link lspLogStartTag Special
highlight def link lspLogWarnTag WarningMsg
highlight def link lspLogErrorTag ErrorMsg
highlight def link lspLogInfoTag Function
highlight def link lspLogDebugTag Comment

" Optional other highlights
highlight def link lspLogTimestamp Number
highlight def link lspLogPath Directory
highlight def link lspLogException Exception

let b:current_syntax = "lsplog"
