class_name MiraApothecaryMap
extends Node2D

@export var map_id := "mira_apothecary"

const TileAssetCatalog = preload("res://scripts/field/tile_asset_catalog.gd")

const WALL_RECTS := [
	Rect2(0, 16, 208, 16),
	Rect2(0, 176, 208, 16),
	Rect2(0, 16, 16, 176),
	Rect2(192, 16, 16, 176),
]


func _init() -> void:
	build_map()


func _ready() -> void:
	build_map()


func build_map() -> void:
	if get_node_or_null("InteriorFloor") != null:
		return
	_add_floor()
	_add_landmarks()
	_add_collision()
	_add_atmosphere()


func _add_floor() -> void:
	var floor := Sprite2D.new()
	floor.name = "InteriorFloor"
	floor.texture = _texture_for_asset("museum_modern_inside_tiles")
	floor.centered = false
	floor.position = Vector2(16, 32)
	floor.z_index = -30
	floor.modulate = Color(0.52, 0.40, 0.30, 0.85)
	floor.set_meta("tile_asset_id", "museum_modern_inside_tiles")
	add_child(floor)


func _add_landmarks() -> void:
	var landmarks := Node2D.new()
	landmarks.name = "Landmarks"
	add_child(landmarks)
	landmarks.add_child(_create_sliced_prop("MedicineShelf", Vector2(128, 64), "res://assets/tilesets/first_slice/apothecary/sliced/medicine_shelf.png", 0.08))
	landmarks.add_child(_create_sliced_prop("RestBed", Vector2(160, 96), "res://assets/tilesets/first_slice/apothecary/sliced/rest_bed.png", 0.24))
	landmarks.add_child(_create_sliced_prop("WorkTable", Vector2(96, 80), "res://assets/tilesets/first_slice/apothecary/sliced/work_table.png", 0.18))
	landmarks.add_child(_create_color_landmark("ExitDoor", Vector2(32, 64), Vector2(20, 34), Color(0.14, 0.10, 0.08, 0.95), "museum_modern_inside_tiles"))
	landmarks.add_child(_create_sliced_prop("BoilingBasin", Vector2(104, 112), "res://assets/tilesets/first_slice/apothecary/sliced/boiling_basin.png", 0.16))


func _add_collision() -> void:
	var collision := Node2D.new()
	collision.name = "Collision"
	add_child(collision)
	var walls := Node2D.new()
	walls.name = "Walls"
	collision.add_child(walls)
	for index in WALL_RECTS.size():
		walls.add_child(_create_wall_body(WALL_RECTS[index], index))


func _add_atmosphere() -> void:
	var atmosphere := Node2D.new()
	atmosphere.name = "Atmosphere"
	add_child(atmosphere)
	var smoke := Node2D.new()
	smoke.name = "HerbSmoke"
	atmosphere.add_child(smoke)
	smoke.add_child(_create_smoke_patch("Steam01", Vector2(92, 98), Vector2(44, 14), 0.14))
	smoke.add_child(_create_smoke_patch("Steam02", Vector2(116, 52), Vector2(58, 12), 0.11))


func _create_color_landmark(node_name: String, position: Vector2, size: Vector2, color: Color, asset_id: String) -> Node2D:
	var node := Node2D.new()
	node.name = node_name
	node.position = position
	node.set_meta("tile_asset_id", asset_id)
	var marker := ColorRect.new()
	marker.name = "Marker"
	marker.offset_left = -size.x / 2.0
	marker.offset_top = -size.y / 2.0
	marker.offset_right = size.x / 2.0
	marker.offset_bottom = size.y / 2.0
	marker.color = color
	node.add_child(marker)
	return node


func _create_sliced_prop(node_name: String, position: Vector2, path: String, prop_scale: float) -> Sprite2D:
	var sprite := Sprite2D.new()
	sprite.name = node_name
	sprite.texture = _load_runtime_texture(path)
	sprite.centered = true
	sprite.position = position
	sprite.scale = Vector2(prop_scale, prop_scale)
	sprite.z_index = -6
	sprite.set_meta("slice_path", path)
	return sprite


func _create_smoke_patch(node_name: String, position: Vector2, size: Vector2, alpha: float) -> ColorRect:
	var patch := ColorRect.new()
	patch.name = node_name
	patch.position = position
	patch.size = size
	patch.color = Color(0.70, 0.76, 0.63, alpha)
	return patch


func _create_wall_body(rect: Rect2, index: int) -> StaticBody2D:
	var body := StaticBody2D.new()
	body.name = "Wall%02d" % index
	body.position = rect.position + rect.size / 2.0
	var shape := CollisionShape2D.new()
	var rectangle := RectangleShape2D.new()
	rectangle.size = rect.size
	shape.shape = rectangle
	body.add_child(shape)
	return body


func _texture_for_asset(asset_id: String) -> Texture2D:
	var asset := TileAssetCatalog.new().asset_by_id(asset_id)
	return _load_runtime_texture(String(asset.get("runtime_path", "")))


func _load_runtime_texture(path: String) -> Texture2D:
	if path.is_empty() or not FileAccess.file_exists(path):
		return null
	var image := Image.new()
	var error := image.load(path)
	if error != OK:
		return null
	return ImageTexture.create_from_image(image)
