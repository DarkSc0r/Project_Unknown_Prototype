extends Control

@onready var item_icon := $Item/ItemIcon
@onready var item_quantity := $Item/ItemQuantity

func update(slot: InventorySlot):
	if !slot.item:
		item_icon.visible = false
		item_quantity.visible = false
	else:
		item_icon.visible = true
		item_icon.texture = slot.item.texture
		item_quantity.visible = true
		item_quantity.text = str(slot.item_quantity)

		
