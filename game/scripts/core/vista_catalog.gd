class_name VistaCatalog
extends RefCounted

const VISTA_DATA_PATH := "res://data/vistas/vista_engines.json"

var _data: Dictionary = {}

func vista(vista_id: String) -> Dictionary:
	_ensure_loaded()
	return _data.get("vistas", {}).get(vista_id, {})

func vista_for_phase(phase_id: String) -> Dictionary:
	_ensure_loaded()
	var vista_id := String(_data.get("phase_map", {}).get(phase_id, ""))
	if vista_id.is_empty():
		return {}
	return vista(vista_id)

func _ensure_loaded() -> void:
	if not _data.is_empty():
		return
	var file := FileAccess.open(VISTA_DATA_PATH, FileAccess.READ)
	if file == null:
		push_error("Unable to load Vista Engine catalog.")
		return
	var parsed = JSON.parse_string(file.get_as_text())
	if parsed is Dictionary:
		_data = parsed
