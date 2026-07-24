extends Control

@export var custom_cursor : Texture2D = preload("res://icons/cursor.png")

@onready var item_icon := $Item/ItemIcon
@onready var item_quantity := $Item/ItemQuantity

var slot_index : int = -1

var player_inventory : Inventory

func _process(_delta: float) -> void:
	if get_viewport().gui_is_dragging():
		Input.set_custom_mouse_cursor(custom_cursor)

func update(slot: InventorySlot):
	if !slot.item:
		item_icon.visible = false
		item_quantity.visible = false
	else:
		item_icon.visible = true
		item_icon.texture = slot.item.texture
		item_quantity.visible = true
		item_quantity.text = str(slot.item_quantity)

func _get_drag_data(_at_position: Vector2):
	var slot = player_inventory.slots[slot_index]

	if slot.item == null:
		return null

	var item_drag_data = {"base_index": slot_index}

	var dragged_item = TextureRect.new()
	
	dragged_item.texture = slot.item.texture
	dragged_item.size = Vector2(44, 44)
	dragged_item.custom_minimum_size = Vector2(44, 44)

	var preview_container = Control.new()
	preview_container.add_child(dragged_item)

	dragged_item.position = Vector2(-11, -11) 

	set_drag_preview(preview_container)

	return item_drag_data

func _can_drop_data(_at_position: Vector2, _data) -> bool:
	# Called continuously while something is being dragged over this slot.
	# Return true/false to tell Godot whether a drop is allowed here.
	#
	# TODO: For now, just return true unconditionally — any item can go
	# in any slot. This is your future hook for restricted slots later
	# (e.g. "only accept if data has an equip_type matching this slot").
	return true

func _drop_data(_at_position: Vector2, data) -> void:
	var data_index = data["base_index"]
	var data_moved_index = slot_index
	player_inventory.move_item(data_index, data_moved_index)
