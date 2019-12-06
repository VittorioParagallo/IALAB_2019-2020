# CLINGO PROJECT

This project implements the ASP project champions 2018-2019 as specified for the Laboratory of Artificial Intelligence at the University of Turin (Italy) during accademic year 2018-2019.
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
- the series of matches must alternate away match and home match;

The data provided already meet the constraints about at least 2 teams from the same town and at least 4 nations with 4 teams each.

The folder `calendar\ui` contains a Kotlin JVM project that starting from a text file containing the `slot/8` predicates converts them in a `.csv` file allowing to import it inside Excel:

<p align="center">
  <img src="https://raw.githubusercontent.com/lamba92/clingo-project/master/stuff/calendar.png"/>
</p>

## Cargo
To solve this problem we used the `incremental ASP solving` approach, widely covered in Potassco User Guide and in the "Reasoning Web - Semantic Interoperability on the Web (2017)" book.<br/>To use this approach is mandatory to include the `#include <incmode>` directive in your file.

Our code for the Cargo Planning Problem uses `#program` directives to define the `base/0` subprogram which initializes and instantiates the prior knowledge base, the `step/1 (t)` subprogram which is the transition state model for each step `t > 0` and the `check/1 (t)` subprogram which checks state constraints and state goal for each step `t >= 0`.

The atom `query (t)`, provided in the incremental mode, allows to incrementally query the knowledge base at each step; his value is TRUE only for the last step `t` and FALSE for all the other steps.

We managed both **single** and **multiple** actions for each step and also the **Frame problem** resolution.

To model the problem we have been inspired by the model written in the **Artificial Intelligence, a Modern Approach** book by Russell and Norvig:

<p align="center">
  <img src="https://raw.githubusercontent.com/lamba92/clingo-project/master/stuff/cargo.png"/>
</p>

## Authors

* **Alberto Guastalla** - [AlebertoGuastalla](https://github.com/AlebertoGuastalla)
* **Tommaso Toscano**  - [DarkRaider95](https://github.com/DarkRaider95)
* **Vittorio Paragallo**  - [VittorioParagallo](https://github.com/VittorioParagallo)
