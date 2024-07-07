extends Control

signal level_timeout

var time_for_play: int = 0
var current_time: int = 0
@onready var bar_timeout: TextureProgressBar = $MarginContainer/TextureProgressBar
@onready var text_timeout: Label = $MarginContainer/TextureProgressBar/Label
@onready var timer: Timer = $Timer

func set_parameters(time: int):
	time_for_play = time
	current_time = time
	text_timeout.text = str(time)
	bar_timeout.value = 100
	timer.start()

func set_new_time(time: int):
	if time >= 0:
		text_timeout.text = str( time)
		if time_for_play != 0:
			bar_timeout.value = (time * 100) / time_for_play

func _on_timer_timeout():
	current_time -= 1
	set_new_time(current_time)
	
	if current_time == -1:
		level_timeout.emit()
