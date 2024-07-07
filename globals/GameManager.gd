extends Node

var player_father : Node2D
var player_push_force
var player_scene: PackedScene = preload("res://player/player.tscn")

var add_new_player: bool = false
var restart_level: bool = false

#region level control
func init_game_manager(marker_spawn, push_force):
	player_push_force = push_force
	player_father = marker_spawn
	spawn_new_player()

func restart_level_manager():
	restart_level = true
	call_deferred("delete_players")

func next_generation():
	add_new_player = true

func spawn_new_player():
	var player = player_scene.instantiate()
	player.PUSH_FORCE = player_push_force
	player_father.add_child(player)

func delete_players():
	for pl in get_tree().get_nodes_in_group("players"):
			pl.queue_free()

func _physics_process(_delta):
	if add_new_player:
		add_new_player = false
		for pl in get_tree().get_nodes_in_group("players"):
			pl.reset_player()
		for bx in get_tree().get_nodes_in_group("boxes"):
			bx.reset_box()
		for ssw in get_tree().get_nodes_in_group("seesaw"):
			ssw.reset_balance()
		spawn_new_player()
	
	if restart_level:
		restart_level = false
		for bx in get_tree().get_nodes_in_group("boxes"):
			bx.reset_box()
		for ssw in get_tree().get_nodes_in_group("seesaw"):
			ssw.reset_balance()
		spawn_new_player()
#endregion

#region Cambio de escenas
func change_scene(new_scene : String):
	call_deferred("defered_change_scene", new_scene)

func defered_change_scene(new_scene : String):
	get_tree().change_scene_to_file(new_scene)
#endregion
