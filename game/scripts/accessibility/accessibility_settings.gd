class_name AccessibilitySettings
extends Resource

@export_range(0.01, 0.2, 0.01) var text_speed_seconds_per_character: float = 0.035
@export_range(0.75, 2.0, 0.05) var menu_scale: float = 1.0
@export var high_contrast_ui: bool = false
@export var reduced_flashing: bool = false
@export_enum("wait", "active") var atb_mode: String = "wait"
@export_range(0.05, 0.6, 0.01) var controller_deadzone: float = 0.2
@export_enum("auto", "xbox", "playstation", "switch", "keyboard") var controller_glyph_family: String = "auto"
@export_enum("windowed", "fullscreen") var window_mode: String = "windowed"
@export_range(0.0, 1.0, 0.01) var master_volume: float = 1.0
@export_range(0.0, 1.0, 0.01) var music_volume: float = 1.0
@export_range(0.0, 1.0, 0.01) var ambience_volume: float = 1.0
@export_range(0.0, 1.0, 0.01) var sfx_volume: float = 1.0
@export_range(0.0, 1.0, 0.01) var ui_volume: float = 1.0
@export_range(0.0, 1.0, 0.01) var dialogue_volume: float = 1.0
@export_range(0.0, 1.0, 0.01) var combat_volume: float = 1.0
@export_range(0.0, 1.0, 0.01) var environment_volume: float = 1.0

func to_dict() -> Dictionary:
	return {
		"text_speed_seconds_per_character": text_speed_seconds_per_character,
		"menu_scale": menu_scale,
		"high_contrast_ui": high_contrast_ui,
		"reduced_flashing": reduced_flashing,
		"atb_mode": atb_mode,
		"controller_deadzone": controller_deadzone,
		"controller_glyph_family": controller_glyph_family,
		"window_mode": window_mode,
		"master_volume": master_volume,
		"music_volume": music_volume,
		"ambience_volume": ambience_volume,
		"sfx_volume": sfx_volume,
		"ui_volume": ui_volume,
		"dialogue_volume": dialogue_volume,
		"combat_volume": combat_volume,
		"environment_volume": environment_volume,
	}

static func from_dict(data: Dictionary) -> Resource:
	var SettingsScript = load("res://scripts/accessibility/accessibility_settings.gd")
	var settings = SettingsScript.new()
	settings.text_speed_seconds_per_character = data.get("text_speed_seconds_per_character", settings.text_speed_seconds_per_character)
	settings.menu_scale = data.get("menu_scale", settings.menu_scale)
	settings.high_contrast_ui = _valid_bool(data.get("high_contrast_ui", settings.high_contrast_ui))
	settings.reduced_flashing = _valid_bool(data.get("reduced_flashing", settings.reduced_flashing))
	settings.atb_mode = _valid_atb_mode(data.get("atb_mode", settings.atb_mode))
	settings.controller_deadzone = clampf(float(data.get("controller_deadzone", settings.controller_deadzone)), 0.05, 0.6)
	settings.controller_glyph_family = _valid_glyph_family(data.get("controller_glyph_family", settings.controller_glyph_family))
	settings.window_mode = _valid_window_mode(data.get("window_mode", settings.window_mode))
	settings.master_volume = _valid_volume(data.get("master_volume", settings.master_volume))
	settings.music_volume = _valid_volume(data.get("music_volume", settings.music_volume))
	settings.ambience_volume = _valid_volume(data.get("ambience_volume", settings.ambience_volume))
	settings.sfx_volume = _valid_volume(data.get("sfx_volume", settings.sfx_volume))
	settings.ui_volume = _valid_volume(data.get("ui_volume", settings.ui_volume))
	settings.dialogue_volume = _valid_volume(data.get("dialogue_volume", settings.dialogue_volume))
	settings.combat_volume = _valid_volume(data.get("combat_volume", settings.combat_volume))
	settings.environment_volume = _valid_volume(data.get("environment_volume", settings.environment_volume))
	return settings

static func _valid_glyph_family(value) -> String:
	if typeof(value) == TYPE_STRING and ["auto", "xbox", "playstation", "switch", "keyboard"].has(value):
		return value
	return "auto"

static func _valid_atb_mode(value) -> String:
	if typeof(value) == TYPE_STRING and ["wait", "active"].has(value):
		return value
	return "wait"

static func _valid_window_mode(value) -> String:
	if typeof(value) == TYPE_STRING and ["windowed", "fullscreen"].has(value):
		return value
	return "windowed"

static func _valid_volume(value) -> float:
	return clampf(float(value), 0.0, 1.0)

static func _valid_bool(value) -> bool:
	if typeof(value) == TYPE_BOOL:
		return value
	if typeof(value) == TYPE_STRING:
		return value.to_lower() in ["true", "1", "yes", "on"]
	if typeof(value) == TYPE_INT or typeof(value) == TYPE_FLOAT:
		return float(value) != 0.0
	return false
