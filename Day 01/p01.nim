import std/[math, strscans]

### Part 1 ###
var pos = 50
var count = 0
for line in lines("p01.data"):
  var dir: char
  var dist: int
  if scanf(line, "$c$i", dir, dist):
    if dir == 'L': dist = -dist
    pos = euclMod(pos + dist, 100)
    if pos == 0: inc count

echo "Part 1: ", count

### Part 2 ###
pos = 50
count = 0
for line in lines("p01.data"):
  var dir: char
  var dist: int
  if scanf(line, "$c$i", dir, dist):
    inc count, dist div 100   # Add number of full rounds.
    dist = dist mod 100
    if dist == 0: continue    # No position change.
    # Now "dist" is in range 1..99.
    if dir == 'R':
      if pos + dist >= 100: inc count
      pos = euclMod(pos + dist, 100)
    else:
      if pos != 0 and dist >= pos: inc count
      pos = euclMod(pos - dist, 100)

echo "Part 2: ", count
