extends Control

@onready var title := $MarginContainer/NewGameSection/SaveTitleGroup/NewGameTitle
@onready var world_seed := $MarginContainer/NewGameSection/SeedGroup/NewGameSeed
@onready var difficulty := $MarginContainer/NewGameSection/DifficultyGroup/NewGameDifficultySelection
@onready var create_world_button := $MarginContainer/NewGameSection/CreateWorldButton

func _ready() -> void:
	create_world_button.pressed.connect(_on_create_world_button_pressed)
	

func _on_create_world_button_pressed() -> void:
	GameData.title = title.text
	if world_seed.text.is_empty():
		world_seed.text = str(randi())
	GameData.world_seed = world_seed.text.hash()
	GameData.difficulty = difficulty.get_item_text(difficulty.selected)
	get_tree().change_scene_to_file("res://Main.tscn")
