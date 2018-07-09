#lang racket

(require (for-syntax racket/list))
(require (for-syntax syntax/parse))
(require rackunit)

(define-syntax (define-rewrite-rule stx)
  (syntax-parse stx
    [(_ pattern:expr template:expr)
     #'(define-syntax ((first pattern) stx2)
         
       

(define-rewrite-rule
  (loop-for-ever exp)
  ; —> 
  (local ((define (for-ever) (begin exp (for-ever)))) (for-ever)))
;; vvvvvvvvvvvvvvvvvvvvvvv
(define-syntax (loop-for-ever stx)
  (syntax-parse stx
    [(_ exp)
     ((local ((define (for-ever) (begin exp (for-ever)))) (for-ever)))]))
  