#lang turnstile/quicklang
(provide
 Int String Bool ->
 (rename-out [typed-datum #%datum]
             [typed+ +]
             [typed-app #%app]
             [typed-if if]
             [typed-λ λ]))

(define-base-types Int String Bool)
(define-type-constructor -> #:arity > 0)

;; \gg -> ≫
;; \vdash -> ⊢
;; \RightArrow -> ⇒
;; \Leftarrow -> ⇐

(define-typerule typed-datum
  [(_ . n:integer) ≫
   -----------------------
   [⊢ (#%datum . n) ⇒ Int]]
  [(_ . n:boolean) ≫
   ------------------------
   [⊢ (#%datum . n) ⇒ Bool]]
  [(_ . n:string) ≫
   ---------------------------
   [⊢ (#%datum . n) ⇒ String]])

(define-primop typed+ + : (-> Int Int Int))

(define-typerule typed-app
  [(_ f e ...) ⇐ tout ≫
               [⊢ e ≫ e- ⇒ tin] ...
               [⊢ f ≫ f- ⇐ (~-> tin ... tout)]
               ---
               [⊢ (#%app  f- e- ...)]]
  [(_ f e ...) ≫
               [⊢ f ≫ f- ⇒ (~-> tin ... tout)]
               #:do [(define arity-expect
                       (length (syntax->list #'(tin ...))))
                     (define arity-in
                       (length (syntax->list #'(e ...))))] 
               #:fail-unless (= arity-expect arity-in)
               (format "expected ~a arguments, but given ~a."
                       arity-expect
                       arity-in)
               [⊢ e ≫ e- ⇐ tin] ...
               --------------------------------
               [⊢ (#%app  f- e- ...) ⇒ tout]])

(define-typerule typed-if
  #:literals (if)
  [(_ e1 e2 e3) ≫
                [⊢ e1 ≫ e1- ⇐ Bool]
                [⊢ e2 ≫ e2- ⇒ τ]
                [⊢ e3 ≫ e3- ⇐ τ]
                -------------------
                [⊢ (if e1- e2- e3-) ⇒ τ]])

(define-typerule (typed-λ ([x (~datum :) τ] ...) e) ≫
  [[x ≫ x- : τ] ...
   ⊢ e ≫ e- ⇒ τ_out]
  -------------------------------------
  [⊢ (λ (x- ...) e-) ⇒ (-> τ ... τ_out)])