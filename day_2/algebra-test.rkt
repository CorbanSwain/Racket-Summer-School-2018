#lang s-exp "algebra.rkt"
(define-function (a) 5)
(define-function (b) 2)
(define-function (double x) (+ x x))

(function-app a) ; 5
(function-app b) ; 2
(function-app double 2) ; 4
(if 1 2 3) ; 2
(function-app idivide 11 5) ; 2
