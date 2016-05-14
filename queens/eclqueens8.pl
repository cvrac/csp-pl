:- lib(ic).

nqueens(N, Solution) :-
   length(Solution, N),
   Solution #:: 1..N,
   constrain(Solution),
   generate(Solution).

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

generate(Sol) :-
   search(Sol, 0, first_fail, indomain, complete, []).

go(N) :- cputime(T1),
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
