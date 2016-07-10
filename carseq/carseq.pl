:- lib(ic).
:- lib(ic_global).

carseq(Sequence) :-
	classes(Classes),
	options(Options),
	length(Classes, NClasses),
	sumlist1(Classes, NCars),
	var_def(Sequence, NCars, NClasses),
	constraints(Sequence, Classes, Options, NClasses),
	search(Sequence, 0, first_fail, indomain, complete, []).


sumlist1([], 0).
sumlist1([X|Y], N) :-
	sumlist1(Y, Ns),
	N is Ns + X.

var_def(Sequence, NCars, NClasses) :-
	length(Sequence, NCars),
	Sequence #:: 1..NClasses.

constraints(Sequence, Classes, Options, NClasses) :-
	carsperclassconstraint(Sequence, Classes, 1),
	capacityconstraints(Sequence, Classes, Options, NClasses).


/* For each class, there's a specific number of cars to be produced,
 *so on the solution, each class has to exist exactly X times (X cars)
 */
carsperclassconstraint(_, [], _).
carsperclassconstraint(Sequence, [X|Y], Z) :-
	occurrences(Z, Sequence, X),
	T is Z + 1,
	carsperclassconstraint(Sequence, Y, T).


/* On a given option, get a list of the classes which have this option, as well as
 *the number of cars belonging to these classes. The capacity constraint is satisfied
 *using the build-in predicate sequence_total/7, where on a sequence of M cars, there
 *exist at most K requiring the current option.
 */
capacityconstraints(_, _, [], _).
capacityconstraints(Sequence, Classes, [M/K/OpClasses|Options], NClasses) :-
	getoptlist(OpClasses, CList, 1),
	numofcars(Classes, CList, Num),
	sequence_total(Num, Num, 0, K, M, Sequence, CList),
	capacityconstraints(Sequence, Classes, Options, NClasses).

/* Given a list of class indexes, find, on the initial classes list,
 *the total sum of the classes' cars.
 */
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


/* Given a list of ZeroOnes, create a list of the indexes where ones exist*/
getoptlist([], [], _).
getoptlist([X|Y], [N|Z], N) :-
	X =:= 1,
	T is N + 1,
	getoptlist(Y, Z, T).
getoptlist([X|Y], Z, N) :-
	X =:= 0,
	T is N + 1,
	getoptlist(Y, Z, T).