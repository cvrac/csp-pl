:- set_flag(print_depth, 1000).

:- lib(ic).
:- lib(ic_global).
:- lib(branch_and_bound).

queens(N, Solution, Cost) :-
   length(Solution, N),
   Solution #:: 1..N,
   make_diag_and_cost_list(Solution, UpDiag, DownDiag, CostList, 1),
   ic_global:alldifferent(Solution),
   ic_global:alldifferent(UpDiag),
   ic_global:alldifferent(DownDiag),
   Cost #= max(CostList),
   bb_min(search(Solution, 0, first_fail, indomain_middle, complete, []),
      Cost, bb_options{strategy:restart}).

make_diag_and_cost_list([], [], [], [], _).
make_diag_and_cost_list([Y|Ys], [U|UpDiag], [D|DownDiag],
      [abs(2*X-Y)|CostList], X) :-
   U #= eval(X-Y),
   D #= eval(X+Y),
   NextX is X + 1,
   make_diag_and_cost_list(Ys, UpDiag, DownDiag, CostList, NextX).