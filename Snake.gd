extends Area

const P2 = PI / 2

func rotate_head(vec: Vector3):
	rotate_object_local(vec, P2)


# The way to move is to move the head and set the last tail node to the last position of the head
# Then position the the tail node as the first child node of the tail.
# Now the last tail node becomes the end of the tail.
func move_ahead(translation: Vector3):
	translate_object_local(translation)
