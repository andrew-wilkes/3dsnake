extends Spatial

var speed = 10
var cube_step
var min_step
var d1 = 0
var d2 = 0

func _ready():
	cube_step = $Snake.width
	min_step = cube_step / 4


func _process(delta):
	# Move the snake in steps
	d1 += speed * delta
	if d1 > min_step:
		d1 = 0
		$Snake.translate_object_local(transform.basis.z * min_step)
	d2 += speed * delta
	# If crossing a segment boundary, rotate the snake head towards the desired
	# direction and then we will move in that direction (along the local z-axis)
	if d2 > cube_step:
		d2 = 0
		if Input.is_action_pressed("ui_right"):
			$Snake.rotate_head(-transform.basis.y)
		elif Input.is_action_pressed("ui_left"):
			$Snake.rotate_head(transform.basis.y)
		elif Input.is_action_pressed("ui_up"):
			$Snake.rotate_head(-transform.basis.x)
		elif Input.is_action_pressed("ui_down"):
			$Snake.rotate_head(transform.basis.x)
