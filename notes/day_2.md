# Morning Exercises

## Excercise 6 - more define-syntax
* think about our design recipie
```racket
(define-syntax (---A--- stx) 
	(syntax-parse stx
		[(---B---)
		#'(---C---)]))
```
* The parts
  * A: macro name
  * B: input pattern
  * C: template for evalution
  
1. choose macro name and format by writing example use cases
```racket
;; ---A---
;; where

;; example 1
(where (+ 5 foo)
	[foo 5])
;; > 10

;; example 2
(where (+ 5 foo bar)
	[foo 5]
	[bar (+ 1 1)])
;; > 12
```

2. use this to generate the inputs
```racket
;; ---B--- 
(_ se:expr [name:id value:expr] ...)
```

3. write out, into the examples, what the replacement code should look
   like, ideally in a generalized way.
```racket
;; example 1
(where (+ 5 foo)
	[foo 5])	
;; ^^^ becomes vvv
(let ([foo 5])
	(+ 5 foo))

;; example 2
(where (+ 5 foo bar)
	[foo 5]
	[bar (+ 1 1)])
;; ^^^ becomes vvv
(let ([foo 5]
	  [bar (+ 1 1)])
  (+ 5 foo bar))
```

4. using this pattern generate the evaluation template in terms of the
   generalized inputs
```racket
;; ---C---
(let ([name value] ...)
	se)
```
   
### Questions
* What if we want pass the assignmant clauses to let directly. -->
  Then we need to use more complex parsing to in syntax-parse to
  ensure uniqe assignment pairs are passed.
  
## Module Systems
* `#lang "_____"` with double-quotes goes to a relative path
* `#lang _____` with no quotes speficies a collection
* To import additional modules use `(require _______)`
* To import only specific definitions, use `only-in`
  * you can also rename by specifying a [old new] pair
```racket
(require (only-in racket/list
		          first
				  [second snd]))
```
* Module definitions can be renamed by `(provide (rename-out [old
  new]))`
* `#lang` essentialy creates a module wrapper around the code
  * Original
```racket Original
#lang racket
10
```
  * Becomes ...
```racket Becomes ...
(module whatever racket
  (#%module-begin
   10))
```
* `quote` the module name to declare and bring in nested module
```racket
(module whatever racket
  (module nested racket/base
    (define my-secret-number 10)
    (provide my-secret-number))
	
  (require 'nested)
  my-secret-number 
  ;; 10
  )
```

* module* lets the submodule reference the enclosing module 
```racket
(module whatever racket
  (define x 11)
  (provide x)

  (module* nested racket/base
    (require (submod ".."))
    x 
    ;; 11
    ))
```

* module+ (a special case mof module *) allows the module definition
  to be proken into parts and automatically requires the enclosing
  module
```racket
(module whatever racket
	(define x 11)
	(provide x)

	(module+ nested
		x 
		:; 11
		))
```

## Dealing with syntax
* `syntax/loc`
```racket foo.rkt
#lang racket
;; foo.rkt
(define the-x-id #'x)
(syntax/loc the-x-id (+ 1 2))
;; syntax object from foo.rkt:3:19
```

## Creating a simple language
* working on file arith.rkt and arith-test.rkt
  * using s-expression parser
  * infinite loop from the cr
```racket
#lang racket
(require (for-syntax syntax/parse))

(provide #%module-begin
         (rename-out [zero #%datum]))

(define-syntax (zero stx)
  (syntax-parse stx
    [(_ . n:number) #'n]
    [(_ . s:string) #'s]
    [(_ . other)
     (raise-syntax-error 'simple
                         "you can only write a number or string"
                         #'other)]))
```

## Registering collections
