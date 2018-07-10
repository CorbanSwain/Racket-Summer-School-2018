#lang racket

#|
https://summer-school.racket-lang.org/2018/plan/mon-aft-lab.html

Exercise 9. Start with the code from lecture and add the following pre-defined, arity-checked functions:
plus, which takes two number arguments and adds them;

minus, which takes two number arguments and subtracts them; and

string+, which takes two srting arguments and concatenates them.

Add these without using define-function.
For example, `(function-app plus 1 2)` should produce 3, but your implementation should not include `(define-function (plus x y) ***)`.

These primitives must work with the protocol from lecture. If you fancy adding other pre-defined function, please feel free to do so.
|#


(require (for-syntax syntax/parse)
         rackunit)

(define-syntax (define-function stx)
  (syntax-parse stx
    [(_ (function-name:id parameter:id ...) body:expr)
     (define arity (length (syntax->list #'(parameter ...))))
     #`(define-syntax function-name
         (cons #,arity #'(lambda (parameter ...) body)))]))

(define-syntax (function-app stx)
  (syntax-parse stx
    [(_ function-name:id argument:expr ...)
     #:do [(define-values (arity function) (lookup #'function-name stx))]
     #:fail-unless (= arity (length (syntax->list #'(argument ...))))
     "wrong number of arguments"
     #`(#,function argument ...)]))

(define-for-syntax (lookup function-name stx)
  (define (when-it-fails)
    (raise-syntax-error #f "not defined" stx))
  (define x (syntax-local-value function-name when-it-fails))
  (values (car x ) (cdr x)))


(define-syntax plus
  (cons 2 #'(lambda (a b) (+ a b))))

(define-syntax minus
  (cons 2 #'(lambda (a b) (- a b))))

(define-syntax string+
  (cons 2 #'(lambda (a b) (string-append a b))))

;; Tests
(let ([a 1] [b 2])
  (check-equal? (function-app plus a b)
                (+ a b))
  (check-equal? (function-app minus a b)
                (- a b)))

(let ([a "Hello"] [b "Goodbye"])
  (check-equal? (function-app string+ a b)
                (string-append a b)))


