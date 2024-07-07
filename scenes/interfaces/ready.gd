extends Control

signal ready_to_start

var waiting_input : bool = true

func _process(_delta):
	if (waiting_input) :
		if (Input.is_action_just_pressed("jump")):
			waiting_input = false
			ready_to_start.emit()


