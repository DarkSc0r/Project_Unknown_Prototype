extends Node2D

@onready var stone_area_trigger := $Area2D

# DEBUG
@export var stone : InventoryItem

var player_in_area := false
var player = null

func _ready() -> void:
	stone_area_trigger.body_entered.connect(_on_area_2d_body_entered)
	# stone_area_trigger.body_exited.connect(_on_area_2d_body_exited)

func _process(_delta: float) -> void:
	if player_in_area == true:
		add_inv()
		self.queue_free()

func _on_area_2d_body_entered(body):
	if body.is_in_group("Player"):
		player_in_area = true
		player = body

# func _on_area_2d_body_exited(body):
# 	if body.is_in_group("Player"):
# 		player_in_area = false

func add_inv():
	player.collect(stone)