nqueens(N, Solution) :-
   make_tmpl(1, N, Solution),
   solution(N, Solution).

solution(_, []).
solution(N, [X/Y|Others]) :-
   solution(N, Others),
   between(1, N, Y),
   noattack(X/Y, Others).

noattack(_, []).
noattack(X/Y, [X1/Y1|Others]) :-
   Y =\= Y1,
   Y1-Y =\= X1-X,
   Y1-Y =\= X-X1,
   noattack(X/Y, Others).

make_tmpl(N, N, [N/_]).
make_tmpl(I, N, [I/_|Rest]) :-
   I < N,
   I1 is I+1,
   make_tmpl(I1, N, Rest).

between(I, J, I) :-
   I =< J.
between(I, J, X) :-
   I < J,
   I1 is I+1,
   between(I1, J, X).

go(N) :-
   cputime(T1),
   findall(Sol, nqueens(N, Sol), Sols),
   cputime(T2),
   length(Sols, L),
   T is T2-T1,
   write('There are '),
   write(L),
   writeln(' solutions.'),
   write('Time: '),
   write(T),
   writeln(' secs.').
