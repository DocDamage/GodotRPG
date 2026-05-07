class_name HiddenHospitalCorridorMap
extends Node2D

@export var map_id := "hidden_hospital_corridor"

const TileAssetCatalog = preload("res://scripts/field/tile_asset_catalog.gd")

const WALL_RECTS := [
	Rect2(0, 16, 416, 16),
	Rect2(0, 160, 416, 16),
	Rect2(0, 16, 16, 160),
	Rect2(400, 16, 16, 160),
	Rect2(176, 32, 32, 32),
]


func _init() -> void:
	build_map()


func _ready() -> void:
	build_map()


func build_map() -> void:
	_apply_map_metadata()
	if get_node_or_null("CorridorFloor") != null:
		return
	_add_floor()
	_add_landmarks()
	_add_collision()
	_add_atmosphere()


func _apply_map_metadata() -> void:
	set_meta("audio_profile", {
		"map_id": map_id,
		"ambience": "ambience_hidden_hospital",
		"entry": "curator_warning",
		"museum_override": "curator_warning",
	})


func _add_floor() -> void:
	var floor := Sprite2D.new()
	floor.name = "CorridorFloor"
	floor.texture = _texture_for_asset("hidden_hospital_lab_tiles")
	floor.centered = false
	floor.position = Vector2(16, 32)
	floor.z_index = -30
	floor.modulate = Color(0.78, 0.84, 0.82, 0.86)
	floor.set_meta("tile_asset_id", "hidden_hospital_lab_tiles")
	add_child(floor)


func _add_landmarks() -> void:
	var landmarks := Node2D.new()
	landmarks.name = "Landmarks"
	add_child(landmarks)
	landmarks.add_child(_create_sliced_prop("HospitalDoor", Vector2(48, 72), "res://assets/tilesets/first_slice/hospital/sliced/hospital_door.png", 0.34, -7))
	landmarks.add_child(_tag_story_prop(_create_sliced_prop("PatientBed", Vector2(112, 88), "res://assets/tilesets/first_slice/hospital/sliced/patient_bed.png", 0.30, -6), "medical_evidence", "The bed frame is newer than Hallowmere by centuries. The restraints are not."))
	landmarks.add_child(_tag_story_prop(_create_sliced_prop("MedicalChart", Vector2(160, 96), "res://assets/tilesets/first_slice/hospital/sliced/medical_chart.png", 0.58, -5), "memory_fever_record", "Containment trial. Memory fever. Bell vector unstable. Someone recorded the sickness before the town named it sin."))
	landmarks.add_child(_tag_story_prop(_create_sliced_prop("MedicineCabinet", Vector2(224, 80), "res://assets/tilesets/first_slice/hospital/sliced/medicine_cabinet.png", 0.24, -7), "medical_supply", "Sealed bottles line the cabinet. Most labels describe symptoms Mira has seen in prayer, not medicine."))
	landmarks.add_child(_create_sliced_prop("OperatingLight", Vector2(288, 64), "res://assets/tilesets/first_slice/hospital/sliced/operating_light.png", 0.42, -4))
	landmarks.add_child(_create_sliced_prop("IvStand", Vector2(136, 104), "res://assets/tilesets/first_slice/hospital/sliced/iv_stand.png", 0.42, -5))


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
	var flicker := Node2D.new()
	flicker.name = "LightFlicker"
	atmosphere.add_child(flicker)
	flicker.add_child(_create_light_patch("LightPatch01", Vector2(72, 42), Vector2(96, 16), 0.13))
	flicker.add_child(_create_light_patch("LightPatch02", Vector2(220, 54), Vector2(116, 18), 0.10))
	flicker.add_child(_create_light_patch("LightPatch03", Vector2(288, 112), Vector2(76, 14), 0.08))


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


func _create_light_patch(node_name: String, position: Vector2, size: Vector2, alpha: float) -> ColorRect:
	var patch := ColorRect.new()
	patch.name = node_name
	patch.position = position
	patch.size = size
	patch.color = Color(0.78, 0.95, 0.90, alpha)
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
