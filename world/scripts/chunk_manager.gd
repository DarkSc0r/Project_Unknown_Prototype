extends Node

@onready var chunk_tilemap := $ChunkTilemap

var chunk := preload("res://world/Chunk.tscn")
var bunker_hatch := preload("res://world/Bunker_Hatch.tscn")

var flat_noise := FastNoiseLite.new()
var flat_noise_scale := 0.1

var biome_noise := FastNoiseLite.new()
var biome_noise_scale := .01

var height_noise := FastNoiseLite.new()
var height_noise_scale := 0.06
var height_layers := 0.0 # DEBUG

var total_height_levels := height_layers + 1

var world_tilemap_layers := []

var loaded_chunks := {}
var render_distance := 4

var player_last_chunk_coordinate := Vector2i(999, 999)

var player : CharacterBody2D

func _ready():
	# Flat World Gen
	flat_noise.seed = GameData.world_seed
	flat_noise.noise_type = FastNoiseLite.TYPE_PERLIN
	flat_noise.frequency = flat_noise_scale

	# Biome World Gen
	biome_noise.seed = GameData.world_seed
	biome_noise.noise_type = FastNoiseLite.TYPE_PERLIN
	biome_noise.frequency = biome_noise_scale

	# Height Gen
	height_noise.seed = GameData.world_seed
	height_noise.noise_type = FastNoiseLite.TYPE_PERLIN
	height_noise.frequency = height_noise_scale

	world_tilemap_layers.append(chunk_tilemap) # 0

	for i in height_layers:
		var height_tilemap := TileMapLayer.new()
		height_tilemap.tile_set = chunk_tilemap.tile_set
		height_tilemap.position.y = (i + 1) * 16
		height_tilemap.y_sort_enabled = true
		add_child(height_tilemap)
		world_tilemap_layers.append(height_tilemap)
	
	# Bunker Hatch
	var bunker_hatch_instance := bunker_hatch.instantiate()
	add_child(bunker_hatch_instance)
	bunker_hatch_instance.position = chunk_tilemap.map_to_local(Vector2i(1, 2))

func _process(_delta: float) -> void:
	var player_current_chunk_coordinate = get_chunk_coordinate(player.position)
	if player_current_chunk_coordinate != player_last_chunk_coordinate:
		update_chunk()
		player_last_chunk_coordinate = player_current_chunk_coordinate

func set_player(player_body : CharacterBody2D):
	player = player_body
	
	# Chunking
	update_chunk()

	# Player Spawning
	if GameData.player_in_bunker == false:
		player.position = chunk_tilemap.map_to_local(Vector2i(0, 3))
		

# Gets the chunk coordinate of whatever you need
func get_chunk_coordinate(world_position : Vector2):
	var chunk_coordinate = Vector2i(chunk_tilemap.local_to_map(world_position) / Chunk.chunk_size)
	return chunk_coordinate

func update_chunk():
	var player_position = get_chunk_coordinate(player.position)
	for x in range(-render_distance, render_distance + 1):
		for y in range(-render_distance, render_distance + 1):
			var chunk_coordinate := Vector2i(player_position.x + x, player_position.y + y)

			if not loaded_chunks.has(chunk_coordinate):
				var chunk_instance = chunk.instantiate()
				chunk_instance.chunk_coordinate = chunk_coordinate
				add_child(chunk_instance)
				chunk_instance.generate_chunks(world_tilemap_layers, flat_noise, biome_noise, height_noise, total_height_levels)
				loaded_chunks[chunk_coordinate] = chunk_instance

	var unload_chunks := []
	for coordinate in loaded_chunks:
		if abs(coordinate.x - player_position.x) > render_distance or abs(coordinate.y - player_position.y) > render_distance:
			unload_chunks.append(coordinate)

	for coordinate in unload_chunks:
		var chunk_instant = loaded_chunks[coordinate]
		for x in chunk_instant.chunk_size:
			for y in chunk_instant.chunk_size:
				var world_position = (chunk_instant.chunk_coordinate * chunk_instant.chunk_size)
				var world_offset := Vector2i(world_position.x + x, world_position.y + y)
				for tilemaps in world_tilemap_layers:
					tilemaps.erase_cell(world_offset)
				
		chunk_instant.queue_free()
		loaded_chunks.erase(coordinate)
