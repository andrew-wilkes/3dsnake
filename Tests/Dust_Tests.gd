# The running scene should look like an infinitely respawning field of boxes
extends Spatial

func _on_Timer_timeout():
	$Camera.translation.z += 1
	$Dust.check_extents($Camera.translation)
