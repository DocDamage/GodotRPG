class_name PortraitCatalog
extends RefCounted

const DEFAULT_PORTRAIT_ID := "dwarf_01"

const PORTRAIT_PATHS := {
	"dwarf_01": "res://assets/portraits/creator/portrait_dwarf_01.png",
	"dwarf_12": "res://assets/portraits/creator/portrait_dwarf_12.png",
	"halfling_01": "res://assets/portraits/creator/portrait_halfling_01.png",
	"halfling_12": "res://assets/portraits/creator/portrait_halfling_12.png",
	"orc_01": "res://assets/portraits/creator/portrait_orc_01.png",
	"orc_12": "res://assets/portraits/creator/portrait_orc_12.png",
	"demon_01": "res://assets/portraits/creator/portrait_demon_01.png",
	"demon_12": "res://assets/portraits/creator/portrait_demon_12.png",
	"fairy_01": "res://assets/portraits/creator/portrait_fairy_01.png",
	"fairy_12": "res://assets/portraits/creator/portrait_fairy_12.png",
}

func path_for_id(portrait_id: String) -> String:
	return PORTRAIT_PATHS.get(portrait_id, PORTRAIT_PATHS[DEFAULT_PORTRAIT_ID])

func has_portrait(portrait_id: String) -> bool:
	return PORTRAIT_PATHS.has(portrait_id)
