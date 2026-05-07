class_name SaintedBellChapelMap
extends Node2D

@export var map_id := "sainted_bell_chapel"

const TileAssetCatalog = preload("res://scripts/field/tile_asset_catalog.gd")

const WALL_RECTS := [
	Rect2(0, 0, 288, 16),
	Rect2(0, 160, 288, 16),
	Rect2(0, 0, 16, 176),
	Rect2(272, 0, 16, 176),
	Rect2(80, 16, 16, 48),
	Rect2(192, 16, 16, 48),
]


func _init() -> void:
	build_map()


func _ready() -> void:
	build_map()


func build_map() -> void:
	_apply_map_metadata()
	if get_node_or_null("ChapelFloor") != null:
		return
	_add_floor()
	_add_landmarks()
	_add_collision()
	_add_atmosphere()


func _apply_map_metadata() -> void:
	set_meta("audio_profile", {
		"map_id": map_id,
		"ambience": "ambience_chapel_bell",
		"entry": "bell_clapper_relic",
		"museum_override": "curator_warning",
	})


func _add_floor() -> void:
	var floor := Sprite2D.new()
	floor.name = "ChapelFloor"
	floor.texture = _texture_for_asset("chapel_gothic_corridor_tiles")
	floor.centered = false
	floor.position = Vector2(16, 16)
	floor.z_index = -30
	floor.modulate = Color(0.62, 0.62, 0.68, 0.86)
	floor.set_meta("tile_asset_id", "chapel_gothic_corridor_tiles")
	add_child(floor)


func _add_landmarks() -> void:
	var landmarks := Node2D.new()
	landmarks.name = "Landmarks"
	add_child(landmarks)
	landmarks.add_child(_create_sliced_prop("ChapelArch", Vector2(128, 48), "res://assets/tilesets/first_slice/chapel/sliced/chapel_arch.png", 0.16, -8))
	landmarks.add_child(_tag_story_prop(_create_sliced_prop("SaintStatue", Vector2(128, 70), "res://assets/tilesets/first_slice/chapel/sliced/saint_statue.png", 0.36, -6), "belief_anchor", "The statue's face is worn smooth where frightened hands asked stone to answer."))
	landmarks.add_child(_tag_story_prop(_create_sliced_prop("CellarDoor", Vector2(224, 112), "res://assets/tilesets/first_slice/chapel/sliced/cellar_door.png", 0.20, -5), "hidden_route", "Cold air leaks through the cellar door. It smells less like earth than sterilized metal."))
	landmarks.add_child(_create_sliced_prop("ChapelLantern", Vector2(88, 112), "res://assets/tilesets/first_slice/chapel/sliced/chapel_lantern.png", 0.70, -5))
	landmarks.add_child(_create_sliced_prop("ChapelBench", Vector2(168, 112), "res://assets/tilesets/first_slice/chapel/sliced/chapel_bench.png", 0.48, -5))
	landmarks.add_child(_create_sliced_prop("StoneRail", Vector2(128, 104), "res://assets/tilesets/first_slice/chapel/sliced/stone_rail.png", 0.34, -7))


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
	var dust := Node2D.new()
	dust.name = "BellDust"
	atmosphere.add_child(dust)
	dust.add_child(_create_dust_patch("Dust01", Vector2(72, 52), Vector2(72, 14), 0.13))
	dust.add_child(_create_dust_patch("Dust02", Vector2(142, 86), Vector2(82, 16), 0.10))
	dust.add_child(_create_dust_patch("Dust03", Vector2(204, 116), Vector2(54, 12), 0.12))


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


func _create_dust_patch(node_name: String, position: Vector2, size: Vector2, alpha: float) -> ColorRect:
	var patch := ColorRect.new()
	patch.name = node_name
	patch.position = position
	patch.size = size
	patch.color = Color(0.74, 0.70, 0.60, alpha)
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
