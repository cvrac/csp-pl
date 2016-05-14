solution([]).
solution([X/Y|Others]) :-
	solution(Others), one_between(1, 8, Y),
	noattack(X/Y, Others).

noattack(X/Y, Others).
noattack(_, []).
noattack(X/Y, [X1/Y1|Others]) :-
	Y =\= Y1, Y1-Y =\= X1-X, Y1-Y =\= X-X1,
	noattack(X/Y, Others).


template([1/Y1, 2/Y2, 3/Y3, 4/Y4, 5/Y5, 6/Y6, 7/Y7, 8/Y8]).

one_between(X, Y, X) :- X =< Y.
one_between(X, Y, Z) :- X < Y, X1 is X + 1, one_between(X1, Y, Z).