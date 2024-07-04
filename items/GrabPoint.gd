extends RigidBody2D

var diccionary_of_grabbers = {}

func grab_me() -> RigidBody2D:
	return self

func add_player_force(identity, force):
	print("identity ", identity, " Force ", force )
	diccionary_of_grabbers[identity] = force

func get_actual_force() -> Vector2:
	var force : Vector2 = Vector2.ZERO
	for grabber in diccionary_of_grabbers.keys():
		force += Vector2(diccionary_of_grabbers[grabber], 0)	
	return force
