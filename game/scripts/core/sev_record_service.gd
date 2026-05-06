class_name SevRecordService
extends RefCounted

const ClassCatalog = preload("res://scripts/progression/class_catalog.gd")
const ContentCatalog = preload("res://scripts/core/content_catalog.gd")
const PortraitCatalog = preload("res://scripts/core/portrait_catalog.gd")
const VoiceBlipCatalog = preload("res://scripts/core/voice_blip_catalog.gd")

func summary(profile) -> Dictionary:
	if profile == null:
		return {}
	var content := ContentCatalog.new()
	var relic: Dictionary = content.item(profile.starting_relic)
	var card: Dictionary = content.memory_card(profile.starting_memory_card)
	return {
		"name": profile.name,
		"class_id": profile.class_id,
		"class_name": _class_display_name(profile.class_id),
		"relic_id": profile.starting_relic,
		"relic_name": relic.get("display_name", profile.starting_relic),
		"memory_card_id": profile.starting_memory_card,
		"memory_card_name": card.get("display_name", profile.starting_memory_card),
		"voice_id": profile.voice_blip,
		"voice_event": VoiceBlipCatalog.new().event_for_id(profile.voice_blip),
		"portrait_id": profile.portrait_id,
		"portrait_path": PortraitCatalog.new().path_for_id(profile.portrait_id),
		"dossier": _dossier_or_default(profile),
	}

func field_line(profile) -> String:
	var data := summary(profile)
	if data.is_empty():
		return ""
	return "%s / %s / %s / %s" % [
		data.name,
		data.class_name,
		data.relic_name,
		data.memory_card_name,
	]

func battle_line(profile) -> String:
	var data := summary(profile)
	if data.is_empty():
		return ""
	return "Loadout: %s + %s" % [data.relic_name, data.memory_card_name]

func _class_display_name(class_id: String) -> String:
	var classes: Dictionary = ClassCatalog.CLASSES
	return classes.get(class_id, classes.vanguard).get("display_name", class_id.capitalize())

func _dossier_or_default(profile) -> Dictionary:
	if profile.uncatalogued_dossier.is_empty():
		return {
			"classification": "Uncatalogued Docent",
			"confidence": 17,
			"tags": [],
			"flags": ["no_exhibit_tag"],
			"curator_line": "",
		}
	return profile.uncatalogued_dossier.duplicate(true)
