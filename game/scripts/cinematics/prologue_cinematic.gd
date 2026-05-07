extends Control

signal prologue_completed

const DATA_PATH := "res://data/cinematics/prologue.json"

@onready var parallax_layer: Node2D = get_node_or_null("%ParallaxLayer")
@onready var vista_pane_layer: HBoxContainer = get_node_or_null("%VistaPaneLayer")
@onready var marcher_layer: Node2D = get_node_or_null("%MarcherLayer")
@onready var weather_layer: Node2D = get_node_or_null("%WeatherLayer")
@onready var caption_label: Label = get_node_or_null("%CaptionLabel")
@onready var prompt_label: Label = get_node_or_null("%PromptLabel")
@onready var progress_bar: ProgressBar = get_node_or_null("%ProgressBar")

var data: Dictionary = {}
var data_path := DATA_PATH
var warn_on_missing_data := true
var elapsed := 0.0
var is_finished := false
var _caption_index := -1
var _rendered := false

func _ready() -> void:
	ensure_rendered()

func ensure_rendered() -> void:
	if _rendered:
		return
	_resolve_nodes()
	data = _load_data()
	_set_prompt_text()
	_build_parallax()
	_build_vista_panes()
	_build_marchers()
	_build_weather()
	_update_caption()
	_update_progress_bar()
	_play_audio(String(data.get("audio_event", "")))
	_rendered = true

func _process(delta: float) -> void:
	ensure_rendered()
	if is_finished:
		return
	elapsed += delta
	_animate_parallax()
	_animate_marchers()
	_animate_weather()
	_update_caption()
	_update_progress_bar()
	var captions: Array = data.get("captions", [])
	if not captions.is_empty() and elapsed >= float(captions.back().get("time", 0.0)) + 4.0:
		finish()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") or event.is_action_pressed("ui_accept") or event.is_action_pressed("cancel"):
		finish()
		if is_inside_tree():
			get_viewport().set_input_as_handled()

func seek_to(time_seconds: float) -> void:
	ensure_rendered()
	elapsed = maxf(0.0, time_seconds)
	_caption_index = -1
	_update_caption()
	_update_progress_bar()

func caption_progress() -> float:
	var captions: Array = data.get("captions", [])
	if captions.is_empty():
		return 1.0
	var end_time := float(captions.back().get("time", 0.0)) + 4.0
	if end_time <= 0.0:
		return 1.0
	return clampf(elapsed / end_time, 0.0, 1.0)

func finish() -> void:
	if is_finished:
		return
	is_finished = true
	prologue_completed.emit()

func _load_data() -> Dictionary:
	var file := FileAccess.open(data_path, FileAccess.READ)
	if file == null:
		if warn_on_missing_data:
			push_warning("Unable to load prologue cinematic data. Using fallback prologue.")
		return _fallback_data()
	var parsed = JSON.parse_string(file.get_as_text())
	return parsed if parsed is Dictionary else _fallback_data()

func _fallback_data() -> Dictionary:
	return {
		"audio_event": "",
		"captions": [
			{"time": 0.0, "speaker": "ARCHIVE", "text": "The Last World Museum preserved the end by making it walk in circles."}
		],
		"vista_panes": [],
		"parallax_layers": [],
		"weather_patches": [],
	}

func _resolve_nodes() -> void:
	if parallax_layer == null:
		parallax_layer = get_node_or_null("%ParallaxLayer")
	if parallax_layer == null:
		parallax_layer = get_node_or_null("ParallaxLayer")
	if vista_pane_layer == null:
		vista_pane_layer = get_node_or_null("%VistaPaneLayer")
	if vista_pane_layer == null:
		vista_pane_layer = get_node_or_null("VistaPaneLayer")
	if marcher_layer == null:
		marcher_layer = get_node_or_null("%MarcherLayer")
	if marcher_layer == null:
		marcher_layer = get_node_or_null("MarcherLayer")
	if weather_layer == null:
		weather_layer = get_node_or_null("%WeatherLayer")
	if weather_layer == null:
		weather_layer = get_node_or_null("WeatherLayer")
	if caption_label == null:
		caption_label = get_node_or_null("%CaptionLabel")
	if caption_label == null:
		caption_label = get_node_or_null("CaptionLabel")
	if prompt_label == null:
		prompt_label = get_node_or_null("%PromptLabel")
	if prompt_label == null:
		prompt_label = get_node_or_null("PromptLabel")
	if progress_bar == null:
		progress_bar = get_node_or_null("%ProgressBar")
	if progress_bar == null:
		progress_bar = get_node_or_null("ProgressBar")

func _set_prompt_text() -> void:
	if prompt_label != null:
		prompt_label.text = "Interact / Enter / Esc: Skip"

func _update_progress_bar() -> void:
	if progress_bar != null:
		progress_bar.value = caption_progress() * 100.0

func _build_parallax() -> void:
	if parallax_layer == null:
		return
	for layer_data in data.get("parallax_layers", []):
		var texture_rect := TextureRect.new()
		texture_rect.name = String(layer_data.get("id", "Parallax")).to_pascal_case()
		texture_rect.texture = _load_texture(String(layer_data.get("texture", "")))
		texture_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		texture_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
		texture_rect.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		var position := _vector_from_dict(layer_data.get("position", {}))
		var size := _vector_from_dict(layer_data.get("size", {"x": 960, "y": 160}))
		texture_rect.position = position
		texture_rect.size = size
		texture_rect.modulate = _color_from_array(layer_data.get("modulate", [1.0, 1.0, 1.0, 1.0]))
		texture_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
		texture_rect.set_meta("base_position", position)
		texture_rect.set_meta("speed", float(layer_data.get("speed", 0.0)))
		parallax_layer.add_child(texture_rect)

