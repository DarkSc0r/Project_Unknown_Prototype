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

	# DEBUG
	StructureManager.generate_structures(world_tilemap, Vector2i(1, 2))
	
func _process(_delta: float) -> void:
	check_tile_under_player()

func check_tile_under_player():
	var player_local_pos = world_tilemap.to_local(player_instance.global_position)
	var tile_under_player_coord = world_tilemap.local_to_map(player_local_pos)
	var tile_under_player_data = GameTileData.get_selected_tile_data(world_tilemap, tile_under_player_coord)

	if tile_under_player_data == null:
		return "Tile does not exist."

	var is_tile_under_player_spawnable = tile_under_player_data.get_custom_data("spawnable")



# DEBUG ^^
