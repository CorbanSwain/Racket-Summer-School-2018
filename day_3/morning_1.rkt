#lang racket
(define ip (open-input-string "(Some cool text (no)) (foo)"))
(read ip)
(list? (read ip))
(eof-object? (read ip))
