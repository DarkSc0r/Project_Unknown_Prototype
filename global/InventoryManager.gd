extends Node

var player_inventory := preload("res://resources/player_inventory.tres")

signal update_item_slot

func add_item(item : InventoryItem):
	for i in range(player_inventory.items.size()):
		if player_inventory.items[i] == item and player_inventory.item_quantities[i] < item.stack_size:
			player_inventory.item_quantities[i] += 1
			update_item_slot.emit()
			return
	for i in range(player_inventory.items.size()):
		if player_inventory.items[i] == null:
			player_inventory.items[i] = item
			player_inventory.item_quantities[i] += 1
			update_item_slot.emit()
			return
