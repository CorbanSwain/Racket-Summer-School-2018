#lang br/quicklang

(module+ reader
  (provide read-syntax))

(define (atom? x) (not (pair? x)))

(define (tokenize ip)
  (for/list ([tok (in-port read ip)])
    tok))

(define (parse toks)
  (cond
    [(empty? toks) empty]
    [(atom? toks) 'taco]
    [else (cons (parse (car toks)) (parse (cdr toks)))]))

(define (read-syntax src ip)
  (define toks (tokenize ip))
  (define parse-tree (parse toks))
  (strip-context
   (with-syntax ([(PT ...) parse-tree])
     #'(module tacofied racket
         'PT ...))))