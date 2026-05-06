class_name MapCatalog
extends RefCounted

const FIRST_SLICE_MAPS_PATH := "res://data/maps/first_slice_maps.json"

var data: Dictionary = {}


func _init() -> void:
	_load()


func map_for_phase(phase_id: String) -> Dictionary:
	var map_id := String(data.get("phase_map", {}).get(phase_id, phase_id))
	return map_by_id(map_id)


func map_by_id(map_id: String) -> Dictionary:
	return data.get("maps", {}).get(map_id, {}).duplicate(true)


func _load() -> void:
	if not FileAccess.file_exists(FIRST_SLICE_MAPS_PATH):
		return
	var file := FileAccess.open(FIRST_SLICE_MAPS_PATH, FileAccess.READ)
	if file == null:
		return
	var parsed = JSON.parse_string(file.get_as_text())
	if typeof(parsed) == TYPE_DICTIONARY:
		data = parsed
