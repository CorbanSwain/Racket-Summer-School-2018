#lang racket

(require (for-syntax syntax/parse))
(require rackunit)

;; SYNTAX
;; (some e0:expr e1:expr ... en:expr)
;; produces a list of all non-#f results of the given expressions
;; until is encounters #f the syntax indicates ther there is at
;; least one expression through there might be arbitriarilly many
;; if thefirst expression yeilds #f then (some ...) returns #f

(define-syntax (some stx)
  (syntax-parse stx
    [(_ e0:expr)
     #'(let ([the-value-of-e0 e0])
     (and the-value-of-e0 (list the-value-of-e0)))]
    [(_ e0:expr e1:expr ...)
     ;; combine is not in a code context
     #'(combine e0 (some e1 ...))]))


;; note the the parameters to the function need to be unquoted
;; since we are defining for syntax
;; the function parameters are not pattern variables
(define-syntax (combine stx)
  (syntax-parse stx
    [(_ e0 some-of-e1)
     #'(let ([v e0])
         (if v
             (let ([w some-of-e1])
               (if (cons? w)
                   (cons v w)
                   (list v)))
             #f))]))

(check-equal? (some #f) #f)
(check-equal? (some 3) '(3))
(check-equal? (some #f #f) #f)
(check-equal? (some 1 2 #f 3) '(1 2))
(check-equal? (some 1 2 #f (displayln 'hello?)) '(1 2))
(check-equal? (some #f #f #f #f 1 2 3) #f)
          