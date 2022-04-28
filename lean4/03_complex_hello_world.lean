-- Source: https://leanprover.github.io/lean4/doc/whatIsLean.html

-- Defines a function that takes a name and produces a greeting.
def getGreeting (name : String) := s!"Hello, {name}! Isn't Lean great?"

-- The `main` function is the entry point of your program.
-- Its type is `IO Unit` because it can perform `IO` operations (side effects).
def main : IO Unit :=
  -- Define a list of names
  let names := ["Sebastian", "Leo", "Daniel"]

  -- Map each name to a greeting
  let greetings := names.map getGreeting

  -- Print the list of greetings
  for greeting in greetings do
    IO.println greeting

