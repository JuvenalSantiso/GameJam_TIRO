extends CharacterBody2D

signal s_death

@onready var death_timer: Timer = $DeathTimer
@onready var buffer_actions: Actions = $Actions

const SPEED = 300.0
const JUMP_VELOCITY = -600.0

var is_death = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var initial_position: Vector2

func reset_player():
	position = initial_position
	set_velocity(Vector2(0,0))

func _ready():
	initial_position = position

func _physics_process(delta):
	if not is_death:
		read_from_player(delta)
	else: 
		read_from_buffer(delta)

	move_and_slide()

func read_from_player(delta) -> void:
	var action = buffer_actions.init_capture_input()
	
	if not is_on_floor():
		velocity.y += gravity * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		action.jump = true
		velocity.y = JUMP_VELOCITY

	var direction = Input.get_axis("left", "right")
	action.move = direction
	
	buffer_actions.capture_input(action)
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

func read_from_buffer(delta) -> void:
	var actionframe = buffer_actions.pop_buffer_action()
	velocity.y += gravity * delta
	if actionframe != null:
		if actionframe.jump:
			velocity.y = JUMP_VELOCITY
		var direction = actionframe.move
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

func _on_death_timer_timeout():
	if not is_death:
		s_death.emit()
	reset_player()
	is_death = true
