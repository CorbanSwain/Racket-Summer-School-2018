# Day 4 - Language Gems

## A survey language
* Thinking about the GUI
* GUI library
```
#lang survey-dsl

form Box1HouseOwning {
   hasSoldHouse: "Did you sell a house in 2010?" boolean
   hasBoughtHouse: "Did you by a house in 2010?" boolean
   hasMaintLoan: "Did you enter a loan for maintenance?" boolean

   if (hasSoldHouse) {
     sellingPrice: "Price the house was sold for:" money
     privateDebt: "Private debts for the sold house:" money
     valueResidue: "Value residue:" money(sellingPrice - privateDebt)
   }
}
```
* Version 0: syntatic abstraction
```racket
(define-simple-macro (form name clause ...)
  (begin
    (define name (make-gui 'name))
```
  * Expand to form clauses
  * expand form clauses
  ```racket
  (define-syntax (form--clause stx)
    (syntax-parse stx
	  #:literals (when)
	  [(_ form-name gaurd (when guard2 nested ...))
	   #'(begin
	       (form-clause form-name (and guard guard2) nested)
		   ...)]
      [(_ form-name guard [id question type])
	   #'(form-clause* form-name guard-expr id question type #f)]
      [(_ form-name guard-expr [id question type expr])
	   #'(form-clause* form-name guard-expr id question type (lambda () expr))]))
   ```
* Version 1
* Version 2 - Module Language `#lang s-exp "survey.rkt`
* Version 3 - Avoiding Duplication
  * You want to prevent excessive code duplication
* Version 4 - Better error messages
* Version 5 - Type Checking
  * Should use turnstile
  * remeber to think about going between compiletime and runtime via
    bridges of define-syntax
	
### Big picture
* SOURCE --[#lang path, #lang reader]--> S-EXPR -> AST

## Jay McCarthy - Teachlog
Repository: *https://github.com/jeapostrophe/teachlog.git*

## Robby - Haiku Lang

## Closing
| You want to abstract over | then use ... | status |
| --- | --- | --- |
| bunches of functions | functional racket | done |
| syntatic patterns | define-syntax racket | done |
| API invariante | #lang Racket | done |
| typing rules | turnstile racket | done |
| languages | LOP racket | research |
|you want ugly syntax? | use lexers and pasers | *unsolved* |

* The racket lang homepage http://racket-lang.com
  * community box 
  * *seed of the idea of racket was going into the community to help*
  * racket IRC and slack channel
  * eigth RacketCon, September 29 - 30
	* 29th - talks and presentations
	* working groups and tutorial groups for help with projects
