extends Node2D

# Chunk Generation Variables
var chunk_coordinate : Vector2i
var chunk_size := 32

# Tile Dictionary	
var white_tile := {"threshold": 0.4, "atlas": Vector2i(0,0), "walkable": true}
var green_tile := {"threshold": 0.6, "atlas": Vector2i(0,3), "walkable": true}
var orange_tile := {"threshold": 1, "atlas": Vector2i(0,6), "walkable": true}

# Array of tiles
var tiles := [white_tile, green_tile, orange_tile]

func generate_chunks(tilemap : TileMapLayer, noise : Noise):
	for x in chunk_size:
		for y in chunk_size:
			var world_position := (chunk_coordinate * chunk_size)
			var world_offset := Vector2i(world_position.x + x, world_position.y + y)
			var noise_value := noise.get_noise_2d(world_offset.x, world_offset.y)
			noise_value = (noise_value + 1) / 2
			var atlas_coord : Vector2i			

			for tile in tiles:
				if noise_value <= tile["threshold"]:
					atlas_coord	= tile["atlas"]
					break
			tilemap.set_cell(world_offset, 1, atlas_coord)
