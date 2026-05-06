class_name PlayerProfile
extends Resource

const AccessibilitySettings = preload("res://scripts/accessibility/accessibility_settings.gd")

const VALID_PRONOUNS := ["they/them", "she/her", "he/him"]
const VALID_CLASSES := ["vanguard", "spellblade", "mystic", "warden"]
const VALID_SPRITES := ["hero_knight", "hero_cloak", "hero_scout", "hero_scholar"]
const VALID_ORIGIN_ECHOES := ["static_hum", "distant_bell", "wet_stone", "paper_names"]
const VALID_STARTING_RELICS := ["cracked_saber", "archive_needle", "guard_shard", "signal_knife"]
const VALID_VOICE_BLIPS := ["soft_synthetic", "warm_human", "low_quiet", "sharp_clear"]
const VALID_STARTING_MEMORY_CARDS := ["locked_door", "calling_name", "ink_hands", "bell_under_water"]
const VALID_PORTRAITS := ["dwarf_01", "dwarf_12", "halfling_01", "halfling_12", "orc_01", "orc_12", "demon_01", "demon_12", "fairy_01", "fairy_12"]

@export var name: String = "Hero"
@export var pronouns: String = "they/them"
@export var class_id: String = "vanguard"
@export var sprite_preset: String = "hero_knight"
@export var palette: Dictionary = {}
@export var origin_echo: String = "static_hum"
@export var starting_relic: String = "cracked_saber"
@export var voice_blip: String = "soft_synthetic"
@export var starting_memory_card: String = "locked_door"
@export var portrait_id: String = "dwarf_01"
@export var uncatalogued_dossier: Dictionary = {}
@export var accessibility: Resource = AccessibilitySettings.new()

func to_dict() -> Dictionary:
	return {
		"name": name,
		"pronouns": pronouns,
		"class_id": class_id,
		"sprite_preset": sprite_preset,
		"palette": palette.duplicate(true),
		"origin_echo": origin_echo,
		"starting_relic": starting_relic,
		"voice_blip": voice_blip,
		"starting_memory_card": starting_memory_card,
		"portrait_id": portrait_id,
		"uncatalogued_dossier": uncatalogued_dossier.duplicate(true),
		"accessibility": accessibility.to_dict(),
	}

static func from_dict(data: Dictionary) -> Resource:
	var ProfileScript = load("res://scripts/core/player_profile.gd")
	var profile = ProfileScript.new()
	profile.name = _clean_name(data.get("name", profile.name))
	profile.pronouns = _valid_option(data.get("pronouns", profile.pronouns), VALID_PRONOUNS, profile.pronouns)
	profile.class_id = _valid_option(data.get("class_id", profile.class_id), VALID_CLASSES, profile.class_id)
	profile.sprite_preset = _valid_option(data.get("sprite_preset", profile.sprite_preset), VALID_SPRITES, profile.sprite_preset)
	profile.palette = _valid_palette(data.get("palette", {}))
	profile.origin_echo = _valid_option(data.get("origin_echo", profile.origin_echo), VALID_ORIGIN_ECHOES, profile.origin_echo)
	profile.starting_relic = _valid_option(data.get("starting_relic", profile.starting_relic), VALID_STARTING_RELICS, profile.starting_relic)
	profile.voice_blip = _valid_option(data.get("voice_blip", profile.voice_blip), VALID_VOICE_BLIPS, profile.voice_blip)
	profile.starting_memory_card = _valid_option(data.get("starting_memory_card", profile.starting_memory_card), VALID_STARTING_MEMORY_CARDS, profile.starting_memory_card)
	profile.portrait_id = _valid_option(data.get("portrait_id", profile.portrait_id), VALID_PORTRAITS, profile.portrait_id)
	profile.uncatalogued_dossier = _valid_dossier(data.get("uncatalogued_dossier", {}))
	profile.accessibility = AccessibilitySettings.from_dict(data.get("accessibility", {}))
	return profile

static func _clean_name(value) -> String:
	if typeof(value) != TYPE_STRING:
		return "Hero"
	var stripped: String = value.strip_edges()
	if stripped.is_empty():
		return "Hero"
	return stripped.substr(0, 24)

static func _valid_option(value, valid_options: Array, fallback: String) -> String:
	if typeof(value) == TYPE_STRING and valid_options.has(value):
		return value
	return fallback

static func _valid_palette(value) -> Dictionary:
	if typeof(value) != TYPE_DICTIONARY:
		return {}
	return value.duplicate(true)

static func _valid_dossier(value) -> Dictionary:
	if typeof(value) != TYPE_DICTIONARY:
		return {}
	var tags: Array = []
	for tag in value.get("tags", []):
		if typeof(tag) == TYPE_STRING:
			tags.append(tag)
	var flags: Array = []
	for flag in value.get("flags", []):
		if typeof(flag) == TYPE_STRING:
			flags.append(flag)
	if flags.is_empty():
		flags.append("no_exhibit_tag")
	return {
		"classification": str(value.get("classification", "Uncatalogued Docent")),
		"confidence": clampi(int(value.get("confidence", 17)), 0, 100),
		"tags": tags,
		"flags": flags,
		"curator_line": str(value.get("curator_line", "")),
	}
