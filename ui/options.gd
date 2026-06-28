extends Control

# Option Menu Options
@onready var fullscreen_checkbox := $MarginContainer/OptionsSection/FullscreenGroup/FullScreenCheckBox
@onready var resolution_options := $MarginContainer/OptionsSection/ResolutionGroup/ResolutionOptions
@onready var vsync_checkbox := $MarginContainer/OptionsSection/VSyncGroup/VSyncCheckBox
@onready var fps_options := $MarginContainer/OptionsSection/FPSGroup/FPSOptions

# Resolution Variables
var user_resolution := DisplayServer.screen_get_size()
var resolutions := [Vector2i(3840, 2160), Vector2i(2560, 1440), Vector2i(1920,1080), Vector2i(1280,720)]
var current_resolutions : Array

func _ready():
	fullscreen_checkbox.toggled.connect(_on_full_screen_check_box_toggled)
	resolution_options.item_selected.connect(_on_resolution_options_item_selected)
	vsync_checkbox.toggled.connect(_on_vsync_check_box_toggled)
	fps_options.item_selected.connect(_on_fps_options_item_selected)
	display_resolutions()

func display_resolutions():
	for res in resolutions:
		if res.x <= user_resolution.x and res.y <= user_resolution.y:
			current_resolutions.append(Vector2i(res.x, res.y))
			resolution_options.add_item(str(res.x) + "x" + str(res.y))

func _on_full_screen_check_box_toggled(is_checked) -> void:
	if is_checked == true:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		DisplayServer.window_set_size(current_resolutions[0])

func _on_resolution_options_item_selected(index) -> void:
	DisplayServer.window_set_size(current_resolutions[index])

func _on_vsync_check_box_toggled(is_checked) -> void:
	if is_checked == true:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)

func _on_fps_options_item_selected(index) -> void:
	match index:
		0:
			Engine.max_fps = 30
		1: 
			Engine.max_fps = 60
		2:
			Engine.max_fps = 120
		3: 
			Engine.max_fps = 144
		4:
			Engine.max_fps = 240
		5:
			Engine.max_fps = 0
