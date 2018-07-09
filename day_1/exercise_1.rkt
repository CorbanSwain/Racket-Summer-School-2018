#lang racket

(require rackunit)
(require (for-syntax syntax/parse))

(define-syntax (define-world* stx)
  (syntax-parse stx
    [(_ args:id ...)
     #'(begin
         (define counter 0)
         (define args
           (begin0
             counter
             (set! counter (+ 1 counter)))) ... )]))


(define-world* a)
(check-equal? a 0)

(define-world* x y z)
(check-equal? (x) 0)
(check-equal? (y) 1)
(check-equal? (z) 2)