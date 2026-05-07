class_name AudioService
extends Node

const AudioEventCatalog = preload("res://scripts/core/audio_event_catalog.gd")

var catalog := AudioEventCatalog.new()
var current_ambience_event_id := ""
var current_ambience_player: AudioStreamPlayer = null

func _exit_tree() -> void:
	_free_audio_players()

func _notification(what: int) -> void:
	if what == NOTIFICATION_PREDELETE:
		_free_audio_players()

func resolve_event(event_id: String) -> Dictionary:
	var event := catalog.event(event_id)
	if event.is_empty():
		return {}
	var resolved := event.duplicate(true)
	resolved.id = event_id
	return resolved

func play_event(event_id: String) -> AudioStreamPlayer:
	var event := resolve_event(event_id)
	if event.is_empty():
		return null
	var stream := _load_audio_stream(String(event.path))
	if stream == null:
		return null
	var player := AudioStreamPlayer.new()
	player.stream = stream
	player.bus = event.get("bus", "SFX")
	player.finished.connect(player.queue_free)
	add_child(player)
	if player.is_inside_tree() and _should_start_playback():
		player.play()
	return player

func play_ambience(event_id: String) -> AudioStreamPlayer:
	if event_id.is_empty():
		stop_ambience()
		return null
	if current_ambience_event_id == event_id and is_instance_valid(current_ambience_player):
		return current_ambience_player
	stop_ambience()
	var event := resolve_event(event_id)
	if event.is_empty():
		return null
	var stream = _load_audio_stream(String(event.path))
	if stream == null:
		return null
	stream.set("loop", true)
	var player := AudioStreamPlayer.new()
	player.stream = stream
	player.bus = event.get("bus", "Environment")
	add_child(player)
	if player.is_inside_tree() and _should_start_playback():
		player.play()
	current_ambience_event_id = event_id
	current_ambience_player = player
	return player

func stop_ambience() -> void:
	if is_instance_valid(current_ambience_player):
		current_ambience_player.stop()
		current_ambience_player.stream = null
		current_ambience_player.free()
	current_ambience_player = null
	current_ambience_event_id = ""

func stop_all() -> void:
	_free_audio_players()

func _free_audio_players() -> void:
	if is_instance_valid(current_ambience_player):
		current_ambience_player.stop()
	current_ambience_player = null
	current_ambience_event_id = ""
	for child in get_children():
		if child is AudioStreamPlayer:
			child.stop()
			child.stream = null
			child.free()

func _load_audio_stream(path: String) -> AudioStream:
	if path.is_empty() or not FileAccess.file_exists(path):
		return null
	if path.get_extension().to_lower() == "ogg":
		return AudioStreamOggVorbis.load_from_file(path)
	return load(path)

func _should_start_playback() -> bool:
	return DisplayServer.get_name() != "headless"
