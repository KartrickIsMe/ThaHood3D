extends Node

@export var level: PackedScene
@export var player: PackedScene
var player_scene: CharacterBody3D

func _ready() -> void:
	var level_scene: Node3D = level.instantiate()
	player_scene = player.instantiate()
	add_child(level_scene)
	add_child(player_scene)
	player_scene.position.y = 4
