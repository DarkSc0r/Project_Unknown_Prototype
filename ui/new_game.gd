extends Control

@onready var title := $MarginContainer/NewGameSection/SaveTitleGroup/NewGameTitle
@onready var world_seed := $MarginContainer/NewGameSection/SeedGroup/NewGameSeed
@onready var difficulty := $MarginContainer/NewGameSection/DifficultyGroup/NewGameDifficultySelection
@onready var create_world_button := $MarginContainer/NewGameSection/StartGameButton

func _ready() -> void:
	create_world_button.pressed.connect(_on_create_world_button_pressed)

func _on_create_world_button_pressed() -> void:
	pass