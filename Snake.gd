extends CSGBox

const P2 = PI / 2

func rotate_head(vec: Vector3):
	rotate_object_local(vec, P2)
