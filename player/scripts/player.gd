extends CharacterBody2D

@onready var buffer_actions: Actions = $Actions
@onready var action_area: CollisionShape2D = $ActionArea/CollisionShape2D


const SPEED = 300.0
const JUMP_VELOCITY = -600.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var initial_position: Vector2
var is_death = false
var is_grabbing: bool = false
var is_grabbable: bool = false
var is_sticking:bool = false
var grabbed_box: RigidBody2D
var grabber_box: Area2D

func vision_direction(direction):
	if direction < 0:
		action_area.position.x = -abs(action_area.position.x)
	elif direction > 0:
		action_area.position.x = abs(action_area.position.x)

func reset_player():
	is_death = true
	position = initial_position
	set_velocity(Vector2(0,0))
	is_sticking = false
	is_grabbable = false
	is_grabbing = false
	grabbed_box = null


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
	
	if Input.is_action_just_pressed("grab") and is_grabbable and grabbed_box:
		action.grab = true
		if is_sticking:
			is_sticking = false
		else:
			print(grabber_box)
			global_position = grabber_box.global_position 
			is_sticking = true
	
	if not is_sticking:
		move_and_slide()
	else:
		global_position = grabber_box.global_position 
		grabbed_box.do_push(direction)
	
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
		
		if actionframe.grab and grabbed_box:
			if is_sticking:
				is_sticking = false
			else:
				global_position = grabber_box.global_position  
				is_sticking = true
		
		if not is_sticking:
			move_and_slide()
		else:
			global_position = grabber_box.global_position
			grabbed_box.do_push(direction)
				
func _ready():
	initial_position = position
	is_death = false

func _physics_process(delta):
	if not is_death:
		read_from_player(delta)
	else: 
		read_from_buffer(delta)



func _on_action_area_body_entered(body):
	if body.is_in_group("boxes"):
		grabbed_box = body
		

func _on_action_area_body_exited(body):
	if body.is_in_group("boxes") and not is_sticking:
		grabbed_box = null
		grabber_box = null
		is_grabbable = false


func _on_action_area_area_entered(area):
	print(area)
	if area.is_in_group("grabber_box"):
		grabber_box = area
		is_grabbable = true
	
