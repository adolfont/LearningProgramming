-module(imc).

-export([calcula/2]).

calcula(Peso, Altura) ->
    Peso/(Altura*Altura).