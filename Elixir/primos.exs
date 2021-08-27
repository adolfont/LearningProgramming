defmodule Primos do
  def eh_primo?(numero) when numero >= 2 do
    numero in crivo(numero)
  end

  def eh_primo?(_), do: false

  def crivo(numero) do
    crivo(Enum.to_list(2..numero), 2, numero)
  end

  defp crivo(resultado, final, final), do: resultado

  defp crivo(resultado, atual, final) do
    resultado
    |> Enum.filter(fn x -> x > atual and rem(x, atual) != 0 end)
    |> crivo(atual + 1, final)
  end
end

1..10000
|> Enum.filter(&Primos.eh_primo?/1)
|> Enum.map(fn x -> IO.write("#{x} ") end)
