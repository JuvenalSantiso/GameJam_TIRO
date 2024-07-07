extends Node2D

@onready var start_button : Button = $CanvasLayer/MarginContainer/Panel/Start
var level_1_scene: String = "res://levels/level_1.tscn"
var level_tutorial_scene: String = "res://levels/level_tutorial.tscn"


func _ready():
	start_button.grab_focus()


func _on_start_pressed():
	GameManager.change_scene(level_1_scene)


func _on_tutorial_pressed():
	GameManager.change_scene(level_tutorial_scene)
