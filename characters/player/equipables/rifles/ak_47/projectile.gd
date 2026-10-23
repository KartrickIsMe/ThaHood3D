extends RigidBody3D

@onready var hit_sound1: AudioStreamPlayer3D = %AudioStreamPlayer3D
@onready var hit_sound2: AudioStreamPlayer3D = %AudioStreamPlayer3D2
@onready var hit_sound3: AudioStreamPlayer3D = %AudioStreamPlayer3D3
@onready var sparks: GPUParticles3D = %GPUParticles3D
var max_hit_sounds: int = 1
@export var min_projectile_velocity: float = 1

func _on_body_entered(_body: Node) -> void:
	var s: GPUParticles3D = sparks.duplicate()
	var i: int = randi_range(1,3)
	if i == 1:
		var h: AudioStreamPlayer3D = hit_sound1.duplicate()
		get_tree().current_scene.add_child(h)
		h.global_position = global_position
		h.play()
	elif i == 2:
		var h: AudioStreamPlayer3D = hit_sound2.duplicate()
		get_tree().current_scene.add_child(h)
		h.global_position = global_position
		h.play()
	elif i == 3:
		var h: AudioStreamPlayer3D = hit_sound3.duplicate()
		get_tree().current_scene.add_child(h)
		h.global_position = global_position
		h.play()
	else:
		print(i)
	get_tree().current_scene.add_child(s)
	s.global_position = global_position
	
	s.emitting = true


func _process(_delta: float) -> void:
	if linear_velocity.length() < min_projectile_velocity:
		queue_free()


func _on_timer_timeout() -> void:
	self.queue_free()
