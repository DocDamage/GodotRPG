extends Node

const AccessibilitySettings = preload("res://scripts/accessibility/accessibility_settings.gd")
const PlayerProfile = preload("res://scripts/core/player_profile.gd")
const SaveService = preload("res://scripts/save/save_service.gd")
const InventoryService = preload("res://scripts/progression/inventory_service.gd")
const MemoryCardService = preload("res://scripts/progression/memory_card_service.gd")
const ClassCatalog = preload("res://scripts/progression/class_catalog.gd")
const ProgressionService = preload("res://scripts/progression/progression_service.gd")
const ContentCatalog = preload("res://scripts/core/content_catalog.gd")

var profile: PlayerProfile
var accessibility: AccessibilitySettings = AccessibilitySettings.new()
var map_id: String = "title"
var player_position: Vector2 = Vector2.ZERO
var party: Array[Dictionary] = []
var inventory: Dictionary = {}
var memory_cards: Dictionary = {"owned": [], "equipped": []}
var flags: Dictionary = {}

const SETTINGS_SLOT_PATH := "user://settings.save"

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
	party = _typed_party_from_payload(payload.get("party", []))
	inventory = payload.get("inventory", {}).duplicate(true)
	memory_cards = payload.get("memory_cards", {"owned": [], "equipped": []}).duplicate(true)
	flags = payload.get("flags", {}).duplicate(true)
	_rebuild_discovered_story_props_from_flags()

func _typed_party_from_payload(value) -> Array[Dictionary]:
	var restored_party: Array[Dictionary] = []
	if not value is Array:
		return restored_party
	for member in value:
		if member is Dictionary:
			restored_party.append(member.duplicate(true))
	return restored_party

func _rebuild_discovered_story_props_from_flags() -> void:
	var discovered: Array = flags.get("discovered_story_props", [])
	for flag_id in flags.keys():
		if not String(flag_id).begins_with("discovered_prop_"):
			continue
		if bool(flags.get(flag_id, false)) and not discovered.has(flag_id):
			discovered.append(flag_id)
	if not discovered.is_empty():
		flags["discovered_story_props"] = discovered

func save_manual_slot() -> Error:
	return SaveService.new().save_slot("user://manual_slot.save", to_save_state())

func load_manual_slot() -> bool:
	var payload := SaveService.new().load_slot("user://manual_slot.save")
	if payload.is_empty():
		return false
	apply_save_payload(payload)
	return true

func has_manual_slot() -> bool:
	return not SaveService.new().load_slot("user://manual_slot.save").is_empty()

func save_settings_slot() -> Error:
	var file := FileAccess.open(SETTINGS_SLOT_PATH, FileAccess.WRITE)
	if file == null:
		return FileAccess.get_open_error()
	file.store_var({"accessibility": accessibility.to_dict()})
	apply_runtime_settings()
	return OK

func load_settings_slot() -> bool:
	if not FileAccess.file_exists(SETTINGS_SLOT_PATH):
		return false
	var file := FileAccess.open(SETTINGS_SLOT_PATH, FileAccess.READ)
	if file == null:
		return false
	var payload = file.get_var()
	if not payload is Dictionary:
		return false
	accessibility = AccessibilitySettings.from_dict(payload.get("accessibility", {}))
	apply_runtime_settings()
	return true

func apply_runtime_settings() -> void:
	_apply_bus_volume("Master", accessibility.master_volume)
	_apply_bus_volume("Music", accessibility.music_volume)
	_apply_bus_volume("Ambience", accessibility.ambience_volume)
	_apply_bus_volume("SFX", accessibility.sfx_volume)
	_apply_bus_volume("UI", accessibility.ui_volume)
	_apply_bus_volume("Dialogue", accessibility.dialogue_volume)
	_apply_bus_volume("Combat", accessibility.combat_volume)
	_apply_bus_volume("Environment", accessibility.environment_volume)
	if DisplayServer.get_name() != "headless":
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN if accessibility.window_mode == "fullscreen" else DisplayServer.WINDOW_MODE_WINDOWED)

func _apply_bus_volume(bus_name: String, value: float) -> void:
	var bus_index := AudioServer.get_bus_index(bus_name)
	if bus_index < 0:
		return
	var linear := clampf(value, 0.0, 1.0)
	AudioServer.set_bus_volume_db(bus_index, -80.0 if is_zero_approx(linear) else linear_to_db(linear))

func add_inventory_items(items: Dictionary) -> void:
	InventoryService.new().add_items(inventory, items)

func consume_inventory_item(item_id: String, count: int = 1) -> bool:
	return InventoryService.new().consume_item(inventory, item_id, count)

func acquire_memory_card(card_id: String) -> bool:
	return MemoryCardService.new().acquire_card(memory_cards, card_id)

func equip_memory_card(card_id: String) -> bool:
	return MemoryCardService.new().equip_card(memory_cards, card_id)

func add_party_xp(xp_gained: int) -> void:
	if xp_gained <= 0:
		return
	var progression := ProgressionService.new()
	var updated_party: Array[Dictionary] = []
	for member in party:
		var class_id := String(member.get("class_id", "vanguard"))
		updated_party.append(progression.apply_xp(member, xp_gained, class_id))
	party = updated_party

func apply_party_battle_state(party_state: Array) -> void:
	if party_state.is_empty():
		return
	var state_by_id := {}
	for state in party_state:
		var member_id := String(state.get("id", ""))
		if not member_id.is_empty():
			state_by_id[member_id] = state
	var updated_party: Array[Dictionary] = []
	for member in party:
		var copy := member.duplicate(true)
		var member_id := String(copy.get("id", ""))
		var state: Dictionary = state_by_id.get(member_id, {})
		if not state.is_empty():
			if state.has("hp"):
				var stats: Dictionary = copy.get("stats", {})
				var max_hp := int(stats.get("max_hp", copy.get("max_hp", state.hp)))
				copy.hp = clampi(int(state.hp), 0, max_hp)
			if state.has("mp"):
				var stats: Dictionary = copy.get("stats", {})
				var max_mp := int(stats.get("max_mp", copy.get("max_mp", state.mp)))
				copy.mp = clampi(int(state.mp), 0, max_mp)
			if state.has("statuses"):
				copy.statuses = state.statuses.duplicate(true)
		updated_party.append(copy)
	party = updated_party

func recruit_party_member(member_id: String) -> bool:
	if member_id.is_empty():
		return false
	for member in party:
		if String(member.get("id", "")) == member_id:
			return false
	var member := ContentCatalog.new().party_member(member_id)
	if member.is_empty():
		return false
	party.append(member)
	return true

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
