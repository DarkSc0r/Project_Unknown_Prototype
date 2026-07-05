extends CanvasLayer

@onready var inventory := preload("res://resources/player_inventory.tres")
@onready var inventory_slots := preload("res://ui/Inventory_Slot.tscn")
@onready var slots_grid := $InventoryBackground/InventoryMargin/InventoryGrid
var slots : Array

var is_open = false

func _ready() -> void:
	print(slots)
	create_slots()
	slots = slots_grid.get_children()
	await get_tree().process_frame
	update_slots()
	close()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("inventory"):
		if is_open == true:
			close()
		else:
			open()

func create_slots():
	for i in range(GameData.inventory_slot_number):
		var slot_instance = inventory_slots.instantiate()
		slots_grid.add_child(slot_instance)

func update_slots():
	for i in range(min(inventory.items.size(), slots.size())):
		slots[i].update(inventory.items[i])

func open():
	visible = true
	is_open = true

func close():
	visible = false
	is_open = false
