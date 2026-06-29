extends Node2D

var pause_menu = preload("res://ui/Pause_Menu.tscn")

var pause_menu_exist := false
var pause_menu_instance = null

func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("pause"):
		if pause_menu_exist == false:
			pause_menu_instance = pause_menu.instantiate()
			add_child(pause_menu_instance)
			pause_menu_instance.connect("pause_menu_closed", set_pause_menu)
			get_tree().paused = true
			pause_menu_exist = true
		else:
			get_tree().paused = false
			pause_menu_instance.queue_free()
			pause_menu_exist = false
		
func set_pause_menu():
	pause_menu_exist = false