extends Node3D
signal hit

#var swing_rate: float = 1

func attack_swing(animation_tree: AnimationTree) -> void:
	if !animation_tree["parameters/OneShot/active"]:
		animation_tree["parameters/OneShot/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE
