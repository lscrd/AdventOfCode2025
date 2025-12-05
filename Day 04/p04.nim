import std/sugar

type
  Grid = seq[string]
  Position = tuple[row, col: int]

proc `[]`(grid: Grid; pos: Position): char =
  ## Return the character at given position.
  ## If "pos" is outside the grid, return ' '.
  result = if pos.row in 0..grid.high and pos.col in 0..grid[0].high: grid[pos.row][pos.col]
           else: ' '

var grid: Grid = collect:
                   for line in lines("p04.data"):
                     if line.len > 0: line

iterator neighbors(pos: Position): Position =
  ## Yield the positions adjacent to "pos".
  ## Some positions may be outside the grid.
  for r in (pos.row - 1)..(pos.row + 1):
    for c in (pos.col - 1)..(pos.col + 1):
      if r != pos.row or c != pos.col:
        yield (r, c)

proc isAccessible(grid: Grid; pos: Position): bool =
  ## Return true if the position is accessible.
  var occupied = 0
  for p in pos.neighbors():
    if grid[p] == '@':
      inc occupied
  result = occupied < 4

proc removable(grid: Grid): seq[Position] =
  ## Return the list of positions in "grid" which
  ## contain a roll or paper and are accessible.
  for row in 0..grid.high:
    for col in 0..grid[0].high:
      let pos = (row, col)
      if grid[pos] == '@' and grid.isAccessible(pos):
        result.add pos

### Part 1 ###

var positions = grid.removable()
echo "Part 1: ", positions.len


### Part 2 ###

proc clear(grid: var Grid; positions: seq[Position]) =
  ## Remove the rolls of paper at given positions.
  for pos in positions:
    grid[pos.row][pos.col] = ' '

# Note: we start with the positions found in part 1.
var count = 0
while positions.len != 0:
  inc count, positions.len
  grid.clear(positions)
  positions = grid.removable()

echo "Part 2: ", count
