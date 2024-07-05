extends CharacterBody2D


@onready var buffer_actions: Actions = $Actions
@onready var action_area: CollisionShape2D = $ActionArea/CollisionShape2D
@onready var visual_player = $VisualPlayer


const SPEED = 300.0
const JUMP_VELOCITY = -685.0
const PUSH_FORCE = 90000

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var initial_position: Vector2
var is_death = false
var is_grabbing: bool = false
var is_grabbable: bool = false
var is_sticking:bool = false
var grabbed_box: RigidBody2D
var grabber_box: Area2D

#region Visual
func vision_direction(direction):
	if direction < 0:
		action_area.position.x = -abs(action_area.position.x)
		visual_player.scale.x = -1
	elif direction > 0:
		action_area.position.x = abs(action_area.position.x)
		visual_player.scale.x = 1

func set_animation_state(direction: float, jump: bool):
	if is_death:
		self.modulate.a = 0.5
	
	if (jump):
		visual_player.set_jump_state()
	elif not is_on_floor():
		if velocity.y < 0 :
			visual_player.set_air_down_state()
	else:
		if visual_player.is_air_state():
			visual_player.set_landing_state()
		elif is_sticking:
			visual_player.set_push_state()
			visual_player.set_push_state_speed(direction)
		else:
			visual_player.set_move_state()
			visual_player.set_move_state_speed(abs(direction))
#endregion

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
	var jump_animation = false
	
	if not is_on_floor():
		velocity.y += gravity * delta

	if Input.is_action_just_pressed("jump"):
		action.jump = true
		if is_on_floor():
			jump_animation = true
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
			global_position = grabber_box.global_position 
			is_sticking = true
	
	if not is_sticking:
		move_and_slide()
		for idx_c in get_slide_collision_count():
			var coll = get_slide_collision(idx_c).get_collider()
			if coll.name == 'A':
				if global_position.x > coll.global_position.x:
					coll.apply_torque(PUSH_FORCE)
				else:
					coll.apply_torque(-PUSH_FORCE)
	else:
		global_position = grabber_box.global_position 
		grabbed_box.do_push(direction)
	
	buffer_actions.capture_input(action)
	set_animation_state(action.move, jump_animation)

func read_from_buffer(delta) -> void:
	var actionframe = buffer_actions.pop_buffer_action()
	var jump_animation = false
	velocity.y += gravity * delta
	if actionframe != null:
		if actionframe.jump and is_on_floor():
			jump_animation = true
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
			for idx_c in get_slide_collision_count():
				var coll = get_slide_collision(idx_c).get_collider()
				if coll.name == 'A':
					if global_position.x > coll.global_position.x:
						coll.apply_torque(PUSH_FORCE)
					else:
						coll.apply_torque(-PUSH_FORCE)
		else:
			global_position = grabber_box.global_position
			grabbed_box.do_push(direction)
				
	var move: float = 0
	if (actionframe != null):
		move = actionframe.move
	set_animation_state(move, jump_animation)

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
	if area.is_in_group("grabber_box"):
		grabber_box = area
		is_grabbable = true
	
