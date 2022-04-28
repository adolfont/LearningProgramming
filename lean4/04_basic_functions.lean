-- Source: https://leanprover.github.io/lean4/doc/tour.html

namespace BasicFunctions

-- The `#eval` command evaluates an expression on the fly and prints the result.
#eval 2+2

-- You use 'def' to define a function. This one accepts a natural number
-- and returns a natural number.
-- Parentheses are optional for function arguments, except for when
-- you use an explicit type annotation.
-- Lean can often infer the type of the function's arguments.
def sampleFunction1 x := x*x + 3

-- Apply the function, naming the function return result using 'def'.
-- The variable type is inferred from the function return type.
def result1 := sampleFunction1 4573

-- This line uses an interpolated string to print the result. Expressions inside
-- braces `{}` are converted into strings using the polymorphic method `toString`
#eval println! "The result of squaring the integer 4573 and adding 3 is {result1}"

-- When needed, annotate the type of a parameter name using '(argument : type)'.
def sampleFunction2 (x : Nat) := 2*x*x - x + 3

def result2 := sampleFunction2 (7 + 4)

#eval println! "The result of applying the 2nd sample function to (7 + 4) is {result2}"

-- Conditionals use if/then/else
def sampleFunction3 (x : Int) :=
  if x > 100 then
    2*x*x - x + 3
  else
    2*x*x + x - 37

#eval println! "The result of applying sampleFunction3 to 2 is {sampleFunction3 2}"

end BasicFunctions