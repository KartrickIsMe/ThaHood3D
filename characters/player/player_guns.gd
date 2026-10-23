extends "res://characters/player/player.gd"

@onready var gun_target: Marker3D = %GunTarget
@onready var r_hand_ba: BoneAttachment3D  = %RHandBA
#@onready var r_hand_ik: FABRIK3D = %RHandIK
@onready var crosshair: TextureRect = %Crosshair
@export var pistol_scene: PackedScene = preload("res://characters/player/equipables/pistol_coonan.tscn")
@export var axe_scene: PackedScene = preload("res://characters/player/equipables/axe.tscn")
@export var ak47_scene: PackedScene = preload("res://characters/player/equipables/rifles/ak_47/ak_47.tscn")


#var pistol_node: Node3D = pistol_scene.instantiate()
#var axe_node: Node3D = axe_scene.instantiate()
#var ak47_node: Node3D = ak47_scene.instantiate()

var weapon_node: Node3D

@export var gun_name: String = "any"

var no_infinite_loop_for_gun_name: String = "any"

func _process(delta: float) -> void:
	if gun_name != no_infinite_loop_for_gun_name:
		no_infinite_loop_for_gun_name = gun_name
		match gun_name:
			"any": set_no_weapon()
			"pistol_coonan": set_pistol()
			"axe": set_axe()
			"ak47": set_ak47()
	
	if not is_multiplayer_authority(): return
	
	super(delta)
	update_animation()
	if speed != sprint_speed:
		set_crosshair_visibility(true)
		if Input.is_action_pressed("attack"):
			if gun_name == "ak47":
				#RPC
				weapon_node.attack_fire.rpc(true, animation_tree.get_path(), camera.get_path(), camera_min_angle_degrees)
	else:
		set_crosshair_visibility(false)

@warning_ignore("shadowed_variable_base_class")
func set_crosshair_visibility(is_visible: bool) -> void:
	crosshair.visible = is_visible
	

#region set_no_weapon()
func set_no_weapon() -> void:
	animation_tree["parameters/playback"].travel("Unarmed")
	r_hand_ik.active = false
	if r_hand_ba.get_child_count() > 0:
		weapon_node.queue_free()
#endregion

#region pistol set
func set_pistol() -> void:
	set_no_weapon()
	r_hand_ik.active = true
	weapon_node = pistol_scene.instantiate()
	r_hand_ba.add_child(weapon_node)
	weapon_node.position = Vector3(0.033, 0.188, 0.02)
	weapon_node.rotation_degrees = Vector3(-0.7, -117.7, 88.3)
	gun_target.position = Vector3(0.213, -0.302, -0.955)
#endregion

#region axe set
func set_axe() -> void:
	set_no_weapon()
	weapon_node = axe_scene.instantiate()
	r_hand_ba.add_child(weapon_node)
	weapon_node.position = Vector3(0.081, 0.134, -0.021)
	weapon_node.rotation_degrees = Vector3(83.6, -167.3, 75.3)
	gun_target.position = Vector3(0.213, -0.302, -0.955)
#endregion

#region set ak47
func set_ak47() -> void:
	set_no_weapon()
	animation_tree["parameters/playback"].travel("RifleArmed")
	weapon_node = ak47_scene.instantiate()
	r_hand_ba.add_child(weapon_node)
	weapon_node.set_multiplayer_authority(get_multiplayer_authority())
#endregion

func _unhandled_input(event: InputEvent) -> void:
	
	if not is_multiplayer_authority(): return
	
	super(event)
#region cycle weapons
	if Input.is_action_just_pressed("secondary"):
		#set_pistol()
		gun_name = "pistol_coonan"
	elif Input.is_action_just_pressed("primary"):
		#set_no_weapon()
		gun_name = "any"
	elif Input.is_action_just_pressed("three"):
		#set_axe()
		gun_name = "axe"
	elif Input.is_action_just_pressed("four"):
		#set_ak47()
		gun_name = "ak47"
#endregion
	
	if Input.is_action_pressed("attack") && speed != sprint_speed:
		if gun_name == "axe":
			weapon_node.attack_swing(animation_tree)
		elif gun_name == "pistol_coonan":
			weapon_node.attack_fire(animation_tree, gun_target, r_hand_ik)
		elif gun_name == "ak47":
			pass # automatic fire handled in process

func update_animation() -> void:
	smooth_value_y = move_toward(smooth_value_y, velocity.y/jump_force, 0.1)
	if gun_name == "any" || gun_name == "pistol_coonan" || gun_name == "axe":
		animation_tree["parameters/Unarmed/BlendSpace2D/blend_position"] = Vector2( Vector2(velocity.x, velocity.z).length()/sprint_speed, smooth_value_y)
	elif gun_name == "ak47":
		animation_tree["parameters/RifleArmed/BlendSpace2D/blend_position"] = Vector2( Vector2(velocity.x, velocity.z).length()/sprint_speed, smooth_value_y)
