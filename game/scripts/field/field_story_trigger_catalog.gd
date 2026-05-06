class_name FieldStoryTriggerCatalog
extends RefCounted

const TRIGGER_PATH := "res://data/story/field_story_triggers.json"

var _data: Dictionary = {}

func trigger_for_phase(phase_id: String) -> Dictionary:
	if _data.is_empty():
		_data = _load_json(TRIGGER_PATH)
	var triggers: Dictionary = _data.get("phase_triggers", {})
	return triggers.get(phase_id, {})

func _load_json(path: String) -> Dictionary:
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		push_error("Unable to load field story trigger data: %s" % path)
		return {}
	var parsed = JSON.parse_string(file.get_as_text())
	if parsed is Dictionary:
		return parsed
	return {}
