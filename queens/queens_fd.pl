%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Constraint library fd (simple, ff)                                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

:- lib(fd).

nqueens(N, Method, Solution) :-
   length(Solution, N),
   Solution :: 1..N,
   constrain(Solution),
   generate(Method, Solution).

constrain([]).
constrain([Column|Columns]) :-
   noattack(Column, Columns, 1),
   constrain(Columns).

noattack(_, [], _).
noattack(Column1, [Column2|Columns], Offset) :-
   Column1 ## Column2,
   Column1 ## Column2+Offset,
   Column1 ## Column2-Offset,
   NewOffset is Offset+1,
   noattack(Column1, Columns, NewOffset).

generate(input_order, Solution) :-
   generate_input_order(Solution).
generate(first_fail, Solution) :-
   generate_first_fail(Solution).

generate_input_order([]).
generate_input_order([Column|Columns]) :-
   indomain(Column),
   generate_input_order(Columns).

generate_first_fail([]).
generate_first_fail(Columns) :-
   deleteff(Column, Columns, RestColumns),
   indomain(Column),
   generate_first_fail(RestColumns).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

go(N, Method) :-
   cputime(T1),
   getall(N, Method, Sols),
   cputime(T2),
   length(Sols, L),
   T is T2-T1,
   write('There are '),
   write(L),
   writeln(' solutions.'),
   write('Time: '),
   write(T),
   writeln(' secs.').

getall(N, input_order, Sols) :-
   findall(Sol, nqueens(N, input_order, Sol), Sols).
getall(N, first_fail, Sols) :-
   findall(Sol, nqueens(N, first_fail, Sol), Sols).

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
   go(N, Method),
   fail.
