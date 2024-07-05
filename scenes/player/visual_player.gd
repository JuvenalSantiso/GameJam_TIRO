extends Node2D

@onready var animation_control: AnimationTree = $AnimationTree
@onready var state_machine: AnimationNodeStateMachinePlayback = animation_control["parameters/playback"]

func set_move_state_speed(speed_value: float) -> void:
	animation_control.set("parameters/Walk/WalkSpeed/blend_amount", clamp(speed_value, 0, 1))

func set_move_state():
	if (state_machine.get_current_node() != "Walk" ):
		state_machine.travel("Walk")

func set_jump_state():
	if (state_machine.get_current_node() != "Jump" || state_machine.get_current_node() != "AirUp"):
		state_machine.travel("Jump")

func set_air_down_state():
	if (state_machine.get_current_node() != "AirDown" ):
		state_machine.travel("AirDown")

func is_air_state() -> bool:
	return state_machine.get_current_node() == "AirDown" ||state_machine.get_current_node() == "AirUp" || state_machine.get_current_node() == "Jump"

func set_landing_state():
	if (state_machine.get_current_node() != "Landing" ):
		state_machine.travel("Landing")

func set_push_state_speed(push_direction):
	animation_control.set("parameters/Push/blend_position", clamp(push_direction, -1, 1))

func set_push_state():
	if (state_machine.get_current_node() != "Push" ):
		state_machine.travel("Push")
