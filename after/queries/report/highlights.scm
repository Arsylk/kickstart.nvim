; highlights.scm
; Define the report header section
(
  [
    (atx_heading (atx_h4_marker) heading_content: (inline) @metadata.header)
    .
    (atx_heading
      (atx_h4_marker)
      heading_content: (inline
        (link
          text: (inline
            ; Extract app name
            (text) @app.name (#match? @app.name "^\\[.+\\s\\(Version")
            ; Extract version number
            (text) @app.version (#match? @app.version "Version\\s\\d+")
          )
          ; Extract URL
          url: (inline) @app.url
        )
      )
    )
    .
    (block_quote
      (paragraph
        (atx_heading
          (atx_h5_marker)
          heading_content: (inline
            (text) @verdict.label (#eq? @verdict.label "Verdict: ")
            ; Extract verdict value
            (emphasis (text) @verdict.value)
            (text) @verdict.for (#eq? @verdict.for " for ")
            ; Extract risk type
            (code_inline) @verdict.type
          )
        )
      )
    )
  ]
) @report.header.section

; App name extraction - clean up the format
((text) @app.name.clean
 (#match? @app.name "^%[.+\\s\\%(Version")
 (#gsub! @app.name "^%[(.+)\\s\\%(Version.*$" "%1"))

; Version number extraction - clean up the format
((text) @app.version.clean
 (#match? @app.version "Version\\s\\d+")
 (#gsub! @app.version "Version\\s(\\d+)" "%1"))

; Verdict value emphasis
((emphasis (text) @verdict.value))

; Risk type in code block
((code_inline) @verdict.type
 (#gsub! @verdict.type "`(.+)`" "%1"))
