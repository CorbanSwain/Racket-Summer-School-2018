#lang brag
taco-program: ( whitespace taco-leaf whitespace )*
taco-leaf: open ( whitespace
                  ( taco | not-a-taco )
                  whitespace ){7} close
taco: /"%"
not-a-taco: open whitespace close
@open: /"#"
@close: /"$"
@whitespace: /( " " | "\r" | "\n" | "\t" )* 