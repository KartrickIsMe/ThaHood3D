extends MultiplayerSpawner

@export var network_player: PackedScene = preload("res://characters/player/player.tscn")
@export var network_map: PackedScene = preload("res://levels/rookie_hood/rookie_hood.tscn")

func _ready() -> void:
	multiplayer.peer_connected.connect(spawn_player)

func spawn_player(id: int) -> void:
	
	#if the thing is not server deny the mf
	if not multiplayer.is_server():
		return
	else:
		var player_node = network_player.instantiate()
		player_node.name = str(id)
		get_node(spawn_path).add_child(player_node)

func spawn_map() -> void:
	
	if not multiplayer.is_server(): return
	var map_node = network_map.instantiate()
	get_node(spawn_path).add_child(map_node)
