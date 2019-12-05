# LABIRINTH 

This project implements a prolog program following the requirements specified for the Laboratory of Artificial Intelligence at the University of Turin (Italy) during accademic year 2018-2019.

<p align="center">
  <img src="https://github.com/VittorioParagallo/IALAB_2019-2020/blob/master/Prolog/img/12710952_202343880119105_5425026629015054834_o.png"/>
</p>

## Description

This implementation allows to find a path to exit from a labirinth. the code will run on any labirint defined as KB if following the domain specification. The initial starting position inside the labirinth can be defined at runtime. More algorithms have been implemented to get a path with an informed or uninformed search. 

### Domain

- The labirinth is represented by a matrix with n*m and defined by the facts `num_righe(X)` and `num_col(Y)`;
- All the rooms are declared by the fact `pos(A,B)` where A>0, A<=num_righe(X), B>0, B<=num_col(Y);
- All the rooms are considered free to route on, so these are not declared at all;
- The occupied cells represent cells not allowed in any path and thus declared as `occupata(pos(A,B))`;
- The labirinth exit room is defined by the fact `finale(pos(A,B))` there can be more of them and can be even not reacheable because of adiacent `occupied` rooms.


### Constraints
- A labirinth has an enter room;
- there are 1 or more exit rooms;
- if there is a path from the enter and exit room it must be found in finite time;
- an occupied room can't be in the path;
- all the rooms in the path must be consequentially adiacenth;
- the path is described by sorted order of actions to move from one room to the adiacent one till the exit;
- there can't be twice the same room in the path;
- if there are more exits, thus more paths, the shortest one has to be the goal.


### Folders description

The mail folder is labirinth it contains: 
- `azioni.pl` contains the set of actions allowed in the labirinth domain;
- `labgen_color.py` a python script to generate labirinths;
- `output.pl` contains the labirinth to run the test on (can be replaced with any labirinth in folder labirinth);
- `algorithms` folder contains the implementation of A*, iterative deepening and IDA*;
- `rooms` folder contains more labirinths with different room sizes.

#### Avaliable Labyrinths (red square exit, yellow one enter)
- 10 X 10
<p align="center">
  <kbd>
  <img src="https://github.com/VittorioParagallo/IALAB_2019-2020/blob/master/Prolog/labirinth/rooms/Maze_10x10.png"/>
    </kbd>
</p>

- 50 X 50
<p align="center">
  <kbd>
  <img src="https://github.com/VittorioParagallo/IALAB_2019-2020/blob/master/Prolog/labirinth/rooms/Maze_50x50.png"/>
  </kbd>
</p>

- 70 X 70
<p align="center">
  <kbd>
  <img src="https://github.com/VittorioParagallo/IALAB_2019-2020/blob/master/Prolog/labirinth/rooms/Maze_70x70.png"/>
     </kbd>
</p>

- 100 X 100
<p align="center">
  <kbd>
  <img src="https://github.com/VittorioParagallo/IALAB_2019-2020/blob/master/Prolog/labirinth/rooms/Maze_100x100.png"/>
     </kbd>
</p>

- 200 X 200
<p align="center">
  <kbd>
  <img src="https://github.com/VittorioParagallo/IALAB_2019-2020/blob/master/Prolog/labirinth/rooms/Maze_200x200.png"/>
     </kbd>
</p>

### Search Algorithms
In the search algorithms described here below we define a graph to explore a labirinth in which every labirinth's room correspond to a node. The root is the Enter room and the Exit is one of the children. The informed algorithms are supplied with two possible heuristics: the Manhattan distances and Euclidean distances.

##### `ID.pl` 
Describes the rules to apply the iterative deepening by a deep first search (DFS) with increasing depth-limits. So the depth-limit starts from zero and the wrapper rule `iterative_deepening` defines the maximum number of iterations as the quantity of free rooms in the labirinth domain.
 Then `iterative_deepening_aux` describes:
  - 1 the recursive exploration of the space state. For every time a solution is not found at the end the depth-limit is incrised by 1 and the explorations starts again (completness);
  - 2 a check case to verify a goal match (correctness and optimality).

##### `Astar.pl` 
implements the heuristic driven search algorithm A* through BFS. The code is structured in "helper method" (astar_aux) e "wrapper method" (astar), the seconds provides the init value to the first. The expanded node are tracked two sorted lists (open nodes and closed nodes) from standard Prolog library ordset.

So `astar_aux` declares:
- 1. a recursive part to explore state space (completeness).
- 2. a control part to check, considering the initial state, wether the most near final state has been found (correctness and optimality).
In the first part the funtion "findall" is used to find reacheble room for the current state. A predicate "generaStatiFigli" is then called to populate a list of all the children (reacheble rooms) defined as:
`nodo(F, G, S, Azioni)`:
  - F the value of the evaluation function (G+H);
  - G the value of the real distance from the initial node to the current node;
  - S the informations related to the current state;
  - Azioni the list of actions to get the path from initial node to current node.
 
 The `generaStatiFigli` rules describe 5 cases:
  - no more allowed moves;
  - a node already in the list of opened ones, but with lower F value;
  - a first time discovered node;
  - a node already in the list of closed ones, but with lower F value;
  - a node already in the list of opened or closed nodes, but with an F value equal or major.
  

##### `IDAStar.pl` 
Describes the rules to apply the Iterative Deepening A* by an informed limited deep first search (DFS) with depth-limits.
The wrapper rule `iterative_deepening_astar` defines the initial treshold as h(S), thus the value of the heuristic function from the start node.
 Then the rule `iterative_deepening_astar_aux` defines:
  - 1. a recursive part to explore state space (completeness). In case a goal is not matched the treshold limit is set to the minimum value F among the nodes over over the treshold during previous iteration. (completness) 
  - 2. a check case to verify a goal match (correctness and optimality).

(astar_aux) e "wrapper method" (astar), the seconds provides the init value to the first. The
    
### Statistics

All the statistics have been reported in the `prolog_statistics.txt` file and used as source data of the following graphs about the quantity of inferences:

<p align="center">
  <img src="https://github.com/VittorioParagallo/IALAB_2019-2020/blob/master/Prolog/img/tblRisultati.png"/>
</p>
<p align="center">
  <img src="https://github.com/lamba92/prolog-project/blob/master/stuff/Lab%205x5.PNG"/>
</p>

## Authors

* **Alberto Guastalla** - [AlebertoGuastalla](https://github.com/AlebertoGuastalla)
* **Tommaso Toscano**  - [DarkRaider95](https://github.com/DarkRaider95)
* **Vittorio Paragallo**  - [VittorioParagallo](https://github.com/VittorioParagallo)
