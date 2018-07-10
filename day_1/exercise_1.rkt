#lang racket

(require rackunit)
(require (for-syntax syntax/parse))

;; mutation 
(define-syntax (define-world* stx)
  (syntax-parse stx
    [(_ args:id ...)
     #'(begin
         (define counter 0)
         (define args
           (begin0
             counter
             (set! counter (+ 1 counter)))) ... )]))

;; manual/procedural manipulation of syntax
(define-syntax (define-world-2* stx)
  (syntax-parse stx
    [(x:id ...)
     (define the-list (syntax->list #'(x ...)))
     (define len (length the-list))
     (define nms (range len))
     (define par (map (lambda (id i) #`(define #,id #,i))
                      the-list
                      nms))
     #`(begin #,@par)]))


(define-world* a)
(check-equal? a 0)

(define-world* x y z)
(check-equal? x 0)
(check-equal? y 1)
(check-equal? z 2)