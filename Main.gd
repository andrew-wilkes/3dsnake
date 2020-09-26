extends Spatial

var speed = 10
var cube_step
var d = 0

func _ready():
	cube_step = 2
	#show_extents()


func _process(delta):
	delta *= speed

	# Rotate the snake head towards the desired
	# direction and then we will move in that direction (along the local z-axis)
	d += delta
	if d > cube_step:
		d = 0
		process_inputs()
		$Base/Snake.move_ahead(transform.basis.z * cube_step)
		set_apple_position()
		move_base()


func move_base():
	# Move base if snake hits box boundary
	# So the camera follows the snake
	# But without stationary items in the scene, the snake seems to have stopped moving
	var st = $Base/Snake.translation
	var bt = $Base.translation
	if st.x > Globals.MAX_OFFSET:
		bt.x += st.x - Globals.MAX_OFFSET
		st.x = Globals.MAX_OFFSET
	if -st.x > Globals.MAX_OFFSET:
		bt.x += st.x + Globals.MAX_OFFSET
		st.x = -Globals.MAX_OFFSET
	if st.y > Globals.MAX_OFFSET:
		bt.y += st.y - Globals.MAX_OFFSET
		st.y = Globals.MAX_OFFSET
	if -st.y > Globals.MAX_OFFSET:
		bt.y += st.y + Globals.MAX_OFFSET
		st.y = -Globals.MAX_OFFSET
	if st.z > Globals.MAX_OFFSET:
		bt.z += st.z - Globals.MAX_OFFSET
		st.z = Globals.MAX_OFFSET
	if -st.z > Globals.MAX_OFFSET:
		bt.z += st.z + Globals.MAX_OFFSET
		st.z = -Globals.MAX_OFFSET
	$Base/Snake.translation = st
	$Base.translation = bt
	$Dust.check_extents(bt)


func process_inputs():
	if Input.is_action_pressed("ui_right"):
		$Base/Snake.rotate_head(-transform.basis.y)
	elif Input.is_action_pressed("ui_left"):
		$Base/Snake.rotate_head(transform.basis.y)
	elif Input.is_action_pressed("ui_up"):
		$Base/Snake.rotate_head(-transform.basis.x)
	elif Input.is_action_pressed("ui_down"):
		$Base/Snake.rotate_head(transform.basis.x)


func show_extents():
	for x in [-1, 1]:
		for y in [-1, 1]:
			for z in [-1, 1]:
				var box = CSGBox.new()
				box.translation = Vector3(x, y, z) * Globals.MAX_OFFSET
				$Base/Extents.add_child(box)


func set_apple_position():
	# The apple should be near the snake but not coincident with any other object apart from dust particles
	
	# Get array of points to avoid
	var points = [$Apple.translation]
	for t in $Base/Tail.get_children():
		points.append(t.translation)
	
	# Find a suitable position in empty space
	var pos
	var finding = true
	while finding:
		# Get a random position away from the snake head
		pos = $Base/Snake.translation + Vector3(get_point(), get_point(), get_point())
		# Continue trying new positions if any of the points are too close
		finding = false
		for p in points:
			if (pos - p).length() < 2.2:
				finding = true
				break
	$Apple.translation = pos + $Base.translation


func get_point():
	# Return a value of +/-4/6/8
	var n = 4 + randi() % 5
	return n if randf() < 0.5 else -n
