/*exw ulopoiisei to games me 2 tropous. O enas einai o dilwtikos, me xrisi tou \+.
 *O deuteros einai o diadikastikos, opou vriskw prwta ti megisti euxaristisi pou mporei na uparxei
 *kai me vasi auti xtizw ti lista lusi sti sunexeia.
 *Kai stis 2 periptwseis, xrisimopoiw ena voithitiko katigorima games1.
 */

%games(Ps, T, K, Gs, P) :- games1(Ps, T, T, K, Gs, P), \+ (games1(Ps, T,  T, K, Ggs, Pz), Pz > P).
games(Ps, T, K, Gs, P) :- find_max_pleasure(Ps, T, K, _, P), games1(Ps, T, T, K, Gs, P).

find_max_pleasure(Ps, T, K, _, P) :- findall(Z, games1(Ps, T, T, K, _, Z), L), find_max(L, P).

find_max([X], X).
find_max([X|L], M) :- find_max(L, K), max1(K, X, M).

max1(X, Y, X) :- X >= Y.
max1(X, Y, Y) :- X < Y.

/*Kanw iterate ti lista me tis euxaristiseis, kai me ti voitheia tou one_between, pairnw
 *ola ta pithana paiksimata pou mpooroun na ginoun ana paixnidi, opote kai proxwraw parakatw.
 *Exw sumperilavei eidikes periptwseis gia tin periptwsi pou i euxaristisi einai arnhtiki, wste to paixnidi
 *na paizete mia mono fora
 */
games1([X], T, C, _, [1], Px) :- X < 0, Px is X.
games1([X], T, C, _, [Ti], Px) :- X >= 0, one_between(1, C, Ti), Px is X * Ti.
games1([X|Y], T, C, K, [1|Ps], Px) :- X < 0, Ti is C - 1 + K, Ti < T, games1(Y, T, Ti, K, Ps, Z), Px is Z + X.
games1([X|Y], T, C, K, [1|Ps], Px) :- X < 0, Ti is C - 1 + K, Ti >= T, games1(Y, T, T, K, Ps, Z), Px is Z + X.
games1([X|Y], T, C, K, [Ti|Ps], Px) :- X >= 0, one_between(1, C, Ti), TTi is C - Ti + K, TTi < T, games1(Y, T, TTi, K, Ps, Z), Px is Z + Ti * X.
games1([X|Y], T, C, K, [Ti|Ps], Px) :- X >= 0, one_between(1, C, Ti), TTi is C - Ti + K, TTi >= T, games1(Y, T, T, K, Ps, Z), Px is Z + Ti * X.

one_between(X, Y, X) :- X =< Y.
one_between(X, Y, Z) :- X < Y, X1 is X + 1, one_between(X1, Y, Z).
