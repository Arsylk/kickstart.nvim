
; App name extraction
((text) @app.name
 (#match? @app.name "^%[.+\\s\\%(Version")
 (#gsub! @app.name "^%[(.+)\\s\\%(Version.*$" "%1"))

; Version number extraction
((text) @app.version
 (#match? @app.version "Version\\s\\d+")
 (#gsub! @app.version "Version\\s(\\d+)" "%1"))

; App URL extraction
((inline) @app.url
 (#match? @app.url "%(.*://.+%)"))
 (#gsub! @app.url  "%((.*://.+)%)" "%1"))

; Verdict value extraction
((emphasis (text) @verdict.value))

; Risk type extraction
((code_inline) @risk.type
 (#gsub! @risk.type "`(.+)`" "%1"))

; Tags extraction
((text) @tags
 (#match? @tags "^#[A-Za-z0-9_]+"))

; Signal strength extraction
((text) @signal.strength
 (#match? @signal.strength "Signal Strength: (Weak|Medium|Strong)"))

