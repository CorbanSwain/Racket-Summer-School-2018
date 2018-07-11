#lang racket

#|
Simple language spec:

Definition = (define-function (Variable Variable1 ...)  Expression)
 	 	 	 	 
Expression = (function-application Variable Expression ...)
 	   | (if Expression Expression Expression)
 	   | (+ Expression Expression)
 	   | Variable
 	   | Number
 	   | String
|#

(require (for-syntax syntax/parse)
         rackunit)

(provide #%module-begin
         (rename-out [literal #%datum])
         define-function
         function-app
         (rename-out [my-add +])
         (rename-out [my-if if]))

(define-syntax (literal stx)
  (syntax-parse stx
    [(_ . n:number) #' 'n]
    [(_ . s:string) #' 's]
    [(_ . b:boolean) #' 'b]
    [(_ . other)
     (raise-syntax-error 'simple
                         "you can only write a number, string, or boolean"
                         #'other)]))

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

(define-syntax (my-add stx)
  (syntax-parse stx
    [(_ a:expr b:expr)
     #'(+ a b)]))

(define-syntax (my-if stx)
  (syntax-parse stx
    [(_ s1:expr s2:expr s3:expr)
     #'(if s1 s2 s3)]))

;; define-operator-syntax recepie
(define-syntax (define-operator-syntax stx)
  (syntax-parse stx
    [(_ [old-n:id new-n:id args:expr ...] ...)
     #'(begin
         (define-syntaxes (new-n ...)
           (values (cons (length (syntax->list #'(args ...)))
                         ;; QUESTION How to use lambda by referencing the
                         ;; argument number
                         ;; not built in, there is a macro you could build
                         ;; would have to build an identifier
                         #;((lambda-n (2) (+ $1 ...)) 5 10) ; 15
                         #'(lambda (args ...) (old-n args ...)))
                   ...))
         (provide)]))
;; QUESTION - how to do more than one thing here within a syntax
;; begin and values dont work because define-syntaxes goes out of
;; top level

#;
(define-operator-syntax
  [expt my-expt b]
  [zero? my-zero? a]
  [log my-log n b]
  [< my-< a b]
  [= my-= a b])
;; ^^^ becomes vvv
#;
(define-syntaxes
  (my-expt my-zero? my-log < my-=)
  ((cons (length '(a b)) #'(lambda (a b) (expt a b)))
   (cons (length '(a)) #'(lambda (a) (zero? a)))
   (cons (length '(n b)) #'(lambda (n b) (log n b)))
   (cons (length '(a b)) #'(lambda (a b) (< a b)))
   (cons (length '(a b)) #'(lambda (n b) (= n b)))))

;; QUESTION - how to programmitically generate argument lists for lambda
;; or anything?
#;
(define-operator-syntax
  [my-expt expt 2])
;; ^^^ becomes vvv
#;
(define-syntaxes (my-expt)
  (cons 2 #`(begin
              (define arg-list ***magic***)
              (lambda (arglist) (exp arg-list)))))


;; QUESTION - how to programitacally create an identifier?
#; (datum->syntax (string->symbol "var"))
#;
(define-operator-syntax
  [expt a b])
;; ^^^ becomes vvv
#;
(define-syntaxes (**magic** expt) ; my-expt gets defined
  (cons 2 #`(begin
              (define arg-list ***magic***)
              (lambda (arglist) (exp arg-list)))))


(define-operator-syntax
  [expt my-expt a b]
  [zero? my-zero? a]
  [log log-b n b]
  [< lt a b]
  [> gt a b]
  [<= lte a b]
  [>= gte a b]
  [= eq? a b]
  [- minus a b]
  [+ plus a b]
  [string-append string+ a b]
  [/ divide a b]
  [quotient idivide a b]
  [remainder rem a b]
  [modulo mod a b]
  [add1 my-add1 a]
  [sub1 my-sub1 a]
  [abs my-abs a]
  [round my-round a]
  [sqrt my-sqrt a]
  [integer-sqrt isqrt a])

(provide log-b
         lt
         gt
         lte
         gte
         eq?
         minus
         plus
         idivide
         rem
         mod
         isqrt
         string+
         (rename-out [my-expt expt]
                     [my-zero? zero?]
                     [my-add1 add1]
                     [my-sub1 sub1]
                     [my-abs abs]
                     [my-round round]
                     [my-sqrt sqrt]))
