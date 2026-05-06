extends Node

const AccessibilitySettings = preload("res://scripts/accessibility/accessibility_settings.gd")
const PlayerProfile = preload("res://scripts/core/player_profile.gd")
const SaveService = preload("res://scripts/save/save_service.gd")
const InventoryService = preload("res://scripts/progression/inventory_service.gd")
const MemoryCardService = preload("res://scripts/progression/memory_card_service.gd")
const ClassCatalog = preload("res://scripts/progression/class_catalog.gd")

var profile: PlayerProfile
var accessibility: AccessibilitySettings = AccessibilitySettings.new()
var map_id: String = "title"
var player_position: Vector2 = Vector2.ZERO
var party: Array[Dictionary] = []
var inventory: Dictionary = {}
var memory_cards: Dictionary = {"owned": [], "equipped": []}
var flags: Dictionary = {}

func start_new_game(new_profile: PlayerProfile) -> void:
	profile = new_profile
	accessibility = new_profile.accessibility
	map_id = "overworld"
	player_position = Vector2(64, 64)
	party = _default_party(new_profile.class_id, new_profile.starting_relic, [new_profile.starting_memory_card])
	inventory = {"potion": 3}
	InventoryService.new().add_items(inventory, {new_profile.starting_relic: 1})
	memory_cards = MemoryCardService.new().default_state()
	var card_service := MemoryCardService.new()
	card_service.acquire_card(memory_cards, new_profile.starting_memory_card)
	card_service.equip_card(memory_cards, new_profile.starting_memory_card)
	flags = {}

func to_save_state() -> Dictionary:
	return {
		"profile": profile.to_dict() if profile else {},
		"accessibility": accessibility.to_dict(),
		"map_id": map_id,
		"position": player_position,
		"party": party.duplicate(true),
		"inventory": inventory.duplicate(true),
		"memory_cards": memory_cards.duplicate(true),
		"flags": flags.duplicate(true),
	}

func apply_save_payload(payload: Dictionary) -> void:
	if payload.get("profile", {}).is_empty():
		profile = null
	else:
		profile = PlayerProfile.from_dict(payload.profile)
	accessibility = AccessibilitySettings.from_dict(payload.get("accessibility", {}))
	map_id = payload.get("map_id", "overworld")
	player_position = payload.get("position", Vector2.ZERO)
	party = payload.get("party", []).duplicate(true)
	inventory = payload.get("inventory", {}).duplicate(true)
	memory_cards = payload.get("memory_cards", {"owned": [], "equipped": []}).duplicate(true)
	flags = payload.get("flags", {}).duplicate(true)

func save_manual_slot() -> Error:
	return SaveService.new().save_slot("user://manual_slot.save", to_save_state())

func load_manual_slot() -> bool:
	var payload := SaveService.new().load_slot("user://manual_slot.save")
	if payload.is_empty():
		return false
	apply_save_payload(payload)
	return true

func add_inventory_items(items: Dictionary) -> void:
	InventoryService.new().add_items(inventory, items)

func consume_inventory_item(item_id: String, count: int = 1) -> bool:
	return InventoryService.new().consume_item(inventory, item_id, count)

func acquire_memory_card(card_id: String) -> bool:
	return MemoryCardService.new().acquire_card(memory_cards, card_id)

func equip_memory_card(card_id: String) -> bool:
	return MemoryCardService.new().equip_card(memory_cards, card_id)

func memory_card_effects() -> Dictionary:
	return MemoryCardService.new().equipped_effects(memory_cards)

func _default_party(lead_class_id: String, lead_relic_id: String = "", lead_memory_cards: Array = []) -> Array[Dictionary]:
	var class_catalog := ClassCatalog.new()
	return [
		{"id": "lead", "name": profile.name if profile else "Hero", "class_id": lead_class_id, "level": 1, "xp": 0, "stats": class_catalog.starting_stats(lead_class_id), "equipped_relic": lead_relic_id, "equipped_memory_cards": lead_memory_cards.duplicate(true)},
		{"id": "guardian", "name": "Rowan", "class_id": "vanguard", "level": 1, "xp": 0, "stats": class_catalog.starting_stats("vanguard")},
		{"id": "arcanist", "name": "Selene", "class_id": "mystic", "level": 1, "xp": 0, "stats": class_catalog.starting_stats("mystic")},
		{"id": "scout", "name": "Kade", "class_id": "spellblade", "level": 1, "xp": 0, "stats": class_catalog.starting_stats("spellblade")},
	]
