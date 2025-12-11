import std/[algorithm, strscans, tables]

type Position = tuple[r, c: int]

proc area(pos1, pos2: Position): int =
  ## Return the area of rectangle defined by "pos1" an "pos2".
  (abs(pos2.r - pos1.r) + 1) * (abs(pos2.c - pos1.c) + 1)

# Read the positions.
var positions: seq[Position]
for line in lines("p09.data"):
  var pos: Position
  if scanf(line, "$i,$i", pos.c, pos.r):
    positions.add pos

# Compute the areas  of retctangles and store them with the positions.
var areas: seq[tuple[val: int; pos1, pos2: Position]]
for i in 0..<positions.high:
  let pos1 = positions[i]
  for j in (i + 1)..positions.high:
    let pos2 = positions[j]
    areas.add (area(pos1, pos2), pos1, pos2)


### Part 1 ###

# Sort the areas by decreasing values.
areas.sort(Descending)

echo "Part 1: ", areas[0].val


### Part 2 ###

type
  Edge = tuple[pos1, pos2: Position]
  Rect = tuple[r1, r2, c1, c2: int]

proc rectangle(pos1, pos2: Position): Rect =
  ## Return the rectangle defined by "pos1" and "pos2".
  (result.r1, result.c1) = pos1
  (result.r2, result.c2) = pos2
  if result.r1 > result.r2: swap result.r1, result.r2
  if result.c1 > result.c2: swap result.c1, result.c2

proc overlap(range1, range2: Slice[int]): bool =
  ## Return true if "range1" and "range2" overlap.
  ## Note that if the ranges have only one common point, i.e "range1.a = range2.b"
  ## or "range2.a = range1.b", they are considered not to overlap.
  if range1.a >= range2.b: return false
  if range2.a >= range1.b: return false
  result = true

proc intersects(edge: Edge; rect: Rect): bool =
  ## Return true if "edge" intersects the interior of "rect".
  # Check projections on row axis.
  var c1 = edge.pos1.c
  var c2 = edge.pos2.c
  if c1 > c2: swap c1, c2
  if not overlap(c1..c2, rect.c1..rect.c2):
    return false
  # Check projections on column axis.
  var r1 = edge.pos1.r
  var r2 = edge.pos2.r
  if r1 > r2: swap r1, r2
  if not overlap(r1..r2, rect.r1..rect.r2):
    return false
  result = true

proc adjust(positions: var seq[Position]) =
  ## Adjust positions to form a chain of segments that make up a polygon.
  ## Adds the first element at the end to close the polygon.
  var currPos = positions[0]
  var i = 0
  while i < positions.high:
    inc i
    var minDist = int.high
    var iminDist: int
    for j in i..positions.high:
      let pos = positions[j]
      if pos.r == currPos.r or pos.c == currPos.c:
        let dist = abs(pos.r - currPos.r) + abs(pos.c - currPos.c)
        if dist < minDist:
          # Found a position closest to "currPos".
          minDist = dist
          iminDist = j
    if iminDist != i:
      # If needed, move the closest position to the right place.
      swap positions[i], positions[iminDist]
    # Prepare to find next position.
    currPos = positions[i]
  # Add first element at the end.
  positions.add positions[0]

proc isAllRedOrGreen(rect: Rect; edges: seq[Edge]): bool =
  ## Return true if "rect" is composed only of red and green tiles
  ## i.e. if all edges don't intersect the interior of "rect".
  for edge in edges:
    if edge.intersects(rect):
      return false
  result = true

# Build edge list.
var edges: seq[Edge]  # List of edges of the polygon.
positions.adjust()
for i in 1..positions.high:
  edges.add (positions[i - 1], positions[i])

# Process areas searching the first one with only red and green tiles.
var result: int
for area in areas:
  let rect = rectangle(area.pos1, area.pos2)
  if rect.isAllRedOrGreen(edges):
    result = area.val
    break

echo "Part 2: ", result
