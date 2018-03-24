# Verificador de Sintaxe para Lógica Clássica Proposicional em Elixir
# Atualização em 2018: este código foi escrito quando eu estava iniciando em Elixir e não reflete boas práticas da linguagem.

# Como executar:
# > elixir sintaxe.exs



# Sintaxe
# Fórmulas atômicas pode ser
#   :p
#   :q
# Enfim, qualquer identificador começando com : exceto os conectivos
#
# Sendo X e Y fórmulas, podemos ter
# [:nao, X]
# [X, :e, Y]
# [X, :ou, Y]
# [X, :implica, Y]


defmodule Sintaxe  do
  def verifica([:nao, formula]) do
    verifica(formula)
  end
  def verifica([esquerda, conectivo, direita]) do
    if conectivo==:e or conectivo==:ou or conectivo==:implica do
      verifica(esquerda) and verifica(direita)
    else
      false
    end
  end
  def verifica(atomo) do
	  is_atom(atomo) and not (atomo==:e or atomo==:ou or atomo==:implica or atomo==:nao)
  end
end




{formula, _} = Code.eval_string IO.gets "Digite a fórmula: "

if Sintaxe.verifica(formula) do
  IO.puts "A sintaxe está correta!"
else
  IO.puts "A sintaxe está incorreta."
end
