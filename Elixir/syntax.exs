# Syntax checker for Classical Propositional Logic

# Examples:
# atomic formulas:
#  :p
#  :q
#  :r
# negation:
#  [:not, :p]
#  [:not, [:not, :q]]]
# conjunction:
#  [:p, :and, :q]
#  [:p, :and, [:q, :and, :r]]
# disjunction:
#  [:p, :or, :q]
#  [:p, :or, [:q, :or, :r]]
# implication:
#  [:p, :implies, :q]
#  [:p, :implies, [:q, :implies, :r]]

defmodule Syntax  do
  def check([:not, formula]) do
    check(formula)
  end
  def check([left, connective, right]) do
    if connective==:and or connective==:or or connective==:implies do
      check(left) and check(right)
    else
      false
    end
  end
  def check(atom) do
	  is_atom(atom) and not (atomo==:and or atomo==:or or atomo==:implies or atomo==:not)
  end
end

{formula, _} = Code.eval_string IO.gets "Type a formula: "
if Syntax.check(formula) do
  IO.puts "The syntax is correct!"
else
  IO.puts "The syntax is not correct."
end
