class_name TetraCardTemplateCatalog
extends RefCounted

const DEFAULT_TEMPLATE_ID := "frame"

const TEMPLATES := {
	"frame": "res://assets/cards/templates/card_frame_template.png",
	"vintage": "res://assets/cards/templates/vintage_frame_template.png",
	"cookie": "res://assets/cards/templates/cookie_theme_template.png",
}


func path_for_id(template_id: String) -> String:
	return TEMPLATES.get(template_id, TEMPLATES[DEFAULT_TEMPLATE_ID])


func all_templates() -> Dictionary:
	return TEMPLATES.duplicate()
