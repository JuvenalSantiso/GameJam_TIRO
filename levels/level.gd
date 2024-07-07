extends Node2D

@export var time_level : int = 5
@export var push_player_force : float = 90000

@export var next_level : String

@export var ready_panel_father : Control
@export var ready_panel : Control
@export var pause_panel_father : Control
@export var pause_panel : Control
@export var bar_timer : Control

@export var players_node : Node2D
@export var exit_node: Node2D

func _ready():
	prepare_to_start()
	exit_node.player_on_exit.connect(exit_arrived)
	ready_panel.ready_to_start.connect(start_game)
	bar_timer.level_timeout.connect(run_timeout)

func prepare_to_start():
	get_tree().paused = true
	bar_timer.set_parameters(time_level)

func _physics_process(_delta):
	if (Input.is_action_just_pressed("options") and not pause_panel_father.visible):
		_on_opciones_pressed()
	
	if (not get_tree().paused and Input.is_action_just_pressed("restart")):
		restart_game()

func exit_arrived():
	GameManager.change_scene(next_level)

#region Control de flujo
func start_game():
	if ready_panel_father.visible:
		ready_panel_father.hide()
		ready_panel.waiting_input = true
		GameManager.init_game_manager(players_node, push_player_force)
		get_tree().paused = false

func run_timeout():
	GameManager.next_generation()
	bar_timer.set_parameters(time_level)

func restart_game():
	GameManager.restart_level_manager()
	get_tree().paused = true
	ready_panel_father.show()
	ready_panel.waiting_input = true
	bar_timer.set_parameters(time_level)
#endregion

#region Opciones
func _on_opciones_pressed():
	get_tree().paused = true
	pause_panel_father.show()

func _on_panel_opciones_continuar():
	pause_panel_father.hide()
	get_tree().paused = false

func _on_panel_opciones_reiniciar():
	restart_game()
	pause_panel_father.hide()
	get_tree().paused = false
#endregion
