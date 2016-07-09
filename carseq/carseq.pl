:- lib(ic).
:- lib(ic_global).

carseq(Sequence) :-
	classes(Classes),
	options(Options),
	writeln(Classes - Options),
	length(Classes, NClasses),
	sumlist1(Classes, NCars),
	var_def(Sequence, NCars, NClasses),
	constraints(Sequence, Classes, Options, NClasses),
	search(Sequence, 0, first_fail, indomain, complete, []).


sumlist1([], 0).
sumlist1([X|Y], N) :-
	sumlist(Y, Ns),
	N is Ns + X.

var_def(Sequence, NCars, NClasses) :-
	length(Sequence, NCars),
	Sequence #:: 1..NClasses.

constraints(Sequence, Classes, Options, NClasses) :-
	carsperclassconstraint(Sequence, Classes, 1),
	capacityconstraints(Sequence, Classes, Options, NClasses).

carsperclassconstraint(_, [], _).
carsperclassconstraint(Sequence, [X|Y], Z) :-
	writeln(Z - X),
	occurrences(Z, Sequence, X),
	T is Z + 1,
	carsperclassconstraint(Sequence, Y, T).

capacityconstraints(_, _, [], _).
capacityconstraints(Sequence, Classes, [M/K/OpClasses|Options], NClasses) :-
	getoptlist(OpClasses, CList, 1),
	numofcars(Classes, CList, Num),
	sequence_total(Num, Num, 0, K, M, Sequence, CList),
	capacityconstraints(Sequence, Classes, Options, NClasses).

numofcars(_, [], 0).
numofcars(Classes, [Class|CList], N) :-
	getnth(Class, Classes, Cars),
	numofcars(Classes, CList, T),
	N is T + Cars.

getnth(1, [X|_], X).
getnth(N, [_|Y], X) :-
	N =\= 1,
	T is N - 1,
	getnth(T, Y, X).

getoptlist([], [], _).
getoptlist([X|Y], [N|Z], N) :-
	X =:= 1,
	T is N + 1,
	getoptlist(Y, Z, T).
getoptlist([X|Y], Z, N) :-
	X =:= 0,
	T is N + 1,
	getoptlist(Y, Z, T).