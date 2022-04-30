variable (p q r s : Prop)

#check True
#check False
#check p ∧ q
#check p ∨ q
#check p → q
#check p ↔ q
#check ¬ p

theorem foo : p → q → p ∧ q :=
  fun hp hq => And.intro hp hq

theorem bar : p ∧ q → q ∧ p :=
  fun ⟨hp, hq⟩ => ⟨hq, hp⟩

example : p → p := by
  intro h
  apply h

theorem two_plus_two_is_four : 2 + 2 = 4 := rfl

def factorial : Nat → Nat
  | 0       => 1
  | (n + 1) => (n + 1) * factorial n

#eval factorial 10
#eval factorial 100


def hanoi (numPegs start finish aux : Nat) : IO Unit :=
  match numPegs with
  | 0     => pure ()
  | n + 1 => do
      hanoi n start aux finish
      IO.println s!"Move disk {n + 1} from peg {start} to peg {finish}"
      hanoi n aux finish start

#eval hanoi 7 1 2 3

def addNums : List Nat → Nat
  | []    => 0
  | a::as => a + addNums as

#eval addNums [0, 1, 2, 3, 4, 5, 6]

theorem and_example : p → q → p ∧ q := by
  intro hp
  intro hq
  apply And.intro
  . exact hp
  . exact hq

#print and_example

example : p → q → p ∧ q :=
  fun hp hq => And.intro hp hq


theorem to_example : (p → q) → ¬ p ∨ q := by
  intro hpq
  sorry

#print to_example

example (h1 : p → q) : ¬ p ∨ q := by
  apply Or.elim (Classical.em p)
  . intro hp
    apply Or.inr
    apply h1
    exact hp
  . intro hnp
    apply Or.inl
    exact hnp

