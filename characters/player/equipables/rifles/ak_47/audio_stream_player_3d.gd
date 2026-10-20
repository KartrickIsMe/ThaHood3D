extends AudioStreamPlayer3D


func _on_finished() -> void:
	self.queue_free()
