extends CanvasLayer

@onready var main_menu_button := $DeathScreenContainer/MainMenuButton

func _ready() -> void:
	main_menu_button.pressed.connect(_on_main_menu_pressed)

func _on_main_menu_pressed():
	get_tree().paused = false
	visible = false
	get_tree().change_scene_to_file("res://ui/Main_Menu.tscn")
