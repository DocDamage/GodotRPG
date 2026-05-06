extends Node2D

var entry: Dictionary = {}
var entry_kind := "interactable"

func configure(data: Dictionary, kind: String) -> void:
	entry = data.duplicate(true)
	entry_kind = kind
	name = String(entry.get("id", "map_interactable"))
	position = _vector_from_dict(entry.get("position", {}))
	add_to_group("interactables")
	_render_marker()

func interact() -> Dictionary:
	var display_name := String(entry.get("name", name))
	var line := String(entry.get("line", ""))
	var status := line
	if entry_kind == "npc" and not display_name.is_empty():
		status = "%s: %s" % [display_name, line]
	return {
		"type": "map_line",
		"status": status,
		"audio_event": "ui_confirm",
		"entry": entry,
		"kind": entry_kind,
	}

func _render_marker() -> void:
	for child in get_children():
		child.queue_free()
	var marker := ColorRect.new()
	marker.name = "Marker"
	marker.offset_left = -5.0
	marker.offset_top = -5.0
	marker.offset_right = 5.0
	marker.offset_bottom = 5.0
	marker.color = Color(0.58, 0.78, 0.95, 1.0) if entry_kind == "npc" else Color(0.92, 0.76, 0.36, 1.0)
	add_child(marker)
	var label := Label.new()
	label.name = "Label"
	label.position = Vector2(8, -10)
	label.add_theme_font_size_override("font_size", 9)
	label.text = String(entry.get("name", name))
	add_child(label)

func _vector_from_dict(value) -> Vector2:
	if value is Dictionary:
		return Vector2(float(value.get("x", 0.0)), float(value.get("y", 0.0)))
	return Vector2.ZERO
