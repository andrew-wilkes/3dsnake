extends Spatial

enum { AHEAD, UP, DOWN, LEFT, RIGHT }

const P2 = PI / 2

var direction = AHEAD
var speed = 10
var cube_step
var min_step
var d1 = 0
var d2 = 0

func _ready():
	cube_step = $Snake.width
	min_step = cube_step / 4


func _process(delta):
	d1 += speed * delta
	if d1 > min_step:
		d1 = 0
		$Snake.translate_object_local(transform.basis.z * min_step)
	d2 += speed * delta
	# If crossing a grid line, rotate the snake head towards the desired direction
	if d2 > cube_step:
		d2 = 0
		if Input.is_action_pressed("ui_right"):
			$Snake.rotate_object_local(Vector3(0, -1, 0), P2)
		elif Input.is_action_pressed("ui_left"):
			$Snake.rotate_object_local(Vector3(0, 1, 0), P2)
		elif Input.is_action_pressed("ui_up"):
			$Snake.rotate_object_local(Vector3(-1, 0, 0), P2)
		elif Input.is_action_pressed("ui_down"):
			$Snake.rotate_object_local(Vector3(1, 0, 0), P2)
