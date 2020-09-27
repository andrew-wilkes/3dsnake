extends Spatial

var speed = 10
var cube_step = 2
var d = 0

func _ready():
	set_apple_position()


func _physics_process(delta):
	delta *= speed

	# Rotate the snake head towards the desired
	# direction and then we will move in that direction (along the local z-axis)
	d += delta
	if d > cube_step:
		d = 0
		process_inputs()
		$Snake.move_ahead(transform.basis.z * cube_step)
		move_snake()


func move_snake():
	# Move whole snake if it hits box boundary
	# So the camera follows the snake
	# But without stationary items (dust) in the scene, the snake seems to have stopped moving
	var st = $Snake/Head.translation
	var bt = $Snake.translation
	if st.x > Globals.MAX_OFFSET:
		bt.x += st.x - Globals.MAX_OFFSET
	if -st.x > Globals.MAX_OFFSET:
		bt.x += st.x + Globals.MAX_OFFSET
	if st.y > Globals.MAX_OFFSET:
		bt.y += st.y - Globals.MAX_OFFSET
	if -st.y > Globals.MAX_OFFSET:
		bt.y += st.y + Globals.MAX_OFFSET
	if st.z > Globals.MAX_OFFSET:
		bt.z += st.z - Globals.MAX_OFFSET
	if -st.z > Globals.MAX_OFFSET:
		bt.z += st.z + Globals.MAX_OFFSET
	$Snake.translation = bt
	$Dust.check_extents(bt)


func process_inputs():
	if Input.is_action_pressed("ui_right"):
		$Snake.rotate_head(-transform.basis.y)
	elif Input.is_action_pressed("ui_left"):
		$Snake.rotate_head(transform.basis.y)
	elif Input.is_action_pressed("ui_up"):
		$Snake.rotate_head(-transform.basis.x)
	elif Input.is_action_pressed("ui_down"):
		$Snake.rotate_head(transform.basis.x)


func show_extents():
	for x in [-1, 1]:
		for y in [-1, 1]:
			for z in [-1, 1]:
				var box = CSGBox.new()
				box.translation = Vector3(x, y, z) * Globals.MAX_OFFSET
				$Snake/Extents.add_child(box)


func _on_Snake_hit_tail():
	pass # Replace with function body.
