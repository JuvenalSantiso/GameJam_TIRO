extends RigidBody2D

const BOUNCE_FORCE = 5000  
const MAX_ROTATION = 50 

@onready var detect_player: Area2D = $DetectPlayer

func _ready():
	detect_player.body_entered.connect(_on_seesaw_area_detect_player_body_entered)

func _on_seesaw_area_detect_player_body_entered(body: Node):
	print(body)
	if body.is_in_group("players"): 
		var player = body
		print(player)
		print(player.position.x, " --- ", position.x)
		if player.position.x > position.x:
			apply_torque_impulse(-BOUNCE_FORCE)
		else:
			apply_torque_impulse(BOUNCE_FORCE)
