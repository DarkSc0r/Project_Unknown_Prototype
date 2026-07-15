extends Control

@onready var title := $MarginContainer/NewGameSection/SaveTitleGroup/NewGameTitle
@onready var world_seed := $MarginContainer/NewGameSection/SeedGroup/NewGameSeed
@onready var difficulty := $MarginContainer/NewGameSection/DifficultyGroup/NewGameDifficultySelection
@onready var create_world_button := $MarginContainer/NewGameSection/CreateWorldButton

func _ready() -> void:
	create_world_button.pressed.connect(_on_create_world_button_pressed)
	
func _on_create_world_button_pressed() -> void:
	initialize_game_data()
	get_tree().change_scene_to_file("res://world/Bunker.tscn")

func initialize_game_data():
	GameData.title = title.text
	if world_seed.text.is_empty():
		world_seed.text = str(randi())
	GameData.world_seed = world_seed.text.hash()
	GameData.difficulty = difficulty.get_item_text(difficulty.selected)
	GameData.player_first_join = true
	GameData.player_in_bunker = true
	GameData.player_health = 100.0
	GameData.infection_value = 0.0
