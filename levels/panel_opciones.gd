extends Panel

var start_scene: String = "res://levels/start_menu/start_menu.tscn"

signal reiniciar
signal continuar

func _on_continuar_pressed():
	continuar.emit()


func _on_reiniciar_button_down():
	reiniciar.emit()


func _on_salir_pressed():
	get_tree().paused = false
	GameManager.change_scene(start_scene)
