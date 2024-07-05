extends Node2D

func _ready():
	GameManager.init_game_manager($Spawn, $DeathTimer, $DoorGoal)
