extends CharacterBody3D

@export var mouse_sensitivity: float = 0.4
@onready var camera: Camera3D = %Camera3D

@export var walk_speed: float = 5.0
@export var sprint_speed: float = 8.0
@export var jump_force: float = 5.0

var speed: float

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta: float) -> void:
	
	if velocity.length() != 0:
		$humanoid_rigged/Idle_Walk.play("default")
	else:
		$humanoid_rigged/Idle_Walk.stop()
	
	
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if is_on_floor() && Input.is_action_just_pressed("jump"):
		velocity.y += jump_force
	
	var input_direction_2d = Input.get_vector(
		"move_left", "move_right", "move_forward", "move_backward"
	)
	
	var input_direction_3d = Vector3(
		input_direction_2d.x, 0.0, input_direction_2d.y
	)
	
	var direction = transform.basis * input_direction_3d
	
	velocity.x = direction.x * speed
	velocity.z = direction.z * speed
	
	move_and_slide()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		self.rotation_degrees.y -= event.relative.x * mouse_sensitivity
		camera.rotation_degrees.x -= event.relative.y * mouse_sensitivity
		camera.rotation_degrees.x = clamp(
			camera.rotation_degrees.x, -60, 69
		)
	elif Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	if Input.is_action_pressed("sprint"):
		speed = sprint_speed
	else:
		speed = walk_speed
	
	if Input.is_action_just_pressed("attack") && not %AnimationPlayer.is_playing():
		%AnimationPlayer.play("axe_attack")
	if Input.is_action_just_pressed("alt_attack") && not %AnimationPlayer.is_playing():
		shoot()

func shoot() -> void:
	%AnimationPlayer.play("axe_shoot")
