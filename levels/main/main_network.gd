extends "res://levels/main/main.gd"

@export var ip_address: String = "localhost"
@export var port: int = 6996
@export var dedicated_server: bool = false
@export var channel_count: int = 0
@export var in_bandwidth: int = 0
@export var out_bandwidth: int = 0
@export var local_port: int = 0
@export var max_clients: int = 32
@export var max_channels: int = 0
var peer: ENetMultiplayerPeer

@onready var multiplayer_spawner: MultiplayerSpawner = %MultiplayerSpawner
@export var player_scene: PackedScene = preload("res://characters/player/player.tscn")
@export var level_scene: PackedScene = preload("res://levels/rookie_hood/rookie_hood.tscn")

@onready var ui: CanvasLayer = %CanvasLayer
#override
#var ms_spawn_path: String = $".".get_path()

func create_client() -> void:
	ip_address = $CanvasLayer/Control/TextEdit.text
	peer = ENetMultiplayerPeer.new()
	peer.create_client(ip_address, port, channel_count, in_bandwidth, out_bandwidth, local_port)
	multiplayer.multiplayer_peer = peer
	ui.hide()

func create_server() -> void:
	peer = ENetMultiplayerPeer.new()
	peer.create_server(port, max_clients, max_channels, in_bandwidth, out_bandwidth)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(spawn_player)
	ui.hide()
	spawn_level()
	if !dedicated_server: spawn_player(1)

func destroy_server() -> void:
	multiplayer.multiplayer_peer = OfflineMultiplayerPeer.new()

func _on_join_server_pressed() -> void:
	create_client()

func _on_create_server_pressed() -> void:
	create_server()

func spawn_level() -> void:
	var level_node: Node3D = level_scene.instantiate()
	multiplayer_spawner.get_node(multiplayer_spawner.spawn_path).call_deferred("add_child", level_node)

func spawn_player(id: int) -> void:
	if not multiplayer_spawner.multiplayer.is_server(): return
	
	var player_node: Node3D = player_scene.instantiate()
	player_node.name = str(id)
	
	#override
	#multiplayer_spawner.spawn_path = ms_spawn_path
	
	multiplayer_spawner.get_node(multiplayer_spawner.spawn_path).call_deferred("add_child", player_node)
