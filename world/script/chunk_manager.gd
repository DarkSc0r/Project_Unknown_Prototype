extends Node

@onready var player := %Player
@onready var chunk_tilemap := $ChunkTilemap
var chunk := preload("res://world/chunk.tscn")
var noise := FastNoiseLite.new()
var loaded_chunk := {}
var render_distance := 5
var noise_scale := 0.1
var player_last_chunk_coordinate := Vector2i(999, 999)

func _ready():
	noise.seed = GameData.world_seed
	noise.noise_type = FastNoiseLite.TYPE_PERLIN
	noise.frequency = noise_scale
	update_chunk()
	
func _process(_delta: float) -> void:
	var player_current_chunk_coordinate = get_chunk_coordinate(player.position)
	if player_current_chunk_coordinate != player_last_chunk_coordinate:
		update_chunk()
		player_last_chunk_coordinate = player_current_chunk_coordinate

	if Input.is_action_just_pressed("test"):
		print("player.position: " + str(player.position))
		print("get_chunk_coordinate(player.position): " + str(get_chunk_coordinate(player.position)))

# Gets the chunk coordinate of whatever you need
func get_chunk_coordinate(world_position : Vector2):
	var chunk_coordinate = Vector2i(chunk_tilemap.local_to_map(world_position) / 32)
	return chunk_coordinate

func update_chunk():
	var player_position = get_chunk_coordinate(player.position)
	for x in range(-render_distance, render_distance + 1):
		for y in range(-render_distance, render_distance + 1):
			var chunk_coordinate := Vector2i(player_position.x + x, player_position.y + y)

			if not loaded_chunk.has(chunk_coordinate):
				var chunk_instance = chunk.instantiate()
				chunk_instance.chunk_coordinate = chunk_coordinate
				add_child(chunk_instance)
				chunk_instance.generate_chunks(chunk_tilemap, noise)
				loaded_chunk[chunk_coordinate] = chunk_instance

	var unload_chunks := []
	for coordinate in loaded_chunk:
		if abs(coordinate.x - player_position.x) > render_distance or abs(coordinate.y - player_position.y) > render_distance:
			unload_chunks.append(coordinate)
			print("coordinate: " + str(coordinate))
			print("player_position: " + str(player_position))
	for coordinate in unload_chunks:
		var chunk_instant = loaded_chunk[coordinate]
		for x in chunk_instant.chunk_size:
			for y in chunk_instant.chunk_size:
				var world_position = (chunk_instant.chunk_coordinate * chunk_instant.chunk_size)
				var world_offset := Vector2i(world_position.x + x, world_position.y + y)
				chunk_tilemap.erase_cell(world_offset)
		chunk_instant.queue_free()
		loaded_chunk.erase(coordinate)
