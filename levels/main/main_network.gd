extends "res://levels/main/main.gd"

var peer: ENetMultiplayerPeer
const PORT: int = 6996
var server_ip_address: String = "localhost"

func create_server() -> void:
	peer = ENetMultiplayerPeer.new()
	peer.create_server(PORT)
	multiplayer.multiplayer_peer = peer

func create_client() -> void:
	peer = ENetMultiplayerPeer.new()
	peer.create_client(server_ip_address, PORT)
	multiplayer.multiplayer_peer = peer

func terminate_networking() -> void:
	multiplayer.multiplayer_peer = OfflineMultiplayerPeer.new()

func do_not_invoke_this_function() -> void:
	var level: PackedScene = preload("res://levels/rookie_hood/rookie_hood.tscn")
	var level_node: Node3D = level.instantiate()
	var player: PackedScene = preload("res://characters/player/player.tscn")
	var player_node: Node3D = player.instantiate()
	add_child(level_node)
	add_child(player_node)
	player_node.position.y = 10
