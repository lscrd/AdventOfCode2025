import std/[math, strutils]

type
  Operation = enum opNone, opAdd = "+", opMul = "*"
  Problem = object
    op: Operation
    numbers: seq[int]

proc grandTotal(problems: seq[Problem]): int =
  ## Return the grand total of the answers to the problems.
  for problem in problems:
    case problem.op
    of opNone:
      assert false
    of opAdd:
      result += sum(problem.numbers)
    of opMul:
      result += prod(problem.numbers)

# Read lines.
var lines: seq[string]
for line in lines("p06.data"):
  if line.len > 0:
    lines.add line


### Part 1 ###

var problems: seq[Problem]
# Create problems with their operation.
for opStr in lines[^1].splitWhiteSpace():
  problems.add Problem(op: parseEnum[Operation](opStr, opNone))
# Get list of numbers.
for iLine in 0..<lines.high:
  var ip = 0  # Problem index.
  for val in lines[iLine].splitWhiteSpace():
    problems[ip].numbers.add parseInt(val)
    inc ip

echo "Part 1: ", problems.grandTotal()


### Part 2 ###

# For facility, we could have reused the list of problems (with the operations)
# and only update the list of numbers (processing in this case from left to right).
# But we chose instead to build the whole problem list from the beginning,
# proceeding from right to left as described.

# Build a grid by transposing the lines.
var grid = newSeq[string](lines[0].len)
for iLine in 0..lines.high:
  for i, c in lines[iLine]:
    grid[i].add c

# Reinitialize and create first problem.
problems.reset()
problems.add Problem(op: opNone)

# Process from bottom to top of "grid", i.e. from right to left in original data.
for iLine in countdown(grid.high, 0):
  var line = grid[iLine]
  let lastChar = line[^1]
  if lastChar in "+*":
    # Found an operation.
    assert problems[^1].op == opNone
    problems[^1].op = if lastChar == '+': opAdd else: opMul
    line.setLen(line.len - 1)
  # Process a value (if any).
  let val = line.strip()
  if val.len > 0:
    # Found a value. Add it to current number list.
    problems[^1].numbers.add parseInt(val)
  else:
    # Empty column. Create a new problem.
    problems.add Problem(op: opNone)

echo "Part 2: ", problems.grandTotal()
