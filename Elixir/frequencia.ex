# https://dev.to/matdsoupe/identificacao-de-caracteres-unicode-em-elixir-f4j

ExUnit.start()

defmodule Frequencia do
  def frequencia(sentencas) when is_list(sentencas) do
    sentencas
    |> separar_grafemas()
    |> contar_letras()
  end

  defp separar_grafemas(sentencas) do
    sentencas
    |> Enum.join()
    |> String.graphemes()
  end

  defp contar_letras(grafemas) do
    for grafema <- grafemas, letra?(grafema), reduce: %{} do
      acc -> Map.update(acc, grafema, 1, &(&1 + 1))
    end
  end

  defp letra?(grafema), do: String.match?(grafema, ~r|\p{L}|u)
end

defmodule MyTests do
  use ExUnit.Case

  test "Primeiro teste do blog post https://dev.to/matdsoupe/identificacao-de-caracteres-unicode-em-elixir-f4j" do
    assert Frequencia.frequencia(["ciências", "naturais"]) ==
             %{
               "a" => 3,
               "i" => 3,
               "ê" => 1,
               "c" => 2,
               "n" => 2,
               "r" => 1,
               "s" => 2,
               "t" => 1,
               "u" => 1
             }
  end
end
