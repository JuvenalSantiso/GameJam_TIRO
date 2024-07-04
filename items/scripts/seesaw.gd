extends RigidBody2D

const BOUNCE_FORCE = 1000  
const MAX_ROTATION = 50 

@onready var detect_player: Area2D = $DetectPlayer

func _ready():
	detect_player.body_entered.connect(_on_seesaw_area_detect_player_body_entered)

func _integrate_forces(state):
	# Limit the rotation to the maximum rotation angle
	var current_rotation = rotation_degrees
	if abs(current_rotation) > MAX_ROTATION:
		angular_velocity = 0
		if current_rotation > MAX_ROTATION:
			rotation_degrees = MAX_ROTATION
		elif current_rotation < -MAX_ROTATION:
			rotation_degrees = -MAX_ROTATION

func _on_seesaw_area_detect_player_body_entered(body: Node):
	print(body)
	if body.is_in_group("players"): 
		var player = body
		if player.position.x > position.x:
			apply_force(Vector2(0, BOUNCE_FORCE), Vector2(0, player.position.x))
		else:
			apply_force(Vector2(0, -BOUNCE_FORCE), Vector2(0, -player.position.x))
