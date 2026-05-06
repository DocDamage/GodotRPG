class_name TetraCardView
extends Control

const TetraRulesScript := preload("res://scripts/cards/tetra_rules.gd")
const TetraCardTemplateCatalogScript := preload("res://scripts/cards/tetra_card_template_catalog.gd")

const TYPE_LABELS := {
	"PHYSICAL": "P",
	"MAGICAL": "M",
	"FLEXIBLE": "X",
	"ASSAULT": "A",
}
const DIRECTIONS := ["N", "NE", "E", "SE", "S", "SW", "W", "NW"]

var _rules := TetraRulesScript.new()
var _templates := TetraCardTemplateCatalogScript.new()


func _ready() -> void:
	_ensure_nodes()


func apply_card(card: Dictionary) -> void:
	_ensure_nodes()
	var display := display_data(card)
	$NameLabel.text = display.name
	$PowerLabel.text = display.power
	$PhysicalDefenseLabel.text = display.physical_defense
	$MagicDefenseLabel.text = display.magic_defense
	$TypeLabel.text = display.card_type
	$ArrowLabel.text = " ".join(display.active_directions)
	_set_texture($TemplateTexture, display.template_path)
	_set_texture($ArtTexture, display.image)


func display_data(card: Dictionary) -> Dictionary:
	var active_directions: Array[String] = []
	for direction in DIRECTIONS:
		if _rules.has_arrow(card, direction):
			active_directions.append(direction)

	return {
		"name": str(card.get("name", "")),
		"power": _rules.to_hex_stat(int(card.get("power", 0))),
		"physical_defense": _rules.to_hex_stat(int(card.get("physical_defense", 0))),
		"magic_defense": _rules.to_hex_stat(int(card.get("magic_defense", 0))),
		"card_type": TYPE_LABELS.get(str(card.get("card_type", "PHYSICAL")), "P"),
		"active_directions": active_directions,
		"image": str(card.get("image", "")),
		"template_path": _templates.path_for_id(str(card.get("template", TetraCardTemplateCatalogScript.DEFAULT_TEMPLATE_ID))),
	}


func _ensure_nodes() -> void:
	custom_minimum_size = Vector2(160, 224)
	if has_node("TemplateTexture"):
		return

	var template_texture := TextureRect.new()
	template_texture.name = "TemplateTexture"
	template_texture.set_anchors_preset(Control.PRESET_FULL_RECT)
	template_texture.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	template_texture.stretch_mode = TextureRect.STRETCH_SCALE
	add_child(template_texture)

	var art_texture := TextureRect.new()
	art_texture.name = "ArtTexture"
	art_texture.position = Vector2(20, 34)
	art_texture.size = Vector2(120, 96)
	art_texture.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	art_texture.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	add_child(art_texture)

	_add_label("NameLabel", Vector2(16, 10), Vector2(128, 20), 14, HORIZONTAL_ALIGNMENT_CENTER)
	_add_label("PowerLabel", Vector2(20, 144), Vector2(28, 24), 18, HORIZONTAL_ALIGNMENT_CENTER)
	_add_label("TypeLabel", Vector2(66, 144), Vector2(28, 24), 18, HORIZONTAL_ALIGNMENT_CENTER)
	_add_label("PhysicalDefenseLabel", Vector2(20, 178), Vector2(28, 20), 14, HORIZONTAL_ALIGNMENT_CENTER)
	_add_label("MagicDefenseLabel", Vector2(112, 178), Vector2(28, 20), 14, HORIZONTAL_ALIGNMENT_CENTER)
	_add_label("ArrowLabel", Vector2(20, 202), Vector2(120, 18), 10, HORIZONTAL_ALIGNMENT_CENTER)


func _add_label(node_name: String, node_position: Vector2, node_size: Vector2, font_size: int, alignment: HorizontalAlignment) -> Label:
	var label := Label.new()
	label.name = node_name
	label.position = node_position
	label.size = node_size
	label.horizontal_alignment = alignment
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override("font_size", font_size)
	add_child(label)
	return label


func _set_texture(texture_rect: TextureRect, path: String) -> void:
	if path.is_empty() or not ResourceLoader.exists(path):
		texture_rect.texture = null
		return
	texture_rect.texture = load(path)
