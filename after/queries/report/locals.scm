; Define app name
((text) @app.name
 (#match? @app.name "^%[.+\\s\\%(Version")
 (#gsub! @app.name "^%[(.+)\\s\\%(Version.*$" "%1"))
 @definition.var

; Define app version
((text) @app.version
 (#match? @app.version "Version\\s\\d+")
 (#gsub! @app.version "Version\\s(\\d+)" "%1"))
 @definition.var

; Define app URL
((inline) @app.url
 (#match? @app.url "%(.*://.+%)"))
 (#gsub! @app.url  "%((.*://.+)%)" "%1"))
 @definition.var

; Define verdict value
((emphasis (text) @verdict.value))
 @definition.var

; Define risk type
((code_inline) @risk.type
 (#gsub! @risk.type "`(.+)`" "%1"))
 @definition.var

; Define tags
((text) @tags
 (#match? @tags "^#[A-Za-z0-9_]+"))
 @definition.constant

; Define signal strength ratings
((text) @signal.strength
 (#match? @signal.strength "Signal Strength: (Weak|Medium|Strong)"))
 @definition.property
