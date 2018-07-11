#lang br/quicklang
(require brag/support
         "grammar.rkt")
(provide (all-from-out br/quicklang) (all-defined-out))

(module+ reader
  (provide read-syntax))

(define tokenize
  (lexer
   [(union "%" "#$") lexeme]
   [(union "#" "$" whitespace) (tokenize input-port)]))

(define (taco-program . pieces)
    (map integer->char pieces))

(define (taco-leaf . pieces)
  (for/sum ([taco? (in-list pieces)]
            [power (in-naturals)]
            #:when taco?)
    (expt 2 power)))

(define (taco) #t)

(define (not-a-taco) #f)

(define (read-syntax src ip)
  (define token-thunk (λ () (tokenize ip)))
  (define parse-tree (parse token-thunk))
  (strip-context
   (with-syntax ([PT parse-tree])
     #'(module winner taco-victory
         (display (apply string PT))))))