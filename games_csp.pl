:- lib(ic).
:- lib(branch_and_bound).

/* First find the optimal solution, and then
 * find all the solutions and keep those which have the maximum pleasure
 */
games_csp(Ps, Capacity, Win, Ts, P):-
	length(Ps, N),
	var_def(Gs, N, Capacity),
	constraints(Ps, Capacity, Capacity, Win, Gs, TotalPleasure),
	MinPleasure #= -TotalPleasure,
	MaxPleasure #= -MinPleasure,
	bb_min(search(Gs, 0, first_fail, indomain, complete, []), MinPleasure, _),
	var_def(Ts, N, Capacity),
	constraints(Ps, Capacity, Capacity, Win, Ts, TotalPleasure),
	search(Ts, 0, first_fail, indomain_middle, complete, []),
	P is MaxPleasure.

var_def(Gs, Size, Capacity) :-
	length(Gs, Size),
	Gs #:: 1..Capacity.

/*	Constraints definition	*
 *	Two Cases	*
 *	Case 1: If the Pleasure of the game is negative, then this game would
 *	be played just one time.
 *	Case 2: If the Pleasure of the game is non negative, then the game would
 *	be played at least one time, and no more than Capacity times.
 *	Possible total pleasure is defined aswell. On the second search, where
 *	we're searching for more optimal solutions with the best pleasure,
 *	the possible list solutions are reduced, since they have to satisfy
 *	the constraint of having the best pleasure.
 */
constraints([], _, _, _, [], 0).
constraints([Pleasure|Ps], Capacity, C, Win, [1|Gs], MP) :-
	Pleasure < 0,
	NextGameCoins #= min(Capacity, C + Win - 1),
	constraints(Ps, Capacity, NextGameCoins, Win, Gs, Curr),
	MP #= 1 * Pleasure + Curr.
constraints([Pleasure|Ps], Capacity, C, Win, [PossiblePlay|Gs], MP) :-
	Pleasure >= 0,
	PossiblePlay #>= 1,
	PossiblePlay #=< C,
	NextGameCoins #= min(Capacity, C + Win - PossiblePlay),
	constraints(Ps, Capacity, NextGameCoins, Win, Gs, Curr),
	MP #= PossiblePlay * Pleasure + Curr.