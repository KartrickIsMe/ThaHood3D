extends RigidBody3D

@onready var hit_sound: AudioStreamPlayer3D = %AudioStreamPlayer3D
@onready var sparks: GPUParticles3D = %GPUParticles3D
var max_hit_sounds: int = 1

func _on_body_entered(_body: Node) -> void:
	var s: GPUParticles3D = sparks.duplicate()
	var h: AudioStreamPlayer3D = hit_sound.duplicate()
	get_tree().current_scene.add_child(s)
	get_tree().current_scene.add_child(h)
	s.global_position = global_position
	h.global_position = global_position
	s.emitting = true
	h.play()


func _on_timer_timeout() -> void:
	self.queue_free()
