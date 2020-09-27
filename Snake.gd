extends Spatial

signal hit_tail

const P2 = PI / 2

var tail_piece_scene = preload("res://TailPiece.tscn")
var displacement = transform.basis.z
var direction = FORWARD

enum { UP, DOWN, LEFT, RIGHT, FORWARD, BACK }

# In the following functions we change direction according to user input
# and current direction of movement of the snake head
func up():
	match direction:
		UP:
			direction = FORWARD
		DOWN:
			direction = BACK
		LEFT:
			direction = UP
		RIGHT:
			direction = UP
		FORWARD:
			direction = UP
		BACK:
			direction = UP


func down():
	match direction:
		UP:
			direction = BACK
		DOWN:
			direction = FORWARD
		LEFT:
			direction = DOWN
		RIGHT:
			direction = DOWN
		FORWARD:
			direction = DOWN
		BACK:
			direction = DOWN


func left():
	match direction:
		UP:
			direction = FORWARD
		DOWN:
			direction = FORWARD
		LEFT:
			direction = FORWARD
		RIGHT:
			direction = BACK
		FORWARD:
			direction = LEFT
		BACK:
			direction = LEFT


func right():
	match direction:
		UP:
			direction = BACK
		DOWN:
			direction = BACK
		LEFT:
			direction = BACK
		RIGHT:
			direction = FORWARD
		FORWARD:
			direction = RIGHT
		BACK:
			direction = RIGHT


func set_displacement():
	match direction:
		UP:
			displacement = transform.basis.y
		DOWN:
			displacement = -transform.basis.y
		LEFT:
			displacement = -transform.basis.x
		RIGHT:
			displacement = transform.basis.x
		FORWARD:
			displacement = transform.basis.z
		BACK:
			displacement = -transform.basis.z


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
