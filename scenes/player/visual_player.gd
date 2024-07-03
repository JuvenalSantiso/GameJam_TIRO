extends Node2D

@onready var animation_control: AnimationTree = $AnimationTree
@onready var state_machine: AnimationNodeStateMachinePlayback = animation_control["parameters/playback"]

#Valor entre 0 -> caminar y 1 -> correr
var speed : float = 0

func _physics_process(delta):
	if (Input.is_action_pressed("SpeedUp")):
		speed += 0.1
		set_move_state(speed)
	if (Input.is_action_pressed("SpeedDown")):
		speed -= 0.1
		set_move_state(speed)
	if (Input.is_action_pressed("Jump")):
		set_jump_state()
	if (Input.is_action_pressed("Air")):
		set_air_down_state()
	if (Input.is_action_pressed("Landing")):
		set_landing_state()

func set_move_state(speed_value: float) -> void:
	animation_control.set("parameters/Walk/WalkSpeed/blend_amount", clamp(speed_value, 0, 1))
	state_machine.travel("Walk")

func set_jump_state():
	if (state_machine.get_current_node() != "Jump" || state_machine.get_current_node() != "AirUp"):
		state_machine.travel("Jump")

func set_air_down_state():
	if (state_machine.get_current_node() != "AirDown" ):
		state_machine.travel("AirDown")

func set_landing_state():
	if (state_machine.get_current_node() != "Landing" ):
		state_machine.travel("Landing")

