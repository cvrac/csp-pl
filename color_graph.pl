:- lib(ic).

color_graph(N, D, Col, C) :-
   create_graph(N, D, Graph),
   length(Sol, N),
   color_graph1(N, Sol, Graph, N, C, Col).

/*Iterate for every possible chromatic num, until there's no other solution
 *The last solution found will be the optimal.
 */
color_graph1(N, Sol, Graph, 1, 1, [1]) :- N =:= 1.
color_graph1(N, Sol, Graph, 1, C, Sol) :- N =\= 1.
color_graph1(N, Sol, Graph, T, C, List2) :-
   length(Solx, N),
   color_graph2(N, Solx, Graph, T), !,
   Z is T - 1,
   color_graph1(N, Solx, Graph, Z, C, List2).
color_graph1(N, Sol, Graph, T, C, Sol) :- C is T + 1.

one_between(X, Y, X) :- X =< Y.
one_between(X, Y, Z) :- X < Y, X1 is X + 1, one_between(X1, Y, Z).

/*find a solution for a specific Chromatic number*/
color_graph2(N, Solution, Graph, C):-
   Solution #:: 1..C,
   constraints(Solution, Graph),
   search(Solution, 0, first_fail, indomain, complete, []).

/*Constraints definition
 *Two neighbors can not have the same color
 */
constraints(_, []).
constraints(Vertices, [V1 - V2|Graph]) :-
   getnth(V1, Vertices, X1),
   getnth(V2, Vertices, X2),
   X1 #\= X2,
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
