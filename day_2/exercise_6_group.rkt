#lang racket

(require (for-syntax racket/list)
         (for-syntax syntax/parse)
         rackunit)

(define-syntax (where* stx)
  (syntax-parse stx
    [(_ body:expr [name:id rhs:expr] ...)
     #`(let* #,(reverse
                (syntax->list #'([name rhs] ...)))
         body)]))

(check-equal? (let ([a 0])
                (where* (+ a b (* a b))
                        [a 120]
                        [b (/ a 75)]))
              (let ([a 0])
                (let* ([b (/ a 75)]
                       [a 120])
                  (+ a b (* a b)))))