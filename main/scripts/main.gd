extends Node2D

@onready var chunk_manager := %ChunkManager
@onready var world_tilemap := $ChunkManager/ChunkTilemap
var player := preload("res://character/Player.tscn")

var player_instance : CharacterBody2D

func _ready() -> void:
	# Player
	player_instance = player.instantiate()
	add_child(player_instance)
	chunk_manager.set_player(player_instance)
	
func _process(_delta: float) -> void:
	check_tile_under_player()

func check_tile_under_player():
	var tile_under_player_coord = world_tilemap.to_local(player_instance.position)
	var tile_under_player_data = world_tilemap.get_cell_tile_data(tile_under_player_coord)

	if tile_under_player_data == null:
		return "Tile does not exist."

	var is_tile_under_player_spawnable = tile_under_player_data.get_custom_data("spawnable")

	print("Tile under player is spawnable: ", is_tile_under_player_spawnable)

# DEBUG ^^