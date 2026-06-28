extends Node2D

# Map Variables
var map_width := 256
var map_length := 128
var map_height := 1
var noise_scale := 0.1
var world_seed := 1234567890

# Tile Dictionary	
var white_tile := {"threshold": 0.4, "atlas": Vector2i(0,0), "walkable": true}
var green_tile := {"threshold": 0.6, "atlas": Vector2i(0,3), "walkable": true}
var orange_tile := {"threshold": 1, "atlas": Vector2i(0,6), "walkable": true}

# Array of tiles
var tiles := [white_tile, green_tile, orange_tile]

@onready var tilemap: TileMapLayer = $TileMapLayer

func generate_map():
	var noise := FastNoiseLite.new()
	noise.seed = world_seed
	noise.noise_type = FastNoiseLite.TYPE_PERLIN
	noise.frequency = noise_scale

	tilemap.clear()

	for x in range(map_width):
		for z in range(map_length):
			for y in range(map_height):
				var noise_value := noise.get_noise_3d(x, y, z)
				noise_value = (noise_value + 1) / 2      # 0-1

				var tile_pos := Vector2i(x, z)
				var atlas_coord : Vector2i			

				for tile in tiles:
					if noise_value <= tile["threshold"]:
						atlas_coord	= tile["atlas"]
						break	

				tilemap.set_cell(tile_pos, 1, atlas_coord)

func _ready():
	generate_map()
