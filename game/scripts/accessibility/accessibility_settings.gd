class_name AccessibilitySettings
extends Resource

@export_range(0.01, 0.2, 0.01) var text_speed_seconds_per_character: float = 0.035
@export_range(0.75, 2.0, 0.05) var menu_scale: float = 1.0
@export var high_contrast_ui: bool = false
@export var reduced_flashing: bool = false
@export_enum("wait", "active") var atb_mode: String = "wait"
@export_range(0.05, 0.6, 0.01) var controller_deadzone: float = 0.2
@export_enum("auto", "xbox", "playstation", "switch", "keyboard") var controller_glyph_family: String = "auto"

func to_dict() -> Dictionary:
	return {
		"text_speed_seconds_per_character": text_speed_seconds_per_character,
		"menu_scale": menu_scale,
		"high_contrast_ui": high_contrast_ui,
		"reduced_flashing": reduced_flashing,
		"atb_mode": atb_mode,
		"controller_deadzone": controller_deadzone,
		"controller_glyph_family": controller_glyph_family,
	}

static func from_dict(data: Dictionary) -> Resource:
	var SettingsScript = load("res://scripts/accessibility/accessibility_settings.gd")
	var settings = SettingsScript.new()
	settings.text_speed_seconds_per_character = data.get("text_speed_seconds_per_character", settings.text_speed_seconds_per_character)
	settings.menu_scale = data.get("menu_scale", settings.menu_scale)
	settings.high_contrast_ui = data.get("high_contrast_ui", settings.high_contrast_ui)
	settings.reduced_flashing = data.get("reduced_flashing", settings.reduced_flashing)
	settings.atb_mode = data.get("atb_mode", settings.atb_mode)
	settings.controller_deadzone = clampf(float(data.get("controller_deadzone", settings.controller_deadzone)), 0.05, 0.6)
	settings.controller_glyph_family = _valid_glyph_family(data.get("controller_glyph_family", settings.controller_glyph_family))
	return settings

static func _valid_glyph_family(value) -> String:
	if typeof(value) == TYPE_STRING and ["auto", "xbox", "playstation", "switch", "keyboard"].has(value):
		return value
	return "auto"
