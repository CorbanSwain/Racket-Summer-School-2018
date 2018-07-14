#lang racket

(require (for-syntax syntax/parse
                     syntax/stx
                     syntax/id-table))
(provide (rename-out [typechecking-mb #%module-begin])
         + if λ : ->)
 
; A TyStx is a syntax object representing a type.
; A ExprStx is a syntax object representing an expression.
; A IdStx is an identifier syntax object.

(define-syntax : #'(error "expression not allowed"))
(define-syntax -> #'(error "expression not allowed"))

 
; TODO: complete this function
; compute: ExprStx -> TyStx
; computes the type of the given term
(define-for-syntax (compute e ctx)
  (syntax-parse e
    #:literals (if + λ : ->)
    [_:integer #'Int]
    [_:string #'String]
    [_:boolean #'Bool]
    [+ (compose-function-type #'(Int Int) #'Int)]
    [if (compose-function-type #'(Bool T T) #'T)]
    [x:id
     #:do [(define var? (lookup-env ctx #'x))]
     #:when var?
     var?]
    [(if e1 e2 e3)
     #:when (check ctx #'e1 #'Bool)
     #:with t2 (compute #'e2 ctx)
     #:when (check ctx #'e3 #'t2)
     #'t2]
    [(+ e1 e2)
     #:with plus-type #'Int
     #:when (and (check ctx #'e1 #'plus-type)
                 (check ctx #'e2 #'plus-type))
     #'plus-type]
    [(λ ([arg-id : arg-type] ...) expr)
     #:do [(define new-ctx
             (for/fold ([new-ctx ctx])
                       ([id (syntax->list #'(arg-id ...))]
                        [type (syntax->list #'(arg-type ...))])             
               (add-to-env new-ctx id type)))]
     (compose-function-type #'(arg-type ...) (compute #'expr new-ctx))]
    [e (raise-syntax-error
        'compute
        (format "could not compute type for term: ~a"
                (syntax->datum #'e))
        #'e)]))

(define-for-syntax (compose-function-type in-ty out-ty)
  #`(-> #,in-ty #,out-ty))

; check : ExprStx TyStx -> Bool
; checks that the given term has the given type
(define-for-syntax (check ctx e t-expected)
  (define t (compute e ctx))
  (or (type=? t t-expected)
      (raise-syntax-error
       'check
       (format "error while checking term ~e: expected ~a; got ~a"
               (syntax->datum e)
               (syntax->datum t-expected)
               (syntax->datum t))
       e)))
 
; type=? : TyStx TyStx -> Bool
; type equality here is is stx equality
(define-for-syntax (type=? t1 t2)
  (or (and (identifier? t1) (identifier? t2) (free-identifier=? t1 t2))
      (and (stx-pair? t1) (stx-pair? t2)
           (= (length (syntax->list t1))
              (length (syntax->list t2)))
           (andmap type=? (syntax->list t1) (syntax->list t2)))))
 
(define-syntax typechecking-mb
  (syntax-parser
    [(_ e ...)
     ; prints out each term e and its type, it if has one;
     ; otherwise raises type error
     #:do[(define ctx mk-empty-env)
          (stx-map
           (λ (e)
             (printf "~a : ~a\n"
                     (syntax->datum e)
                     (syntax->datum (compute e ctx))))
           #'(e ...))]
     ; this language only checks types,
     ; it doesn't run anything
     #'(#%module-begin (void))]))


; A TyEnv is a [ImmutableFreeIdTableOf IdStx -> TyStx]
 
; mk-empty-env : -> TyEnv
; Returns a new type environment with no bindings.
(define-for-syntax mk-empty-env
  (make-immutable-free-id-table))

; add-to-env : TyEnv IdStx TyStx -> TyEnv
; Returns a new type environment that extends the given env with the given binding.
(define-for-syntax (add-to-env env id ty)
  (free-id-table-set env id ty))
 
; lookup-env : TyEnv IdStx -> TyStx or #f
; Looks up the given id in the given env and returns corresponding type. Returns false if the id is not in the env.
(define-for-syntax (lookup-env env id)
  (free-id-table-ref env id #f))
