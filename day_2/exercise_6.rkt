#lang racket

#|
Exercise 6. Develop the macro where, which is a kind of backward let that has an expression followed by a binding that can be used by the expression. The binding is evaluated before the expression (even though it appears later). For example,

```
(where (+ my-favorite-number 2)
  [my-favorite-number 8])
```
produces 10.

After you have where with a single binding working, generalize it to support multiple bindings. With that generalization,
```
(where (op 10 (+ my-favorite-number an-ok-number))
  [my-favorite-number 8]
  [an-ok-number 2]
  [op *])
```
produces 100.

Now implement where*, which is a backwards let* that evaluates its clauses and binds in reverse order:
(where* (list x y z)
  [x (+ y 4)]
  [y (+ z 2)]
  [z 1])
produces the same values as (list 7 3 1). image
|#



(require rackunit)
(require (for-syntax syntax/parse))

;; one argument case
(define-syntax (where-simple stx)
  (syntax-parse stx
    [(_ se:expr [name:id value:expr])
     #'(local [(define name value)]
         se)]))


(define a (where-simple (+ my-favorite-number 2)
                 [my-favorite-number 8]))
(check-equal? a 10)

;; multi-argument case
(define-syntax (where stx)
  (syntax-parse stx
    [(_ se:expr [name:id value:expr] ...)
     #'(let ([name value] ...)
         se)]))

(define x (where (+ a b)
                 [a (+ 4 4)] [b 2]))
(check-equal? x 10)