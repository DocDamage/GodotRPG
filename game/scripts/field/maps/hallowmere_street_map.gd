class_name HallowmereStreetMap
extends Node2D

@export var map_id := "hallowmere_street"

const TileAssetCatalog = preload("res://scripts/field/tile_asset_catalog.gd")

const WALL_RECTS := [
	Rect2(0, 16, 480, 16),
	Rect2(0, 176, 480, 16),
	Rect2(0, 16, 16, 176),
	Rect2(464, 16, 16, 176),
	Rect2(176, 32, 32, 48),
	Rect2(288, 48, 32, 48),
]


func _init() -> void:
	build_map()


func _ready() -> void:
	build_map()


func build_map() -> void:
	_apply_map_metadata()
	if get_node_or_null("GroundTiles") != null:
		return
	_add_ground_tiles()
	_add_landmarks()
	_add_collision()


func _apply_map_metadata() -> void:
	set_meta("audio_profile", {
		"map_id": map_id,
		"ambience": "ambience_plague_town",
		"entry": "plague_cough",
		"museum_override": "curator_warning",
	})


func _add_ground_tiles() -> void:
	var ground := Sprite2D.new()
	ground.name = "GroundTiles"
	ground.texture = _texture_for_asset("plague_town_ground")
	ground.centered = false
	ground.position = Vector2(16, 24)
	ground.z_index = -30
	ground.modulate = Color(0.92, 0.82, 0.68, 0.9)
	ground.set_meta("tile_asset_id", "plague_town_ground")
	add_child(ground)


func _add_landmarks() -> void:
	var landmarks := Node2D.new()
	landmarks.name = "Landmarks"
	add_child(landmarks)
	landmarks.add_child(_create_sprite_landmark("House01", "plague_town_house_01", Vector2(72, 24), Color(0.86, 0.78, 0.70, 0.95), -10))
	landmarks.add_child(_create_sprite_landmark("House02", "plague_town_house_02", Vector2(240, 32), Color(0.78, 0.72, 0.66, 0.92), -10))
	landmarks.add_child(_create_sprite_landmark("GraveMarker", "plague_town_grave_01", Vector2(256, 128), Color(0.65, 0.70, 0.68, 0.95), -8))
	landmarks.add_child(_tag_story_prop(_create_sliced_prop("CoffinStack", Vector2(216, 96), "res://assets/tilesets/first_slice/hallowmere/sliced/coffin_stack.png", 0.52, -7), "plague_cost", "Fresh coffins wait beside old mud. Hallowmere is running out of distance between sickness and burial."))
	landmarks.add_child(_create_sprite_landmark("RoadStone", "plague_town_rock_01", Vector2(144, 120), Color(0.62, 0.58, 0.52, 0.9), -8))
	landmarks.add_child(_create_color_landmark("TownWell", Vector2(176, 128), Vector2(24, 24), Color(0.22, 0.24, 0.22, 0.95)))
	var toll_stall := _create_color_landmark("TollStall", Vector2(320, 96), Vector2(34, 22), Color(0.40, 0.22, 0.16, 0.35))
	_tag_story_prop(toll_stall, "shop_anchor", "Toll's stall looks temporary, but the same coin mark is carved into the counter in every era.")
	toll_stall.add_child(_create_sliced_prop("TollStallSprite", Vector2.ZERO, "res://assets/tilesets/first_slice/hallowmere/sliced/toll_stall.png", 0.30, -6))
	landmarks.add_child(toll_stall)
	landmarks.add_child(_create_color_landmark("ApothecaryDoor", Vector2(352, 96), Vector2(22, 30), Color(0.18, 0.30, 0.22, 0.95)))
	var chapel_road := _create_color_landmark("ChapelRoad", Vector2(416, 80), Vector2(38, 28), Color(0.27, 0.24, 0.29, 0.35))
	_tag_story_prop(chapel_road, "route_marker", "The chapel sign has been repainted so many times the arrow points more like an accusation than a direction.")
	chapel_road.add_child(_create_sliced_prop("ChapelSignSprite", Vector2.ZERO, "res://assets/tilesets/first_slice/hallowmere/sliced/chapel_sign.png", 0.62, -6))
	landmarks.add_child(chapel_road)
	landmarks.add_child(_create_sliced_prop("RefusePile", Vector2(304, 136), "res://assets/tilesets/first_slice/hallowmere/sliced/refuse_pile.png", 0.34, -7))
	_add_atmosphere()


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
	var fog := Node2D.new()
	fog.name = "PlagueFog"
	atmosphere.add_child(fog)
	fog.add_child(_create_fog_patch("FogPatch01", Vector2(48, 78), Vector2(86, 18), 0.18))
	fog.add_child(_create_fog_patch("FogPatch02", Vector2(178, 106), Vector2(112, 24), 0.16))
	fog.add_child(_create_fog_patch("FogPatch03", Vector2(344, 64), Vector2(100, 20), 0.20))


func _create_sprite_landmark(node_name: String, asset_id: String, position: Vector2, tint: Color, z: int) -> Sprite2D:
	var sprite := Sprite2D.new()
	sprite.name = node_name
	sprite.texture = _texture_for_asset(asset_id)
	sprite.centered = true
	sprite.position = position
	sprite.z_index = z
	sprite.modulate = tint
	sprite.set_meta("tile_asset_id", asset_id)
	return sprite


func _create_color_landmark(node_name: String, position: Vector2, size: Vector2, color: Color) -> Node2D:
	var node := Node2D.new()
	node.name = node_name
	node.position = position
	var marker := ColorRect.new()
	marker.name = "Marker"
	marker.offset_left = -size.x / 2.0
	marker.offset_top = -size.y / 2.0
	marker.offset_right = size.x / 2.0
	marker.offset_bottom = size.y / 2.0
	marker.color = color
	node.add_child(marker)
	return node


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


func _create_fog_patch(node_name: String, position: Vector2, size: Vector2, alpha: float) -> ColorRect:
	var patch := ColorRect.new()
	patch.name = node_name
	patch.position = position
	patch.size = size
	patch.color = Color(0.62, 0.68, 0.55, alpha)
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
