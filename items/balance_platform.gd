extends Node2D

@onready var seesaw_bar: RigidBody2D = $A

var initial_position: Vector2 
var initial_rotation: float

func _ready():
	initial_position = position
	initial_rotation = rotation

func reset_balance():
	seesaw_bar.freeze = true
	seesaw_bar.global_transform.origin = initial_position
	seesaw_bar.global_rotation = initial_rotation
	seesaw_bar.linear_velocity = Vector2(0, 0)
	seesaw_bar.angular_velocity = 0.0
	seesaw_bar.set_axis_velocity(Vector2.ZERO)
	await get_tree().create_timer(0.1).timeout
	seesaw_bar.freeze = false
