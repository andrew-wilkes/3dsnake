extends Spatial

var speed = 10
var cube_step = 2
var d = 0

func _ready():
	set_apple_position()


func _physics_process(delta):
	d += delta * speed
	if d > cube_step:
		d = 0
		$Snake.move_ahead(cube_step)
		move_camera()
		$Dust.check_extents($Tripod.translation)


func move_camera():
	# Move camera with snake head at extents of movement box
	var st = $Snake/Head.translation
	var tt = $Tripod.translation
	var offset = st - tt
	if offset.x > Globals.MAX_OFFSET:
		tt.x = st.x - Globals.MAX_OFFSET
	if -offset.x > Globals.MAX_OFFSET:
		tt.x = st.x + Globals.MAX_OFFSET
	if offset.y > Globals.MAX_OFFSET:
		tt.y = st.y - Globals.MAX_OFFSET
	if -offset.y > Globals.MAX_OFFSET:
		tt.y = st.y + Globals.MAX_OFFSET
	if offset.z > Globals.MAX_OFFSET:
		tt.z = st.z - Globals.MAX_OFFSET
	if -offset.z > Globals.MAX_OFFSET:
		tt.z = st.z + Globals.MAX_OFFSET
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
	Globals.add_to_tail = 1
	set_apple_position()
