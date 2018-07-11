#lang racket
(require (for-syntax syntax/parse))

(module reader syntax/module-reader
  atomic-taco)

(provide #%module-begin
         (rename-out [app #%app]
                     [datum #%datum]
                     [top-interact #%top-interaction]))

(define-syntax (app stx)
  (syntax-parse stx
    [(_ f args ...)
     #'`(taco ,args ...)]))

(define-syntax (datum stx)
  (syntax-parse stx
    [(_ . d)
     #''taco]))

(define-syntax (top-interact stx)
  (syntax-parse stx
    [(_ . e) #'e]))