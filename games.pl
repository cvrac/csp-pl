/*Implemented both with the procedural and the \+ way*/

%games(Ps, T, K, Gs, P) :- games1(Ps, T, T, K, Gs, P), \+ (games1(Ps, T,  T, K, Ggs, Pz), Pz > P).
games(Ps, T, K, Gs, P) :- find_max_pleasure(Ps, T, K, _, P), games1(Ps, T, T, K, Gs, P).

find_max_pleasure(Ps, T, K, _, P) :- findall(Z, games1(Ps, T, T, K, _, Z), L), find_max(L, P).

find_max([X], X).
find_max([X|L], M) :- find_max(L, K), max1(K, X, M).

max1(X, Y, X) :- X >= Y.
max1(X, Y, Y) :- X < Y.

/*Iteration of the pleasure list.
 *one_between gives us all the possible plays of a game, and given this we
 *continue to the next game, having either max coins or coins in relation to the
 *previous play, on the box
 *
 *Case 1: Negative pleasure -> game's played once
 *Case 2: Non-negative pleasure -> game's played twice
 */
games1([X], T, C, _, [1], Px) :- X < 0, Px is X.
games1([X], T, C, _, [Ti], Px) :- X >= 0, one_between(1, C, Ti), Px is X * Ti.
games1([X|Y], T, C, K, [1|Ps], Px) :- X < 0, Ti is C - 1 + K, Ti < T, games1(Y, T, Ti, K, Ps, Z), Px is Z + X.
games1([X|Y], T, C, K, [1|Ps], Px) :- X < 0, Ti is C - 1 + K, Ti >= T, games1(Y, T, T, K, Ps, Z), Px is Z + X.
games1([X|Y], T, C, K, [Ti|Ps], Px) :- X >= 0, one_between(1, C, Ti), TTi is C - Ti + K, TTi < T, games1(Y, T, TTi, K, Ps, Z), Px is Z + Ti * X.
games1([X|Y], T, C, K, [Ti|Ps], Px) :- X >= 0, one_between(1, C, Ti), TTi is C - Ti + K, TTi >= T, games1(Y, T, T, K, Ps, Z), Px is Z + Ti * X.

one_between(X, Y, X) :- X =< Y.
one_between(X, Y, Z) :- X < Y, X1 is X + 1, one_between(X1, Y, Z).
