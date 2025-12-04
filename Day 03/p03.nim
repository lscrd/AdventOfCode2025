

proc largest(bank: string; first, last: int): tuple[val: char; pos: int] =
  ## In the given bank between positions "first" and "last",
  ## return the largest joltage and its position.
  for i in first..last:
    if bank[i] > result.val:
      result = (bank[i], i)

proc maxJoltage(bank: string; count: Positive): int =
  ## Return the maximum joltage available from "bank" using "count" batteries.
  var first = 0                 # Starting position for next battery.
  var last = bank.len - count   # Last possible position for next battery.
  for i in 1..count:
    let (val, pos) = bank.largest(first, last)
    result = 10 * result + ord(val) - ord('0')
    first = pos + 1
    inc last

proc totalOutputJoltage(batteryCount: Positive): int =
  ## Return the total output joltage using "batteryCount" battery in each bank.
  for bank in lines("p03.data"):
    let jolt = bank.maxJoltage(batteryCount)
    inc result, jolt


### Part 1 ###

echo "Part 1: ", totalOutputJoltage(2)


### Part 2 ###

echo "Part 2: ", totalOutputJoltage(12)
