extends Node2D

var map_width := 256
var map_length := 128
var map_height := 4
var noise_scale := 0.1

# personal challenge || create this with a dictionary
var green_tile_threshold := 0.475
var white_tile_threshold := 0.45

@onready var tilemap: TileMapLayer = $TileMapLayer

func generate_map():
	var noise := FastNoiseLite.new()
	noise.seed = randi()
	noise.noise_type = FastNoiseLite.TYPE_PERLIN
	noise.frequency = noise_scale

	tilemap.clear()

	for x in range(map_width):
		for z in range(map_length):
			for y in range(map_height):
				var noise_value := noise.get_noise_3d(x, y, z)
				noise_value = (noise_value + 1) / 2

				var tile_pos := Vector2i(x, z)			
				var atlas_coords := Vector2i(0, 0)

				if noise_value < white_tile_threshold:
					atlas_coords = Vector2i(0, 0)
				elif noise_value < green_tile_threshold:
					atlas_coords = Vector2i(0,3)

				tilemap.set_cell(tile_pos, 1, atlas_coords)

func _ready():
	generate_map()
