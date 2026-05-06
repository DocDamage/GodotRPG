extends Control

const DialogueService = preload("res://scripts/dialogue/dialogue_service.gd")
const PortraitCatalog = preload("res://scripts/core/portrait_catalog.gd")
const VoiceBlipCatalog = preload("res://scripts/core/voice_blip_catalog.gd")

@onready var speaker_label: Label = %SpeakerLabel
@onready var line_label: Label = %LineLabel
@onready var portrait_rect: TextureRect = get_node_or_null("%PortraitRect")
@onready var continue_prompt: Label = get_node_or_null("%ContinuePrompt")

var lines: Array[String] = []
var line_index := 0

func show_dialogue(dialogue: Dictionary, profile: Dictionary) -> void:
	_resolve_late_bound_nodes()
	if speaker_label == null or line_label == null:
		return
	speaker_label.text = dialogue.get("speaker", "")
	lines = DialogueService.new().prepare_lines(dialogue, profile)
	line_index = 0
	_show_portrait(resolve_portrait_path(dialogue, profile))
	_play_voice_blip(resolve_voice_event(dialogue, profile))
	_show_current_line()
	if continue_prompt != null:
		continue_prompt.visible = true

func resolve_portrait_path(dialogue: Dictionary, profile: Dictionary) -> String:
	var speaker: String = dialogue.get("speaker", "")
	if speaker.to_upper() != "SEV" and speaker.to_upper() != "PLAYER":
		return ""
	return PortraitCatalog.new().path_for_id(profile.get("portrait_id", ""))

func resolve_voice_event(dialogue: Dictionary, profile: Dictionary) -> String:
	var speaker: String = dialogue.get("speaker", "")
	if speaker.to_upper() == "SEV" or speaker.to_upper() == "PLAYER":
		return VoiceBlipCatalog.new().event_for_id(profile.get("voice_blip", ""))
	return VoiceBlipCatalog.new().event_for_speaker(speaker)

func advance() -> bool:
	if line_index + 1 >= lines.size():
		return false
	line_index += 1
	_show_current_line()
	return true

func _show_current_line() -> void:
	_resolve_late_bound_nodes()
	if line_label == null:
		return
	line_label.text = lines[line_index] if not lines.is_empty() else ""

func _play_voice_blip(event_id: String) -> void:
	if event_id.is_empty():
		return
	if not is_inside_tree():
		return
	var audio := get_node_or_null("/root/Audio")
	if audio and audio.has_method("play_event"):
		audio.play_event(event_id)

func _show_portrait(path: String) -> void:
	_resolve_late_bound_nodes()
	if portrait_rect == null:
		return
	if path.is_empty():
		portrait_rect.texture = null
		portrait_rect.visible = false
		return
	portrait_rect.texture = _load_texture_from_path(path)
	portrait_rect.visible = portrait_rect.texture != null

func _load_texture_from_path(path: String) -> Texture2D:
	if ResourceLoader.exists(path, "Texture2D"):
		var loaded = load(path)
		if loaded is Texture2D:
			return loaded
	var image := Image.new()
	if image.load(path) != OK:
		return null
	return ImageTexture.create_from_image(image)

func _resolve_late_bound_nodes() -> void:
	if speaker_label == null:
		speaker_label = get_node_or_null("%SpeakerLabel")
	if line_label == null:
		line_label = get_node_or_null("%LineLabel")
	if portrait_rect == null:
		portrait_rect = get_node_or_null("%PortraitRect")
	if continue_prompt == null:
		continue_prompt = get_node_or_null("%ContinuePrompt")
