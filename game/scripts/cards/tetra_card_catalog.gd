class_name TetraCardCatalog
extends RefCounted

const CARD_DATA_PATH := "res://data/tetra/tetra_cards.json"

var _data: Dictionary = {}

func card(card_id: String) -> Dictionary:
	_ensure_loaded()
	return _data.get("cards", {}).get(card_id, {})

func starter_deck() -> Array:
	_ensure_loaded()
	return _data.get("starter_deck", []).duplicate(true)

func _ensure_loaded() -> void:
	if not _data.is_empty():
		return
	var file := FileAccess.open(CARD_DATA_PATH, FileAccess.READ)
	if file == null:
		push_error("Unable to load tetra card data.")
		return
	var parsed = JSON.parse_string(file.get_as_text())
	if parsed is Dictionary:
		_data = parsed
