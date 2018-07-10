#lang racket

(require (for-syntax syntax/parse))

(define-syntax (define-function stx)
  (syntax-parse stx
    [(_ (function-name:id parameter:id ...) body:expr)
     (define arity (length (syntax->list #'(parameter ...))))
     #`(define-syntax function-name
         (cons #,arity #'(lambda (parameter ...) body)))]))

(define-syntax (function-app stx)
  (syntax-parse stx
    [(_ function-name:id argument:expr ...)
     #:do((define-values (arity function) (lookup #'function-name stx)))
     #:fail-unless (= arity (length (syntax->list #'(argument ...))))
     "wrong number of arguments"
     #`(#,function argument ...)]))

(define-for-syntax (lookup function-name stx)
  (define (when-it-fails)
    (raise-syntax-error #f "not defined" stx))
  (define x (syntax-local-value function-name when-it-fails))
  (values (car x ) (cdr x)))

(define-function (f x y)
  (+ x y))

(define-function (g x)
  (if (zero? x)
      1
      (function-app g 0)))
  
(function-app f 1 2)