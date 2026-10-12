extends "res://characters/player/player.gd"

@onready var gun_target: Marker3D = %GunTarget
@onready var r_hand_ba: BoneAttachment3D  = %RHandBA
#@onready var r_hand_ik: FABRIK3D = %RHandIK

func get_gun_name() -> String:
	var gun_name: String = r_hand_ba.get_child(0).name
	return gun_name

#called by the parent _ready
func _ready() -> void:
	super() # call parent's _ready first
	print(get_gun_name())
	if get_gun_name() == "pistol-coonan":
		set_pistol()


func set_pistol() -> void:
	gun_target.position = Vector3(0.213, -0.302, -0.955)
