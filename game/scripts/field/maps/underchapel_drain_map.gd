class_name UnderchapelDrainMap
extends Node2D

@export var map_id := "underchapel_drain"

const TileAssetCatalog = preload("res://scripts/field/tile_asset_catalog.gd")

const WALL_RECTS := [
	Rect2(0, 32, 384, 16),
	Rect2(0, 160, 384, 16),
	Rect2(0, 32, 16, 144),
	Rect2(368, 32, 16, 144),
	Rect2(192, 48, 32, 32),
]


func _init() -> void:
	build_map()


func _ready() -> void:
	build_map()


func build_map() -> void:
	_apply_map_metadata()
	if get_node_or_null("DrainFloor") != null:
		return
	_add_floor()
	_add_landmarks()
	_add_collision()
	_add_atmosphere()


func _apply_map_metadata() -> void:
	set_meta("audio_profile", {
		"map_id": map_id,
		"ambience": "ambience_underchapel_drain",
		"entry": "door_museum_open",
		"museum_override": "curator_warning",
	})


func _add_floor() -> void:
	var floor := Sprite2D.new()
	floor.name = "DrainFloor"
	floor.texture = _texture_for_asset("underchapel_sewer_tiles")
	floor.centered = false
	floor.position = Vector2(16, 32)
	floor.z_index = -30
	floor.modulate = Color(0.48, 0.62, 0.50, 0.82)
	floor.set_meta("tile_asset_id", "underchapel_sewer_tiles")
	add_child(floor)


func _add_landmarks() -> void:
	var landmarks := Node2D.new()
	landmarks.name = "Landmarks"
	add_child(landmarks)
	landmarks.add_child(_tag_story_prop(_create_sliced_prop("MuseumPipe", Vector2(96, 72), "res://assets/tilesets/first_slice/underchapel/sliced/museum_pipe.png", 0.72, -6), "museum_infrastructure", "The pipe sweats plague water and hums with museum power. It should not belong to either world."))
	landmarks.add_child(_tag_story_prop(_create_sliced_prop("PumpMachine", Vector2(160, 96), "res://assets/tilesets/first_slice/underchapel/sliced/pump_machine.png", 0.30, -6), "cross_era_machine", "A clean machine forces dirty water through old stone. The Curator's layer is under the chapel."))
	landmarks.add_child(_create_sliced_prop("DrainGrate", Vector2(224, 116), "res://assets/tilesets/first_slice/underchapel/sliced/drain_grate.png", 0.72, -5))
	landmarks.add_child(_create_sliced_prop("ServiceLadder", Vector2(304, 96), "res://assets/tilesets/first_slice/underchapel/sliced/service_ladder.png", 0.82, -5))
	landmarks.add_child(_tag_story_prop(_create_sliced_prop("WarningPanel", Vector2(128, 120), "res://assets/tilesets/first_slice/underchapel/sliced/warning_panel.png", 0.52, -5), "curator_warning_label", "The warning panel uses museum symbols, but the grime around it is older than the town above."))
	landmarks.add_child(_create_sliced_prop("WasteBags", Vector2(272, 128), "res://assets/tilesets/first_slice/underchapel/sliced/waste_bags.png", 0.42, -6))


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
	var mist := Node2D.new()
	mist.name = "SewerMist"
	atmosphere.add_child(mist)
	mist.add_child(_create_mist_patch("Mist01", Vector2(54, 86), Vector2(112, 18), 0.14))
	mist.add_child(_create_mist_patch("Mist02", Vector2(170, 122), Vector2(128, 22), 0.12))
	mist.add_child(_create_mist_patch("Mist03", Vector2(284, 72), Vector2(76, 14), 0.10))


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


func _create_mist_patch(node_name: String, position: Vector2, size: Vector2, alpha: float) -> ColorRect:
	var patch := ColorRect.new()
	patch.name = node_name
	patch.position = position
	patch.size = size
	patch.color = Color(0.54, 0.70, 0.58, alpha)
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
