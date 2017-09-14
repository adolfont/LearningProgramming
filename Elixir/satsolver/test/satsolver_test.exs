defmodule SatSolverTest do
  use ExUnit.Case
  doctest SatSolver


# TODO: new tests
#  test "easy satisfiable instance" do
#    assert SatSolver.solve([[1, 2, 3]]) == :sat
#  end
#  test "easy unsatisfiable instance" do
#    assert SatSolver.solve([[1], [-1]]) == :unsat
#  end

  test "value a clause 1: a satisfying valuation" do
    assert SatSolver.value([1,2,3], [1]) == true
  end

  test "value a clause 2: one valuation that leads to a removal" do
    assert SatSolver.value([1,2,3], [-1]) == [2,3]
  end

  test "value a clause 3: useless valuation" do
    assert SatSolver.value([1,2,3], [4]) == [1,2,3]
  end

  test "value a clause 4: empty valuation" do
    assert SatSolver.value([1,2,3], []) == [1,2,3]
  end

  test "value a clause 5: two atoms removed" do
    assert SatSolver.value([1,2,3], [-1,-2]) == [3]
  end

  test "value a clause 6: true on second value" do
    assert SatSolver.value([1,2,3], [-1,2]) == true
  end

  test "value a clause 7: empty clause" do
    assert SatSolver.value([1,2,3], [-1,-2,-3]) == []
  end

  test "value a formula: empty valuation" do
    assert SatSolver.value_formula([[1,2,3],[-4, -5]], []) == [[1,2,3],[-4, -5]]
  end

  test "value a formula: no satisfying clauses" do
    assert SatSolver.value_formula([[1,2,3],[-4, -5]], [6,7]) == [[1,2,3],[-4, -5]]
  end

  test "value a formula: one satisfying clause" do
    assert SatSolver.value_formula([[1,2,3],[-4, -5]], [1]) == [[-4, -5]]
  end

  test "value a formula: one satisfying clause, three clauses" do
    assert SatSolver.value_formula([[1,2,3],[-4, -5],[6,7]], [1]) == [[-4, -5],[6,7]]
  end

  test "value a formula: no satisfying clause, three clauses, valuations that matter" do
    assert SatSolver.value_formula([[1,2,3],[-4, -5],[6,7]], [-1,5,-7]) == [[2,3],[-4],[6]]
  end

  test "value a formula: one empty clause, three clauses become two clauses" do
    assert SatSolver.value_formula([[1,2,3],[-4, -5],[6,7]], [4,5]) == [[1, 2, 3], [], [6, 7]]
  end

  test "value a formula: ..." do
    assert SatSolver.value_formula([[1,2,3],[-4, -5],[6,7]], [7,-4,3]) == []
  end


  test "verifies if a formula is satisfied by a certain valuation" do
    assert SatSolver.satisfies?([[1,2,3],[-4, -5],[6,7]], [7,-4,3]) == true
  end

  test "verifies if a formula is falsified by a certain valuation" do
    assert SatSolver.falsifies?([[1,2,3],[-4, -5],[6,7]], [-1,-2,-3]) == true
  end

  test "basic dpll functioning 1" do
    assert SatSolver.dpll([]) == {true,[]}
  end

  test "basic dpll functioning 2" do
    assert SatSolver.dpll([[]]) == {false,[]}
  end

  test "basic dpll functioning 3" do
    assert SatSolver.dpll([[1]]) == {true,[1]}
  end


  test "find next atom in pair formula, valuation: empty formula" do
    assert SatSolver.next_value([],[1]) == nil
  end

  test "find next atom in pair formula, valuation: simple formula" do
    assert SatSolver.next_value([[1]],[]) == 1
  end

  test "find next atom in pair formula, valuation: two clauses" do
    assert SatSolver.next_value([[1],[2]],[1]) == 2
  end

  test "find next atom in pair formula, valuation: three clauses" do
    assert SatSolver.next_value([[1],[2,-3], [-4,5]],[1,2,-3]) == -4
  end

  test "find next atom in pair formula, valuation: three clauses, ???" do
    assert SatSolver.next_value([[1],[2,-3], [-4,5]],[1,2,-3]) == -4
  end

  test "basic dpll functioning 4" do
    assert SatSolver.dpll([[1],[-2]]) == {true,[-2,1]}
  end

  test "basic dpll functioning 5" do
    assert SatSolver.dpll([[1,2],[-2]]) == {true,[-2,1]}
  end

  test "basic dpll functioning 6" do
    assert SatSolver.dpll([[2],[-2]]) == {false,[]}
  end

  test "basic dpll functioning 7" do
    assert SatSolver.dpll([[1,2],[-2,3],[-3,4]]) == {true,[-3,-2,1]}
  end

  test "Convert DIMACS file to list" do
    assert List.first(SatSolver.from_DIMACS_to_list("lib/uf20-01.cnf"))==[4, -18, 19]
  end

  test "No DIMACS file " do
    assert SatSolver.from_DIMACS_to_list("lib/uf20-03.cnf")== nil
  end

end
