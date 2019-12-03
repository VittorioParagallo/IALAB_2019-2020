# Bikers-companion
This project implements an expert system written in CLIPS meeting the requirements specified for the Laboratory of Artificial Intelligence at the University of Turin (Italy) during accademic year 2018-2019. 
<p align="center">
  <img src="https://github.com/VittorioParagallo/IALAB_2019-2020/blob/master/clips/BikersCompanion/img/bikerscompanion_logo_nobackground.png"/>
</p>

# User interaction
The system prompts several questions to the user about his travel preferences. The user can input then his desiderata without need of beeing too specific. The system will, according to user specifications, reply with the best solution found. In the end the user can either, accept the solution, or define more specific criteria to get a more custom one.
<p align="center">
  <img src="https://github.com/VittorioParagallo/IALAB_2019-2020/blob/master/clips/BikersCompanion/img/mainscreen.jpeg"/>
</p>
# Project Description
Bikers companion is an expert system set up to help users, willing to travel within Italy's borders*, to plan a journey according to their wishes. The hotels records have been retreived from GPS POI avaliable online and frequently updated (last update 11 November 2019). So the system is strongly raccomanded for bikers community, but could be as well suitable for users travelling by car/van/caravan.
<p><br><i>*For simplicity geographics constraints have not been considered by trip rules Ex. moving from/to an island</i></p>

# Source Data
Raw data have been retreived from poi file:
http://www.poigps.com/modules.php?name=Downloads&d_op=getit&lid=2795
so all poi's latitude and longitude coordinates have been treated by some google scripting so to get addresses ad set up a catalog of 486 hotels in 85 Italian towns classified by their region and turism type.
<p align="center">
  <img src="https://github.com/VittorioParagallo/IALAB_2019-2020/blob/master/clips/BikersCompanion/img/tbl_cittaRegioneHotel.png"/>
</p>
Here below as well the dataset specifications by geografic regions and possible turism type:

<p>
<img height="250" src="https://github.com/VittorioParagallo/IALAB_2019-2020/blob/master/clips/BikersCompanion/img/tbl_regioneTurismType.png"/>
  </p>
  
The project comes with a validation set of 15 hotels retreived from the catalog.
Several templates have been defined in clips to manage hotels and towns like facts:

<b>tourism-resort:</b> 
- *name*  the town's name;
- *region*  region the town belongs to;
- *type*  multislot listing all avaliable tourism type for the specific town;
- *scors* multislot listing the score for every tourism type specified in type.

<b>hotel: </b>
- *name*  hotel name as by POI file;
- *tr*  tourism-resort type specification;
- *stars* hotel's stars randomly assigned douring source data fetching (data not avaliable in source);
- *price-per-night* price for a double room per night;
- *free-percent*  percentage of room avaliability (used as well to balance hotel loading);

a <b>distance</b> template has been declared and for simplicity the distance facts predefined:
- *loc1* town leaving from;
- *loc2* town arriving to;
- *distance* idistance between loc1 and loc2.

