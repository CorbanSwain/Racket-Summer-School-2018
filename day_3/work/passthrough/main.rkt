#lang racket
(module reader syntax/module-reader
  ;; `passthrough` is the name of the expander
  passthrough)
(provide (all-from-out racket))