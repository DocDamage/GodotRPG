class_name AccessibilitySettings
extends Resource

@export_range(0.01, 0.2, 0.01) var text_speed_seconds_per_character: float = 0.035
@export_range(0.75, 2.0, 0.05) var menu_scale: float = 1.0
@export var high_contrast_ui: bool = false
@export var reduced_flashing: bool = false
@export_enum("wait", "active") var atb_mode: String = "wait"

func to_dict() -> Dictionary:
	return {
		"text_speed_seconds_per_character": text_speed_seconds_per_character,
		"menu_scale": menu_scale,
		"high_contrast_ui": high_contrast_ui,
		"reduced_flashing": reduced_flashing,
		"atb_mode": atb_mode,
	}

static func from_dict(data: Dictionary) -> Resource:
	var SettingsScript = load("res://scripts/accessibility/accessibility_settings.gd")
	var settings = SettingsScript.new()
	settings.text_speed_seconds_per_character = data.get("text_speed_seconds_per_character", settings.text_speed_seconds_per_character)
	settings.menu_scale = data.get("menu_scale", settings.menu_scale)
	settings.high_contrast_ui = data.get("high_contrast_ui", settings.high_contrast_ui)
	settings.reduced_flashing = data.get("reduced_flashing", settings.reduced_flashing)
	settings.atb_mode = data.get("atb_mode", settings.atb_mode)
	return settings
