extends Node3D

@onready var muzzle_flash: GPUParticles3D = %GPUParticles3D
@export var fire_rate: float = 7
@export var recoil: float = 10
var fire_rate_set: bool



func attack_fire(animation_tree: AnimationTree, camera: MeshInstance3D) -> void:
	if not fire_rate_set:
		animation_tree["parameters/RifleArmed/TimeScale/scale"] = fire_rate
		muzzle_flash.lifetime = fire_rate/1000
		fire_rate_set = true
	
	if not animation_tree["parameters/RifleArmed/OneShot/active"]:
		animation_tree["parameters/RifleArmed/OneShot/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE
		camera.rotation_degrees.x = move_toward(camera.rotation_degrees.x, camera.rotation_degrees.x - recoil, recoil)
		muzzle_flash.restart()
