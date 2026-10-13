extends Node3D

func attack_fire(animation_tree: AnimationTree, gun_target: Marker3D, r_hand_ik: FABRIK3D) -> void:
	print("Pistol Fires")
	animation_tree["parameters/OneShotP/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE
	pass
