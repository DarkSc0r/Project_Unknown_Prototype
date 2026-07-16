extends Resource

class_name Inventory

signal update

@export var slots : Array[InventorySlot]

func insert(item : InventoryItem):
	var item_slots = slots.filter(func(slot): return slot.item == item)
	if !item_slots.is_empty():
		item_slots[0].item_quantity += 1
	else:
		var empty_slots = slots.filter(func(slot): return slot.item == null)
		if !empty_slots.is_empty():
			empty_slots[0].item = item
			empty_slots[0].item_quantity = 1
	update.emit()

func move_item(from_index: int, to_index: int) -> void:
	if from_index < 0 or from_index >= slots.size():
		return

	if to_index < 0 or to_index >= slots.size():
		return

	if from_index == to_index:
		return

	var from_slot = slots[from_index]
	var to_slot = slots[to_index]

	if to_slot.item == null:
		to_slot.item = from_slot.item
		to_slot.item_quantity = from_slot.item_quantity

		from_slot.item = null
		from_slot.item_quantity = 0
	elif to_slot.item == from_slot.item:
		# Total amount between the 2 items
		var to_slot_total = to_slot.item_quantity + from_slot.item_quantity

		# If the total amount is > the max_stack_size
		if (to_slot_total) > to_slot.item.max_stack_size:
			# Sets the current slot to have the max value
			to_slot.item_quantity = to_slot.item.max_stack_size

			# Sets the amount in the players hand to the excess
			from_slot.item_quantity = to_slot_total - to_slot.item.max_stack_size
		else:
			# Sets our slot items quantity to the total amount
			to_slot.item_quantity = to_slot_total

			# Removes the item from our other slot
			from_slot.item = null
			from_slot.item_quantity = 0
	elif to_slot.item != from_slot.item and to_slot.item != null:
		var temp_item = to_slot.item
		var temp_quantity = to_slot.item_quantity

		to_slot.item = from_slot.item
		from_slot.item = temp_item

		to_slot.item_quantity = from_slot.item_quantity
		from_slot.item_quantity = temp_quantity
	update.emit()