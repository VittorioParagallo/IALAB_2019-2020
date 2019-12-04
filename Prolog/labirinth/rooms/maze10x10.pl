:- dynamic finale/1.
:- dynamic occupata/1.

% Min
list_min([L|Ls], Min) :-
	list_min(Ls, L, Min).

list_min([], Min, Min).
list_min([L|Ls], Min0, Min) :-
	Min1 is min(L, Min0),
	list_min(Ls, Min1, Min).

% euristica1 (distanza di manatthan)
h_Manatthan(pos(R, C), MinDistance):-
	findall(Distance, (finale(pos(FinalR, FinalC)), Distance is abs(FinalR-R) + abs(FinalC-C)), Distances),
	list_min(Distances, MinDistance).

% euristica2 (distanza euclidea)
h_Euclidean(pos(R, C), MinDistance):-
	findall(Distance, (finale(pos(FinalR, FinalC)), Distance is sqrt((FinalR-R)^2 + (FinalC-C)^2)), Distances),
	list_min(Distances, MinDistance).

% euristica
h(pos(R, C), Distance):-
	heuristic(H),
	H == 1,!,
	h_Manatthan(pos(R, C), Distance).

h(pos(R, C), Distance):-
	heuristic(H),
	H == 2,!,
	h_Euclidean(pos(R, C), Distance).

% gScore
g(CurrentGValue, GScore):-
	GScore is CurrentGValue + 1.

heuristic(1).
num_righe(10).
num_col(10).
iniziale(pos(4,9)).
occupata(pos(1,2)).
occupata(pos(1,4)).
occupata(pos(1,8)).
occupata(pos(2,6)).
occupata(pos(2,8)).
occupata(pos(2,9)).
occupata(pos(3,2)).
occupata(pos(3,3)).
occupata(pos(3,5)).
occupata(pos(3,9)).
occupata(pos(4,3)).
occupata(pos(4,6)).
occupata(pos(4,7)).
occupata(pos(4,9)).
occupata(pos(5,1)).
occupata(pos(5,4)).
occupata(pos(5,7)).
occupata(pos(5,9)).
occupata(pos(6,3)).
occupata(pos(6,5)).
occupata(pos(6,7)).
occupata(pos(7,2)).
occupata(pos(7,5)).
occupata(pos(7,8)).
occupata(pos(7,9)).
occupata(pos(8,4)).
occupata(pos(8,7)).
occupata(pos(8,9)).
occupata(pos(9,1)).
occupata(pos(9,3)).
occupata(pos(9,5)).
occupata(pos(9,7)).
occupata(pos(9,9)).
occupata(pos(10,3)).
occupata(pos(10,7)).
numeroOccupate(35).
finale(pos(1,3)).
