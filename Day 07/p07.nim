import std/[sequtils, strutils, tables]

# Read data.
var manifold: seq[string]
for line in lines("p07.data"):
  if line.len > 0:
    manifold.add line
let startCol = manifold[0].find('S')


### Part 1 ###

proc splitCount(manifold: seq[string]; startCol: int): int =
  ## Return the number of times the beam is split for given
  ## manifold starting at "startCol".

  var beamCols = @[startCol]  # Columns where a beam exists.
  for i in 1..manifold.high:
    var newCols: seq[int]     # Columns for new row.
    for col in beamCols:
      if manifold[i][col] == '.':
        newCols.add col
      else:
        # Split the beam.
        inc result
        newCols.add col - 1
        newCols.add col + 1
    # Update "beamCols" removing possible duplicates.
    beamCols = newCols.deduplicate(true)

echo "Part 1: ", manifold.splitCount(startCol)


### Part 2 ###

proc timelineCount(manifold: seq[string]; startCol: int): int =
  ## Return the number of timelines for given manifold
  ## starting at "startCol".

  var beamCols: CountTable[int]   # Map from columns to timeline counts.
  beamCols[startCol] = 1
  for i in 1..manifold.high:
    var newCols: CountTable[int]  # Count table for new row.
    for col, count in beamCols:
      if manifold[i][col] == '.':
        newCols.inc(col, count)
      else:
        newCols.inc(col - 1, count)
        newCols.inc(col + 1, count)
    beamCols = ensureMove(newCols)
  for count in beamCols.values:
    inc result, count

echo "Part 2: ", manifold.timelineCount(startCol)
