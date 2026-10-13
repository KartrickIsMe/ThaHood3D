extends "res://characters/player/player.gd"

@onready var gun_target: Marker3D = %GunTarget
@onready var r_hand_ba: BoneAttachment3D  = %RHandBA
#@onready var r_hand_ik: FABRIK3D = %RHandIK
@export var pistol_scene: PackedScene = preload("res://characters/player/equipables/pistol_coonan.tscn")

var pistol_node: Node3D = pistol_scene.instantiate()

func get_gun_name() -> String:
	var gun_name: String = "pistol_coonan"
	return gun_name

#called by the parent _ready
func _ready() -> void:
	super() # call parent's _ready first

func set_no_weapon() -> void:
	r_hand_ik.active = false
	if r_hand_ba.get_child_count() == 1:
		r_hand_ba.remove_child(r_hand_ba.get_child(0))

func set_pistol() -> void:
	set_no_weapon()
	r_hand_ik.active = true
	if r_hand_ba.get_child_count() == 0:
		r_hand_ba.add_child(pistol_node)
	pistol_node.position = Vector3(0.033, 0.188, 0.02)
	pistol_node.rotation_degrees = Vector3(-0.7, -117.7, 88.3)
	print(pistol_node.position)
	gun_target.position = Vector3(0.213, -0.302, -0.955)

func _unhandled_input(event: InputEvent) -> void:
	super(event)
	if Input.is_action_just_pressed("secondary"):
		set_pistol()
	elif Input.is_action_just_pressed("primary"):
		set_no_weapon()
	
