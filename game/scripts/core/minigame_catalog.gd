class_name MinigameCatalog
extends RefCounted

const MINIGAME_DATA_PATH := "res://data/minigames/minigames.json"

var asset_root := ""
var minigames: Dictionary = {}


func _init() -> void:
	_load()


func all() -> Dictionary:
	return minigames.duplicate(true)


func get_minigame(id: String) -> Dictionary:
	return minigames.get(id, {})


func for_location(location_id: String) -> Array[Dictionary]:
	var results: Array[Dictionary] = []
	for game in minigames.values():
		if game.get("locations", []).has(location_id):
			results.append(game)
	results.sort_custom(func(a, b): return str(a.get("name", "")) < str(b.get("name", "")))
	return results


func unlocked_for_chapter(chapter: int) -> Array[Dictionary]:
	var results: Array[Dictionary] = []
	for game in minigames.values():
		if int(game.get("unlock_chapter", 0)) <= chapter:
			results.append(game)
	results.sort_custom(func(a, b): return int(a.get("unlock_chapter", 0)) < int(b.get("unlock_chapter", 0)))
	return results


func _load() -> void:
	if not FileAccess.file_exists(MINIGAME_DATA_PATH):
		return
	var file := FileAccess.open(MINIGAME_DATA_PATH, FileAccess.READ)
	if file == null:
		return
	var parsed = JSON.parse_string(file.get_as_text())
	if typeof(parsed) != TYPE_DICTIONARY:
		return
	asset_root = str(parsed.get("asset_root", ""))
	for id in parsed.get("minigames", {}).keys():
		var game: Dictionary = parsed.minigames[id].duplicate(true)
		game["asset_source"] = _asset_source_for(game)
		minigames[id] = game


func _asset_source_for(game: Dictionary) -> String:
	var folder := str(game.get("asset_folder", ""))
	if folder.is_empty():
		return asset_root
	return "%s/%s" % [asset_root, folder]
