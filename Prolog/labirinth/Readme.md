# LABIRINTH 

This project implements a prolog program following the requirements specified for the Laboratory of Artificial Intelligence at the University of Turin (Italy) during accademic year 2018-2019.

## Installing

To run the code you need to download and install SWIProlog and set a runnable path.
TO check and analyze sourse code you can use [VSCode](https://code.visualstudio.com/download) together with the extension [VSC-Prolog](https://marketplace.visualstudio.com/items?itemName=arthurwang.vsc-prolog).

## Running the program

@TODO

## Description

This implementation allows to find a path to exit from a labirinth. the code will run on any labirint defined as KB if following the domain specification. The initial starting position inside the labirinth can be defined at runtime. More algorithms have been implemented to get a path with an informed or uninformed search. 

### Domain

- The labirinth is represented by a matrix with n*m and defined by the facts `num_righe(X)` and `num_col(Y)`;
- All the rooms are declared by the fact `pos(A,B)` where A>0, A<=num_righe(X), B>0, B<=num_col(Y);
- All the rooms are considered free to route on, so these are not declared at all;
- The occupied cells represent cells not allowed in any path and thus declared as `occupata(pos(A,B))`;
- The labirinth exit room is defined by the fact `finale(pos(A,B))` there can be more of them and can be even not reacheable because of adiacent `occupied` rooms.


### Constraints
- A labirinth has an enter room
File structure:


### Folder structure

The mail folder is labirinth it contains: 
- `azioni.pl` contains the set of actions allowed in the labirinth domain;
- `labgen_color.py` a python script to generate labirinths;
- `output.pl` contains the labirinth to run the test on (can be replaced with any labirinth in folder labirinth);
- `algorithms` folder contains the implementation of A*, iterative deepening and IDA*;
- `rooms` folder contains more labirinths with different room sizes.

#### Labyrinth

<p align="center">
  <img src="https://raw.githubusercontent.com/lamba92/prolog-project/master/stuff/labyrinth.png"/>
</p>

This domain represent a labyrinth using the predicate `pos(X, Y)` where `X` and `Y` are the agent position coordinates. Similarly the blue walls are represented by `occupied(pos(X, Y))`. `allowed/2` just checks if the action doesn't lead outside the labyrinth or inside a blue block, while `move/3` generate the new state.

The heuristic used here is the manhattan distance that ignores the blue squares.

#### 8/15 Tile Game

<p align="center">
  <img src="https://raw.githubusercontent.com/lamba92/prolog-project/master/stuff/tiles.png"/>
</p>

Both domains are represent by using two predicates (this one below represents a 8 tile game):

`initialPosition([2,4,3,7,1,6,v,5,8]).`
`finalPosition([1,2,3,4,5,6,7,8,v]).`

The game columns/rows number is expressed by `dim(n)` inside the knowledge bases files, the order of the tiles is expressed by the above mentioned list of lenght `n*n` (this domain has `n = 3` which means a list lenght of 9).

The `v` inside the list represent the void tile that can be moved up, down, left and right. To check if the action is `allowed/2` the predicate uses `nth0/3` to get the position of the void tile, then through some mathematical magic, checks if the action can be done or not.

The heuristic used here is the sum of the Manhattan distances of every tile from its desidered position. Some other mathematical magic helps us doing the job once again.

### Search Algorithms

- `iterative_deepening.pl` implements an iterative deepening search exploiting the innate Prolog's depth search inside the space of possibile variables unifications. The code is pretty self explanatory.

- `astar.pl` implements the heuristic driven search algorithm A*. The basic data structure is the predicate `node/4`. The algorithm is implemented by 3 predicates:
  - `astar/1`: allows to starts the search and fill the only parameter with a list of moves to reach the solution.
  - `astar_search/3`: the predicates that implements the search; it has 3 parameters, the first is a list of the frontier nodes, the second is a list of already visited ones, while the third is a list of actions that represent the solution.
  - `generateSons/4`: allows to generate the children of a given node, checking all the allowed actions in that node.

- `idastar.pl` implements the heuristic driven search algorithm IDA*. The basic data structure is the predicate `ida_node/2` . The algorithm is implemented by 3 predicates:
  - `ida/1`: allows to calculate the initial threshold, starts the search and fill the only parameter with a list of moves to reach the solution.
  - `idastar/5`: the predicates starts the search through the predicate `ida_search/5` and allows to calculate a new threshold in case it returns false.
  - `ida_search/5`: the predicates that implements the IDA* search.

## Statistics

All the statistics have been reported in the `prolog-statistics.pdf` file. Here you can see two meaningful examples:

<p align="center">
  <img src="https://github.com/lamba92/prolog-project/blob/master/stuff/15_D.PNG"/>
 </p>
<p align="center">
  <img src="https://github.com/lamba92/prolog-project/blob/master/stuff/Lab%205x5.PNG"/>
</p>

## Authors

- **Cesare Iurlaro** - [CesareIurlaro](https://github.com/CesareIurlaro)
- **Giuseppe Gabbia**  - [beppe95](https://github.com/beppe95)
- **Lamberto Basti**  - [lamba92](https://github.com/lamba92)
