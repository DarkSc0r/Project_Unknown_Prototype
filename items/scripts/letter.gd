extends Node2D

@onready var letter_area_trigger := $Area2D

var letter_ui := preload("res://ui/Letter_UI.tscn")
var letter_instance_exists := false

var player_in_area := false
func _ready() -> void:
	letter_area_trigger.body_entered.connect(_on_area_2d_body_entered)
	letter_area_trigger.body_exited.connect(_on_area_2d_body_exited)

func _process(_delta: float) -> void:
	if player_in_area == true and Input.is_action_just_pressed("interact"):
		if letter_instance_exists == false:
			var letter_ui_instance = letter_ui.instantiate()
			letter_ui_instance.connect("letter_instance_close", set_letter_instance)
			add_child(letter_ui_instance)
			letter_instance_exists = true
			get_tree().paused = true

func _on_area_2d_body_entered(body):
	if body.is_in_group("Player"):
		player_in_area = true

func _on_area_2d_body_exited(body):
	if body.is_in_group("Player"):
		player_in_area = false

func set_letter_instance():
	letter_instance_exists = false