func _build_vista_panes() -> void:
	if vista_pane_layer == null:
		return
	for pane_data in data.get("vista_panes", []):
		var frame := PanelContainer.new()
		frame.name = String(pane_data.get("id", "Vista")).to_pascal_case()
		frame.custom_minimum_size = Vector2(126, 176)
		frame.modulate = Color(0.84, 0.90, 0.90, 0.72)
		var stack := VBoxContainer.new()
		stack.name = "Stack"
		frame.add_child(stack)
		var texture := TextureRect.new()
		texture.name = "Image"
		texture.custom_minimum_size = Vector2(126, 136)
		texture.texture = _load_texture(String(pane_data.get("texture", "")))
		texture.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		texture.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
		texture.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		stack.add_child(texture)
		var label := Label.new()
		label.name = "Label"
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label.add_theme_font_size_override("font_size", 10)
		label.text = String(pane_data.get("label", "EXHIBIT"))
		stack.add_child(label)
		vista_pane_layer.add_child(frame)

func _build_marchers() -> void:
	if marcher_layer == null:
		return
	for i in range(3):
		var marcher := ColorRect.new()
		marcher.name = "DocentSilhouette%d" % (i + 1)
		marcher.color = Color(0.08, 0.10, 0.12, 0.92)
		marcher.size = Vector2(18, 34)
		marcher.position = Vector2(210 + i * 46, 344 + i * 7)
		marcher.set_meta("base_position", marcher.position)
		marcher.set_meta("phase", float(i) * 0.8)
		marcher_layer.add_child(marcher)
		var head := ColorRect.new()
		head.name = "Head"
		head.color = Color(0.10, 0.13, 0.15, 0.95)
		head.size = Vector2(14, 10)
		head.position = Vector2(2, -10)
		marcher.add_child(head)

func _build_weather() -> void:
	if weather_layer == null:
		return
	for patch_data in data.get("weather_patches", []):
		var rect := ColorRect.new()
		rect.name = String(patch_data.get("id", "Weather")).to_pascal_case()
		var patch_rect := _rect_from_dict(patch_data.get("rect", {}))
		rect.position = patch_rect.position
		rect.size = patch_rect.size
		rect.color = _color_from_array(patch_data.get("color", [0.6, 0.7, 0.7, 0.12]))
		rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
		rect.set_meta("base_position", rect.position)
		rect.set_meta("speed", float(patch_data.get("speed", -10.0)))
		weather_layer.add_child(rect)

func _update_caption() -> void:
	if caption_label == null:
		return
	var captions: Array = data.get("captions", [])
	var next_index := 0
	for i in range(captions.size()):
		if elapsed >= float(captions[i].get("time", 0.0)):
			next_index = i
	if next_index == _caption_index or captions.is_empty():
		return
	_caption_index = next_index
	var caption: Dictionary = captions[_caption_index]
	caption_label.text = "%s\n%s" % [String(caption.get("speaker", "ARCHIVE")), String(caption.get("text", ""))]

func _animate_parallax() -> void:
	if parallax_layer == null:
		return
	for child in parallax_layer.get_children():
		if child is Control:
			var base: Vector2 = child.get_meta("base_position", child.position)
			var speed := float(child.get_meta("speed", 0.0))
			child.position.x = base.x + fmod(elapsed * speed, 96.0)

func _animate_marchers() -> void:
	if marcher_layer == null:
		return
	for child in marcher_layer.get_children():
		if child is Control:
			var base: Vector2 = child.get_meta("base_position", child.position)
			var phase := float(child.get_meta("phase", 0.0))
			child.position = base + Vector2(sin(elapsed * 1.5 + phase) * 3.0, sin(elapsed * 5.0 + phase) * 2.0)

func _animate_weather() -> void:
	if weather_layer == null:
		return
	for child in weather_layer.get_children():
		if child is Control:
			var base: Vector2 = child.get_meta("base_position", child.position)
			var speed := float(child.get_meta("speed", 0.0))
			child.position.x = wrapf(base.x + elapsed * speed, -260.0, 960.0)

func _load_texture(path: String) -> Texture2D:
	if path.is_empty() or not ResourceLoader.exists(path):
		return null
	return load(path)

func _vector_from_dict(value) -> Vector2:
	if value is Dictionary:
		return Vector2(float(value.get("x", 0.0)), float(value.get("y", 0.0)))
	return Vector2.ZERO

func _rect_from_dict(value) -> Rect2:
	if value is Dictionary:
		return Rect2(float(value.get("x", 0.0)), float(value.get("y", 0.0)), float(value.get("w", 0.0)), float(value.get("h", 0.0)))
	return Rect2()

func _color_from_array(value) -> Color:
	if value is Array and value.size() >= 4:
		return Color(float(value[0]), float(value[1]), float(value[2]), float(value[3]))
	return Color.WHITE

func _play_audio(event_id: String) -> void:
	if event_id.is_empty() or not is_inside_tree():
		return
	var audio = get_node_or_null("/root/Audio")
	if audio and audio.has_method("play_event"):
		audio.play_event(event_id)
