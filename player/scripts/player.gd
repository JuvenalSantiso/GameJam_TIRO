extends CharacterBody2D

@onready var death_timer: Timer = $DeathTimer
@onready var buffer_actions: Actions = $Actions

const SPEED = 300.0
const JUMP_VELOCITY = -600.0

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
	if not is_on_floor():
		velocity.y += gravity * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		buffer_actions.capture_input("jump", delta)
		velocity.y = JUMP_VELOCITY

	var direction = Input.get_axis("left", "right")
	if direction < 0: 
		buffer_actions.capture_input("left", delta)
	if direction > 0: 
		buffer_actions.capture_input("right", delta)
		
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()


func _on_death_timer_timeout():
	reset_player()
	death_timer.start()
	replay_actions()
