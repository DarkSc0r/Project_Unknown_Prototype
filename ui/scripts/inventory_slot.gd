extends Panel

@onready var item_icon := $CenterContainer/Panel/InventoryItem

func update(item: InventoryItem):
    if !item:
        item_icon.visible = false
    else:
        item_icon.visible = true
        item_icon.texture = item.item_icon