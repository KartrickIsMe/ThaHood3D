extends Node3D

@onready var muzzle_flash: GPUParticles3D = %GPUParticles3D
@export var fire_rate: float = 10 #RPS
@export var recoil: float = 0 #DegreePS
@onready var shot_sound: AudioStreamPlayer3D = %AudioStreamPlayer3D
@export var projectile_scene: PackedScene = preload("res://characters/player/equipables/rifles/ak_47/projectile.tscn")
@export var bullet_speed: float = 300 #MS
@export var inaccuracy: float = 5 #Degree Deviation
var fire_rate_set: bool

func attack_fire(is_firing: bool, animation_tree: AnimationTree, camera: Node3D, camera_min_angle_degrees: float, camera_max_angle_degrees: float, delta: float, player: Node3D) -> void:
	if not fire_rate_set:
		animation_tree["parameters/RifleArmed/TimeScale/scale"] = fire_rate
		muzzle_flash.emitting = true
		fire_rate_set = true
	
	if not animation_tree["parameters/RifleArmed/OneShot/active"] && is_firing:
		animation_tree["parameters/RifleArmed/OneShot/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE
		spawn_bullet(camera)
		if camera.rotation_degrees.x >= camera_min_angle_degrees + recoil:
			#camera.rotation_degrees.x = move_toward(camera.rotation_degrees.x, camera.rotation_degrees.x - recoil, recoil)
			camera.rotation_degrees.x -= recoil
		shot_sound.play()
		muzzle_flash.restart()

func spawn_bullet(camera: Node3D) -> void:
	var bullet: RigidBody3D = projectile_scene.instantiate()
	get_tree().current_scene.add_child(bullet)
	bullet.linear_velocity.z = bullet_speed
	bullet.global_position = muzzle_flash.global_position
	bullet.rotation.z = camera.global_rotation.z
	bullet.rotation_degrees.x = camera.global_rotation_degrees.x + randf_range(-inaccuracy, +inaccuracy)
	bullet.rotation_degrees.y = camera.global_rotation_degrees.y + randf_range(-inaccuracy, +inaccuracy)
	bullet.linear_velocity = bullet.global_basis.z * bullet_speed
