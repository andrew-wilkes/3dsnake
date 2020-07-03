extends Spatial

var speed = 10
var cube_step
var min_step
var d1 = 0
var d2 = 0
var max_offset = 8

func _ready():
	cube_step = $Base/Snake.width
	min_step = cube_step / 8


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
	
	# Move base if snake hits box boundary
	var st = $Base/Snake.translation
	var bt = $Base.translation
	if st.x > max_offset:
		bt.x += st.x - max_offset
		st.x = max_offset
	if -st.x > max_offset:
		bt.x += st.x + max_offset
		st.x = -max_offset
	if st.y > max_offset:
		bt.y += st.y - max_offset
		st.y = max_offset
	if -st.y > max_offset:
		bt.y += st.y + max_offset
		st.y = -max_offset
	if st.z > max_offset:
		bt.z += st.z - max_offset
		st.z = max_offset
	if -st.z > max_offset:
		bt.z += st.z + max_offset
		st.z = -max_offset
	$Base/Snake.translation = st
	$Base.translation = bt


func process_inputs():
	if Input.is_action_pressed("ui_right"):
		$Base/Snake.rotate_head(-transform.basis.y)
	elif Input.is_action_pressed("ui_left"):
		$Base/Snake.rotate_head(transform.basis.y)
	elif Input.is_action_pressed("ui_up"):
		$Base/Snake.rotate_head(-transform.basis.x)
	elif Input.is_action_pressed("ui_down"):
		$Base/Snake.rotate_head(transform.basis.x)
