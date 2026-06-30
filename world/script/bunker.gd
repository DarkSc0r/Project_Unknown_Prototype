extends Node2D

@onready var player_preload := preload("res://character/Player.tscn")

func _ready() -> void:
	var player_instance := player_preload.instantiate()
	add_child(player_instance)
