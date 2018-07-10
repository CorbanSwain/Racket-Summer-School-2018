#lang racket
;; foo.rkt
(define the-x-id #'x)
(syntax/loc the-x-id (+ 1 2))
;; syntax object from foo.rkt:3:19