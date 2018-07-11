#lang racket
(require (for-syntax syntax/parse))

(define-syntax then
  #'(error "then not allowed as an expression"))
(define-syntax else
  #'(error "else not allowed as an expression"))

(provide #%module-begin
         (rename-out [literal #%datum])
         (rename-out [plus +])
         (rename-out [if-cond if])
         (rename-out [bad-parens #%app])
         then
         else)

(define-syntax (literal stx)
  (syntax-parse stx
    [(_ . n:number) #' 'n]
    [(_ . s:string) #' 's]
    [(_ . b:boolean) #' 'b]
    [(_ . other)
     (raise-syntax-error 'simple
                         "you can only write a number or string"
                         #'other)]))

(define-syntax (plus stx)
  (syntax-parse stx
    [(_ a:expr b:expr)
     (syntax/loc stx (+ a b))]))

(define-syntax (bad-parens stx)
  (raise-syntax-error 'parens
                      "misuse"
                      stx))

(define-syntax (if-cond stx)
  (syntax-parse stx
    #:literals (then else)
    [(_ se1:expr then se2:expr)
     #'(cond
         [se1 se2])]
    [(_ se1:expr then se2:expr else se3:expr)
     #'(cond
         [se1 se2]
         [#t se3])]))

(module reader syntax/module-reader
  arith)

;; manual version
#;
(module reader racket/base
  (provide (rename-out
           [my-read-syntax read-syntax]))

  (define (get-all src in)
    (define e (read-syntax src in))
    (if (eof-object? e)
        '()
        (cons e (get-all src in))))
  
  (define (my-read-syntax src in)
    (define all (get-all src in))
    #`(module whatever
        #,(datum->syntax #f 'arith) #,@all)))
