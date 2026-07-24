extends Node

# Bunker hatch position map_to_local(Vector2i(1, 2))

# (floor(sqrt(R1)) - 1) ** 2

const R1 := 45 # Inner circle radius || tiles || 45
const R2 := 71 # Outer circle radius || tiles || 71
const TARGET_STRUCTURE_AMOUNT := 18
const MINIMUM_DISTANCE_BETWEEN_STRUCTURES := 10
const MAXIMUM_ATTEMPTS := 25 # Base on how many structures are generated from the average of 5 generations, then decide the new maximum attempts

var placed_structures := []

func generate_structures(tilemap : TileMapLayer, bunker_hatch_position : Vector2i):
	var attempts := 0

	while placed_structures.size() < TARGET_STRUCTURE_AMOUNT and attempts < MAXIMUM_ATTEMPTS:

		attempts += 1

		var r = sqrt(R1**2 + (R2**2 - R1**2) * randf())

		var t = (2 * PI) * randf()

		var x = r * cos(t)
		var y = r * sin(t)

		var candidate_tile_offset : Vector2i = Vector2i(roundi(x), roundi(y))

		var candidate_tile : Vector2i = candidate_tile_offset + bunker_hatch_position

		var candidate_tile_data = GameTileData.get_selected_tile_data(tilemap, candidate_tile)
		
		if candidate_tile_data == null:
			print("Tile does not exist.")
			continue

		var can_candidate_spawn = candidate_tile_data.get_custom_data("spawnable")
		
		if can_candidate_spawn != true:
			print("Structure cannot be generated.")
			continue
		
		var is_structure_far_enough = true

		for existing_structures in placed_structures:
			var distance_between = existing_structures.distance_to(candidate_tile)
			if distance_between <= MINIMUM_DISTANCE_BETWEEN_STRUCTURES:
				is_structure_far_enough = false
		if is_structure_far_enough == false:
			print("Structure to close to existing structure.")
			continue

		placed_structures.append(candidate_tile)
		# print(placed_structures) || DEBUG
