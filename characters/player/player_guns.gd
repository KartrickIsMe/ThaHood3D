extends "res://characters/player/player.gd"

@onready var gun_target: Marker3D = %GunTarget
@onready var r_hand_ba: BoneAttachment3D  = %RHandBA
#@onready var r_hand_ik: FABRIK3D = %RHandIK
@onready var crosshair: TextureRect = %Crosshair
@export var pistol_scene: PackedScene = preload("res://characters/player/equipables/pistol_coonan.tscn")
@export var axe_scene: PackedScene = preload("res://characters/player/equipables/axe.tscn")
@export var ak47_scene: PackedScene = preload("res://characters/player/equipables/rifles/ak_47/ak_47.tscn")


var pistol_node: Node3D = pistol_scene.instantiate()
var axe_node: Node3D = axe_scene.instantiate()
var ak47_node: Node3D = ak47_scene.instantiate()

var gun_name: String = "any"

func _process(delta: float) -> void:
	super(delta)
	update_animation()
	if speed != sprint_speed:
		set_crosshair_visibility(true)
		if Input.is_action_pressed("attack"):
			if gun_name == "ak47":
				ak47_node.attack_fire(true, animation_tree, camera, camera_min_angle_degrees,  camera_max_angle_degrees, delta, player)
	else:
		set_crosshair_visibility(false)
	
@warning_ignore("shadowed_variable_base_class")
func set_crosshair_visibility(is_visible: bool) -> void:
	crosshair.visible = is_visible
	

#region set_no_weapon()
func set_no_weapon() -> void:
	animation_tree["parameters/playback"].travel("Unarmed")
	gun_name = "any"
	r_hand_ik.active = false
	if r_hand_ba.get_child_count() == 1:
		r_hand_ba.remove_child(r_hand_ba.get_child(0))
#endregion

#region pistol set
func set_pistol() -> void:
	set_no_weapon()
	r_hand_ik.active = true
	if r_hand_ba.get_child_count() == 0:
		r_hand_ba.add_child(pistol_node)
	gun_name = "pistol_coonan"
	pistol_node.position = Vector3(0.033, 0.188, 0.02)
	pistol_node.rotation_degrees = Vector3(-0.7, -117.7, 88.3)
	print(pistol_node.position)
	gun_target.position = Vector3(0.213, -0.302, -0.955)
#endregion

#region axe set
func set_axe() -> void:
	set_no_weapon()
	gun_name = "axe"
	if r_hand_ba.get_child_count() == 0:
		r_hand_ba.add_child(axe_node)
	axe_node.position = Vector3(0.081, 0.134, -0.021)
	axe_node.rotation_degrees = Vector3(83.6, -167.3, 75.3)
	gun_target.position = Vector3(0.213, -0.302, -0.955)
#endregion

#region set ak47
func set_ak47() -> void:
	set_no_weapon()
	animation_tree["parameters/playback"].travel("RifleArmed")
	gun_name = "ak47"
	if r_hand_ba.get_child_count() == 0:
		r_hand_ba.add_child(ak47_node)
#endregion

func _unhandled_input(event: InputEvent) -> void:
	super(event)
#region cycle weapons
	if Input.is_action_just_pressed("secondary"):
		set_pistol()
	elif Input.is_action_just_pressed("primary"):
		set_no_weapon()
	elif Input.is_action_just_pressed("three"):
		set_axe()
	elif Input.is_action_just_pressed("four"):
		set_ak47()
#endregion
	
	if Input.is_action_pressed("attack") && speed != sprint_speed:
		if gun_name == "axe":
			axe_node.attack_swing(animation_tree)
		elif gun_name == "pistol_coonan":
			pistol_node.attack_fire(animation_tree, gun_target, r_hand_ik)
		elif gun_name == "ak47":
			pass # automatic fire handled in process
			
func update_animation() -> void:
	smooth_value_y = move_toward(smooth_value_y, velocity.y/jump_force, 0.1)
	if gun_name == "any" || gun_name == "pistol_coonan" || gun_name == "axe":
		animation_tree["parameters/Unarmed/BlendSpace2D/blend_position"] = Vector2( Vector2(velocity.x, velocity.z).length()/sprint_speed, smooth_value_y)
	elif gun_name == "ak47":
		animation_tree["parameters/RifleArmed/BlendSpace2D/blend_position"] = Vector2( Vector2(velocity.x, velocity.z).length()/sprint_speed, smooth_value_y)
