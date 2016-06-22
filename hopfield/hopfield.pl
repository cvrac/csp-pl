hopfield(Lv, W) :- length(Lv, M), MM is -M, hopfield1(Lv, MM, W).

/*For each vector, generate the Yi * Yi transpose matrix, and add the matrix to the sum matrix. For the case of 
the rightmost matrix, add the -I identity matrix.*/
hopfield1([V], M, W) 	:- genmatr(V, V, Mat), length(V, N), K is N + 1, genidmat(N, K, M, I), sumatr(Mat, I, W).
hopfield1([V|Lv], M, W) :- genmatr(V, V, Mat), hopfield1(Lv, M, S), sumatr(Mat, S, W).

/*Given a vector, generates the Yi * Yi transpose matrix, by iterating the vector elements and using prod*/
genmatr([H], V, [Vz])		:- prod(H, V, Vz).
genmatr([H|L], V, [Vz|R])	:- genmatr(L, V, R), prod(H, V, Vz).

/*Multiplies a vector by 1 or -1*/
prod(H, [X], [X])		:- H =:= 1.
prod(H, [X], [Xz])		:- H =:= -1, Xz is -1 * X.
prod(H, [X|V], [X|S]) 	:- H =:= 1, prod(H, V, S).
prod(H, [X|V], [Xz|S])	:- H =:= -1, prod(H, V, S), Xz is -1 * X.

/*generates an identity matrix I, on which the elements of the main diagonal of the matrix are multiplied by M (-M on the first line).*/
genidmat(0, _, _, []).
genidmat(L, N, M, I) :- L =\= 0, U is N - L, K is N - 1, genidrow(K, U, M, Ri), S is L - 1, genidmat(S, N, M, Temp), append(Temp, [Ri], I).

/*generates an identity matrix row*/
genidrow(0, _, _, []).
genidrow(T, N, M, [0|R]) :- T =\= 0, T =\= N, S is T - 1, genidrow(S, N, M, R).
genidrow(T, N, M, [M|R]) :- T =\= 0, T =:= N, S is T - 1, genidrow(S, N, M, R).

/*addition of 2 matrices*/
sumatr([R], [I], [W])				:- sumrow(R, I, W).
sumatr([R|RMat], [I|IMat], [S|W])	:- sumatr(RMat, IMat, W), sumrow(R, I, S).

/*addition of 2 rows*/
sumrow([X], [Y], [Z]) 			:- Z is X + Y.
sumrow([X|Xs], [Y|Ys], [Z|Zs]) 	:- sumrow(Xs, Ys, Zs), Z is X + Y.