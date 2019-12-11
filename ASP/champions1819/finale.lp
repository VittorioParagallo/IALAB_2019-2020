girone(a;b;c;d;e;f;g;h).
squadra(club_brugge; monaco; paris_saint_germain; olympic_lione; borussia_dortmund; schalke_04; bayern_monaco; hoffenheim; aek; tottenham_hotspur; liverpool; manchester_city; manchester_united; inter; napoli; roma; juventus; psv_eindhoven; ajax; porto; benfica; viktoria_plzen; lokomotiv_mosca; cska_mosca; stella_rossa; atletico_madrid; barcellona; real_madrid; valencia; young_boys; galatasaray; shakhtar_donetsk).

haNazione(club_brugge, belgio).
haNazione(monaco, francia).
haNazione(paris_saint_germain, francia).
haNazione(olympic_lione, francia).
haNazione(borussia_dortmund, germania).
haNazione(schalke_04, germania).
haNazione(bayern_monaco, germania).
haNazione(hoffenheim, germania).
haNazione(aek, grecia).
haNazione(tottenham_hotspur, inghilterra).
haNazione(liverpool, inghilterra).
haNazione(manchester_city, inghilterra).
haNazione(manchester_united, inghilterra).
haNazione(inter, italia).
haNazione(napoli, italia).
haNazione(roma, italia).
haNazione(juventus, italia).
haNazione(psv_eindhoven, olanda).
haNazione(ajax, olanda).
haNazione(porto, portogallo).
haNazione(benfica, portogallo).
haNazione(viktoria_plzen, repubblica_ceca).
haNazione(lokomotiv_mosca, russia).
haNazione(cska_mosca, russia).
haNazione(stella_rossa, serbia).
haNazione(atletico_madrid, spagna).
haNazione(barcellona, spagna).
haNazione(real_madrid, spagna).
haNazione(valencia, spagna).
haNazione(young_boys, svizzera).
haNazione(galatasaray, turchia).
haNazione(shakhtar_donetsk, ucraina).

haCitta(club_brugge, bruges).
haCitta(monaco, monaco).
haCitta(paris_saint_germain, parigi).
haCitta(olympic_lione, lione).
haCitta(borussia_dortmund, dortmund).
haCitta(schalke_04, gelsenkirchen).
haCitta(bayern_monaco, monaco_di_baviera).
haCitta(hoffenheim, hoffenheim_sinsheim).
haCitta(aek, atene).
haCitta(tottenham_hotspur, londra).
haCitta(liverpool, liverpool).
haCitta(manchester_city, manchester).
haCitta(manchester_united, manchester).
haCitta(inter, milano).
haCitta(napoli, napoli).
haCitta(roma, roma).
haCitta(juventus, torino).
haCitta(psv_eindhoven, eindhoven).
haCitta(ajax, amsterdam).
haCitta(porto, porto).
haCitta(benfica, lisbona).
haCitta(viktoria_plzen, plzen).
haCitta(lokomotiv_mosca, mosca).
haCitta(cska_mosca, mosca).
haCitta(stella_rossa, belgrado).
haCitta(atletico_madrid, madrid).
haCitta(barcellona, barcellona).
haCitta(real_madrid, madrid).
haCitta(valencia, valencia).
haCitta(young_boys, berna).
haCitta(galatasaray, istanbul).
haCitta(shakhtar_donetsk, donetsk).

% ad ogni squadra associamo un girone
1 { assegnaSquadra(S,Y):girone(Y) } 1 :- squadra(S).
% ad ogni girone associamo quattro squadre
4 { assegnaSquadra(S,Y):squadra(S) } 4 :- girone(Y).

% due squadre della stessa nazione non possono essere collocate nello stesso girone
:- haNazione(S1, Z), haNazione(S2, Z), assegnaSquadra(S1, G), assegnaSquadra(S2, G), S1 != S2.

% per ogni girone genera una coppia di squadre assegnata allo stesso girone per ogni giornata di andata
2 { partita(S, S1, G, 1, and): assegnaSquadra(S, G), assegnaSquadra(S1, G), S != S1 } 2 :- girone(G).
2 { partita(S, S1, G, 2, and): assegnaSquadra(S, G), assegnaSquadra(S1, G), S != S1 } 2 :- girone(G).
2 { partita(S, S1, G, 3, and): assegnaSquadra(S, G), assegnaSquadra(S1, G), S != S1 } 2 :- girone(G).

% escludi tutti gli AS in cui in due partite differenti vi è almeno una squadra in comune nello stesso girone nella stessa giornata
:- partita(S1, S2, G, N, and), partita(S1, S4, G, N, and), S2 != S4.
:- partita(S1, S2, G, N, and), partita(S3, S1, G, N, and), S2 != S3.
:- partita(S1, S2, G, N, and), partita(S2, S4, G, N, and), S1 != S4.
:- partita(S1, S2, G, N, and), partita(S3, S2, G, N, and), S1 != S3.
:- partita(S1, S2, G, N, and), partita(S2, S1, G, N, and).

% non possono esistere due partite uguali in giornate diverse
:- partita(S1, S2, G, N1, and), partita(S1, S2, G, N2, and), N1 != N2.
:- partita(S1, S2, G, N1, and), partita(S2, S1, G, N2, and), N1 != N2.

% due squadre della stessa città non possono giocare entrambe in casa durante la medesima giornata
:- partita(S1, S2, G1, N, and), partita(S3, S4, G2, N, and),
   haCitta(S1, C), haCitta(S3, C),
   S1 != S3.
 
:- partita(S1, S2, G1, N, and), partita(S3, S4, G2, N, rit),
   haCitta(S1, C), haCitta(S3, C),
   S1 != S3.

% una squadra non può giocare più di due partite consecutive in casa
:- partita(S1, S2, G, 1, and), partita(S1, S3, G, 2, and), partita(S1, S4, G, 3, and).

% una squadra non può giocare più di due partite consecutive in trasferta
:- partita(S2, S1, G, 1, and), partita(S3, S1, G, 2, and), partita(S4, S1, G, 3, and).

% genera le partite di ritorno
partita(S1, S, G, N, rit) :- partita(S, S1, G, N, and).

%Time: 50.828s (Solving: 0.22s 1st Model: 0.18s Unsat: 0.00s) Senza vincoli
%Time: 59.470s (Solving: 0.23s 1st Model: 0.18s Unsat: 0.00s)
%assegnaSquadra(real_madrid, a).
%assegnaSquadra(monaco, b).
%assegnaSquadra(juventus, c).

#show partita/5.
