class_name ContentCatalog
extends RefCounted

const ITEMS_PATH := "res://data/items/items.json"
const MEMORY_CARDS_PATH := "res://data/cards/memory_cards.json"
const CHAPTER_ONE_DIALOGUE_PATH := "res://data/dialogue/chapter_01_bell_saint.json"
const BATTLE_SKILLS_PATH := "res://data/battle/skills.json"
const BATTLE_ANIMATION_SETS_PATH := "res://data/battle/animation_sets.json"
const PARTY_PATH := "res://data/characters/party.json"

var _items: Dictionary = {}
var _memory_cards: Dictionary = {}
var _chapter_one_dialogue: Dictionary = {}
var _battle_skills: Dictionary = {}
var _battle_animation_sets: Dictionary = {}
var _party_members: Dictionary = {}

func item(item_id: String) -> Dictionary:
	if _items.is_empty():
		_items = _load_json(ITEMS_PATH)
	return _items.get(item_id, {})

func memory_card(card_id: String) -> Dictionary:
	if _memory_cards.is_empty():
		_memory_cards = _load_json(MEMORY_CARDS_PATH)
	return _memory_cards.get(card_id, {})

func battle_skill(skill_id: String) -> Dictionary:
	if _battle_skills.is_empty():
		_battle_skills = _load_json(BATTLE_SKILLS_PATH)
	return _battle_skills.get(skill_id, {})

func battle_animation_set(animation_set_id: String) -> Dictionary:
	if _battle_animation_sets.is_empty():
		_battle_animation_sets = _load_json(BATTLE_ANIMATION_SETS_PATH)
	return _battle_animation_sets.get(animation_set_id, {})

func party_member(member_id: String) -> Dictionary:
	if _party_members.is_empty():
		_party_members = _load_json(PARTY_PATH)
	var member: Dictionary = _party_members.get(member_id, {})
	if member.is_empty():
		return {}
	var hydrated := member.duplicate(true)
	hydrated.id = member_id
	return hydrated

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
