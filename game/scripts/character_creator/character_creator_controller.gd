class_name CharacterCreatorController
extends RefCounted

const PlayerProfile = preload("res://scripts/core/player_profile.gd")

const VALID_CLASSES := ["vanguard", "spellblade", "mystic", "warden"]
const VALID_PRONOUNS := ["they/them", "she/her", "he/him"]
const VALID_SPRITES := ["hero_knight", "hero_cloak", "hero_scout", "hero_scholar"]
const VALID_ORIGIN_ECHOES := ["static_hum", "distant_bell", "wet_stone", "paper_names"]
const VALID_STARTING_RELICS := ["cracked_saber", "archive_needle", "guard_shard", "signal_knife"]
const VALID_VOICE_BLIPS := ["soft_synthetic", "warm_human", "low_quiet", "sharp_clear"]
const VALID_STARTING_MEMORY_CARDS := ["locked_door", "calling_name", "ink_hands", "bell_under_water"]
const VALID_PORTRAITS := ["dwarf_01", "dwarf_12", "halfling_01", "halfling_12", "orc_01", "orc_12", "demon_01", "demon_12", "fairy_01", "fairy_12"]

func create_profile(selection: Dictionary) -> PlayerProfile:
	var profile := PlayerProfile.new()
	profile.name = _clean_name(selection.get("name", profile.name))
	profile.pronouns = _valid_option(selection.get("pronouns", profile.pronouns), VALID_PRONOUNS, profile.pronouns)
	profile.class_id = _valid_class(selection.get("class_id", profile.class_id))
	profile.sprite_preset = _valid_option(selection.get("sprite_preset", profile.sprite_preset), VALID_SPRITES, profile.sprite_preset)
	profile.palette = _valid_palette(selection.get("palette", {}))
	profile.origin_echo = _valid_option(selection.get("origin_echo", profile.origin_echo), VALID_ORIGIN_ECHOES, profile.origin_echo)
	profile.starting_relic = _valid_option(selection.get("starting_relic", profile.starting_relic), VALID_STARTING_RELICS, profile.starting_relic)
	profile.voice_blip = _valid_option(selection.get("voice_blip", profile.voice_blip), VALID_VOICE_BLIPS, profile.voice_blip)
	profile.starting_memory_card = _valid_option(selection.get("starting_memory_card", profile.starting_memory_card), VALID_STARTING_MEMORY_CARDS, profile.starting_memory_card)
	profile.portrait_id = _valid_option(selection.get("portrait_id", profile.portrait_id), VALID_PORTRAITS, profile.portrait_id)
	profile.uncatalogued_dossier = _valid_dossier(selection.get("uncatalogued_dossier", {}), profile)
	return profile

func _clean_name(value: String) -> String:
	var stripped := value.strip_edges()
	if stripped.is_empty():
		return "Hero"
	return stripped.substr(0, 24)

func _valid_class(value: String) -> String:
	if VALID_CLASSES.has(value):
		return value
	return "vanguard"

func _valid_option(value, valid_options: Array, fallback: String) -> String:
	if typeof(value) == TYPE_STRING and valid_options.has(value):
		return value
	return fallback

func _valid_palette(value) -> Dictionary:
	if typeof(value) != TYPE_DICTIONARY:
		return {}
	return value.duplicate(true)

func _valid_dossier(value, profile: PlayerProfile) -> Dictionary:
	if typeof(value) == TYPE_DICTIONARY and value.has("classification"):
		return PlayerProfile.from_dict({"uncatalogued_dossier": value}).uncatalogued_dossier
	return {
		"classification": "Uncatalogued Docent",
		"confidence": 17,
		"tags": [
			"class:%s" % profile.class_id,
			"origin_echo:%s" % profile.origin_echo,
			"memory_card:%s" % profile.starting_memory_card,
			"relic:%s" % profile.starting_relic,
		],
		"flags": ["no_exhibit_tag", "classification_unstable"],
		"curator_line": "%s remains outside assigned parameters. %s should report for correction." % [
			profile.name,
			_subject_pronoun(profile.pronouns),
		],
	}

func _subject_pronoun(pronouns: String) -> String:
	match pronouns:
		"she/her":
			return "she"
		"he/him":
			return "he"
		_:
			return "they"
