extends Panel

@onready var item_icon := $CenterContainer/Panel/InventoryItem
@onready var item_quantity := $CenterContainer/Panel/ItemQuantity

var slot_index : int

func update(item: InventoryItem):
	if !item:
		item_icon.visible = false
		item_quantity.visible = false
	else:
		item_icon.visible = true
		item_quantity.visible = true
		item_icon.texture = item.item_icon
		if GameData.player_inventory.item_quantities[slot_index] == 0:
			item_quantity.text = ""
		else:
			item_quantity.text = str(GameData.player_inventory.item_quantities[slot_index])