# Project structure
The project, contained within the BikeCompanion folder:
- `sourcedata`, folder contains all the raw data and an xlsx file to manipulate (the poi address translastion has been done in google script with google sheet but can't be updated on GitHub;
- `domain`, that contains functions, facts, rules and templates used specifically for the domain,
- `bikers-companion.clp`, file contains all the code to run the system;
- `img` folder contains all the images used in the documentation.

To run the system download `bikers-companion.clp` file and use `clips` to run it.

# Implementation details

The system is structured in 7 modules.
<p align="center">
  <img src="https://github.com/VittorioParagallo/IALAB_2019-2020/blob/master/clips/BikersCompanion/img/SYSTEMFLOWCHART.png"/>
</p>


**MAIN**: defines several functions and templates needed to design the knoldge and exposes them to the other modules. Then controls the execution order of the other modules through the `start rule`. It handles as well some `auto focus` rules to combine the certainty factors linked to similar facts with different Fact-ID. Some more rules are implemented to filter more detailed facts despite less detailed ones.

**FORMAT-ATTRIBUTES**: implements all the needed rules to format `attribute` fact types given in input by the user during che main prompt process.

**CHOOSE-HINTS**:  handles the interation with the user to define the journey requirements. It shows a list of hints to help the user to express his preferences and prompts a choice. Once the user expresses his preference the system confirms the choice with a message and clears the hint item from the list, then the newly reduced list is shown again to the user do that he can add more choices. So the system iterates over the process till the user chooses to stop inputing preferences or there are no more questions. 
In the interation process the loop is allowed by a specific fact (in the same module's agenda) modified on every interation (retracted and differently asserted again) to sort the rules execution flow.

**HINTS**: defines the rule `ask-a-question` to prompt the user input through the function `ask-question` (exposed from MAIN module). It retrieves unformatted `attribute` facts type. Two more rules are implemented to hadle the preconditions to list or not hint items.

**CLIENT-REQUESTS**: contains all the predifined questions (hints)
Hint/questions:
- `1 Hint` Visita luoghi nell'arco di un certo periodo di tempo spendendo al massimo una certa somma.
  - Quali luoghi intendi visitare (immettere / se non si desidera rispondere)?
  - Per quanto tempo intendi visitarli (giorni)?
  - Qual'e' il tuo budget massimo (euro)?
  - Quante persone siete?

- `2 Hint` Visita solo luoghi appartenenti ad una specifica regione.
  - Inserire la regione:
  
- `3 Hint` Visita solo luoghi non appartenenti ad una specifica regione.
  - Inserire la regione:
  
- `4 Hint` Prenota un albergo con al massimo con un determinato numero di stelle.
  - Inserire il massimo numero di stelle:
  
- `5 Hint` Prenota un albergo con al massimo con un determinato numero di stelle.
  - Prenota un albergo con al minimo con un determinato numero di stelle.
  
- `5 Hint` Visita mete turistiche.
  - Inserire i tipi di turismo (separati da spazio): 

**RULES**: this module does some parsing over "if then" rules type used to apply inference to over user requirements. "if-then" facts are then generated in the module `REASONING-RULES`.

**REASONING-RULES**: defines all the rules, with format "if then", needed for the reasoning process over the user preferences

**HOTELS**: models the knowledge base with the Hotels, the Towns, the Tourism types and the distances between towns. The rule `generate-hotels` does part of the reasoning process on the user requirements to assert `hotel-attribute` facts.
This fact merges hotels data and user preferences while stores in the attribute `unknown-variables` all the user missing preferences. 

**MAKE-RESULTS**: defines templates to compute finals solutions and rules to offset doubled facts with lower certainty factor.

These are:
- `make-possible-combinations` generates, though combinatorics, all possible hotel time distribution sets.
- `make-feasible-solutions` offsets all not feasible solutions and generates `alternative` type facts for the feasible ones.
- `update-certainties-about-distances` updates the attribute `sum-certanties` for `alternative` facts according to computed trip distance, hotel booking nights and hotel certanty factors. 
- `print-results` prints on screen the resulting alternatives sorted by `sum-certanties` descend order. This sorting is implemented by the `sort` function thuough a comparator exposed from main module `rating-sort`). So the first 5 alternatives are printed and the user can shut-down the system or refine again the criteria.

## Inference details
The user input attributes are combined to get new `best-attribute` facts type as inizial best solutions.
Then `best-attribute` are combined with hotel-attribute according to hotel facts present in knwoledge base.
Finally the booking days distributions flow is managed by an enumeration algorithm, the booking days are distributed over the most feasible hotel by generating every possible assignment and proceding by successive divisions.
Alternatives assigning the whole amount of days to a single hotel or subset are penalized, so that a more balanced distribution can score best.
Identical solutions over the towns are avoided as well (Ex. 3 days in Milan and 2 in Rome is avoided if there is already the solution 3 days in Rome and 2 in Milan).
At least there is a little algorithmic part that compute the days distribuition of the hotels that are "promising".
Also solutions splitting many short days time units in the same town over different hotels are avoided, infact is not reasonable to spend 4 days in the same town and every day in a different hotel.

## Scenario
Here a scenario is shown the user choosing the hint 1 only and inputing the following data:
- 4 days
- 4 people
- 1500€
- chosen towns Nuoro, Cagliari and Salerno

<p>
<img src="https://github.com/VittorioParagallo/IALAB_2019-2020/blob/master/clips/BikersCompanion/img/prototype.jpeg"/>
  </p>
  
The system lists 5 alternatives and the user is satisfied.

## Conclusion
Our expert system, after making inference on the data entered by the user, proposes a list of 5 valid
possible alternatives, such that not exceed the budget entered by the user.<br>
Finally numerous solutions are filtered before being proposed to the user and the ones remaining are 
ordered by total certainty. In case such values are equal, the solutions are ordered by price.<br>
The code has been made modular to avoid the problems related to the activation of multiple rules that belong to different modules.<br>
The algorithmic part of the expert system was difficult to realize, because the language is not meant to write algorithms.<br>
The solutions proposed by the expert system usually satisfy user requests, exept the cases in which the user makes requests that are incoherents.<br>
Our expert system consists of 6 suggestions offered to the user and therefore a clear possible improvement would simply be the widening of these suggestions for a more and more precise solution.

## Authors

* **Alberto Guastalla** - [AlebertoGuastalla](https://github.com/AlebertoGuastalla)
* **Tommaso Toscano**  - [DarkRaider95](https://github.com/DarkRaider95)
* **Vittorio Paragallo**  - [VittorioParagallo](https://github.com/VittorioParagallo)
