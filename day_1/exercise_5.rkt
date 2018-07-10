#lang racket

(require (for-syntax racket/list))
(require (for-syntax syntax/parse))
(require rackunit)

(define-syntax (define-rewrite-rule stx)
  (syntax-parse stx
    [(_ (name:id pattern:expr ...) tmpl:expr)
     #'(define-syntax (name stx)
          (syntax-parse stx
            [(_ pattern ...)
             #'tmpl]))]))
                
(define-rewrite-rule
  (print-twice exp)
  (begin (displayln exp) (displayln exp)))

(print-twice "hello")