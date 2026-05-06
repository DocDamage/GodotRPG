class_name InventoryService
extends RefCounted

func add_items(inventory: Dictionary, items: Dictionary) -> void:
	for item_id in items:
		var count := int(items[item_id])
		if count <= 0:
			continue
		inventory[item_id] = int(inventory.get(item_id, 0)) + count

func consume_item(inventory: Dictionary, item_id: String, count: int = 1) -> bool:
	if count <= 0:
		return false
	var current := int(inventory.get(item_id, 0))
	if current < count:
		return false
	var remaining := current - count
	if remaining > 0:
		inventory[item_id] = remaining
	else:
		inventory.erase(item_id)
	return true

func has_item(inventory: Dictionary, item_id: String, count: int = 1) -> bool:
	return int(inventory.get(item_id, 0)) >= count
