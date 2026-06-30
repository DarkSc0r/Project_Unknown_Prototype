extends CanvasLayer

@onready var pause_menu := self

@onready var resume_button := $PauseMenuContainerMargin/PauseMenuContainer/PauseMenuMargin/PauseMenuPanel/Resume
@onready var save_game_button := $PauseMenuContainerMargin/PauseMenuContainer/PauseMenuMargin/PauseMenuPanel/SaveGame
@onready var options_button := $PauseMenuContainerMargin/PauseMenuContainer/PauseMenuMargin/PauseMenuPanel/Options
@onready var main_menu_button := $PauseMenuContainerMargin/PauseMenuContainer/PauseMenuMargin/PauseMenuPanel/MainMenu

@onready var options_container := $OptionsMenuMargin/OptionsContainer
@onready var options_panel := $OptionsMenuMargin/OptionsContainer/OptionsPanel

enum options_panel_state { CLOSED, OPEN }
var current_state := options_panel_state.CLOSED

signal pause_menu_closed

func _ready() -> void:
	visible = true
	resume_button.pressed.connect(_on_resume_pressed)
	save_game_button.pressed.connect(_on_save_game_pressed)
	options_button.pressed.connect(_on_options_pressed)
	main_menu_button.pressed.connect(_on_main_menu_pressed)

func _on_resume_pressed():
	pause_menu_closed.emit()
	get_tree().paused = false
	self.queue_free()

func _on_save_game_pressed():
	pass

func _on_options_pressed():
	match current_state:
		options_panel_state.CLOSED:
			var options_container_tween := options_container.create_tween()
			var options_panel_tween := options_panel.create_tween()

			options_container_tween.tween_property(options_container, "modulate:a", 1, 0.5)
			options_panel_tween.tween_property(options_panel, "modulate:a", 1, 0.5)

			options_panel.mouse_filter = Control.MOUSE_FILTER_STOP
			current_state = options_panel_state.OPEN
		options_panel_state.OPEN:
			var options_container_tween := options_container.create_tween()
			var options_panel_tween := options_panel.create_tween()

			options_container_tween.tween_property(options_container, "modulate:a", 0, 0.5)
			options_panel_tween.tween_property(options_panel, "modulate:a", 0, 0.5)

			options_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
			current_state = options_panel_state.CLOSED

func _on_main_menu_pressed():
	get_tree().paused = false
	visible = false
	get_tree().change_scene_to_file("res://ui/Main_Menu.tscn")
