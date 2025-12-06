import std/[algorithm, strscans, strutils]

var ranges: seq[Slice[int]]
var ids: seq[int]

# Read ranges and ids.
var readingRanges = true
for line in lines("p05.data"):
  if line.len == 0:
    readingRanges = false
  elif readingRanges:
    var first, last: int
    discard scanf(line, "$i-$i", first, last)
    ranges.add first..last
  else:
    ids.add parseInt(line)


### Part 1 ###
var count = 0
for id in ids:
  for rng in ranges:
    if id in rng:
      # Ingredient is fresh.
      inc count
      break

echo "Part 1: ", count


### Part 2 ###

proc rangeCmp(x , y: Slice[int]): int =
  ## Compare two ranges. Used for sorting.
  result = cmp(x.a, y.a)
  if result == 0:
    result = cmp(x.b, y.b)

proc optimize(ranges: var seq[Slice[int]]) =
  ## Optimize a sorted list of ranges by merging
  ## consecutive ranges when possible.
  var i = 0
  while i < ranges.high:
    let r1 = ranges[i]
    let r2 = ranges[i + 1]
    if r1.b > r2.b:
      # r2 is included in r1.
      ranges.delete(i + 1)
    elif r1.b >= r2.a:
      # Overlap.
      ranges[i] = r1.a..r2.b
      ranges.delete(i + 1)
    else:
      # No overlap.
      inc i

ranges.sort(rangeCmp)
ranges.optimize()

count = 0
for rng in ranges:
  inc count, rng.b - rng.a + 1

echo "Part 2: ", count
