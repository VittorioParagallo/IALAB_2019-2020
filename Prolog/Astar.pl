% estrazione elemento da una lista
extract([Head|Tail], Head, Tail):-!.
extract([Head|Tail], X, [Head|L]):-
    extract(Tail, X, L).

% fScore
  f(G, pos(R, C), FScore):-
      h(pos(R, C), H),
      FScore is G + H.

astar(Soluzione):-
    iniziale(S),
    f(0,S,F),
    astar_aux([nodo(F,0,S,[])],[],Soluzione).

% astar_aux(Opened,Closed,Soluzione)
% Coda = [nodo(F,G,S,Azioni)|...]

% OTTIMALITA e CORRETTEZZA
astar_aux([nodo(F,_,S,Azioni)|Opened],_,Azioni):-
    finale(S),
    findall(
        SOpened,
        (member(nodo(FOpened, _, SOpened, _),Opened), FOpened < F),
        ListaPromettenti),
    length(ListaPromettenti, L),
    L == 0,!.

% COMPLETEZZA
astar_aux([nodo(F,G,S,Azioni)|Tail],Closed,Soluzione):-
    findall(Azione,applicabile(Azione,S),ListaApplicabili),
    generaStatiFigli(nodo(F,G,S,Azioni),Tail,ListaApplicabili,[nodo(F,G,S,Azioni)|Closed],ListaFigli,NuoviAperti,NuoviChiusi),
    ord_union(NuoviAperti, ListaFigli, Union),
    astar_aux(Union,[nodo(F,G,S,Azioni)|NuoviChiusi],Soluzione).

% 0 azioni ammissibili
generaStatiFigli(_,Op,[],Cl,[],Op,Cl):-!.

% Trovo un nodo che appartiene ad Opened con F minore
generaStatiFigli(nodo(F,G,S,AzioniPerS),Opened,[Azione|AltreAzioni],Closed,OrderedFigliTail,NewOpenedOut,NewClosedOut):-
    trasforma(Azione,S,SNuovo),
    member(nodo(FOpened, GOpened, SNuovo, Az),Opened),
    g(G, NewG),
    f(NewG, SNuovo, FNew),
    FNew < FOpened,!,
    ord_subtract(Opened, [nodo(FOpened, GOpened, SNuovo, Az)], NewOpened),
    generaStatiFigli(nodo(F,G,S,AzioniPerS),NewOpened,AltreAzioni,Closed,FigliTail,NewOpenedOut,NewClosedOut),
    append(AzioniPerS, [Azione], Azioni),
		ord_add_element(FigliTail, nodo(FNew, NewG, SNuovo, Azioni), OrderedFigliTail).

% Trovo un nodo che non sta negli Opened o nei Closed
generaStatiFigli(nodo(F,G,S,AzioniPerS),Opened,[Azione|AltreAzioni],Closed,OrderedFigliTail,NewOpenedOut,NewClosedOut):-
    trasforma(Azione,S,SNuovo),
    \+member(nodo(_, _, SNuovo, _),Closed),
    g(G, NewG),
    f(NewG, SNuovo, FNew),
    \+member(nodo(_, _, SNuovo, _),Opened),!,
    generaStatiFigli(nodo(F,G,S,AzioniPerS),Opened,AltreAzioni,Closed,FigliTail,NewOpenedOut,NewClosedOut),
    append(AzioniPerS, [Azione], Azioni),
		ord_add_element(FigliTail, nodo(FNew, NewG, SNuovo, Azioni), OrderedFigliTail).

% Trovo un nodo che appartiene a Closed con F minore
generaStatiFigli(nodo(F,G,S,AzioniPerS),Opened,[Azione|AltreAzioni],Closed,OrderedFigliTail, NewOpenedOut,NewClosedOut):-
    trasforma(Azione,S,SClosed),
    member(nodo(SClosedF, GClosed, SClosed, AzioniSClosed),Closed),
    g(G, NewG),
    f(NewG, SClosed, FNew),
    FNew < SClosedF,!,
    extract(Closed, nodo(SClosedF, GClosed, SClosed, AzioniSClosed), NewClosed),
    generaStatiFigli(nodo(F,G,S,AzioniPerS),Opened,AltreAzioni,NewClosed,FigliTail,NewOpenedOut,NewClosedOut),
		append(AzioniSClosed, [Azione], Azioni),
		ord_add_element(FigliTail, nodo(FNew, NewG, SClosed, Azioni), OrderedFigliTail).

% Trovo un nodo che appartiene ad Opened o a Closed ma con F maggiore o uguale
generaStatiFigli(nodo(F,G,S,AzioniPerS),Opened,[_|AltreAzioni],Closed,FigliTail, NewOpenedOut,NewClosedOut):-
    generaStatiFigli(nodo(F,G,S,AzioniPerS),Opened,AltreAzioni,Closed,FigliTail, NewOpenedOut,NewClosedOut).
