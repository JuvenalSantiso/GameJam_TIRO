extends Area2D

signal s_saw_a_player

func _on_body_entered(body):
	for group in body.get_groups():
		if group == "players":
			print("YOU WIN")
			s_saw_a_player.emit()

