class_name FieldObjectiveCatalog
extends RefCounted

const OBJECTIVES_PATH := "res://data/story/first_slice_objectives.json"

var _data: Dictionary = {}

func objective_for_phase(phase_id: String) -> Dictionary:
	if _data.is_empty():
		_data = _load_json(OBJECTIVES_PATH)
	var objectives: Dictionary = _data.get("phase_objectives", {})
	return objectives.get(phase_id, {})

func _load_json(path: String) -> Dictionary:
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		push_error("Unable to load field objective data: %s" % path)
		return {}
	var parsed = JSON.parse_string(file.get_as_text())
	if parsed is Dictionary:
		return parsed
	return {}
