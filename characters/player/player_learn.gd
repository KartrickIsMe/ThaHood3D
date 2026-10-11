extends CharacterBody3D

@export var mouse_senstivity: float = 0.30
@onready var camera: Camera3D = %Camera3D

@export var walk_speed: float = 10.0
@export var jump_force: float = 4.5

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		self.rotation_degrees.y -= event.relative.x * mouse_senstivity
		camera.rotation_degrees.x -= event.relative.y * mouse_senstivity
		camera.rotation_degrees.x = clamp(
			camera.rotation_degrees.x, -60, 69
		)
	elif event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _physics_process(delta: float) -> void:
	
	var input_direction_2d = Input.get_vector(
		"move_left", "move_right", "move_forward", "move_backward"
	)
	
	var input_direction_3d = Vector3(
		input_direction_2d.x, 0.0, input_direction_2d.y
	)
	
	var direction = transform.basis * input_direction_3d
	
	velocity.x = direction.x * walk_speed
	velocity.z = direction.z * walk_speed
	
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y += jump_force
	move_and_slide()
