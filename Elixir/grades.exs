defmodule Grades do
  def run(number_of_questions, number_of_students) do
    IO.puts("Type Answer Key")
    answer_key = read_answer_key(number_of_questions)

    IO.puts("\nType Student Answers")
    student_answers = read_answers(number_of_questions, number_of_students)

    IO.puts("\nResults")
    grade_answers(answer_key, student_answers)
  end

  defp grade_answers(answer_key, student_answers) do
    Enum.map(student_answers, &grade_student(answer_key, &1))
  end

  defp grade_student(answer_key, {name, answers}) do
    right_answers =
      Enum.zip(answer_key, answers)
      |> Enum.count(fn {x, y} -> x == y end)

    IO.puts("Student \"#{name}\" got #{right_answers} of #{length(answer_key)} right!")
  end

  defp read_answer_key(number_of_questions) do
    1..number_of_questions
    |> Enum.map(fn i -> read_string("Type answer for question #{i}:") end)
  end

  defp read_answers(number_of_questions, number_of_students) do
    for i <- 1..number_of_students do
      read_answer_for_one_student(i, number_of_questions)
    end
  end

  def read_answer_for_one_student(index, number_of_questions) do
    name = read_string("Type student #{index} name:")

    answers =
      1..number_of_questions
      |> Enum.map(fn i -> read_string("Type #{name}'s answer for question #{i}:") end)

    {name, answers}
  end

  defp read_string(message) do
    (message <> " ")
    |> IO.gets()
    |> String.trim()
  end
end

Grades.run(5, 5)
