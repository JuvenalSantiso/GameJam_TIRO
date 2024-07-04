extends RigidBody2D

const STRONG = 100

var initial_position: Vector2
var initial_rotation
@onready var grab_point = $GrabPoint

var force: Vector2 = Vector2.ZERO

func do_push(direction):
	force += Vector2(direction*STRONG,0)

func _ready():
	initial_position = position
	initial_rotation = rotation

func reset_box():
	force = Vector2.ZERO
	global_transform.origin = initial_position
	global_rotation = initial_rotation
	linear_velocity = Vector2(0, 0)
	angular_velocity = 0.0
	
func _integrate_forces(state):
	apply_central_force(force)

func _physics_process(delta):
	print("force ", grab_point.get_actual_force())
	apply_central_force(grab_point.get_actual_force() * STRONG)


