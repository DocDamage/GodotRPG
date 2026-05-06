class_name AudioService
extends Node

const AudioEventCatalog = preload("res://scripts/core/audio_event_catalog.gd")

var catalog := AudioEventCatalog.new()

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
	var stream := load(event.path)
	if stream == null:
		push_warning("Audio event file not found: %s" % event.path)
		return null
	var player := AudioStreamPlayer.new()
	player.stream = stream
	player.bus = event.get("bus", "SFX")
	player.finished.connect(player.queue_free)
	add_child(player)
	player.play()
	return player
