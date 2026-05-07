class_name MapPropRenderer
extends RefCounted

const MANIFEST_PATH := "res://data/maps/first_slice_prop_placements.json"
const TileAssetCatalog = preload("res://scripts/field/tile_asset_catalog.gd")

var data: Dictionary = {}


func _init() -> void:
	_load()


func props_for_map(map_id: String) -> Array:
	return data.get("maps", {}).get(map_id, {}).get("props", []).duplicate(true)


func render_props(parent: Node, map_id: String) -> void:
	for prop in props_for_map(map_id):
		parent.add_child(create_prop(prop))


func create_prop(prop: Dictionary) -> Node2D:
	var kind := String(prop.get("kind", "sprite"))
	var node: Node2D
	match kind:
		"color":
			node = _create_color_prop(prop)
		_:
			node = _create_sprite_prop(prop)
	_apply_common_metadata(node, prop)
	for child in prop.get("children", []):
		node.add_child(create_prop(child))
	if prop.has("collision_rect"):
		node.add_child(_create_collision_body(prop.collision_rect))
	return node


func _create_sprite_prop(prop: Dictionary) -> Sprite2D:
	var sprite := Sprite2D.new()
	sprite.texture = _texture_for_prop(prop)
	sprite.centered = true
	sprite.scale = Vector2(float(prop.get("scale", 1.0)), float(prop.get("scale", 1.0)))
	sprite.z_index = int(prop.get("z_index", -6))
	if prop.has("asset_path"):
		sprite.set_meta("slice_path", String(prop.asset_path))
	if prop.has("asset_id"):
		sprite.set_meta("tile_asset_id", String(prop.asset_id))
	sprite.modulate = _color_from_value(prop.get("modulate", [1.0, 1.0, 1.0, 1.0]))
	return sprite


func _create_color_prop(prop: Dictionary) -> Node2D:
	var node := Node2D.new()
	if prop.has("asset_id"):
		node.set_meta("tile_asset_id", String(prop.asset_id))
	var marker := ColorRect.new()
	marker.name = "Marker"
	var size := _vector_from_value(prop.get("size", {"x": 16, "y": 16}))
	marker.offset_left = -size.x / 2.0
	marker.offset_top = -size.y / 2.0
	marker.offset_right = size.x / 2.0
	marker.offset_bottom = size.y / 2.0
	marker.color = _color_from_value(prop.get("color", [1.0, 1.0, 1.0, 1.0]))
	node.add_child(marker)
	return node


func _apply_common_metadata(node: Node2D, prop: Dictionary) -> void:
	node.name = String(prop.get("id", "Prop"))
	node.position = _vector_from_value(prop.get("position", {}))
	node.set_meta("prop_category", String(prop.get("category", "")))
	if prop.has("story_role"):
		node.set_meta("story_role", String(prop.story_role))
	if prop.has("inspect_text"):
		node.set_meta("inspect_text", String(prop.inspect_text))
	if prop.has("inspect_audio"):
		node.set_meta("inspect_audio", String(prop.inspect_audio))
	if prop.has("discovery_flag"):
		node.set_meta("discovery_flag", String(prop.discovery_flag))


func _create_collision_body(rect_data: Dictionary) -> StaticBody2D:
	var rect := Rect2(
		float(rect_data.get("x", 0.0)),
		float(rect_data.get("y", 0.0)),
		float(rect_data.get("w", 0.0)),
		float(rect_data.get("h", 0.0))
	)
	var body := StaticBody2D.new()
	body.name = "PropCollision"
	body.position = rect.position + rect.size / 2.0
	var shape := CollisionShape2D.new()
	shape.name = "CollisionShape2D"
	var rectangle := RectangleShape2D.new()
	rectangle.size = rect.size
	shape.shape = rectangle
	body.add_child(shape)
	return body


func _texture_for_prop(prop: Dictionary) -> Texture2D:
	var path := String(prop.get("asset_path", ""))
	if path.is_empty() and prop.has("asset_id"):
		var asset := TileAssetCatalog.new().asset_by_id(String(prop.asset_id))
		path = String(asset.get("runtime_path", ""))
	return _load_runtime_texture(path)


func _load_runtime_texture(path: String) -> Texture2D:
	if path.is_empty() or not FileAccess.file_exists(path):
		return null
	var image := Image.new()
	var error := image.load(path)
	if error != OK:
		return null
	return ImageTexture.create_from_image(image)


func _vector_from_value(value) -> Vector2:
	if value is Dictionary:
		return Vector2(float(value.get("x", 0.0)), float(value.get("y", 0.0)))
	if value is Array and value.size() >= 2:
		return Vector2(float(value[0]), float(value[1]))
	return Vector2.ZERO


func _color_from_value(value) -> Color:
	if value is Array and value.size() >= 4:
		return Color(float(value[0]), float(value[1]), float(value[2]), float(value[3]))
	if value is Dictionary:
		return Color(
			float(value.get("r", 1.0)),
			float(value.get("g", 1.0)),
			float(value.get("b", 1.0)),
			float(value.get("a", 1.0))
		)
	return Color.WHITE


func _load() -> void:
	if not FileAccess.file_exists(MANIFEST_PATH):
		return
	var file := FileAccess.open(MANIFEST_PATH, FileAccess.READ)
	if file == null:
		return
	var parsed = JSON.parse_string(file.get_as_text())
	if parsed is Dictionary:
		data = parsed
