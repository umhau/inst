#!/bin/bash

# The parser for Julia is implemented in Femtolisp, a dialect of Scheme (Julia 
# is inspired by Scheme, which in turn is a Lisp dialect). 

cd ~/system/
[ ! -d ./femtolisp ] && git clone https://github.com/JeffBezanson/femtolisp.git
