extends Node

func get_selected_tile_data(tilemap : TileMapLayer, tile_position : Vector2i):
	return tilemap.get_cell_tile_data(tile_position)
