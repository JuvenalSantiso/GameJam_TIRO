extends CharacterBody2D

@onready var buffer_actions: Actions = $Actions
@onready var action_area: CollisionShape2D = $ActionArea/CollisionShape2D


const SPEED = 300.0
const JUMP_VELOCITY = -600.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var identity: int

var initial_position: Vector2
var is_death = false
var is_grabbable = false
var is_grabbing = false
var grabbed_box: RigidBody2D
var original_parent: Node2D

func vision_direction(direction):
	if direction < 0:
		action_area.position.x = -abs(action_area.position.x)
	elif direction > 0:
		action_area.position.x = abs(action_area.position.x)

func reset_player():
	is_death = true
	position = initial_position
	set_velocity(Vector2(0,0))

func read_from_player(delta) -> void:
	#region Read Input
	var direction = Input.get_axis("left", "right")
	var jumping = Input.is_action_just_pressed("jump")
	var grab = Input.is_action_just_pressed("push")
	#endregion
		
	#region Save Input
	var action = buffer_actions.init_capture_input()
	action.move = direction
	action.jump = jumping
	action.grab = grab
	buffer_actions.capture_input(action)
	#endregion 
	
	aply_inputs(delta, action)

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
		
		if actionframe.grab and grabbed_box != null:
			if grabbed_box.has_method("do_push"):
				grabbed_box.do_push(direction)
				
	if not is_grabbing:
		move_and_slide()

func aply_inputs(delta, action) -> void:
	if action.grab and grabbed_box:
		if is_grabbing:
			self.reparent(original_parent)
			is_grabbing = false
		else:
			self.reparent(grabbed_box)
			is_grabbing = true
	
	#region Movimiento
	if not is_on_floor():
		velocity.y += gravity * delta
	elif action.jump:
		velocity.y = JUMP_VELOCITY
	
	if is_grabbing and grabbed_box:
		if action.move:
			grabbed_box.add_player_force(identity, action.move)
		else:
			grabbed_box.add_player_force(identity, 0)
	else:
		if action.move:
			velocity.x = action.move * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)	
		vision_direction(action.move)
	#endregion
	

	if not is_grabbing:
		move_and_slide()

func _ready():
	initial_position = position
	original_parent = get_parent()
	is_death = false

func _physics_process(delta):
	if not is_death:
		read_from_player(delta)
	else: 
		read_from_buffer(delta)


#region Signal Objeto Agarrable
func _on_action_area_body_entered(body):
	if body.has_method("grab_me"):
		grabbed_box = body.grab_me()


#endregion
