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

num_righe(20).
num_col(20).
iniziale(pos(6,20)).
occupata(pos(1,2)).
occupata(pos(1,4)).
occupata(pos(1,8)).
occupata(pos(1,10)).
occupata(pos(1,13)).
occupata(pos(1,18)).
occupata(pos(2,6)).
occupata(pos(2,8)).
occupata(pos(2,12)).
occupata(pos(2,15)).
occupata(pos(2,16)).
occupata(pos(2,18)).
occupata(pos(2,20)).
occupata(pos(3,1)).
occupata(pos(3,3)).
occupata(pos(3,4)).
occupata(pos(3,5)).
occupata(pos(3,6)).
occupata(pos(3,10)).
occupata(pos(3,11)).
occupata(pos(3,14)).
occupata(pos(3,15)).
occupata(pos(3,18)).
occupata(pos(3,20)).
occupata(pos(4,1)).
occupata(pos(4,3)).
occupata(pos(4,7)).
occupata(pos(4,8)).
occupata(pos(4,13)).
occupata(pos(4,17)).
occupata(pos(5,3)).
occupata(pos(5,5)).
occupata(pos(5,9)).
occupata(pos(5,10)).
occupata(pos(5,11)).
occupata(pos(5,12)).
occupata(pos(5,15)).
occupata(pos(5,16)).
occupata(pos(5,18)).
occupata(pos(5,19)).
occupata(pos(6,2)).
occupata(pos(6,6)).
occupata(pos(6,8)).
occupata(pos(6,13)).
occupata(pos(6,16)).
occupata(pos(7,3)).
occupata(pos(7,4)).
occupata(pos(7,6)).
occupata(pos(7,10)).
occupata(pos(7,12)).
occupata(pos(7,14)).
occupata(pos(7,17)).
occupata(pos(7,19)).
occupata(pos(8,1)).
occupata(pos(8,5)).
occupata(pos(8,6)).
occupata(pos(8,8)).
occupata(pos(8,10)).
occupata(pos(8,15)).
occupata(pos(8,17)).
occupata(pos(8,19)).
occupata(pos(9,3)).
occupata(pos(9,5)).
occupata(pos(9,9)).
occupata(pos(9,11)).
occupata(pos(9,13)).
occupata(pos(9,14)).
occupata(pos(9,17)).
occupata(pos(9,19)).
occupata(pos(10,2)).
occupata(pos(10,3)).
occupata(pos(10,5)).
occupata(pos(10,7)).
occupata(pos(10,11)).
occupata(pos(10,14)).
occupata(pos(10,16)).
occupata(pos(10,19)).
occupata(pos(11,1)).
occupata(pos(11,5)).
occupata(pos(11,8)).
occupata(pos(11,9)).
occupata(pos(11,10)).
occupata(pos(11,13)).
occupata(pos(11,14)).
occupata(pos(11,17)).
occupata(pos(11,20)).
occupata(pos(12,1)).
occupata(pos(12,3)).
occupata(pos(12,4)).
occupata(pos(12,6)).
occupata(pos(12,7)).
occupata(pos(12,12)).
occupata(pos(12,16)).
occupata(pos(12,18)).
occupata(pos(13,3)).
occupata(pos(13,4)).
occupata(pos(13,9)).
occupata(pos(13,11)).
occupata(pos(13,14)).
occupata(pos(13,15)).
occupata(pos(13,16)).
occupata(pos(13,20)).
occupata(pos(14,2)).
occupata(pos(14,6)).
occupata(pos(14,8)).
occupata(pos(14,10)).
occupata(pos(14,13)).
occupata(pos(14,17)).
occupata(pos(14,18)).
occupata(pos(15,3)).
occupata(pos(15,5)).
occupata(pos(15,7)).
occupata(pos(15,12)).
occupata(pos(15,15)).
occupata(pos(15,17)).
occupata(pos(15,20)).
occupata(pos(16,1)).
occupata(pos(16,3)).
occupata(pos(16,5)).
occupata(pos(16,7)).
occupata(pos(16,9)).
occupata(pos(16,11)).
occupata(pos(16,14)).
occupata(pos(16,15)).
occupata(pos(16,19)).
occupata(pos(16,20)).
occupata(pos(17,3)).
occupata(pos(17,7)).
occupata(pos(17,9)).
occupata(pos(17,10)).
occupata(pos(17,13)).
occupata(pos(17,16)).
occupata(pos(17,17)).
occupata(pos(17,20)).
occupata(pos(18,2)).
occupata(pos(18,4)).
occupata(pos(18,5)).
occupata(pos(18,11)).
occupata(pos(18,14)).
occupata(pos(18,17)).
occupata(pos(18,18)).
occupata(pos(19,5)).
occupata(pos(19,6)).
occupata(pos(19,8)).
occupata(pos(19,9)).
occupata(pos(19,11)).
occupata(pos(19,13)).
occupata(pos(19,15)).
occupata(pos(19,18)).
occupata(pos(19,19)).
occupata(pos(20,2)).
occupata(pos(20,3)).
occupata(pos(20,7)).
occupata(pos(20,16)).
numeroOccupate(154).
heuristic(1).
