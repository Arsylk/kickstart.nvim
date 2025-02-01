;extends
(new_expression
  constructor: (identifier) @ctor
    (#eq? @ctor "CModule")
  arguments: (arguments
    (_) @injection.content
      (#offset! @injection.content 1 0 -1 0)
      (#set! injection.include-children)
      (#set! injection.language "c")))


