extends Spatial

const MAX_OFFSET = 8
const STEP_SIZE = 2

var tail_segments_to_add = 8

func _ready():
	set_apple_position()


func _on_StepTimer_timeout():
	tail_segments_to_add = $Snake.move_ahead(STEP_SIZE, tail_segments_to_add)
	move_camera()
	$Dust.check_extents($Tripod.translation)


func move_camera():
	# Move camera with snake head at extents of movement box
	var st = $Snake/Head.translation
	var tt = $Tripod.translation
	var offset = st - tt
	if offset.x > MAX_OFFSET:
		tt.x = st.x - MAX_OFFSET
	if -offset.x > MAX_OFFSET:
		tt.x = st.x + MAX_OFFSET
	if offset.y > MAX_OFFSET:
		tt.y = st.y - MAX_OFFSET
	if -offset.y > MAX_OFFSET:
		tt.y = st.y + MAX_OFFSET
	if offset.z > MAX_OFFSET:
		tt.z = st.z - MAX_OFFSET
	if -offset.z > MAX_OFFSET:
		tt.z = st.z + MAX_OFFSET
	$Tripod.translation = tt


func _input(event):
	if event is InputEventKey:
		if event.pressed:
			match event.scancode:
				KEY_RIGHT:
					$Snake.right()
				KEY_LEFT:
					$Snake.left()
				KEY_UP:
					$Snake.up()
				KEY_DOWN:
					$Snake.down()


func _on_Snake_hit_tail():
	print("Hit tail")


func set_apple_position():
	$Apple.set_position($Snake/Head.translation, $Snake.get_positions())


func _on_Apple_ate_apple():
	tail_segments_to_add = 1
	set_apple_position()
