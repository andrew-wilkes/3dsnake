# In the scene there will always be one apple
# The apple occupies one unit of space
# When the apple is hit, it emits an ate_apple signal
# Then the apple should be re-positioned in an area of free space

extends Area

signal eaten

func set_position(origin: Vector3, points_to_avoid: Array):
	# Find a suitable position in empty space
	var pos
	var finding = true
	while finding:
		# Get a random position away from the snake head
		pos = origin + Vector3(get_point(), get_point(), get_point())
		# Continue trying new positions if any of the points are too close
		finding = false
		for p in points_to_avoid:
			if (pos - p).length() < 2.2:
				finding = true
				break
	translation = pos


func get_point():
	# Return a value of +/-4/6/8
	var n = 4 + randi() % 5
	return n if randf() < 0.5 else -n


func _on_Apple_area_entered(_area):
	emit_signal("eaten")
