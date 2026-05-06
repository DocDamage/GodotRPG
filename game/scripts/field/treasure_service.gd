class_name TreasureService
extends RefCounted

const InventoryService = preload("res://scripts/progression/inventory_service.gd")

func pickup(state: Dictionary, treasure: Dictionary) -> Dictionary:
	var treasure_id := String(treasure.get("id", ""))
	if treasure_id.is_empty():
		return {"collected": false, "reason": "missing_id"}
	var flag_id := "treasure_%s" % treasure_id
	var flags: Dictionary = state.get("flags", {})
	if flags.get(flag_id, false):
		return {"collected": false, "reason": "already_collected"}
	var inventory: Dictionary = state.get("inventory", {})
	InventoryService.new().add_items(inventory, treasure.get("loot", {}))
	flags[flag_id] = true
	state.inventory = inventory
	state.flags = flags
	return {"collected": true, "flag": flag_id, "loot": treasure.get("loot", {}).duplicate(true)}
