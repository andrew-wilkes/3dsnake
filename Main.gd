extends Spatial

var speed = 10
var cube_step
var min_step
var d1 = 0
var d2 = 0

func _ready():
	cube_step = $Base/Snake.width
	min_step = cube_step / 8
	if Globals.TESTING:
		show_extents()


func _process(delta):
	delta *= speed
	# Move the snake in steps
	d1 += delta
	if d1 > min_step:
		d1 = 0
		$Base/Snake.move_ahead(transform.basis.z * min_step)
	
	# If crossing a segment boundary, rotate the snake head towards the desired
	# direction and then we will move in that direction (along the local z-axis)
	d2 += delta
	if d2 > cube_step:
		d2 = 0
		process_inputs()
	
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
