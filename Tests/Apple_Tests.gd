# Randomly position the green cube about the origin whilst avoiding the other objects

extends Spatial

var positions_to_avoid = []
var origin: Vector3

func _ready():
	for item in $Items.get_children():
		positions_to_avoid.append(item.translation)


func _on_Timer_timeout():
	$Apple.set_position(origin, positions_to_avoid)
