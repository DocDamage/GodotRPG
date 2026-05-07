class_name BellTowerBossRoomMap
extends Node2D

@export var map_id := "bell_tower_boss_room"

const TileAssetCatalog = preload("res://scripts/field/tile_asset_catalog.gd")
const MapPropRenderer = preload("res://scripts/field/map_prop_renderer.gd")

const WALL_RECTS := [
	Rect2(0, 0, 272, 16),
	Rect2(0, 144, 272, 16),
	Rect2(0, 0, 16, 160),
	Rect2(256, 0, 16, 160),
	Rect2(80, 16, 16, 48),
	Rect2(176, 16, 16, 48),
]


func _init() -> void:
	build_map()


func _ready() -> void:
	build_map()


func build_map() -> void:
	_apply_map_metadata()
	if get_node_or_null("BellTowerFloor") != null:
		return
	_add_floor()
	_add_landmarks()
	_add_collision()
	_add_atmosphere()


func _apply_map_metadata() -> void:
	set_meta("audio_profile", {
		"map_id": map_id,
		"ambience": "ambience_bell_tower",
		"entry": "bell_clapper_relic",
		"museum_override": "curator_warning",
	})


func _add_floor() -> void:
	var floor := Sprite2D.new()
	floor.name = "BellTowerFloor"
	floor.texture = _texture_for_asset("chapel_gothic_corridor_tiles")
	floor.centered = false
	floor.position = Vector2(16, 16)
	floor.z_index = -30
	floor.modulate = Color(0.58, 0.48, 0.50, 0.86)
	floor.set_meta("tile_asset_id", "chapel_gothic_corridor_tiles")
	add_child(floor)


func _add_landmarks() -> void:
	var landmarks := Node2D.new()
	landmarks.name = "Landmarks"
	add_child(landmarks)
	MapPropRenderer.new().render_props(landmarks, map_id)


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
	var haze := Node2D.new()
	haze.name = "JudgmentHaze"
	atmosphere.add_child(haze)
	haze.add_child(_create_haze_patch("Haze01", Vector2(62, 44), Vector2(140, 20), 0.16))
	haze.add_child(_create_haze_patch("Haze02", Vector2(104, 92), Vector2(96, 18), 0.12))
	haze.add_child(_create_haze_patch("Haze03", Vector2(176, 118), Vector2(58, 12), 0.14))


func _create_sliced_prop(node_name: String, position: Vector2, path: String, prop_scale: float, z: int) -> Sprite2D:
	var sprite := Sprite2D.new()
	sprite.name = node_name
	sprite.texture = _load_runtime_texture(path)
	sprite.centered = true
	sprite.position = position
	sprite.scale = Vector2(prop_scale, prop_scale)
	sprite.z_index = z
	sprite.set_meta("slice_path", path)
	return sprite


func _tag_story_prop(node: Node, story_role: String, inspect_text: String) -> Node:
	node.set_meta("story_role", story_role)
	node.set_meta("inspect_text", inspect_text)
	return node


func _create_haze_patch(node_name: String, position: Vector2, size: Vector2, alpha: float) -> ColorRect:
	var patch := ColorRect.new()
	patch.name = node_name
	patch.position = position
	patch.size = size
	patch.color = Color(0.70, 0.58, 0.62, alpha)
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
