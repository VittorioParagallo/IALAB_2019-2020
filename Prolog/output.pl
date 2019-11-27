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
num_righe(20).
num_col(20).
iniziale(pos(8,8)).
occupata(pos(1,2)).
occupata(pos(1,3)).
occupata(pos(1,8)).
occupata(pos(1,11)).
occupata(pos(1,12)).
occupata(pos(1,17)).
occupata(pos(2,5)).
occupata(pos(2,6)).
occupata(pos(2,9)).
occupata(pos(2,14)).
occupata(pos(2,15)).
occupata(pos(2,16)).
occupata(pos(2,19)).
occupata(pos(3,2)).
occupata(pos(3,3)).
occupata(pos(3,4)).
occupata(pos(3,5)).
occupata(pos(3,7)).
occupata(pos(3,10)).
occupata(pos(3,12)).
occupata(pos(3,13)).
occupata(pos(3,14)).
occupata(pos(3,18)).
occupata(pos(4,2)).
occupata(pos(4,8)).
occupata(pos(4,16)).
occupata(pos(4,17)).
occupata(pos(4,20)).
occupata(pos(5,3)).
occupata(pos(5,4)).
occupata(pos(5,6)).
occupata(pos(5,9)).
occupata(pos(5,11)).
occupata(pos(5,12)).
occupata(pos(5,13)).
occupata(pos(5,14)).
occupata(pos(5,15)).
occupata(pos(5,19)).
occupata(pos(6,1)).
occupata(pos(6,4)).
occupata(pos(6,7)).
occupata(pos(6,9)).
occupata(pos(6,10)).
occupata(pos(6,17)).
occupata(pos(6,18)).
occupata(pos(7,1)).
occupata(pos(7,2)).
occupata(pos(7,4)).
occupata(pos(7,6)).
occupata(pos(7,7)).
occupata(pos(7,8)).
occupata(pos(7,12)).
occupata(pos(7,13)).
occupata(pos(7,15)).
occupata(pos(7,16)).
occupata(pos(7,20)).
occupata(pos(8,1)).
occupata(pos(8,2)).
occupata(pos(8,4)).
occupata(pos(8,7)).
occupata(pos(8,10)).
occupata(pos(8,12)).
occupata(pos(8,14)).
occupata(pos(8,18)).
occupata(pos(9,1)).
occupata(pos(9,4)).
occupata(pos(9,6)).
occupata(pos(9,7)).
occupata(pos(9,8)).
occupata(pos(9,9)).
occupata(pos(9,11)).
occupata(pos(9,14)).
occupata(pos(9,16)).
occupata(pos(9,17)).
occupata(pos(9,19)).
occupata(pos(10,3)).
occupata(pos(10,7)).
occupata(pos(10,13)).
occupata(pos(10,16)).
occupata(pos(11,2)).
occupata(pos(11,5)).
occupata(pos(11,8)).
occupata(pos(11,10)).
occupata(pos(11,12)).
occupata(pos(11,15)).
occupata(pos(11,18)).
occupata(pos(11,19)).
occupata(pos(12,3)).
occupata(pos(12,5)).
occupata(pos(12,6)).
occupata(pos(12,8)).
occupata(pos(12,10)).
occupata(pos(12,14)).
occupata(pos(12,15)).
occupata(pos(12,17)).
occupata(pos(13,1)).
occupata(pos(13,3)).
occupata(pos(13,6)).
occupata(pos(13,9)).
occupata(pos(13,10)).
occupata(pos(13,12)).
occupata(pos(13,14)).
occupata(pos(13,17)).
occupata(pos(13,19)).
occupata(pos(14,1)).
occupata(pos(14,4)).
occupata(pos(14,6)).
occupata(pos(14,7)).
occupata(pos(14,11)).
occupata(pos(14,14)).
occupata(pos(14,16)).
occupata(pos(14,18)).
occupata(pos(14,20)).
occupata(pos(15,2)).
occupata(pos(15,4)).
occupata(pos(15,8)).
occupata(pos(15,9)).
occupata(pos(15,11)).
occupata(pos(15,12)).
occupata(pos(15,14)).
occupata(pos(15,16)).
occupata(pos(16,2)).
occupata(pos(16,4)).
occupata(pos(16,6)).
occupata(pos(16,9)).
occupata(pos(16,13)).
occupata(pos(16,17)).
occupata(pos(16,19)).
occupata(pos(17,2)).
occupata(pos(17,5)).
occupata(pos(17,6)).
occupata(pos(17,8)).
occupata(pos(17,10)).
occupata(pos(17,11)).
occupata(pos(17,14)).
occupata(pos(17,15)).
occupata(pos(17,19)).
occupata(pos(18,3)).
occupata(pos(18,5)).
occupata(pos(18,8)).
occupata(pos(18,10)).
occupata(pos(18,11)).
occupata(pos(18,12)).
occupata(pos(18,16)).
occupata(pos(18,18)).
occupata(pos(19,1)).
occupata(pos(19,5)).
occupata(pos(19,7)).
occupata(pos(19,11)).
occupata(pos(19,14)).
occupata(pos(19,17)).
occupata(pos(19,19)).
occupata(pos(20,3)).
occupata(pos(20,7)).
occupata(pos(20,9)).
occupata(pos(20,13)).
occupata(pos(20,14)).
occupata(pos(20,15)).
numeroOccupate(158).
finale(pos(20,1)).
