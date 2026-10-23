extends CharacterBody3D

@export var mouse_sensitivity: float = 0.4
@onready var camera: Node3D= %Pivot
@export var walk_speed: float = 1
@export var sprint_speed: float = 5.0
@export var acceleration: float = 0.2
@export var jump_force: float = 5.0
@export var show_logs: bool = true #does nothing
@export var camera_constraints_degrees: float = 89
@export var air_control: float = 0.02
@onready var animation_tree: AnimationTree = %AnimationTree
@onready var actual_camera: Camera3D = %Camera3D
@onready var player: Node3D = $"."
var camera_max_angle_degrees: float = camera_constraints_degrees
var camera_min_angle_degrees: float = -camera_constraints_degrees + 14
var smooth_value_y: float
var speed: float
@onready var r_hand_ik: FABRIK3D = %RHandIK
@onready var pivot_base_y: float = camera.position.y

@export var mp_sync_velocity: Vector3
#VELOCITY BASED ANIMATION HANDLED IN player_guns.gd

func _enter_tree() -> void:
	set_multiplayer_authority(name.to_int())

func _ready() -> void:
	animation_tree.active = true
	actual_camera.current = false
	$HUD.visible = false
	
	if not is_multiplayer_authority(): return
	
	actual_camera.make_current()
	$HUD.visible = true
	global_position.y = 10
	actual_camera.global_rotation_degrees.z = 0
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _log_message():
	pass

func _process(_delta: float) -> void:
	
	if not is_multiplayer_authority(): return
	
	mp_sync_velocity = velocity
	actual_camera.global_rotation_degrees.z = 0
	if speed == sprint_speed:
		r_hand_ik.influence = move_toward(
			r_hand_ik.influence, 0, 0.05)
		animation_tree["parameters/RifleArmed/Blend2/blend_amount"] = move_toward(animation_tree["parameters/RifleArmed/Blend2/blend_amount"], 0, 0.2)
	else:
		r_hand_ik.influence = move_toward(
			r_hand_ik.influence, 1, 0.05)
		animation_tree["parameters/RifleArmed/Blend2/blend_amount"] = move_toward(animation_tree["parameters/RifleArmed/Blend2/blend_amount"], 1, 0.2)


func _physics_process(delta: float) -> void:
	
	if not is_multiplayer_authority(): return
	
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
	
	if is_on_floor():
		apply_bob()
		velocity.x = move_toward(velocity.x, direction.x * speed, acceleration)
		velocity.z = move_toward(velocity.z, direction.z * speed, acceleration)
	elif not is_on_floor():
		velocity.x += direction.x * air_control
		velocity.z += direction.z * air_control
	move_and_slide()

func _unhandled_input(event: InputEvent) -> void:
	
	if not is_multiplayer_authority(): return
	
	if event is InputEventMouseMotion:
		self.rotation_degrees.y -= event.relative.x * mouse_sensitivity
		camera.rotation_degrees.x += event.relative.y * mouse_sensitivity
		camera.rotation_degrees.x = clamp(camera.rotation_degrees.x, camera_min_angle_degrees, camera_max_angle_degrees)
		
	elif Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	if Input.is_action_pressed("sprint"):
		speed = sprint_speed
	else:
		speed = walk_speed
	
	if Input.is_action_just_pressed("three"):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func apply_bob() -> void:
	var speed_ratio = Vector2(velocity.x, velocity.z).length() / sprint_speed		#amp
	camera.position.y = pivot_base_y + sin(Time.get_ticks_msec() / 1000.0 * 12.0) * 0.06 * speed_ratio
