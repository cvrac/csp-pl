:- lib(fd).

color_graph(N, D, Col, C) :-
	create_graph(N, D, Graph),
	length(Sol, N),
	color_graph1(N, Sol, Graph, N, C, Col).

color_graph1(N, Sol, Graph, N, 1, [1]) :-
   N =:= 1.
color_graph1(N, Sol, Graph, N, T, Sol) :-
   N > 1,
   one_between(2, N, T),
   Sol :: 1..T,
   color_graph2(N, Sol, Graph, T), !.

one_between(X, Y, X) :- X =< Y.
one_between(X, Y, Z) :- X < Y, X1 is X + 1, one_between(X1, Y, Z).

color_graph2(_, [], _, _).
color_graph2(N, Sol, Graph, C) :-
	deleteffc(V1, Sol, RestSol),
	indomain(V1),
	color_graph2(N, RestSol, Graph, C).


constraints(_, []).
constraints(Vertices, [V1 - V2|Graph]) :-
   getnth(V1, Vertices, X1),
   getnth(V2, Vertices, X2),
   X1 ## X2,
   constraints(Vertices, Graph).

getnth(1, [Vertex|_], Vertex).
getnth(N, [_|Vertices], Vertex) :-
   N =\= 1,
   T is N - 1,
   getnth(T, Vertices, Vertex).

create_graph(NNodes, Density, Graph) :-
   cr_gr(1, 2, NNodes, Density, [], Graph).

cr_gr(NNodes, _, NNodes, _, Graph, Graph).
cr_gr(N1, N2, NNodes, Density, SoFarGraph, Graph) :-
   N1 < NNodes,
   N2 > NNodes,
   NN1 is N1 + 1,
   NN2 is NN1 + 1,
   cr_gr(NN1, NN2, NNodes, Density, SoFarGraph, Graph).
cr_gr(N1, N2, NNodes, Density, SoFarGraph, Graph) :-
   N1 < NNodes,
   N2 =< NNodes,
   rand(1, 100, Rand),
   (Rand =< Density ->
      append(SoFarGraph, [N1 - N2], NewSoFarGraph) ;
      NewSoFarGraph = SoFarGraph),
   NN2 is N2 + 1,
   cr_gr(N1, NN2, NNodes, Density, NewSoFarGraph, Graph).

rand(N1, N2, R) :-
   random(R1),
   R is R1 mod (N2 - N1 + 1) + N1.