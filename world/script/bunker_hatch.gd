extends Node2D

@onready var bunker_area_trigger := $Area2D

var player_in_area := false

func _ready() -> void:
	bunker_area_trigger.body_entered.connect(_on_area_2d_body_entered)
	bunker_area_trigger.body_exited.connect(_on_area_2d_body_exited)

func _process(_delta: float) -> void:
	if player_in_area == true and Input.is_action_just_pressed("interact"):
		GameData.player_first_join = false
		get_tree().change_scene_to_file("res://world/Bunker.tscn")

func _on_area_2d_body_entered(body):
	if body.is_in_group("Player"):
		player_in_area = true

func _on_area_2d_body_exited(body):
	if body.is_in_group("Player"):
		player_in_area = false
