extends Node

var player_scene: PackedScene = preload("res://player/player.tscn")
var player_count: int = 0
var current_spawner: Marker2D

var death_timer: Timer

func init_game_manager(marker_spawn, pdeath_timer, goal_signal):
	current_spawner = marker_spawn
	death_timer = pdeath_timer
	death_timer.timeout.connect(next_generation)
	goal_signal.s_saw_a_player.connect(winner)
	spawn_player()


func next_generation():
	for pl in get_tree().get_nodes_in_group("players"):
		pl.reset_player()
	for bx in get_tree().get_nodes_in_group("boxes"):
		bx.reset_box()
	for ssw in get_tree().get_nodes_in_group("seesaw"):
		ssw.reset_balance()
	
	spawn_player()
	
	player_count += 1
	

func winner():
	death_timer.stop()
	for pl in get_tree().get_nodes_in_group("players"):
		pl.queue_free()
		
	get_tree().quit()

func spawn_player():
	var player = player_scene.instantiate()
	current_spawner.add_child(player)

