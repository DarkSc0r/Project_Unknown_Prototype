extends Node2D

@onready var bunker_tilemap := $BunkerTilemapLayer
@onready var ladder_area_trigger := $BunkerTilemapLayer/Area2D

var player_preload := preload("res://character/Player.tscn")
var letter_preload := preload("res://items/Letter.tscn")

var player_in_area := false

func _ready() -> void:
	var player_instance := player_preload.instantiate()
	add_child(player_instance)
	match GameData.player_first_join:
		false:
			player_instance.position = bunker_tilemap.map_to_local(Vector2i(1, -7))
		true:
			player_instance.position = bunker_tilemap.map_to_local(Vector2i(-1, -1))
	
	var letter_instance := letter_preload.instantiate()
	add_child(letter_instance)
	letter_instance.position = bunker_tilemap.map_to_local(Vector2i(-2, -9))

	ladder_area_trigger.body_entered.connect(_on_area_2d_body_entered)
	ladder_area_trigger.body_exited.connect(_on_area_2d_body_exited)

func _process(_delta: float) -> void:
	if player_in_area == true and Input.is_action_just_pressed("interact"):
		get_tree().change_scene_to_file("res://main/Main.tscn")
		GameData.player_in_bunker = false
		GameData.player_first_join = false
	
func _on_area_2d_body_entered(body):
	if body.is_in_group("Player"):
		player_in_area = true

func _on_area_2d_body_exited(body):
	if body.is_in_group("Player"):
		player_in_area = false
