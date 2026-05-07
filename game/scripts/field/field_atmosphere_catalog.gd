class_name FieldAtmosphereCatalog
extends RefCounted

const ATMOSPHERE_DATA_PATH := "res://data/field/atmosphere_profiles.json"

var _data: Dictionary = {}

func _init() -> void:
	_data = _load_data()

func profile_for_phase(phase_id: String) -> Dictionary:
	var profile: Dictionary = _data.get("profiles", {}).get(phase_id, {})
	return profile.duplicate(true)

func _load_data() -> Dictionary:
	var file := FileAccess.open(ATMOSPHERE_DATA_PATH, FileAccess.READ)
	if file == null:
		push_error("Unable to load field atmosphere profiles.")
		return {}
	var parsed = JSON.parse_string(file.get_as_text())
	if not parsed is Dictionary:
		return {}
	return parsed
