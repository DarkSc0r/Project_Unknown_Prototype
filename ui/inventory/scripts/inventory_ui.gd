extends CanvasLayer

@onready var player_inventory : Inventory = preload("res://resources/inventory/player_inventory.tres")
@onready var inventory_slots : Array = $InventoryBackground/SlotsMargin/SlotsGrid.get_children()

var is_open := false

func _ready() -> void:
	player_inventory.update.connect(update_slots)
	update_slots()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("inventory"):
		if is_open == false:
			visible = true
			is_open = true
		elif is_open == true:
			visible = false
			is_open = false

func update_slots():
	for i in range(min(player_inventory.slots.size(), inventory_slots.size())):
		inventory_slots[i].update(player_inventory.slots[i])
