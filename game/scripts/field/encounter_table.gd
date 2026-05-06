class_name EncounterTable
extends RefCounted

var region_id: String
var entries: Array
var step_threshold: int

func _init(p_region_id: String = "", p_entries: Array = [], p_step_threshold: int = 16) -> void:
	region_id = p_region_id
	entries = p_entries
	step_threshold = p_step_threshold

func should_check(steps_since_last_check: int) -> bool:
	return steps_since_last_check >= step_threshold

func pick(roll: float) -> String:
	if entries.is_empty():
		return ""
	var total_weight := 0.0
	for entry in entries:
		total_weight += float(entry.get("weight", 1))
	var cursor := clampf(roll, 0.0, 0.999999) * total_weight
	for entry in entries:
		cursor -= float(entry.get("weight", 1))
		if cursor < 0.0:
			return entry.get("id", "")
	return entries.back().get("id", "")
