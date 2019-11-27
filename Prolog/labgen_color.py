# Random Maze Generator using Depth-first Search
# http://en.wikipedia.org/wiki/Maze_generation_algorithm
# FB - 20121214
import random
from PIL import Image
import argparse

HEURISTIC="""% Min
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
	GScore is CurrentGValue + 1."""

def genMaze(h,mx,my,outputname):
	imgx = 500; imgy = 500
	image = Image.new("RGB", (imgx, imgy))
	pixels = image.load()

	maze = [[0 for x in range(mx)] for y in range(my)]
	dx = [0, 1, 0, -1]; dy = [-1, 0, 1, 0] # 4 directions to move in the maze
	color = [(0,0,0), (255, 255, 255), (255,255,0), (255,0,0)] # RGB colors of the maze

	# start the maze from a random cell
	startx = random.randint(0, mx - 1)
	starty = random.randint(0, my - 1)

	f= open(outputname,"w")
	f.write(HEURISTIC)
	f.write("\n\nheuristic(%d).\n" % h)
	f.write("num_righe(%d).\n" % my)
	f.write("num_col(%d).\n" % mx)
	f.write("iniziale(pos(%d,%d)).\n" % (starty+1,startx+1))

	stack = [(startx, starty)]

	while len(stack) > 0:
		(cx, cy) = stack[-1]
		maze[cy][cx] = 1
		# find a new cell to add
		nlst = [] # list of available neighbors
		for i in range(4):
			nx = cx + dx[i]
			ny = cy + dy[i]

			if nx >= 0 and nx < mx and ny >= 0 and ny < my:
				if maze[ny][nx] == 0:
					# of occupied neighbors must be 1
					ctr = 0
					for j in range(4):
						ex = nx + dx[j]; ey = ny + dy[j]
						if ex >= 0 and ex < mx and ey >= 0 and ey < my:
							if maze[ey][ex] == 1: ctr += 1
					if ctr == 1: nlst.append(i)
		# if 1 or more neighbors available then randomly select one and move
		if len(nlst) > 0:
			ir = nlst[random.randint(0, len(nlst) - 1)]
			cx += dx[ir]; cy += dy[ir]
			stack.append((cx, cy))
		else: stack.pop()

	n_occupate = 0
	#save maze in file
	for ky in range(my):
		for kx in range(mx):
			if(maze[kx][ky] == 0):
				f.write("occupata(pos(%d,%d)).\n" % (ky+1,kx+1))
				n_occupate+=1
			#print(maze[kx][ky]," ", end = '')

		#print("\n")
	f.write("numeroOccupate(%d).\n" % n_occupate)

	endx=-1
	endy=-1
	#select random end
	found=False
	while(found==False):
		endx = random.randint(0, mx - 1)
		endy = random.randint(0, my - 1)
		if(maze[endx][endy]==1 and startx != endx and starty!=endy):
			f.write("finale(pos(%d,%d)).\n" % (endy+1,endx+1))
			found=True

	# paint the maze
	for ky in range(imgy):
		for kx in range(imgx):
			if(int(my * ky / imgy) == starty and int(mx * kx / imgx) == startx):
				pixels[kx, ky] = color[2]
			elif(int(my * ky / imgy) == endy and int(mx * kx / imgx) == endx):
				pixels[kx, ky] = color[3]
			else:
				pixels[kx, ky] = color[maze[int(mx * kx / imgx)][int(my * ky / imgy)]]

	f.close()
	image.save("Maze_" + str(mx) + "x" + str(my) + ".png", "PNG")

def main():
	parser = argparse.ArgumentParser()
	parser.add_argument("-o", "--output", help="specify output filename")
	parser.add_argument("-r", "--rows", type=int, help="number of rows")
	parser.add_argument("-c", "--columns", type=int, help="number of columns")
	parser.add_argument("-e", "--heuristic", type=int, help="1=manatthan 2=euclidea")

	args = parser.parse_args()

	mx=20
	if(args.rows):
		mx = args.rows

	my=20
	if(args.columns):
		my = args.columns

	h=1
	if(args.heuristic):
		h = args.heuristic
		if(h > 2 or h < 1):
			h=1

	outputname = "output.pl"

	if(args.output):
		outputname = args.output

	genMaze(h,mx,my,outputname)

if __name__ == '__main__':
		main()
