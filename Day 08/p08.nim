import std/[algorithm, math, strscans]

type
  Position = tuple[x, y, z: int]
  Box = ref object
    pos: Position       # Box position.
    circuit: Circuit    # The current circuit to which the box belongs.
  Circuit = ref object
    boxes: seq[Box]     # The list of boxes currently connected in the circuit.


proc euclidDist2(pos1, pos2: Position): int =
  ## Return the squared euclidean distance between two positions.
  (pos2.x - pos1.x)^2 + (pos2.y - pos1.y)^2 + (pos2.z - pos1.z)^2


proc connect(circuits: var seq[Circuit]; box1, box2: Box) =
  ## Connect "box1" and "box2".
  if box1.circuit != box2.circuit:
    # Merge circuits.
    box1.circuit.boxes.add box2.circuit.boxes
    let box2Circuit = box2.circuit
    for box in box2Circuit.boxes:
      box.circuit = box1.circuit
    circuits.del circuits.find(box2Circuit)


# Read data and build boxes and associated circuits.
var boxes: seq[Box]
var circuits: seq[Circuit]
for line in lines("p08.data"):
  var pos: Position
  if scanf(line, "$i,$i,$i", pos.x, pos.y, pos.z):
    let box = Box(pos: pos)
    boxes.add box
    box.circuit = Circuit(boxes: @[box])
    circuits.add box.circuit

# Build the sorted list of distances between boxes.
var distances: seq[tuple[val: int; box1, box2: Box]]
for i in 0..<boxes.high:
  let box1 = boxes[i]
  for j in (i + 1)..boxes.high:
    let box2 = boxes[j]
    distances.add (euclidDist2(box1.pos, box2.pos), box1, box2)
distances.sort()


### Part 1 ###

for i in 0..999:
  let dist = distances[i]
  circuits.connect(dist.box1, dist.box2)

# Sort the circuits by decreasing number of boxes.
circuits = circuits.sortedByIt(-it.boxes.len)

echo "Part 1: ", circuits[0].boxes.len * circuits[1].boxes.len * circuits[2].boxes.len


### Part 2 ###

# Reinitialize circuits.
circuits.setLen(0)
for box in boxes:
  box.circuit = Circuit(boxes: @[box])
  circuits.add box.circuit

var x1, x2: int
for dist in distances:
  circuits.connect(dist.box1, dist.box2)
  if circuits.len == 1:
    # All boxes are connected.
    x1 = dist.box1.pos.x
    x2 = dist.box2.pos.x
    break

echo "Part 2: ", x1 * x2
