extends Spatial

signal hit_tail

const P2 = PI / 2

var tail_piece_scene = preload("res://TailPiece.tscn")
var inverted = false
var reversed = false
var displacement = transform.basis.z
var direction = FORWARD

enum { UP, DOWN, LEFT, RIGHT, FORWARD, BACK }

func up():
	match direction:
		UP:
			direction = FORWARD
			displacement = transform.basis.z
		DOWN:
			direction = BACK
			displacement = -transform.basis.z
		LEFT:
			direction = UP
			displacement = transform.basis.y
		RIGHT:
			direction = UP
			displacement = transform.basis.y
		FORWARD:
			direction = UP
			displacement = transform.basis.y
		BACK:
			direction = UP
			displacement = transform.basis.y

func down():
	match direction:
		UP:
			direction = BACK
			displacement = -transform.basis.z
		DOWN:
			direction = FORWARD
			displacement = transform.basis.z
		LEFT:
			direction = DOWN
			displacement = -transform.basis.y
		RIGHT:
			direction = DOWN
			displacement = -transform.basis.y
		FORWARD:
			direction = DOWN
			displacement = -transform.basis.y
		BACK:
			direction = DOWN
			displacement = -transform.basis.y


func left():
	match direction:
		UP:
			direction = FORWARD
			displacement = transform.basis.z
		DOWN:
			direction = FORWARD
			displacement = transform.basis.z
		LEFT:
			direction = FORWARD
			displacement = transform.basis.z
		RIGHT:
			direction = BACK
			displacement = -transform.basis.z
		FORWARD:
			direction = LEFT
			displacement = -transform.basis.x
		BACK:
			direction = LEFT
			displacement = -transform.basis.x


func right():
	match direction:
		UP:
			direction = BACK
			displacement = -transform.basis.z
		DOWN:
			direction = BACK
			displacement = -transform.basis.z
		LEFT:
			direction = BACK
			displacement = -transform.basis.z
		RIGHT:
			direction = FORWARD
			displacement = transform.basis.z
		FORWARD:
			direction = RIGHT
			displacement = transform.basis.x
		BACK:
			direction = RIGHT
			displacement = transform.basis.x


# The way to move is to move the head and set the last tail node to the last position of the head
# Then position the the tail node as the first child node of the tail.
# Now the last tail node becomes the end of the tail.
func move_ahead(step: int, tail_segments_to_add: int) -> int:
	var old_head_pos = $Head.translation
	var end_pos = $Head.translation
	$Head.translate(displacement * step)
	var n = $Tail.get_child_count()
	if n > 0:
		var tail_piece = $Tail.get_child(n-1)
		end_pos = tail_piece.translation
		$Tail.move_child(tail_piece, 0)
		tail_piece.translation = old_head_pos
	
	if tail_segments_to_add > 0:
		tail_segments_to_add -= 1
		var tpi = tail_piece_scene.instance()
		tpi.connect("area_entered", self, "hit_tail")
		tpi.translation = end_pos
		$Tail.add_child(tpi)
	
	return tail_segments_to_add


func hit_tail(_area):
	emit_signal("hit_tail")


func get_positions():
	var positions = []
	for item in $Tail.get_children():
		positions.append(item.translation)
	return positions
