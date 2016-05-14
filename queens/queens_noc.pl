%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Backtracking method (bt)                                                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

bt_nqueens(N, Queens) :-
   make_tmpl(1, N, Queens),
   solution(N, Queens).

make_tmpl(N, N, [N/_]).
make_tmpl(I, N, [I/_|Rest]) :-
   I < N,
   I1 is I+1,
   make_tmpl(I1, N, Rest).

solution(_, []).
solution(N, [X/Y|Others]) :-
   solution(N, Others),
   between(1, N, Y),
   noattack(X/Y, Others).

between(I, J, I) :-
   I =< J.
between(I, J, X) :-
   I < J,
   I1 is I+1,
   between(I1, J, X).

noattack(_,[]).
noattack(X/Y,[X1/Y1|Others]) :-
   Y =\= Y1,
   Y1-Y =\= X1-X,
   Y1-Y =\= X-X1,
   noattack(X/Y,Others).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Generate-and-test method (gt)                                           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

gt_nqueens(N, Queens) :-
   choices(1, N, Choices),
   permutation(Choices, Queens),
   safe(Queens).

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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Diagonal lookahead method (dl)                                          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

dl_nqueens(N, Queens) :-
   choices(1, N, Dxy),
   Nu1 is 1-N,
   Nu2 is N-1,
   choices(Nu1, Nu2, Du),
   Nv2 is 2*N,
   choices(2, Nv2, Dv),
   sol(Queens, Dxy, Dxy, Du, Dv).

sol([], [], _, _, _).
sol([Y|Ylist], [X|Dx1], Dy, Du, Dv) :-
   delete(Y, Dy, Dy1),
   U is X-Y,
   delete(U, Du, Du1),
   V is X+Y,
   delete(V, Dv, Dv1),
   sol(Ylist, Dx1, Dy1, Du1, Dv1).

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

getall(N, bt, Sols) :-
   findall(Sol, bt_nqueens(N, Sol), Sols).
getall(N, gt, Sols) :-
   findall(Sol, gt_nqueens(N, Sol), Sols).
getall(N, dl, Sols) :-
   findall(Sol, dl_nqueens(N, Sol), Sols).

go_all :-
   member(Method, [bt, gt, dl]),
   member(N, [6, 7, 8, 9, 10, 11]),
   nl,
   write('-----------------------'),
   nl,
   write('Method: '),
   write(Method),
   write('  Queens: '),
   write(N),
   nl,
   write('-----------------------'),
   nl,
   go(N, Method),
   fail.
