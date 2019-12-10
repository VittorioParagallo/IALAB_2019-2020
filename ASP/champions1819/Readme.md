# CLINGO PROJECT

This project implements the ASP project champions 2018-2019 as specified for the Laboratory of Artificial Intelligence at the University of Turin (Italy) during accademic year 2019-2020.
A calendar is required to plan the UEFA champions league, so through CLINGO the needed answer set is computed according to severeal constraints.

<p align="center">
  <img src="https://github.com/VittorioParagallo/IALAB_2019-2020/blob/master/ASP/img/kisspng-201617-uefa-champions-league-premier-league-201-5b08f06ae70224.2252970515273124909462.jpg"/>
</p>


## Data and constraint

The system issues a calendar to plan the uefa champions league matches for the year 2018-1029 taking into account 32 teams coming from 15 nations: Belgio, Francia, Germania, Grecia, Inghilterra, Italia, Olanda, Portogallo, Repubblica Ceca, Russia, Serbia, Spagna, Svizzera, Turchia, Ucraina.

<p align="center">
  <img src="https://github.com/VittorioParagallo/IALAB_2019-2020/blob/master/ASP/img/championsteamlist.png"/>
</p>

Those specifications have been splitted in two predicates `haNazione(X, Y)` and `haCitta(X, Z).` where X is the team Y the corresponding nation and Z the corresponding town.

Those 32 teams have been then combined, according to the contraints in 8 rounds on two halves season: `girone(a;b;c;d;e;f;g;h).` with 4 teams each.
The final calendar follows the constraints here below:
- max 1 team per nation in the same round;
- in every round, every team plays against the other 3 only once, both for first and second half season;
- matches are grouped in 3 days per half season, all the 32 teams play each day;
- two teams from the same town can't both play home match during the same day;
- a team can't play more than 2 consecutive matches home or more than 2 away.

The data provided already meet the constraints about at least 2 teams from the same town and at least 4 nations with 4 teams each.

We tried to constrain some teams on a specific round, in order to obtain an improvement over the execution time, but the perfomances didn't show improvements.
The overall time to find an answer set is about 50 seconds.

## Calendar
The following calendar is the clingo answer set resulting from file `finale.lp`. 
<p align="center">
  <img src="https://github.com/VittorioParagallo/IALAB_2019-2020/blob/master/ASP/img/calendario finale.png"/>
</p>


## Authors

* **Alberto Guastalla** - [AlebertoGuastalla](https://github.com/AlebertoGuastalla)
* **Tommaso Toscano**  - [DarkRaider95](https://github.com/DarkRaider95)
* **Vittorio Paragallo**  - [VittorioParagallo](https://github.com/VittorioParagallo)
