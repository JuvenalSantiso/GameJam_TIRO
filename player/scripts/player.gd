extends CharacterBody2D

@onready var buffer_actions: Actions = $Actions
@onready var action_area: CollisionShape2D = $ActionArea/CollisionShape2D


const SPEED = 300.0
const JUMP_VELOCITY = -600.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var initial_position: Vector2
var is_death = false
var object_in_range: Node2D

func vision_direction(direction):
	if direction < 0:
		action_area.position.x = -abs(action_area.position.x)
	elif direction > 0:
		action_area.position.x = abs(action_area.position.x)

func reset_player():
	is_death = true
	position = initial_position
	set_velocity(Vector2(0,0))

func _ready():
	initial_position = position
	is_death = false

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
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	vision_direction(direction)
	
	if Input.is_action_just_pressed("push") and object_in_range != null:
		action.push = true
		if object_in_range.has_method("do_push"):
			object_in_range.do_push(direction)
		
	
	buffer_actions.capture_input(action)

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
		vision_direction(direction)
		
		if actionframe.push and object_in_range != null:
			if object_in_range.has_method("do_push"):
				object_in_range.do_push(direction)
	
	

func _on_action_area_body_entered(body):
	print(body)
	object_in_range = body

func _on_action_area_body_exited(body):
	print("out")
	object_in_range = null
