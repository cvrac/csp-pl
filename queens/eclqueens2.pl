nqueens(N, Solution) :-
   choices(1, N, Choices),
   permutation(Choices, Solution),
   safe(Solution).

choices(N, N, [N]).
choices(M, N, [M|Ns]) :-
   M < N,
   M1 is M+1,
   choices(M1, N, Ns).

permutation([], []).
permutation([Head|Tail], PermList) :-
   permutation(Tail, PermTail),
   delete(Head, PermList, PermTail).

safe([]).
safe([Queens|Others]) :-
   safe(Others),
   noatt(Queens, Others, 1).

noatt(_, [], _).
noatt(Y, [Y1|Ylist], Xdist) :-
   Y1-Y =\= Xdist,
   Y-Y1 =\= Xdist,
   Dist1 is Xdist+1,
   noatt(Y, Ylist, Dist1).

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
