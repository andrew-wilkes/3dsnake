extends Spatial

const MAX_OFFSET = 8
const STEP_SIZE = 2
const START_TAIL_LENGTH = 4
const SCORE_INCREMENT = 950

var tail_segments_to_add: int
var score = 0


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
				KEY_ESCAPE:
					get_tree().quit()
		$Snake.set_displacement()


func set_apple_position():
	$Apple.set_position($Snake/Head.translation, $Snake.get_positions())


func _on_Snake_hit_tail():
	$StepTimer.stop()
	$IO.game_over()


func _on_Apple_eaten():
	tail_segments_to_add = 1
	score += SCORE_INCREMENT
	$IO.set_score(score)
	set_apple_position()


func _on_IO_start_game():
	# Reset the score and chop off the tail to start a new game
	$IO.set_score(0)
	score = 0
	$Snake.remove_tail()
	tail_segments_to_add = START_TAIL_LENGTH
	set_apple_position()
	$StepTimer.start()


func _on_IO_exit_game():
	get_tree().quit()
