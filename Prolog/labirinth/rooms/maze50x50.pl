:- dynamic finale/1.
:- dynamic occupata/1.
:- dynamic heuristic/1.
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
num_righe(50).
num_col(50).
iniziale(pos(32,46)).
occupata(pos(1,7)).
occupata(pos(1,12)).
occupata(pos(1,18)).
occupata(pos(1,26)).
occupata(pos(1,31)).
occupata(pos(1,37)).
occupata(pos(1,40)).
occupata(pos(1,46)).
occupata(pos(2,2)).
occupata(pos(2,3)).
occupata(pos(2,4)).
occupata(pos(2,5)).
occupata(pos(2,9)).
occupata(pos(2,11)).
occupata(pos(2,14)).
occupata(pos(2,16)).
occupata(pos(2,20)).
occupata(pos(2,21)).
occupata(pos(2,22)).
occupata(pos(2,23)).
occupata(pos(2,24)).
occupata(pos(2,26)).
occupata(pos(2,28)).
occupata(pos(2,30)).
occupata(pos(2,33)).
occupata(pos(2,34)).
occupata(pos(2,35)).
occupata(pos(2,38)).
occupata(pos(2,40)).
occupata(pos(2,42)).
occupata(pos(2,44)).
occupata(pos(2,46)).
occupata(pos(2,48)).
occupata(pos(2,49)).
occupata(pos(3,2)).
occupata(pos(3,6)).
occupata(pos(3,7)).
occupata(pos(3,8)).
occupata(pos(3,9)).
occupata(pos(3,12)).
occupata(pos(3,14)).
occupata(pos(3,15)).
occupata(pos(3,18)).
occupata(pos(3,19)).
occupata(pos(3,24)).
occupata(pos(3,26)).
occupata(pos(3,28)).
occupata(pos(3,31)).
occupata(pos(3,36)).
occupata(pos(3,42)).
occupata(pos(3,44)).
occupata(pos(3,46)).
occupata(pos(3,49)).
occupata(pos(4,4)).
occupata(pos(4,6)).
occupata(pos(4,10)).
occupata(pos(4,13)).
occupata(pos(4,17)).
occupata(pos(4,21)).
occupata(pos(4,22)).
occupata(pos(4,23)).
occupata(pos(4,26)).
occupata(pos(4,29)).
occupata(pos(4,32)).
occupata(pos(4,33)).
occupata(pos(4,34)).
occupata(pos(4,36)).
occupata(pos(4,37)).
occupata(pos(4,38)).
occupata(pos(4,40)).
occupata(pos(4,41)).
occupata(pos(4,44)).
occupata(pos(4,48)).
occupata(pos(5,2)).
occupata(pos(5,3)).
occupata(pos(5,6)).
occupata(pos(5,8)).
occupata(pos(5,11)).
occupata(pos(5,15)).
occupata(pos(5,16)).
occupata(pos(5,19)).
occupata(pos(5,21)).
occupata(pos(5,25)).
occupata(pos(5,26)).
occupata(pos(5,28)).
occupata(pos(5,30)).
occupata(pos(5,34)).
occupata(pos(5,39)).
occupata(pos(5,43)).
occupata(pos(5,45)).
occupata(pos(5,46)).
occupata(pos(5,47)).
occupata(pos(5,50)).
occupata(pos(6,3)).
occupata(pos(6,5)).
occupata(pos(6,9)).
occupata(pos(6,12)).
occupata(pos(6,14)).
occupata(pos(6,18)).
occupata(pos(6,21)).
occupata(pos(6,23)).
occupata(pos(6,24)).
occupata(pos(6,28)).
occupata(pos(6,31)).
occupata(pos(6,32)).
occupata(pos(6,35)).
occupata(pos(6,36)).
occupata(pos(6,37)).
occupata(pos(6,39)).
occupata(pos(6,41)).
occupata(pos(6,42)).
occupata(pos(6,47)).
occupata(pos(6,49)).
occupata(pos(7,1)).
occupata(pos(7,3)).
occupata(pos(7,7)).
occupata(pos(7,9)).
occupata(pos(7,11)).
occupata(pos(7,13)).
occupata(pos(7,14)).
occupata(pos(7,15)).
occupata(pos(7,17)).
occupata(pos(7,19)).
occupata(pos(7,21)).
occupata(pos(7,24)).
occupata(pos(7,25)).
occupata(pos(7,27)).
occupata(pos(7,29)).
occupata(pos(7,32)).
occupata(pos(7,34)).
occupata(pos(7,39)).
occupata(pos(7,41)).
occupata(pos(7,44)).
occupata(pos(7,46)).
occupata(pos(7,47)).
occupata(pos(7,49)).
occupata(pos(8,1)).
occupata(pos(8,4)).
occupata(pos(8,5)).
occupata(pos(8,6)).
occupata(pos(8,8)).
occupata(pos(8,11)).
occupata(pos(8,14)).
occupata(pos(8,17)).
occupata(pos(8,21)).
occupata(pos(8,22)).
occupata(pos(8,27)).
occupata(pos(8,30)).
occupata(pos(8,32)).
occupata(pos(8,35)).
occupata(pos(8,37)).
occupata(pos(8,38)).
occupata(pos(8,42)).
occupata(pos(8,43)).
occupata(pos(8,44)).
occupata(pos(9,2)).
occupata(pos(9,6)).
occupata(pos(9,8)).
occupata(pos(9,10)).
occupata(pos(9,12)).
occupata(pos(9,16)).
occupata(pos(9,18)).
occupata(pos(9,19)).
occupata(pos(9,22)).
occupata(pos(9,23)).
occupata(pos(9,24)).
occupata(pos(9,25)).
occupata(pos(9,26)).
occupata(pos(9,27)).
occupata(pos(9,29)).
occupata(pos(9,33)).
occupata(pos(9,35)).
occupata(pos(9,38)).
occupata(pos(9,40)).
occupata(pos(9,41)).
occupata(pos(9,45)).
occupata(pos(9,46)).
occupata(pos(9,47)).
occupata(pos(9,48)).
occupata(pos(9,49)).
occupata(pos(10,3)).
occupata(pos(10,5)).
occupata(pos(10,8)).
occupata(pos(10,10)).
occupata(pos(10,12)).
occupata(pos(10,13)).
occupata(pos(10,15)).
occupata(pos(10,16)).
occupata(pos(10,20)).
occupata(pos(10,21)).
occupata(pos(10,31)).
occupata(pos(10,32)).
occupata(pos(10,35)).
occupata(pos(10,36)).
occupata(pos(10,38)).
occupata(pos(10,40)).
occupata(pos(10,41)).
occupata(pos(10,43)).
occupata(pos(10,45)).
occupata(pos(10,50)).
occupata(pos(11,2)).
occupata(pos(11,7)).
occupata(pos(11,10)).
occupata(pos(11,15)).
occupata(pos(11,18)).
occupata(pos(11,23)).
occupata(pos(11,24)).
occupata(pos(11,25)).
occupata(pos(11,26)).
occupata(pos(11,28)).
occupata(pos(11,29)).
occupata(pos(11,32)).
occupata(pos(11,34)).
occupata(pos(11,36)).
occupata(pos(11,38)).
occupata(pos(11,43)).
occupata(pos(11,45)).
occupata(pos(11,47)).
occupata(pos(11,48)).
occupata(pos(11,50)).
occupata(pos(12,4)).
occupata(pos(12,6)).
occupata(pos(12,9)).
occupata(pos(12,12)).
occupata(pos(12,13)).
occupata(pos(12,17)).
occupata(pos(12,19)).
occupata(pos(12,20)).
occupata(pos(12,22)).
occupata(pos(12,26)).
occupata(pos(12,30)).
occupata(pos(12,32)).
occupata(pos(12,34)).
occupata(pos(12,38)).
occupata(pos(12,39)).
occupata(pos(12,40)).
occupata(pos(12,41)).
occupata(pos(12,43)).
occupata(pos(12,48)).
occupata(pos(13,2)).
occupata(pos(13,3)).
occupata(pos(13,7)).
occupata(pos(13,10)).
occupata(pos(13,14)).
occupata(pos(13,15)).
occupata(pos(13,16)).
occupata(pos(13,17)).
occupata(pos(13,21)).
occupata(pos(13,22)).
occupata(pos(13,24)).
occupata(pos(13,26)).
occupata(pos(13,28)).
occupata(pos(13,29)).
occupata(pos(13,32)).
occupata(pos(13,35)).
occupata(pos(13,36)).
occupata(pos(13,42)).
occupata(pos(13,44)).
occupata(pos(13,46)).
occupata(pos(13,48)).
occupata(pos(13,49)).
occupata(pos(14,4)).
occupata(pos(14,6)).
occupata(pos(14,8)).
occupata(pos(14,11)).
occupata(pos(14,12)).
occupata(pos(14,14)).
occupata(pos(14,19)).
occupata(pos(14,24)).
occupata(pos(14,26)).
occupata(pos(14,30)).
occupata(pos(14,33)).
occupata(pos(14,37)).
occupata(pos(14,38)).
occupata(pos(14,40)).
occupata(pos(14,41)).
occupata(pos(14,45)).
occupata(pos(14,47)).
occupata(pos(15,1)).
occupata(pos(15,2)).
occupata(pos(15,5)).
occupata(pos(15,8)).
occupata(pos(15,10)).
occupata(pos(15,12)).
occupata(pos(15,16)).
occupata(pos(15,17)).
occupata(pos(15,18)).
occupata(pos(15,20)).
occupata(pos(15,21)).
occupata(pos(15,22)).
occupata(pos(15,23)).
occupata(pos(15,27)).
occupata(pos(15,28)).
occupata(pos(15,30)).
occupata(pos(15,32)).
occupata(pos(15,34)).
occupata(pos(15,35)).
occupata(pos(15,39)).
occupata(pos(15,43)).
occupata(pos(15,49)).
occupata(pos(16,4)).
occupata(pos(16,7)).
occupata(pos(16,10)).
occupata(pos(16,13)).
occupata(pos(16,14)).
occupata(pos(16,15)).
occupata(pos(16,20)).
occupata(pos(16,23)).
occupata(pos(16,25)).
occupata(pos(16,26)).
occupata(pos(16,28)).
occupata(pos(16,30)).
occupata(pos(16,31)).
occupata(pos(16,35)).
occupata(pos(16,36)).
occupata(pos(16,38)).
occupata(pos(16,41)).
occupata(pos(16,42)).
occupata(pos(16,44)).
occupata(pos(16,46)).
occupata(pos(16,47)).
occupata(pos(16,49)).
occupata(pos(17,2)).
occupata(pos(17,6)).
occupata(pos(17,7)).
occupata(pos(17,9)).
occupata(pos(17,12)).
occupata(pos(17,13)).
occupata(pos(17,17)).
occupata(pos(17,18)).
occupata(pos(17,21)).
occupata(pos(17,25)).
occupata(pos(17,28)).
occupata(pos(17,33)).
occupata(pos(17,34)).
occupata(pos(17,38)).
occupata(pos(17,40)).
occupata(pos(17,44)).
occupata(pos(17,45)).
occupata(pos(17,48)).
occupata(pos(18,1)).
occupata(pos(18,3)).
occupata(pos(18,5)).
occupata(pos(18,9)).
occupata(pos(18,10)).
occupata(pos(18,15)).
occupata(pos(18,16)).
occupata(pos(18,18)).
occupata(pos(18,19)).
occupata(pos(18,22)).
occupata(pos(18,24)).
occupata(pos(18,27)).
occupata(pos(18,30)).
occupata(pos(18,32)).
occupata(pos(18,36)).
occupata(pos(18,37)).
occupata(pos(18,40)).
occupata(pos(18,42)).
occupata(pos(18,47)).
occupata(pos(18,50)).
occupata(pos(19,4)).
occupata(pos(19,7)).
occupata(pos(19,10)).
occupata(pos(19,11)).
occupata(pos(19,12)).
occupata(pos(19,13)).
occupata(pos(19,14)).
occupata(pos(19,20)).
occupata(pos(19,22)).
occupata(pos(19,24)).
occupata(pos(19,25)).
occupata(pos(19,28)).
occupata(pos(19,30)).
occupata(pos(19,33)).
occupata(pos(19,34)).
occupata(pos(19,36)).
occupata(pos(19,38)).
occupata(pos(19,41)).
occupata(pos(19,42)).
occupata(pos(19,43)).
occupata(pos(19,45)).
occupata(pos(19,47)).
occupata(pos(19,48)).
occupata(pos(20,2)).
occupata(pos(20,4)).
occupata(pos(20,5)).
occupata(pos(20,8)).
occupata(pos(20,9)).
occupata(pos(20,16)).
occupata(pos(20,18)).
occupata(pos(20,20)).
occupata(pos(20,22)).
occupata(pos(20,26)).
occupata(pos(20,29)).
occupata(pos(20,31)).
occupata(pos(20,36)).
occupata(pos(20,39)).
occupata(pos(20,42)).
occupata(pos(20,46)).
occupata(pos(20,50)).
occupata(pos(21,2)).
occupata(pos(21,5)).
occupata(pos(21,6)).
occupata(pos(21,9)).
occupata(pos(21,11)).
occupata(pos(21,13)).
occupata(pos(21,14)).
occupata(pos(21,15)).
occupata(pos(21,16)).
occupata(pos(21,17)).
occupata(pos(21,20)).
occupata(pos(21,23)).
occupata(pos(21,24)).
occupata(pos(21,27)).
occupata(pos(21,32)).
occupata(pos(21,34)).
occupata(pos(21,35)).
occupata(pos(21,37)).
occupata(pos(21,41)).
occupata(pos(21,44)).
occupata(pos(21,46)).
occupata(pos(21,48)).
occupata(pos(21,49)).
occupata(pos(22,2)).
occupata(pos(22,3)).
occupata(pos(22,7)).
occupata(pos(22,12)).
occupata(pos(22,16)).
occupata(pos(22,19)).
occupata(pos(22,20)).
occupata(pos(22,21)).
occupata(pos(22,24)).
occupata(pos(22,26)).
occupata(pos(22,27)).
occupata(pos(22,28)).
occupata(pos(22,30)).
occupata(pos(22,33)).
occupata(pos(22,35)).
occupata(pos(22,37)).
occupata(pos(22,39)).
occupata(pos(22,41)).
occupata(pos(22,43)).
occupata(pos(22,45)).
occupata(pos(22,46)).
occupata(pos(22,48)).
occupata(pos(23,3)).
occupata(pos(23,5)).
occupata(pos(23,8)).
occupata(pos(23,9)).
occupata(pos(23,10)).
occupata(pos(23,11)).
occupata(pos(23,14)).
occupata(pos(23,16)).
occupata(pos(23,18)).
occupata(pos(23,20)).
occupata(pos(23,22)).
occupata(pos(23,24)).
occupata(pos(23,27)).
occupata(pos(23,30)).
occupata(pos(23,31)).
occupata(pos(23,33)).
occupata(pos(23,37)).
occupata(pos(23,39)).
occupata(pos(23,41)).
occupata(pos(23,48)).
occupata(pos(23,50)).
occupata(pos(24,1)).
occupata(pos(24,4)).
occupata(pos(24,6)).
occupata(pos(24,11)).
occupata(pos(24,13)).
occupata(pos(24,14)).
occupata(pos(24,16)).
occupata(pos(24,18)).
occupata(pos(24,22)).
occupata(pos(24,25)).
occupata(pos(24,29)).
occupata(pos(24,33)).
occupata(pos(24,35)).
occupata(pos(24,39)).
occupata(pos(24,41)).
occupata(pos(24,42)).
occupata(pos(24,43)).
occupata(pos(24,45)).
occupata(pos(24,47)).
occupata(pos(25,2)).
occupata(pos(25,4)).
occupata(pos(25,8)).
occupata(pos(25,9)).
occupata(pos(25,13)).
occupata(pos(25,18)).
occupata(pos(25,20)).
occupata(pos(25,21)).
occupata(pos(25,24)).
occupata(pos(25,25)).
occupata(pos(25,26)).
occupata(pos(25,28)).
occupata(pos(25,29)).
occupata(pos(25,31)).
occupata(pos(25,32)).
occupata(pos(25,34)).
occupata(pos(25,35)).
occupata(pos(25,36)).
occupata(pos(25,38)).
occupata(pos(25,39)).
occupata(pos(25,44)).
occupata(pos(25,47)).
occupata(pos(25,49)).
occupata(pos(26,2)).
occupata(pos(26,5)).
occupata(pos(26,7)).
occupata(pos(26,11)).
occupata(pos(26,14)).
occupata(pos(26,15)).
occupata(pos(26,16)).
occupata(pos(26,17)).
occupata(pos(26,23)).
occupata(pos(26,25)).
occupata(pos(26,27)).
occupata(pos(26,31)).
occupata(pos(26,35)).
occupata(pos(26,40)).
occupata(pos(26,42)).
occupata(pos(26,45)).
occupata(pos(26,47)).
occupata(pos(26,48)).
occupata(pos(27,3)).
occupata(pos(27,5)).
occupata(pos(27,6)).
occupata(pos(27,9)).
occupata(pos(27,10)).
occupata(pos(27,11)).
occupata(pos(27,13)).
occupata(pos(27,18)).
occupata(pos(27,19)).
occupata(pos(27,20)).
occupata(pos(27,22)).
occupata(pos(27,23)).
occupata(pos(27,28)).
occupata(pos(27,30)).
occupata(pos(27,33)).
occupata(pos(27,36)).
occupata(pos(27,37)).
occupata(pos(27,38)).
occupata(pos(27,41)).
occupata(pos(27,43)).
occupata(pos(27,45)).
occupata(pos(27,48)).
occupata(pos(27,50)).
occupata(pos(28,1)).
occupata(pos(28,3)).
occupata(pos(28,7)).
occupata(pos(28,8)).
occupata(pos(28,12)).
occupata(pos(28,15)).
occupata(pos(28,16)).
occupata(pos(28,20)).
occupata(pos(28,25)).
occupata(pos(28,26)).
occupata(pos(28,32)).
occupata(pos(28,35)).
occupata(pos(28,39)).
occupata(pos(28,43)).
occupata(pos(28,46)).
occupata(pos(28,48)).
occupata(pos(29,4)).
occupata(pos(29,5)).
occupata(pos(29,8)).
occupata(pos(29,10)).
occupata(pos(29,14)).
occupata(pos(29,17)).
occupata(pos(29,18)).
occupata(pos(29,20)).
occupata(pos(29,21)).
occupata(pos(29,23)).
occupata(pos(29,27)).
occupata(pos(29,28)).
occupata(pos(29,29)).
occupata(pos(29,30)).
occupata(pos(29,32)).
occupata(pos(29,34)).
occupata(pos(29,37)).
occupata(pos(29,40)).
occupata(pos(29,41)).
occupata(pos(29,44)).
occupata(pos(29,46)).
occupata(pos(29,50)).
occupata(pos(30,2)).
occupata(pos(30,4)).
occupata(pos(30,6)).
occupata(pos(30,10)).
occupata(pos(30,12)).
occupata(pos(30,13)).
occupata(pos(30,16)).
occupata(pos(30,18)).
occupata(pos(30,22)).
occupata(pos(30,24)).
occupata(pos(30,26)).
occupata(pos(30,31)).
occupata(pos(30,34)).
occupata(pos(30,36)).
occupata(pos(30,37)).
occupata(pos(30,38)).
occupata(pos(30,40)).
occupata(pos(30,42)).
occupata(pos(30,43)).
occupata(pos(30,46)).
occupata(pos(30,48)).
occupata(pos(31,3)).
occupata(pos(31,7)).
occupata(pos(31,8)).
occupata(pos(31,9)).
occupata(pos(31,11)).
occupata(pos(31,14)).
occupata(pos(31,19)).
occupata(pos(31,20)).
occupata(pos(31,24)).
occupata(pos(31,26)).
occupata(pos(31,28)).
occupata(pos(31,29)).
occupata(pos(31,31)).
occupata(pos(31,33)).
occupata(pos(31,36)).
occupata(pos(31,37)).
occupata(pos(31,38)).
occupata(pos(31,40)).
occupata(pos(31,45)).
occupata(pos(31,49)).
occupata(pos(32,1)).
occupata(pos(32,5)).
occupata(pos(32,7)).
occupata(pos(32,13)).
occupata(pos(32,16)).
occupata(pos(32,17)).
occupata(pos(32,19)).
occupata(pos(32,21)).
occupata(pos(32,22)).
occupata(pos(32,25)).
occupata(pos(32,29)).
occupata(pos(32,31)).
occupata(pos(32,35)).
occupata(pos(32,37)).
occupata(pos(32,40)).
occupata(pos(32,42)).
occupata(pos(32,43)).
occupata(pos(32,45)).
occupata(pos(32,46)).
occupata(pos(32,47)).
occupata(pos(32,50)).
occupata(pos(33,3)).
occupata(pos(33,4)).
occupata(pos(33,5)).
occupata(pos(33,8)).
occupata(pos(33,10)).
occupata(pos(33,12)).
occupata(pos(33,15)).
occupata(pos(33,17)).
occupata(pos(33,19)).
occupata(pos(33,21)).
occupata(pos(33,23)).
occupata(pos(33,27)).
occupata(pos(33,29)).
occupata(pos(33,32)).
occupata(pos(33,33)).
occupata(pos(33,34)).
occupata(pos(33,37)).
occupata(pos(33,39)).
occupata(pos(33,42)).
occupata(pos(33,44)).
occupata(pos(33,48)).
occupata(pos(34,2)).
occupata(pos(34,6)).
occupata(pos(34,8)).
occupata(pos(34,9)).
occupata(pos(34,10)).
occupata(pos(34,14)).
occupata(pos(34,19)).
occupata(pos(34,23)).
occupata(pos(34,24)).
occupata(pos(34,25)).
occupata(pos(34,26)).
occupata(pos(34,28)).
occupata(pos(34,31)).
occupata(pos(34,35)).
occupata(pos(34,37)).
occupata(pos(34,40)).
occupata(pos(34,46)).
occupata(pos(34,49)).
occupata(pos(35,2)).
occupata(pos(35,4)).
occupata(pos(35,12)).
occupata(pos(35,13)).
occupata(pos(35,16)).
occupata(pos(35,18)).
occupata(pos(35,20)).
occupata(pos(35,22)).
occupata(pos(35,30)).
occupata(pos(35,33)).
occupata(pos(35,39)).
occupata(pos(35,40)).
occupata(pos(35,42)).
occupata(pos(35,43)).
occupata(pos(35,45)).
occupata(pos(35,48)).
occupata(pos(35,49)).
occupata(pos(36,3)).
occupata(pos(36,4)).
occupata(pos(36,6)).
occupata(pos(36,7)).
occupata(pos(36,8)).
occupata(pos(36,9)).
occupata(pos(36,10)).
occupata(pos(36,12)).
occupata(pos(36,15)).
occupata(pos(36,17)).
occupata(pos(36,22)).
occupata(pos(36,24)).
occupata(pos(36,26)).
occupata(pos(36,27)).
occupata(pos(36,28)).
occupata(pos(36,29)).
occupata(pos(36,32)).
occupata(pos(36,33)).
occupata(pos(36,34)).
occupata(pos(36,35)).
occupata(pos(36,36)).
occupata(pos(36,37)).
occupata(pos(36,38)).
occupata(pos(36,44)).
occupata(pos(36,47)).
occupata(pos(37,1)).
occupata(pos(37,3)).
occupata(pos(37,6)).
occupata(pos(37,11)).
occupata(pos(37,14)).
occupata(pos(37,15)).
occupata(pos(37,19)).
occupata(pos(37,21)).
occupata(pos(37,22)).
occupata(pos(37,25)).
occupata(pos(37,30)).
occupata(pos(37,33)).
occupata(pos(37,40)).
occupata(pos(37,41)).
occupata(pos(37,43)).
occupata(pos(37,46)).
occupata(pos(37,48)).
occupata(pos(37,50)).
occupata(pos(38,4)).
occupata(pos(38,5)).
occupata(pos(38,8)).
occupata(pos(38,9)).
occupata(pos(38,12)).
occupata(pos(38,14)).
occupata(pos(38,17)).
occupata(pos(38,18)).
occupata(pos(38,23)).
occupata(pos(38,25)).
occupata(pos(38,26)).
occupata(pos(38,27)).
occupata(pos(38,28)).
occupata(pos(38,30)).
occupata(pos(38,31)).
occupata(pos(38,34)).
occupata(pos(38,36)).
occupata(pos(38,37)).
occupata(pos(38,39)).
occupata(pos(38,40)).
occupata(pos(38,42)).
occupata(pos(38,45)).
occupata(pos(38,50)).
occupata(pos(39,2)).
occupata(pos(39,5)).
occupata(pos(39,7)).
occupata(pos(39,10)).
occupata(pos(39,12)).
occupata(pos(39,15)).
occupata(pos(39,18)).
occupata(pos(39,20)).
occupata(pos(39,22)).
occupata(pos(39,28)).
occupata(pos(39,33)).
occupata(pos(39,36)).
occupata(pos(39,42)).
occupata(pos(39,44)).
occupata(pos(39,45)).
occupata(pos(39,47)).
occupata(pos(39,49)).
occupata(pos(40,1)).
occupata(pos(40,4)).
occupata(pos(40,7)).
occupata(pos(40,8)).
occupata(pos(40,10)).
occupata(pos(40,13)).
occupata(pos(40,15)).
occupata(pos(40,16)).
occupata(pos(40,17)).
occupata(pos(40,20)).
occupata(pos(40,23)).
occupata(pos(40,24)).
occupata(pos(40,25)).
occupata(pos(40,26)).
occupata(pos(40,28)).
occupata(pos(40,29)).
occupata(pos(40,31)).
occupata(pos(40,33)).
occupata(pos(40,34)).
occupata(pos(40,35)).
occupata(pos(40,38)).
occupata(pos(40,39)).
occupata(pos(40,40)).
occupata(pos(40,41)).
occupata(pos(40,44)).
occupata(pos(40,48)).
occupata(pos(41,3)).
occupata(pos(41,4)).
occupata(pos(41,6)).
occupata(pos(41,8)).
occupata(pos(41,12)).
occupata(pos(41,19)).
occupata(pos(41,21)).
occupata(pos(41,26)).
occupata(pos(41,30)).
occupata(pos(41,36)).
occupata(pos(41,38)).
occupata(pos(41,42)).
occupata(pos(41,45)).
occupata(pos(41,46)).
occupata(pos(41,50)).
occupata(pos(42,1)).
occupata(pos(42,6)).
occupata(pos(42,9)).
occupata(pos(42,11)).
occupata(pos(42,14)).
occupata(pos(42,15)).
occupata(pos(42,16)).
occupata(pos(42,17)).
occupata(pos(42,19)).
occupata(pos(42,23)).
occupata(pos(42,25)).
occupata(pos(42,27)).
occupata(pos(42,28)).
occupata(pos(42,31)).
occupata(pos(42,32)).
occupata(pos(42,33)).
occupata(pos(42,34)).
occupata(pos(42,37)).
occupata(pos(42,40)).
occupata(pos(42,43)).
occupata(pos(42,45)).
occupata(pos(42,47)).
occupata(pos(42,48)).
occupata(pos(42,50)).
occupata(pos(43,3)).
occupata(pos(43,5)).
occupata(pos(43,7)).
occupata(pos(43,9)).
occupata(pos(43,11)).
occupata(pos(43,13)).
occupata(pos(43,18)).
occupata(pos(43,21)).
occupata(pos(43,24)).
occupata(pos(43,29)).
occupata(pos(43,35)).
occupata(pos(43,37)).
occupata(pos(43,39)).
occupata(pos(43,42)).
occupata(pos(43,45)).
occupata(pos(44,1)).
occupata(pos(44,4)).
occupata(pos(44,9)).
occupata(pos(44,12)).
occupata(pos(44,15)).
occupata(pos(44,17)).
occupata(pos(44,20)).
occupata(pos(44,23)).
occupata(pos(44,26)).
occupata(pos(44,27)).
occupata(pos(44,30)).
occupata(pos(44,31)).
occupata(pos(44,33)).
occupata(pos(44,35)).
occupata(pos(44,37)).
occupata(pos(44,40)).
occupata(pos(44,43)).
occupata(pos(44,45)).
occupata(pos(44,46)).
occupata(pos(44,48)).
occupata(pos(44,49)).
occupata(pos(45,2)).
occupata(pos(45,4)).
occupata(pos(45,6)).
occupata(pos(45,7)).
occupata(pos(45,10)).
occupata(pos(45,13)).
occupata(pos(45,14)).
occupata(pos(45,15)).
occupata(pos(45,19)).
occupata(pos(45,22)).
occupata(pos(45,25)).
occupata(pos(45,27)).
occupata(pos(45,28)).
occupata(pos(45,32)).
occupata(pos(45,35)).
occupata(pos(45,38)).
occupata(pos(45,40)).
occupata(pos(45,42)).
occupata(pos(45,47)).
occupata(pos(45,49)).
occupata(pos(46,2)).
occupata(pos(46,6)).
occupata(pos(46,8)).
occupata(pos(46,11)).
occupata(pos(46,16)).
occupata(pos(46,18)).
occupata(pos(46,20)).
occupata(pos(46,23)).
occupata(pos(46,25)).
occupata(pos(46,29)).
occupata(pos(46,30)).
occupata(pos(46,31)).
occupata(pos(46,34)).
occupata(pos(46,37)).
occupata(pos(46,38)).
occupata(pos(46,40)).
occupata(pos(46,43)).
occupata(pos(46,45)).
occupata(pos(46,50)).
occupata(pos(47,3)).
occupata(pos(47,4)).
occupata(pos(47,5)).
occupata(pos(47,9)).
occupata(pos(47,12)).
occupata(pos(47,13)).
occupata(pos(47,14)).
occupata(pos(47,16)).
occupata(pos(47,17)).
occupata(pos(47,21)).
occupata(pos(47,25)).
occupata(pos(47,27)).
occupata(pos(47,31)).
occupata(pos(47,32)).
occupata(pos(47,33)).
occupata(pos(47,35)).
occupata(pos(47,40)).
occupata(pos(47,41)).
occupata(pos(47,44)).
occupata(pos(47,45)).
occupata(pos(47,46)).
occupata(pos(47,47)).
occupata(pos(47,48)).
occupata(pos(48,2)).
occupata(pos(48,5)).
occupata(pos(48,6)).
occupata(pos(48,8)).
occupata(pos(48,10)).
occupata(pos(48,14)).
occupata(pos(48,19)).
occupata(pos(48,22)).
occupata(pos(48,24)).
occupata(pos(48,25)).
occupata(pos(48,28)).
occupata(pos(48,29)).
occupata(pos(48,36)).
occupata(pos(48,38)).
occupata(pos(48,39)).
occupata(pos(48,41)).
occupata(pos(48,42)).
occupata(pos(48,45)).
occupata(pos(48,50)).
occupata(pos(49,4)).
occupata(pos(49,8)).
occupata(pos(49,10)).
occupata(pos(49,11)).
occupata(pos(49,12)).
occupata(pos(49,14)).
occupata(pos(49,15)).
occupata(pos(49,16)).
occupata(pos(49,17)).
occupata(pos(49,18)).
occupata(pos(49,21)).
occupata(pos(49,23)).
occupata(pos(49,27)).
occupata(pos(49,30)).
occupata(pos(49,32)).
occupata(pos(49,33)).
occupata(pos(49,35)).
occupata(pos(49,37)).
occupata(pos(49,43)).
occupata(pos(49,47)).
occupata(pos(49,48)).
occupata(pos(50,2)).
occupata(pos(50,6)).
occupata(pos(50,19)).
occupata(pos(50,25)).
occupata(pos(50,29)).
occupata(pos(50,33)).
occupata(pos(50,39)).
occupata(pos(50,41)).
occupata(pos(50,45)).
occupata(pos(50,49)).
numeroOccupate(1001).
finale(pos(40,6)).
