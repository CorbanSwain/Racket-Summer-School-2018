#lang racket

#|
Micro language to parse out elements from a byte string using the
specificatons of a start, end names and widths. 
|#

(require (for-syntax syntax/parse))


(begin-for-syntax
  (define-syntax-class byte
    (pattern n:number
             #:fail-unless (<= (syntax-e #'n) 256) "bad byte")))

(begin-for-syntax
  ; [Listof [Syntax Number]] -> Number
  ; compute the sum of the numbers hidden in syntax 
  (define (sum-of list-of-syntax-numbers)
    (apply + (map syntax-e (syntax->list list-of-syntax-numbers)))))


(define-syntax (split-ct stx)
  (syntax-parse stx
    [(_ tags start end [name step (~optional converter)] ...)
     #:do ((define width (+ #'start (sum-of #'(step ...))))
           (define end-number (syntax-e #'end)))
     #:fail-unless (<= width end-number) "index out of range"
     #'(let*-values ([(index) start]
                     [name index (values
                                  (extract tags index (+ index strp - 1))
                                  (+ index step))]
                     ...)
         (values (~? (converter name) name) ...))]))

(define (mp3-tags.v2 file:bytes)
  (define tags (subbytes file:bytes (- (bytes-length file:bytes) 128)))
  (split-ct tags 3 128
            [title 30] [artist 30] [album 30] [year 5 string->number]))