defmodule SatSolver do
  @moduledoc """
  Documentation for SatSolver.
  """

  @doc """
  Values a clause according to a valuation.
  Supposes no repetition of atoms on clauses.

  Returns either true or a clause.
  """
  def value(clause, []) do
    clause
  end

  def value(clause, [head|tail]) do
    head in clause or value(List.delete(clause,-head),tail)
  end

  @doc """
  Values a formula (as a list of clauses) according to a valuation.
  Supposes no repetition of atoms on clauses.

  Returns either true or a formula.
  """
  def value_formula(formula, []) do
    formula
  end

  def value_formula([], _) do
    []
  end

  def value_formula([head|tail], valuation) do
    result_first_clause = value(head,valuation)
    if result_first_clause == true do
       value_formula(tail,valuation)
    else
       [result_first_clause |  value_formula(tail,valuation)]
    end
  end

  def satisfies?(formula,valuation) do
     value_formula(formula,valuation) == []
  end

  def falsifies?(formula,valuation) do
     [] in value_formula(formula,valuation)
  end

  def dpll(formula) do
    dpll_aux(formula,[])
  end

  def dpll_aux([],valuation) do
    {true, valuation}
  end

  def dpll_aux(formula,valuation) do
    cond do
      [] in formula ->
        {false, valuation}
      satisfies?(formula,valuation) ->
        {true, valuation}
      falsifies?(formula,valuation) ->
        {false,valuation}
      true ->
        next_value_on_valuation = next_value(formula,valuation)
        dpll_or(formula,valuation,next_value_on_valuation)
    end
  end

  def dpll_or(formula,valuation,value) do
    new_valuation = [value] ++ valuation
    first_result = dpll_aux(value_formula(formula, new_valuation), new_valuation)
    {result, _} = first_result
    if result == true  do
       first_result
    else
      new_valuation_2 = [-value] ++ valuation
      second_result = dpll_aux(value_formula(formula, new_valuation_2), new_valuation_2)
      {result_2, _} = second_result
      if result_2 == true  do
        second_result
      else
        {false, []}
      end
    end
  end

  def next_value([],_) do
    nil
  end

  def next_value(formula,valuation) do
   ((formula |> List.flatten |> Enum.uniq) -- valuation) |> List.first
  end

  def remove_unused_lines (lines) do
    Enum.filter(lines, fn (x) -> not
    (
    (String.starts_with? x, "c") or
    (String.starts_with? x, "p") or
    (String.starts_with? x, "0") or
    (String.starts_with? x, "%") or
    x == ""
    )
   end)
  end

  def remove_trailing_zero (lines) do
    for x <- lines, do: String.trim_trailing(x," 0")
  end

  def make_number_list (lines) do
    for x <- lines, do:
       for y <- String.split(x), do: String.to_integer(y)
  end

  def from_DIMACS_to_list (filename) do
    process_file(File.read filename)
  end

  defp process_file({:error,_}) do
    nil
  end

  defp process_file({:ok, file_content}) do
    strings_from_file = file_content |> String.split("\n")

    lines_from_file = for x <- strings_from_file, do: String.trim(x)

    lines_from_file
    |> remove_unused_lines
    |> remove_trailing_zero
    |> make_number_list
  end
end
