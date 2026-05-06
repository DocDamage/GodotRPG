class_name TileAssetCatalog
extends RefCounted

const FIRST_SLICE_TILE_ASSETS_PATH := "res://data/tilesets/first_slice_tile_assets.json"

var data: Dictionary = {}


func _init() -> void:
	_load()


func asset_for_map(map_id: String) -> Dictionary:
	var assets := assets_for_map(map_id)
	if assets.is_empty():
		return {}
	return assets[0]


func assets_for_map(map_id: String) -> Array:
	var ids: Array = data.get("map_assets", {}).get(map_id, [])
	var resolved := []
	for asset_id in ids:
		var asset := asset_by_id(String(asset_id))
		if not asset.is_empty():
			resolved.append(asset)
	return resolved


func asset_by_id(asset_id: String) -> Dictionary:
	return data.get("assets", {}).get(asset_id, {}).duplicate(true)


func _load() -> void:
	if not FileAccess.file_exists(FIRST_SLICE_TILE_ASSETS_PATH):
		return
	var file := FileAccess.open(FIRST_SLICE_TILE_ASSETS_PATH, FileAccess.READ)
	if file == null:
		return
	var parsed = JSON.parse_string(file.get_as_text())
	if typeof(parsed) == TYPE_DICTIONARY:
		data = parsed
