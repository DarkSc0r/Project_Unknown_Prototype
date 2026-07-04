extends Node2D

@onready var chunk_manager := %ChunkManager
var player := preload("res://character/Player.tscn")

func _ready() -> void:
	# Player
	var player_instance := player.instantiate()
	add_child(player_instance)
	chunk_manager.set_player(player_instance)
