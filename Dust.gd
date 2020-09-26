extends Spatial

func _ready():
	# Spawn a cloud of dust particles
	for n in Globals.NUM_PARTICLES:
		$Cloud.add_child($Cloud/Box.duplicate())
	# Randomly position them
	for box in $Cloud.get_children():
		box.set_translation(Vector3(get_rand_pos(), get_rand_pos(), get_rand_pos()))
		box.rotate(Vector3(randf(), randf(), randf()).normalized(), PI)


func get_rand_pos():
	return rand_range(-Globals.MAX_CLOUD_OFFSET, Globals.MAX_CLOUD_OFFSET)


func check_extents(base_pos: Vector3):
	for box in $Cloud.get_children():
		var pos = box.translation - base_pos
		box.translation = base_pos + Vector3(wrap_coor(pos.x), wrap_coor(pos.y), wrap_coor(pos.z))


func wrap_coor(n):
	if n > Globals.MAX_CLOUD_OFFSET:
		return n - 2 * Globals.MAX_CLOUD_OFFSET
	if n < -Globals.MAX_CLOUD_OFFSET:
		return n + 2 * Globals.MAX_CLOUD_OFFSET
	return n
