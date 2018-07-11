#lang br/quicklang

(require bitsyntax)

(module+ reader
  (provide read-syntax))

(define (tokenize ip)
  ;; provides a list of integers
  (for/list ([tok (in-port read-char ip)])
    (char->integer tok)))

(define (integer->binary n width)
  (cond
    [(zero? width) empty]
    [else
     (define p (sub1 width))
     (define val (expt 2 p))
     (cond
       [(< n val) (cons 0 (integer->binary n p))]
       [else (cons 1 (integer->binary (- n val) p))])]))

(define (parse toks)
  (define (boolean->taco b) (if (= b 1) 'taco empty))
  (define (taco-rep n)
    (reverse (map boolean->taco (integer->binary n 7))))
  (map taco-rep toks))

(define (parse-2 toks)
  (for/list ([tok (in-list toks)])
    (define int (char->integer tok))
    (for/list ([bit (in-range 7)])
      (if (bitwise-bit-set? int bit)
          'taco
          null))))

(define (read-syntax src ip)
  (define toks (tokenize ip))
  (define parse-tree (parse toks))
    (strip-context
     (with-syntax ([PT parse-tree])
       #'(module tacofied racket
           (for-each displayln 'PT)))))
