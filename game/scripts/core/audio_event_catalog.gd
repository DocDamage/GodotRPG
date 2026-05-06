class_name AudioEventCatalog
extends RefCounted

const AUDIO_EVENTS_PATH := "res://data/audio/audio_events.json"

var _data: Dictionary = {}

func event(event_id: String) -> Dictionary:
	_ensure_loaded()
	return _data.get("events", {}).get(event_id, {})

func events_for_chapter(chapter_id: String) -> Array:
	_ensure_loaded()
	return _data.get("chapters", {}).get(chapter_id, [])

func _ensure_loaded() -> void:
	if not _data.is_empty():
		return
	var file := FileAccess.open(AUDIO_EVENTS_PATH, FileAccess.READ)
	if file == null:
		push_error("Unable to load audio event catalog.")
		return
	var parsed = JSON.parse_string(file.get_as_text())
	if parsed is Dictionary:
		_data = parsed
