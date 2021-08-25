-module(fibonacci).

-export([fib/1, fib_with_history/1, tests/0]).

fib(1) -> 1;
fib(2) -> 1;
fib(N) -> fib(N-1)+fib(N-2).

fib_with_history(N) -> fib_with_history(N, 1, 1, 0).

fib_with_history(1, _, _, _) -> 1; 
fib_with_history(2, _, _, _) -> 1;
fib_with_history(N, N, P1, _P2) -> P1;
fib_with_history(N, M, P1, P2) -> 
   fib_with_history(N, M+1, P2+P1, P1).



tests()->
    true = (fib(1) == fib_with_history(1)),
    true = (fib(2) == fib_with_history(2)),
    true = (fib(3) == fib_with_history(3)),
    true = (fib(4) == fib_with_history(4)),
    true = (fib(8) == fib_with_history(8)),
    true = (fib(15) == fib_with_history(15)).

    

    





