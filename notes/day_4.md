# Day 3 - Type Systems (Static)

## Introduction
* one of the "Holy Grails" of PL research is to predict a programs behavior
  * launching a rocket
  * avoiding malware
  * refactoring code
* The halting problem
* Enter type systems ... a lightweight syntatic analysis the
  approximates a systems behavior
  * validate function arguments (prevent bugs)
  * Rust, check memory saftey (aviod malware)
  * verify program properties (prove equivalence)
* Matthias .. "you dont need a type system to build a type driven
  language"
### *How do we create typed languages*
  1. Incorporate types into the grammar
  2. Come up with a language of types
```
Type = (-> Type ...)
     | Number
     | Boolean
     | String
```
     * structural vs. nominal typing
  3. Develop type ruled for each language construct
  4. Implement a type chaecker

### Type Judgements
* "It is true (provable) that,
```
-----------------
⊢ <string> : String
```
