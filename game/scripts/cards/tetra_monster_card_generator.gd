class_name TetraMonsterCardGenerator
extends RefCounted

const ENEMY_DATA_PATH := "res://data/combat/enemies.json"
const CARD_ART := [
	"res://assets/cards/faces/face_character_01.png",
	"res://assets/cards/faces/face_character_02.png",
]

var _enemies: Dictionary = {}

func card_for_enemy(enemy_id: String) -> Dictionary:
	_ensure_loaded()
	var enemy: Dictionary = _enemies.get(enemy_id, {})
	if enemy.is_empty():
		return {}
	var strength := int(enemy.get("strength", 1))
	var defense := int(enemy.get("defense", 0))
	var speed := int(enemy.get("speed", 1))
	return {
		"id": "monster_%s" % enemy_id,
		"name": enemy_id.replace("_", " ").capitalize(),
		"power": clampi(ceili(float(strength) / 3.0), 0, 15),
		"physical_defense": clampi(ceili(float(defense) / 2.0), 0, 15),
		"magic_defense": clampi(ceili(float(defense + speed) / 8.0), 0, 15),
		"card_type": "PHYSICAL" if strength >= speed else "FLEXIBLE",
		"directions": _directions_for(enemy_id, strength, defense, speed),
		"image": CARD_ART[_enemy_index(enemy_id) % CARD_ART.size()],
		"source_enemy": enemy_id,
	}

func all_enemy_cards() -> Dictionary:
	_ensure_loaded()
	var cards := {}
	for enemy_id in _enemies.keys():
		var card := card_for_enemy(enemy_id)
		cards[card.id] = card
	return cards

func _directions_for(enemy_id: String, strength: int, defense: int, speed: int) -> Array:
	var arrows := [false, false, false, false, false, false, false, false]
	arrows[0] = true
	arrows[2] = strength >= defense
	arrows[4] = defense >= 2
	arrows[6] = speed >= 8
	arrows[abs(hash(enemy_id)) % arrows.size()] = true
	return arrows

func _enemy_index(enemy_id: String) -> int:
	var keys := _enemies.keys()
	return max(0, keys.find(enemy_id))

func _ensure_loaded() -> void:
	if not _enemies.is_empty():
		return
	var file := FileAccess.open(ENEMY_DATA_PATH, FileAccess.READ)
	if file == null:
		push_error("Unable to load enemy data for tetra cards.")
		return
	var parsed = JSON.parse_string(file.get_as_text())
	if parsed is Dictionary:
		_enemies = parsed
