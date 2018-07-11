#lang br
(require brag/support)
(define lex (lexer
             ;; wants to match "fo" and will return "fe"
             ["fo" lexeme]

             ;; `::` looks for a sequence "f" followed
             ;; by any number of "o"'s
             [(:: "f" (:+ "o")) 42]

             ;; any other character will be skipped
             [any-char (lex input-port)]))

(for/list ([tok (in-port lex
                         (open-input-string "foobar"))])
  tok)
;; '(42)


(for/list ([tok (in-port lex
                         (open-input-string "fobar"))])
  tok)
;; '("fo")
;; both first and second rule match