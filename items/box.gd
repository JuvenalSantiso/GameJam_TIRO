extends RigidBody2D

const PUSH_FORCE = 5

var initial_position: Vector2
var initial_rotation

var force: Vector2 = Vector2.ZERO

func do_push(direction):
	force += Vector2(direction*PUSH_FORCE,0)

func reset_box():
	force = Vector2.ZERO
	global_transform.origin = initial_position
	global_rotation = initial_rotation
	linear_velocity = Vector2(0, 0)
	angular_velocity = 0.0
	set_axis_velocity(Vector2.ZERO)
	

func _ready():
	initial_position = position
	initial_rotation = rotation

func _integrate_forces(state):
	apply_force(force)


	


