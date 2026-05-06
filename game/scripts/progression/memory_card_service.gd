class_name MemoryCardService
extends RefCounted

const CARD_DATA_PATH := "res://data/cards/memory_cards.json"
const DEFAULT_MAX_EQUIPPED := 3

var cards: Dictionary = {}

func _init() -> void:
	cards = _load_cards()

func default_state() -> Dictionary:
	return {"owned": [], "equipped": []}

func acquire_card(state: Dictionary, card_id: String) -> bool:
	if not cards.has(card_id):
		return false
	var owned: Array = state.get("owned", [])
	if owned.has(card_id):
		return false
	owned.append(card_id)
	state.owned = owned
	return true

func equip_card(state: Dictionary, card_id: String, max_equipped: int = DEFAULT_MAX_EQUIPPED) -> bool:
	var owned: Array = state.get("owned", [])
	if not owned.has(card_id):
		return false
	var equipped: Array = state.get("equipped", [])
	if equipped.has(card_id):
		return true
	if equipped.size() >= max_equipped:
		return false
	equipped.append(card_id)
	state.equipped = equipped
	return true

func unequip_card(state: Dictionary, card_id: String) -> bool:
	var equipped: Array = state.get("equipped", [])
	if not equipped.has(card_id):
		return false
	equipped.erase(card_id)
	state.equipped = equipped
	return true

func equipped_effects(state: Dictionary) -> Dictionary:
	var combined: Dictionary = {}
	for card_id in state.get("equipped", []):
		var card: Dictionary = cards.get(card_id, {})
		var effect: Dictionary = card.get("effect", {})
		for key in effect.keys():
			combined[key] = effect[key]
	return combined

func _load_cards() -> Dictionary:
	if not FileAccess.file_exists(CARD_DATA_PATH):
		return {}
	var file := FileAccess.open(CARD_DATA_PATH, FileAccess.READ)
	if file == null:
		return {}
	var parsed = JSON.parse_string(file.get_as_text())
	if typeof(parsed) != TYPE_DICTIONARY:
		return {}
	return parsed
