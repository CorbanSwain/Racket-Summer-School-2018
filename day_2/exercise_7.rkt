#lang racket

#|
Exercise 7. Develop the macro and/v, which is like and except that it binds the result of its first expression to a variable written => identifier. For example,
(and/v 1 => x (+ x 1))

evaluates to 2, but
(and/v #f => x (+ x 1))

evaluates to #f. You can use #:literals in syntax-parse, since => is already bound (assuming you think that binding’s reuse is appropriate).
After getting and/v to work, make the => identifier part optional. Note that both => and identifier must be both omitted or both present. image
|#


(require rackunit)
(require (for-syntax syntax/parse))

;; may be better to go with the simple case of using two macros
;; usint (~optional (~seq ...)) can have unexpected results
(define-syntax (and/v stx)
  (syntax-parse stx
    #:literals (=>)
    [(_ s1:expr (~optional (~seq => name:id)) s2:expr)
     #'(let ((~? [name s1]))
       (and s1 s2))]))

(check-equal? (and/v 1 => x (+ x 1)) 2)
(check-equal? (and/v #f => x (+ x 1)) #f)
(check-equal? (and/v #f (+ 2 1)) #f)