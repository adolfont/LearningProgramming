-- Lean has first-class functions.
-- `twice` takes two arguments `f` and `a` where
-- `f` is a function from natural numbers to natural numbers, and
-- `a` is a natural number.
def twice (f : Nat → Nat) (a : Nat) :=
  f (f a)

-- `fun` is used to declare anonymous functions
#eval twice (fun x => x + 2) 10

-- You can prove theorems about your functions.
-- The following theorem states that for any natural number `a`,
-- adding 2 twice produces a value equal to `a + 4`.
theorem twiceAdd2 (a : Nat) : twice (fun x => x + 2) a = a + 4 :=
  -- The proof is by reflexivity. Lean "symbolically" reduces both sides of the equality
  -- until they are identical.
  rfl

-- `(· + 2)` is syntax sugar for `(fun x => x + 2)`. The parentheses + `·` notation
-- is useful for defining simple anonymous functions.
#eval twice (· + 2) 10

-- Enumerated types are a special case of inductive types in Lean,
-- which we will learn about later.
-- The following command creates a new type `Weekday`.
inductive Weekday where
  | sunday    : Weekday
  | monday    : Weekday
  | tuesday   : Weekday
  | wednesday : Weekday
  | thursday  : Weekday
  | friday    : Weekday
  | saturday  : Weekday

-- `Weekday` has 7 constructors/elements.
-- The constructors live in the `Weekday` namespace.
-- Think of `sunday`, `monday`, …, `saturday` as being distinct elements of `Weekday`,
-- with no other distinguishing properties.
-- The command `#check` prints the type of a term in Lean.
#check Weekday.sunday
#check Weekday.monday

-- The `open` command opens a namespace, making all declarations in it accessible without
-- qualification.
open Weekday
#check sunday
#check tuesday

-- You can define functions by pattern matching.
-- The following function converts a `Weekday` into a natural number.
def natOfWeekday (d : Weekday) : Nat :=
  match d with
  | sunday    => 1
  | monday    => 2
  | tuesday   => 3
  | wednesday => 4
  | thursday  => 5
  | friday    => 6
  | saturday  => 7

#eval natOfWeekday tuesday

def isMonday : Weekday → Bool :=
  -- `fun` + `match`  is a common idiom.
  -- The following expression is syntax sugar for
  -- `fun d => match d with | monday => true | _ => false`.
  fun
    | monday => true
    | _      => false

#eval isMonday monday
#eval isMonday sunday

-- Lean has support for type classes and polymorphic methods.
-- The `toString` method converts a value into a `String`.
#eval toString 10
#eval toString (10, 20)

-- The method `toString` converts values of any type that implements
-- the class `ToString`.
-- You can implement instances of `ToString` for your own types.
instance : ToString Weekday where
  toString (d : Weekday) : String :=
    match d with
    | sunday    => "Sunday"
    | monday    => "Monday"
    | tuesday   => "Tuesday"
    | wednesday => "Wednesday"
    | thursday  => "Thursday"
    | friday    => "Friday"
    | saturday  => "Saturday"

#eval toString (sunday, 10)

def Weekday.next (d : Weekday) : Weekday :=
  match d with
  | sunday    => monday
  | monday    => tuesday
  | tuesday   => wednesday
  | wednesday => thursday
  | thursday  => friday
  | friday    => saturday
  | saturday  => sunday

#eval Weekday.next Weekday.wednesday
-- Since the `Weekday` namespace has already been opened, you can also write
#eval next wednesday

-- Matching on a parameter like in the previous definition
-- is so common that Lean provides syntax sugar for it. The following
-- function uses it.
def Weekday.previous : Weekday -> Weekday
  | sunday    => saturday
  | monday    => sunday
  | tuesday   => monday
  | wednesday => tuesday
  | thursday  => wednesday
  | friday    => thursday
  | saturday  => friday

#eval next (previous wednesday)

-- We can prove that for any `Weekday` `d`, `next (previous d) = d`
theorem Weekday.nextOfPrevious (d : Weekday) : next (previous d) = d :=
  match d with
  | sunday    => rfl
  | monday    => rfl
  | tuesday   => rfl
  | wednesday => rfl
  | thursday  => rfl
  | friday    => rfl
  | saturday  => rfl

-- You can automate definitions such as `Weekday.nextOfPrevious`
-- using metaprogramming (or "tactics").
theorem Weekday.nextOfPrevious' (d : Weekday) : next (previous d) = d := by
  cases d       -- A proof by case distinction
  all_goals rfl  -- Each case is solved using `rfl`
