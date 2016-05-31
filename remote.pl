remote(Starter, N, List1, C) :- length(Starter, Len), distances(Starter, N, N, L), sort(2, @=<, L, L1), changes(Starter, Len, N, L1, [List1, C]).
%remote(Starter, N, List1, C) :- length(Starter, Len), distances(Starter, N, N, L), quicksort(L,L1), changes(Starter, Len, N, L1, [List1, C]).

getlistchan([X], 1, X).
getlistchan([X|Xs], N, D) :- length(X, Len), Z is N - 1, getlistchan(Xs, Z, T), length(T, L2), min1(X, Len, T, L2, D).

min1(X, Len, _, L2, X) :- Len < L2.
min1(_, Len, Z, L2, Z) :- Len >= L2.

distance([], _, _, 0).
distance([X|Y], N, X, Dist) :- distance(Y, N, X, Dist).
distance([X|Y], N, Chan, Dist) :- Chan > X,
								distance(Y, N, Chan, TempDist),
								Dist is TempDist + Chan - X.
distance([X|Y], N, Chan, Dist) :- Chan < X,
								distance(Y, N, Chan, TempDist),
								Dist is TempDist + N - X + Chan.

distances(Starter, N, 1, [[1, Xdist]]) :- distance(Starter, N, 1, Xdist).
distances(Starter, N, X, T) :- X > 1,
							Z is X - 1,
							distance(Starter, N, X, Xdist),
							distances(Starter, N, Z, Y),
							append([[X, Xdist]], Y, T).


changes(Starter, Len, Chans, [[X, Y]|_], [[], X]) :- checklist(Starter, X, Check), Check =:= 1.
changes(Starter, Len, Chans, [[X, Y]|_], [Changes, X]) :- checklist(Starter, X, Check), Check =:= -1, findchanges(Starter, Len, Chans, X, Y, Changes), length(Changes, U), U =:= Y.
changes(Starter, Len, Chans, [[X, Y]|Xs], D) :- checklist(Starter, X, Check), Check =:= -1, findchanges(Starter, Len, Chans, X, Y, Changes), length(Changes, U), U =\= Y,
											changes(Starter, Len, Chans, Xs, [L, Ch]), length(Changes, L1), length(L, L2), min2(Changes, L1, X, L, L2, Ch, D).


min2(L1, Len1, Ch1, _, Len2, _, [L1, Ch1]) :- Len1 < Len2.
min2(_, Len1, _, L2, Len2, Ch2, [L2, Ch2]) :- Len1 >= Len2.

checklist([X], X, 1).
checklist([X], Y, -1) :- Y =\= X.
checklist([X|_], Y, -1) :- Y =\= X.
checklist([X|Xs], X, 1) :- checklist(Xs, X, T), T =\= -1.
checklist([X|Xs], X, -1) :- checklist(Xs, X, T), T =:= -1, !.


findchanges(Starter, Len, Channels, Channel, Y, [NextCh|TChanges]) :- Z is Len + 1,
									findnextchange([Starter], Starter, Channels, Z, Len, -1, Channel, NextCh),
									changechannel(Starter, Starter, Channels, Z, Len, NextCh, NewList),
									findchanges1(Starter, NewList, Channels, Channel, Y, Z, NextCh, TChanges).

findchanges1(Starter, Starter, _, _, _, _, _, []).
findchanges1(_, TList, _, Channel, _, _, _, []) :- checklist(TList, Channel, Check), Check =:= 1, !.
findchanges1(Starter, TList, Channels, Channel, D,  N, LastChange, [NextCh|TChanges]):- checklist(TList, Channel, Check), Check =:= -1, Z is N - 1,
														findnextchange([Starter], TList, Channels, N, Z, LastChange, Channel, NextCh),
														changechannel(Starter, TList, Channels, N, Z, NextCh, NewList), T is D - 1,
														findtvchan(Starter, N, Z, NextCh, Ch), findtvchan(NewList, N, Z, NextCh, ChN),
														ChN =\= Ch,
														findchanges1(Starter, NewList, Channels, Channel, T, N, NextCh, TChanges), !.
findchanges1(Starter, TList, Channels, Channel, D,  N, LastChange, []):- checklist(TList, Channel, Check), Check =:= -1, Z is N - 1,
														findnextchange([Starter], TList, Channels, N, Z, LastChange, Channel, NextCh),
														changechannel(Starter, TList, Channels, N, Z, NextCh, NewList),
														findtvchan(Starter, N, Z, NextCh, Ch), findtvchan(NewList, N, Z, NextCh, ChN),
														ChN =:= Ch.


findtvchan([X], N, 1, Ind, Ch) :- T is N - 1, Ind =:= T, Ch is X.
findtvchan([X|_], N, Tv, Ind, Ch) :- Tv > 1, Z is N - Tv, Ind =:= Z, Ch is X.
findtvchan([_|Xs], N, Tv, Ind, Ch) :- Tv > 1, Z is N - Tv, Ind =\= Z, T is Tv - 1,
									findtvchan(Xs, N, T, Ind, Ch).

maxdist([Dist, X, D, _], X) :- Dist >= D.
maxdist([Dist, _, D, Y], Y) :- Dist < D.

/*The tv with the biggest distance from the goal will be changed next. */
findnextchange([Starter], [X], C, N, 1, LastChange, Channel, -1):- T is N - 1, LastChange =\= T, distance([X], C, Channel, Dist), Dist =:= 0.
findnextchange([Starter], [_], _, N, 1, LastChange, _, -1):- T is N - 1, LastChange =:= T.
findnextchange([Starter], [X], C, N, 1, LastChange, Channel, T):- T is N - 1, LastChange =\= T, distance([X], C, Channel, Dist), Dist > 0.
findnextchange([Starter], [_|Xs], C, N, Tv, LastChange, Channel, Change):- Tv > 1, Curr is N - Tv, T is Tv - 1,
														LastChange =:= Curr,
														findnextchange([Starter], Xs, C, N, T, LastChange, Channel, Change), !.
findnextchange([Starter], [X|Xs], C, N, Tv, LastChange, Channel, Change):- Tv > 1, Curr is N - Tv, T is Tv - 1,
														LastChange =\= Curr,
														findnextchange([Starter], Xs, C, N, T, LastChange, Channel, Y), Y =\= -1,
														findtvchan(Xs, N, T, Y, NC),
														distance([X], C, Channel, Dist), distance([NC], C, Channel, D),
														maxdist([Dist, Curr, D, Y], Z), Change is Z, !.
findnextchange([Starter], [_|Xs], C, N, Tv, LastChange, Channel, Change):- Tv > 1, Curr is N - Tv, T is Tv - 1,
 														LastChange =\= Curr,
														findnextchange([Starter], Xs, C, N, T, LastChange, Channel, Y),
 														Y =:= -1, Change is Curr.

/*Given the list of tvs, and an tv index, changes the channel of this tv*/
changechannel(Starter, [X], Chans, N, 1, Ind, [Y]) :- T is N - 1, Ind =:= T, updatechan([X, Chans], Y).
changechannel(Starter, [X|Xs], Chans, N, Tv, Ind, [Y|Xs]) :- Tv > 1, Z is N - Tv, Ind =:= Z,  updatechan([X, Chans], Y), !.
changechannel(Starter, [X|Xs], Chans, N, Tv, Ind, [X|Ys]) :- Tv > 1, Z is N - Tv, Ind =\= Z, T is Tv - 1,
											changechannel(Starter, Xs, Chans, N, T, Ind, Ys), !.

updatechan([X, N], 1) :- X =:= N.
updatechan([X, N], Z) :- X < N, Z is X + 1.
