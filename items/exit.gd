extends Area2D

signal player_on_exit



func _on_body_entered(_body):
	player_on_exit.emit()
