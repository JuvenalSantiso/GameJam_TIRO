extends Node

var player_scene: PackedScene = preload("res://player/player.tscn")
var player_count: int = 0
var current_spawner: Marker2D

func init_game_manager(marker_spawn, death_signal):
	current_spawner = marker_spawn
	death_signal.connect(next_generation)
	spawn_player()


func next_generation():
	for pl in get_tree().get_nodes_in_group("players"):
		pl.reset_player()
	for bx in get_tree().get_nodes_in_group("boxes"):
		bx.reset_box()
	
	spawn_player()
	
	player_count += 1

func spawn_player():
	var player = player_scene.instantiate()
	current_spawner.add_child(player)

