extends CharacterBody2D

@onready var death_timer: Timer = $DeathTimer
@onready var buffer_actions: Actions = $Actions

const SPEED = 300.0
const JUMP_VELOCITY = -600.0

var savedActions : Array[ActionFrame] = []
var death = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var initial_position: Vector2

func reset_player():
	position = initial_position
	set_velocity(Vector2(0,0))

func replay_actions():
	for action in buffer_actions.action_buffer:
		await get_tree().create_timer(action.delta).timeout
		execute_action(action.action, action.elapsed_time)

func execute_action(action: String, delta: float):
	var input_action = action
	
	if not is_on_floor():
		velocity.y += gravity * delta

	if input_action == "jump" and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction = 0
	if input_action == "left":
		direction = -1
	if input_action == "right":
		direction = 1
		
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	move_and_slide()

func _ready():
	initial_position = position
	print(initial_position)
	death_timer.start()

func _physics_process(delta):
	if (!death):
		read_from_player(delta)
	else: 
		read_from_buffer(delta)

	move_and_slide()

func read_from_player(delta) -> void:
	var newFrameAction : ActionFrame = ActionFrame.new()
	
	if not is_on_floor():
		velocity.y += gravity * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		newFrameAction.Jump = true
		velocity.y = JUMP_VELOCITY

	var direction = Input.get_axis("left", "right")
	newFrameAction.Move = direction
	
	savedActions.append(newFrameAction)
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

func read_from_buffer(delta) -> void:
	var actionframe = savedActions.pop_front()
	if actionframe != null:
		velocity.y += gravity * delta
		if actionframe.Jump:
			velocity.y = JUMP_VELOCITY
		var direction = actionframe.Move
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

func _on_death_timer_timeout():
	reset_player()
	death = true


class ActionFrame:
	var Move: float = 0
	var Jump: bool = false
