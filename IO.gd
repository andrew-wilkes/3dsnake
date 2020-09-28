extends Control

signal start_game
signal exit_game

func _ready():
	$Start.popup_centered()
	$GameOver.get_cancel().connect("pressed", self, "quit")


func _on_Start_confirmed():
	emit_signal("start_game")


func _on_GameOver_confirmed():
	emit_signal("start_game")


func quit():
	emit_signal("exit_game")


func set_score(value):
	$Score.bbcode_text = "%06d" % value


func game_over():
	$GameOver.popup_centered()
