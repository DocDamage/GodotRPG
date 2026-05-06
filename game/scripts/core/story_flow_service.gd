class_name StoryFlowService
extends RefCounted

const FIRST_SLICE_PATH := "res://data/story/first_slice.json"

var title := ""
var slice_name := ""
var phases: Array[String] = ["character_creator"]
var phase_index := 0
var story_data: Dictionary = {}

func load_first_slice() -> void:
	var file := FileAccess.open(FIRST_SLICE_PATH, FileAccess.READ)
	if file == null:
		push_error("Unable to load first slice story data.")
		return
	story_data = JSON.parse_string(file.get_as_text())
	title = story_data.get("title", "")
	slice_name = story_data.get("slice_name", "")
	phases = ["character_creator"]
	for phase in story_data.get("flow", []):
		phases.append(String(phase))
	phases.append("battle")
	phases.append("truth_recovered")
	phase_index = 0

func current_phase() -> String:
	return phases[phase_index]

func advance() -> String:
	phase_index = min(phase_index + 1, phases.size() - 1)
	return current_phase()

func go_to_phase(phase_id: String) -> bool:
	var next_index := phases.find(phase_id)
	if next_index < 0:
		return false
	phase_index = next_index
	return true

func is_field_phase(phase_id: String = current_phase()) -> bool:
	return story_data.get("flow", []).has(phase_id)

func is_battle_phase(phase_id: String = current_phase()) -> bool:
	return phase_id == "battle"

func format_phase_name(phase_id: String = current_phase()) -> String:
	return phase_id.replace("_", " ").capitalize()

func phase_metadata(phase_id: String = current_phase()) -> Dictionary:
	var all_metadata: Dictionary = story_data.get("phase_metadata", {})
	var fallback := {
		"display_name": format_phase_name(phase_id),
		"mood": "",
		"beat": "",
	}
	return all_metadata.get(phase_id, fallback)
