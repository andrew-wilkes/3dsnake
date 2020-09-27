extends Spatial

signal hit_tail

const P2 = PI / 2

var tail_piece_scene = preload("res://TailPiece.tscn")
var inverted = false
var reversed = false

func make_upright():
	if $Head.transform.basis.y.y < -0.5:
		$Head.rotate_object_local(transform.basis.x, PI)


func up():
	rotate_head(-transform.basis.x)


func down():
	rotate_head(transform.basis.x)


func left():
	rotate_head(transform.basis.y)


func right():
	rotate_head(-transform.basis.y)


func roll():
	$Head.rotate_object_local(transform.basis.z, PI)


func rotate_head(vec: Vector3):
	$Head.rotate_object_local(vec, P2)


# The way to move is to move the head and set the last tail node to the last position of the head
# Then position the the tail node as the first child node of the tail.
# Now the last tail node becomes the end of the tail.
func move_ahead(displacement: Vector3):
	var old_head_pos = $Head.translation
	var end_pos = $Head.translation
	$Head.translate(displacement)
	var n = $Tail.get_child_count()
	if n > 0:
		var tail_piece = $Tail.get_child(n-1)
		end_pos = tail_piece.translation
		$Tail.move_child(tail_piece, 0)
		tail_piece.translation = old_head_pos
	
	if Globals.add_to_tail:
		Globals.add_to_tail = false
		var tpi = tail_piece_scene.instance()
		tpi.connect("area_entered", self, "hit_tail")
		tpi.translation = end_pos
		$Tail.add_child(tpi)


func hit_tail(_area):
	emit_signal("hit_tail")


func get_positions():
	var positions = []
	for item in $Tail.get_children():
		positions.append(item.translation)
	return positions
