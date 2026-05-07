class_name InputPromptService
extends RefCounted

const KEYBOARD_LABELS := {
	"interact": "E / Enter",
	"cancel": "Esc",
	"menu": "Esc / Start",
	"ui_accept": "Enter",
	"ui_cancel": "Esc",
	"page_left": "Q",
	"page_right": "R",
}
const XBOX_LABELS := {
	"interact": "A",
	"cancel": "B",
	"menu": "Menu",
	"ui_accept": "A",
	"ui_cancel": "B",
	"page_left": "LB",
	"page_right": "RB",
}
const PLAYSTATION_LABELS := {
	"interact": "Cross",
	"cancel": "Circle",
	"menu": "Options",
	"ui_accept": "Cross",
	"ui_cancel": "Circle",
	"page_left": "L1",
	"page_right": "R1",
}
const SWITCH_LABELS := {
	"interact": "B",
	"cancel": "A",
	"menu": "Plus",
	"ui_accept": "B",
	"ui_cancel": "A",
	"page_left": "L",
	"page_right": "R",
}


func action_label(action: String, device_family: String = "keyboard") -> String:
	var labels := _labels_for_family(device_family)
	return String(labels.get(action, action.capitalize()))


func mixed_action_label(action: String, controller_family: String = "xbox") -> String:
	return "%s / %s" % [action_label(action, controller_family), action_label(action, "keyboard").split(" / ")[-1]]


func resolve_glyph_family(preference: String, detected_device_name: String = "") -> String:
	if ["xbox", "playstation", "switch", "keyboard"].has(preference):
		return preference
	return device_family_from_name(detected_device_name)


func device_family_from_name(device_name: String) -> String:
	var lower := device_name.to_lower()
	if lower.contains("dualshock") or lower.contains("dualsense") or lower.contains("playstation") or lower.contains("ps4") or lower.contains("ps5"):
		return "playstation"
	if lower.contains("switch") or lower.contains("nintendo") or lower.contains("joy-con") or lower.contains("joycon"):
		return "switch"
	if lower.contains("xbox") or lower.contains("xinput"):
		return "xbox"
	return "xbox"


func _labels_for_family(device_family: String) -> Dictionary:
	match device_family:
		"xbox":
			return XBOX_LABELS
		"playstation":
			return PLAYSTATION_LABELS
		"switch":
			return SWITCH_LABELS
		_:
			return KEYBOARD_LABELS
