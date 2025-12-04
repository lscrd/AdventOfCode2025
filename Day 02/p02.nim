import std/[strutils, strscans]

# Read ranges.
var ranges: seq[Slice[int]]
for rng in readFile("p02.data").split(','):
  var first, last: int
  if scanf(rng, "$i-$i", first, last):
    ranges.add first..last


### Part 1 ###

proc isInvalid1(id: int): bool =
  ## Return true if "id" is invalid according to part 1 rule.
  let s = $(id)
  if (s.len and 1) != 0: return  # Odd length => valid.
  let m = s.len shr 1
  result = true
  # Check without copying.
  for i in 0..<m:
    if s[i] != s[i + m]:
      return false

var result = 0
for rng in ranges:
    for id in rng:
      if id.isInvalid1:
        result += id

echo "Part 1: ", result


### Part 2 ###

# Possible lengths for subsequences.
const Lengths = [2: @[1], 3: @[1], 4: @[1, 2], 5: @[1], 6: @[1, 2, 3],
                 7: @[1], 8: @[1, 2, 4], 9: @[1, 3], 10: @[1, 2, 5]]


proc isInvalid2(id: int): bool =
  ## Return true if "id" is invalid according to part 2 rule.
  if id < 11: return    # First invalid id is 11.
  let s = $(id)
  for lg in Lengths[s.len]:
    block Check:
      # Check without copying.
      for i in 0..<lg:
        for n in countup(lg, s.len - lg, lg):
          if s[i + n] != s[i]:
            break Check   # Valid.
      return true

result = 0
for rng in ranges:
  for id in rng:
    if id.isInvalid2:
      result += id

echo "Part 2: ", result
