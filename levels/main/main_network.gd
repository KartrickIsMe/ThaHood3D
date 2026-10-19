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
