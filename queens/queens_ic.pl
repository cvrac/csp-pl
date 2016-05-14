%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Constraint library ic (simple, ff)                                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

:- lib(ic).

nqueens(N, SelMethod, Solution) :-
   length(Solution, N),
   Solution #:: 1..N,
   constrain(Solution),
   search(Solution, 0, SelMethod, indomain, complete, []).

constrain([]).
constrain([X|Xs]) :-
   noattack(X, Xs, 1),
   constrain(Xs).

noattack(_, [], _).
noattack(X, [Y|Ys], M) :-
   X #\= Y,
   X #\= Y-M,
   X #\= Y+M,
   M1 is M+1,
   noattack(X, Ys, M1).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

go_all(N, Method) :-
   cputime(T1),
   findall(Sol, nqueens(N, Method, Sol), Sols),
   cputime(T2),
   length(Sols, L),
   T is T2-T1,
   write('There are '),
   write(L),
   writeln(' solutions.'),
   write('Time: '),
   write(T),
   writeln(' secs.').

go_all :-
   member(Method, [input_order, first_fail]),
   member(N, [9, 10, 11, 12, 13]),
   nl,
   write('--------------------------------'),
   nl,
   write('Method: '),
   write(Method),
   write('  Queens: '),
   write(N),
   nl,
   write('--------------------------------'),
   nl,
   go_all(N, Method),
   fail.
