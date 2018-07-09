#lang racket

(require (for-syntax racket/list))
(require (for-syntax syntax/parse))

;; SYNTAX
;; (define-hello world good bye damn it) means the identifier 'world'
;; 'good' bye' 'damn' 'it' is bound to "good bye"
;; translate this to code of the shape (define 2nd-of-given-syntax "good bye")
;; (define world "good")
;; (define good "good")
;; ...

(define-syntax (define-hello stx)
  (syntax-parse stx
    [(_ the-identifier:id ...)
     #'(define-values (the-identifier ...)
         (values (begin 'the-identifier "good bye") ...))]))

(define-hello world good bye damn it)
world ; "good bye"
good  ; "good bye"
bye   ; "good bye"
damn  ; "good bye"
it    ; "good bye"

