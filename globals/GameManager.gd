extends Node

var player_scene: PackedScene = preload("res://player/player.tscn")

var current_spawner: Marker2D

func spawn_player(marker_spawn: Marker2D):
	current_spawner = marker_spawn
	var player = player_scene.instantiate()
	player.s_death.connect(spawn_player_and_set_active)
	marker_spawn.add_child(player)
	
func spawn_player_and_set_active():
	var p = player_scene.instantiate()
	p.s_death.connect(spawn_player_and_set_active)
	current_spawner.add_child(p)
