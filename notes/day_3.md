# Day 3 - Matthew Butterick
* https://beautifulracket.com/racket-school-2018/

## Introduction
* goals --> pay attention to grammar!

## PL-checklist
* 2 peicies of a #lang
  1. reader
  2. expander
* can pass off the 

## Tacopocolypse
* figuring out the code
```
  0  1  2  3  4  5  6
# #$ #$ #$ #$ #$ #$ #$ $    (() () () () () () ())
# #$ #$ #$ #$ #$ #$ %  $    (() () () () () () taco)
# #$ #$ #$ #$ %  %  %  $    (() () () () taco taco taco)
# %  #$ #$ #$ #$ #$ #$ $    (taco () () () () () ())

# -> (
$ -> )
% -> taco
```

## Taco Victory
### **Lex -> Parse -> Expand**


  
