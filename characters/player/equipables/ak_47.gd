extends Node3D

@onready var muzzle_flash: GPUParticles3D = %GPUParticles3D
@export var fire_rate: float = 9	
@export var recoil: float = 7
@onready var shot_sound: AudioStreamPlayer3D = %AudioStreamPlayer3D
var fire_rate_set: bool



func attack_fire(is_firing: bool, animation_tree: AnimationTree, camera: Node3D, camera_min_angle_degrees: float, camera_max_angle_degrees, delta) -> void:
	if not fire_rate_set:
		animation_tree["parameters/RifleArmed/TimeScale/scale"] = fire_rate
		muzzle_flash.emitting = true
		fire_rate_set = true
	
	if not animation_tree["parameters/RifleArmed/OneShot/active"] && is_firing:
		animation_tree["parameters/RifleArmed/OneShot/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE
		if camera.rotation_degrees.x >= camera_min_angle_degrees + recoil:
			#camera.rotation_degrees.x = move_toward(camera.rotation_degrees.x, camera.rotation_degrees.x - recoil, recoil)
			camera.rotation_degrees.x -= recoil
		shot_sound.play()
		muzzle_flash.restart()
