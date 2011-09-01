%% Implementation of Analytic Tableau Rules
%% Adolfo Neto
%% September 1th, 2011

%% How to run this in Linux?
% 1. Install Erlang
% 2. In a shell issue the following command:
%   erlc analytic_tableau.erl ; erl  -noshell -s analytic_tableau start -s init stop

-module(analytic_tableau).
-export([t_not/1]).
-export([f_not/1]).

-export([t_and/1]).
-export([f_or/1]).
-export([f_implies/1]).

-export([f_and/1]).
-export([t_or/1]).
-export([t_implies/1]).

-export([start/0]).

t_not({"t", {"not", X}}) -> [ {"f", X} ];
t_not(Y) -> [Y].

f_not({"f", {"not", X}}) -> [ {"t", X} ];
f_not(Y) -> [Y].

t_and({"t", {"and", [X, Y]}}) -> [ {"t", X} , {"t", Y}];
t_and(Y) -> [Y].

f_or({"f", {"or", [X, Y]}}) -> [ {"f", X} , {"f", Y}];
f_or(Y) -> [Y].

f_implies({"f", {"implies", [X, Y]}}) -> [ {"t", X} , {"f", Y}];
f_implies(Y) -> [Y].

f_and({"f", {"and", [X, Y]}}) -> [ [ {"f", X} ], [{"f", Y} ] ];
f_and(Y) -> [Y].

t_or({"t", {"or", [X, Y]}}) -> [ [ {"t", X} ], [{"t", Y} ] ];
t_or(Y) -> [Y].

t_implies({"t", {"implies", [X, Y]}}) -> [ [ {"f", X} ], [{"t", Y} ] ];
t_implies(Y) -> [Y].


start() ->
  io:format("Analytic Tableau Rules! ~n~n"),
  F1 = {"t", {"not", "a"}},
  io:format("Applying T NOT rule to ~p results in ~n", [F1]),
  io:format("~p~n~n",[t_not(F1)]),
  F2 = {"f", {"not", "a"}},
  io:format("Applying F NOT rule to ~p results in ~n", [F2]),
  io:format("~p~n~n",[f_not(F2)]),
  F3 = {"t", {"and", ["a", "b"]}},
  io:format("Applying T AND rule to ~p results in ~n", [F3]),
  io:format("~p~n~n",[t_and(F3)]),
  F4 = {"f", {"or", ["a", "b"]}},
  io:format("Applying F OR rule to ~p results in ~n", [F4]),
  io:format("~p~n~n",[f_or(F4)]),
  F5 = {"f", {"implies", ["a", "b"]}},
  io:format("Applying F IMPLIES rule to ~p results in ~n", [F5]),
  io:format("~p~n~n",[f_implies(F5)]),
  F6 = {"f", {"and", ["a", "b"]}},
  io:format("Applying F AND rule to ~p results in ~n", [F6]),
  io:format("~p~n~n",[f_and(F6)]),
  F7 = {"t", {"or", ["a", "b"]}},
  io:format("Applying T OR rule to ~p results in ~n", [F7]),
  io:format("~p~n~n",[t_or(F7)]),
  F8 = {"t", {"implies", ["a", "b"]}},
  io:format("Applying T IMPLIES rule to ~p results in ~n", [F8]),
  io:format("~p~n~n",[t_implies(F8)]),
  io:format("The End~n").
