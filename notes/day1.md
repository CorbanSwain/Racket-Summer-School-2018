# Day 1

## Introduction
* What about languages? Why do we need another language?
* Programming languages are not a solved problem.
* Code is a medium for communicating your thoughts. --> sending a message to our future selves and mantainers of our code.
* A strange thesis. Every programming languaging has a whole bunch of languages inside of ir already.
  * format strings
  * regular expressions
  * algebreic patter matching of structured data
  ```racket
  (match '(a 1 2 3)
	  [`(a ,x ,y)]
	  []
	  ["error"])
  ```
  * SQL databases
  * funuctional event languages (javascript react)
* Why doesn't the programmer have the ability to build these natively?
* Thesis of racket: empower us to solve these problem ourselves.
* Each module solves a problem, and each module uses the most suitable progrmming language.
  * How do you glue them together well?


## Demos
```racket
(define-syntax (f x)
  #'5)

(f 17 18) ; 5
```
the entire 

```racket
(define-syntax (f x)
  (define e (syntax->list x))
  (second e))

(f 17) ; 16
```

```racket
(define-syntax (define-hello stx)
  #`(define #,(second (syntax->list stx)) "good bye"))
 ```

### syntax-parse is its own sub language
```racket
(define-syntax (define-hello stx)
  (syntax-parse stx
    [(_ the-identifier) #'(define the-identifier "good bye")]))

(define-hello world)
world 
;; "good bye"
```
```racket
(define-syntax (define-hello stx)
  (syntax-parse stx
    [(_ the-identifier) #'(define the-identifier
                            '(the-identifier "the-identifier"))]))

(define-hello world)
world 
;; '(world "the-identifier")
```
* referentially transparent

### using dots
```racket
(define-syntax (define-hello stx)
  (syntax-parse stx
    [(_ the-identifier:id ...)
     #'(define-values (the-identifier ...)
         (values (begin 'the-identifier "good bye") ...))]))

(define-hello world good bye damn it)
world ; "good bye"
good  ; "good bye"
bye   ; "good bye"
damn  ; "good bye"
it    ; "good bye"
```

### using `define-for-syntax` to break up code
```racket
#lang racket

(require (for-syntax syntax/parse))
(require rackunit)

;; SYNTAX
;; (some e0:expr e1:expr ... en:expr)
;; produces a list of all non-#f results of the given expressions
;; until is encounters #f the syntax indicates ther there is at
;; least one expression through there might be arbitriarilly many
;; if thefirst expression yeilds #f then (some ...) returns #f

(define-syntax (some stx)
  (syntax-parse stx
    [(_ e0:expr)
     #'(let ([the-value-of-e0 e0])
     (and the-value-of-e0 (list the-value-of-e0)))]
    [(_ e0:expr e1:expr ...)
     (combine #'e0 #'(some e1 ...))]))


;; note the the parameters to the function need to be unquoted
;; since we are defining for syntax
;; the function parameters are not pattern variables
(define-for-syntax (combine e0 some-of-e1)
  #`(let ([v #,e0])
      (if v
          (let ([w #,some-of-e1])
            (if (cons? w)
            (cons v w)
            (list v)))
          #f)))

(check-equal? (some #f) #f)
(check-equal? (some 3) '(3))
(check-equal? (some #f #f) #f)
(check-equal? (some 1 2 #f 3) '(1 2))
(check-equal? (some 1 2 #f (displayln 'hello?)) '(1 2))
(check-equal? (some #f #f #f #f 1 2 3) #f)
```
* stratification
  * enabling us to work with lists `'(something)` and code `#'(something`
  * signaling to the reader there is code

### version with define-syntax
```racket
#lang racket

(require (for-syntax syntax/parse))
(require rackunit)

;; SYNTAX
;; (some e0:expr e1:expr ... en:expr)
;; produces a list of all non-#f results of the given expressions
;; until is encounters #f the syntax indicates ther there is at
;; least one expression through there might be arbitriarilly many
;; if thefirst expression yeilds #f then (some ...) returns #f

(define-syntax (some stx)
  (syntax-parse stx
    [(_ e0:expr)
     #'(let ([the-value-of-e0 e0])
     (and the-value-of-e0 (list the-value-of-e0)))]
    [(_ e0:expr e1:expr ...)
     ;; combine is not in a code context
     #'(combine e0 (some e1 ...))]))


;; note the the parameters to the function need to be unquoted
;; since we are defining for syntax
;; the function parameters are not pattern variables
(define-syntax (combine stx)
  (syntax-parse stx
    [(_ e0 some-of-e1)
     #'(let ([v e0])
         (if v
             (let ([w some-of-e1])
               (if (cons? w)
                   (cons v w)
                   (list v)))
             #f))]))

(check-equal? (some #f) #f)
(check-equal? (some 3) '(3))
(check-equal? (some #f #f) #f)
(check-equal? (some 1 2 #f 3) '(1 2))
(check-equal? (some 1 2 #f (displayln 'hello?)) '(1 2))
(check-equal? (some #f #f #f #f 1 2 3) #f)
```
* the compiler curries back and forth from calls to the macro defined
  function and the run-time code
  
## Decoding an mp3 file
* Niave solution boilerplate code, everything hard coded
* Haskell style
