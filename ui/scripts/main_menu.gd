extends Control

@onready var fps_counter := $FPS

# Main Menu Imports
@onready var left_panel := $MarginContainer/HBoxContainer/LeftSidePanel
@onready var new_game_panel := $MarginContainer/HBoxContainer/LeftSidePanel/NewGamePanel
@onready var options_panel := $MarginContainer/HBoxContainer/LeftSidePanel/OptionsPanel
@onready var new_game_button := $MarginContainer/HBoxContainer/GameOptions/NewGameButton
@onready var options_button := $MarginContainer/HBoxContainer/GameOptions/OptionsButton
@onready var exit_button := $MarginContainer/HBoxContainer/GameOptions/ExitButton

# Main Menu State
enum left_panel_state { CLOSED, NEW_GAME, OPTIONS }
var current_state := left_panel_state.CLOSED

func _ready():
	new_game_button.pressed.connect(_on_new_game_button_pressed)
	options_button.pressed.connect(_on_options_button_pressed)
	exit_button.pressed.connect(_on_exit_button_pressed)

func _process(_delta: float) -> void:
	fps_counter.text = str(Engine.get_frames_per_second())

func _on_new_game_button_pressed() -> void:
	match current_state:
		left_panel_state.CLOSED:
			var left_panel_tween := left_panel.create_tween()
			var new_game_panel_tween := new_game_panel.create_tween()

			new_game_panel.visible = true

			left_panel_tween.tween_property(left_panel, "modulate:a", 1, 0.5)
			new_game_panel_tween.tween_property(new_game_panel, "modulate:a", 1, 0.5)

			new_game_panel.mouse_filter = Control.MOUSE_FILTER_STOP
			current_state = left_panel_state.NEW_GAME
		left_panel_state.NEW_GAME:
			var left_panel_tween := left_panel.create_tween()
			var new_game_panel_tween := new_game_panel.create_tween()

			left_panel_tween.tween_property(left_panel, "modulate:a", 0, 0.5)
			new_game_panel_tween.tween_property(new_game_panel, "modulate:a", 0, 0.5)

			new_game_panel_tween.finished.connect(func(): new_game_panel.visible = false)

			new_game_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
			current_state = left_panel_state.CLOSED
		left_panel_state.OPTIONS:
			var options_panel_tween := options_panel.create_tween()
			var new_game_panel_tween := new_game_panel.create_tween()
			
			options_panel_tween.tween_property(options_panel, "modulate:a", 0, 0.5)
			new_game_panel_tween.tween_property(new_game_panel, "modulate:a", 1, 0.5)

			options_panel_tween.finished.connect(func(): options_panel.visible = false)
			new_game_panel.visible = true

			options_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
			new_game_panel.mouse_filter = Control.MOUSE_FILTER_STOP
			current_state = left_panel_state.NEW_GAME

func _on_options_button_pressed() -> void:
	match current_state:
		left_panel_state.CLOSED:
			var left_panel_tween := left_panel.create_tween()
			var options_panel_tween := options_panel.create_tween()

			options_panel.visible = true

			left_panel_tween.tween_property(left_panel, "modulate:a", 1, 0.5)
			options_panel_tween.tween_property(options_panel, "modulate:a", 1, 0.5)

			options_panel.mouse_filter = Control.MOUSE_FILTER_STOP
			current_state = left_panel_state.OPTIONS
		left_panel_state.OPTIONS:
			var left_panel_tween := left_panel.create_tween()
			var options_panel_tween := options_panel.create_tween()

			left_panel_tween.tween_property(left_panel, "modulate:a", 0, 0.5)
			options_panel_tween.tween_property(options_panel, "modulate:a", 0, 0.5)

			options_panel_tween.finished.connect(func(): options_panel.visible = false)

			options_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
			current_state = left_panel_state.CLOSED
		left_panel_state.NEW_GAME:
			var options_panel_tween := options_panel.create_tween()
			var new_game_panel_tween := new_game_panel.create_tween()

			new_game_panel_tween.tween_property(new_game_panel, "modulate:a", 0, 0.5)
			options_panel_tween.tween_property(options_panel, "modulate:a", 1, 0.5)

			new_game_panel_tween.finished.connect(func(): new_game_panel.visible = false)
			options_panel.visible = true

			new_game_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
			options_panel.mouse_filter = Control.MOUSE_FILTER_STOP
			current_state = left_panel_state.OPTIONS

func _on_exit_button_pressed() -> void:
	get_tree().quit()
