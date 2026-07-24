extends Node2D

class_name Chunk

# Chunk Generation Variables
var chunk_coordinate : Vector2i
const chunk_size := 32 # Tiles

# Tile Dictionary	
var dirt_tile := {"threshold": 1, "atlas": Vector2i(0, 0)}
var stone_tile := {"threshold": 0.35, "atlas": Vector2i(1, 0)}

# Array of tiles
var tiles := [stone_tile, dirt_tile]

# DEBUG
var temp_structure := preload("res://structures/Temp_Structure.tscn")

func generate_chunks(world_tilemap : Array, world : Noise, biome : Noise, height : Noise, height_layers : float):
	for x in chunk_size:
		for y in chunk_size:
			var world_position := (chunk_coordinate * chunk_size)
			var world_offset := Vector2i(world_position.x + x, world_position.y + y)

			var flat_noise_value := world.get_noise_2d(world_offset.x, world_offset.y)
			flat_noise_value = (flat_noise_value + 1) / 2

			var biome_noise_value := biome.get_noise_2d(world_offset.x, world_offset.y)
			biome_noise_value = (biome_noise_value + 1) / 2

			var height_noise_value := height.get_noise_2d(world_offset.x, world_offset.y)
			height_noise_value = (height_noise_value + 1) / 2

			var biome_ceiling = lerp(0.0, height_layers, biome_noise_value)
			var height_level = int(lerp(0.0, biome_ceiling, height_noise_value))

			var tilemap = world_tilemap[height_level]

			var atlas_coord : Vector2i			

			for tile in tiles:
				if flat_noise_value <= tile["threshold"]:
					atlas_coord	= tile["atlas"]
					break

			# DEBUG
			if StructureManager.placed_structures.has(world_offset) == true:
				print("Match Found: ", world_offset)
				var structure_spawn_position = tilemap.map_to_local(world_offset)
				var temp_structure_instance := temp_structure.instantiate()
				add_child(temp_structure_instance)
				temp_structure_instance.position = structure_spawn_position


			tilemap.set_cell(world_offset, 1, atlas_coord)