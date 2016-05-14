nqueens(N, Solution) :-
   gen(1, N, Dxy),
   Nu1 is 1-N,
   Nu2 is N-1,
   gen(Nu1, Nu2, Du),
   Nv2 is N+N,
   gen(2, Nv2, Dv),
   sol(Solution, Dxy, Dxy, Du, Dv).

sol([], [], Dy, Du, Dv).
sol([Y|Ylist], [X|Dx1], Dy, Du, Dv) :-
   delete(Y, Dy, Dy1),
   U is X-Y,
   delete(U, Du, Du1),
   V is X+Y,
   delete(V, Dv, Dv1),
   sol(Ylist, Dx1, Dy1, Du1, Dv1).

gen(N, N, [N]).
gen(N1, N2, [N1|List]) :-
   N1 < N2,
   M is N1+1,
   gen(M, N2, List).

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
