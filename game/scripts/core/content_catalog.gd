class_name ContentCatalog
extends RefCounted

const ITEMS_PATH := "res://data/items/items.json"
const MEMORY_CARDS_PATH := "res://data/cards/memory_cards.json"
const CHAPTER_ONE_DIALOGUE_PATH := "res://data/dialogue/chapter_01_bell_saint.json"

var _items: Dictionary = {}
var _memory_cards: Dictionary = {}
var _chapter_one_dialogue: Dictionary = {}

func item(item_id: String) -> Dictionary:
	if _items.is_empty():
		_items = _load_json(ITEMS_PATH)
	return _items.get(item_id, {})

func memory_card(card_id: String) -> Dictionary:
	if _memory_cards.is_empty():
		_memory_cards = _load_json(MEMORY_CARDS_PATH)
	return _memory_cards.get(card_id, {})

func dialogue_scene(section_id: String, scene_id: String) -> Dictionary:
	if _chapter_one_dialogue.is_empty():
		_chapter_one_dialogue = _load_json(CHAPTER_ONE_DIALOGUE_PATH)
	var section: Dictionary = _chapter_one_dialogue.get(section_id, {})
	return section.get(scene_id, {})

func _load_json(path: String) -> Dictionary:
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		push_error("Unable to load content catalog file: %s" % path)
		return {}
	var parsed = JSON.parse_string(file.get_as_text())
	if parsed is Dictionary:
		return parsed
	return {}
