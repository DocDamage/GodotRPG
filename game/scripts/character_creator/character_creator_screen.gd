extends Control

signal profile_confirmed(profile)

const CharacterCreatorController = preload("res://scripts/character_creator/character_creator_controller.gd")
const ClassCatalog = preload("res://scripts/progression/class_catalog.gd")
const ContentCatalog = preload("res://scripts/core/content_catalog.gd")

const PRONOUN_OPTIONS := ["they/them", "she/her", "he/him"]
const CLASS_OPTIONS := ["vanguard", "spellblade", "mystic", "warden"]
const SPRITE_OPTIONS := ["hero_knight", "hero_cloak", "hero_scout", "hero_scholar"]
const ORIGIN_ECHO_OPTIONS := ["static_hum", "distant_bell", "wet_stone", "paper_names"]
const STARTING_RELIC_OPTIONS := ["cracked_saber", "archive_needle", "guard_shard", "signal_knife"]
const VOICE_BLIP_OPTIONS := ["soft_synthetic", "warm_human", "low_quiet", "sharp_clear"]
const STARTING_MEMORY_CARD_OPTIONS := ["locked_door", "calling_name", "ink_hands", "bell_under_water"]
const PORTRAIT_OPTIONS := ["dwarf_01", "dwarf_12", "halfling_01", "halfling_12", "orc_01", "orc_12", "demon_01", "demon_12", "fairy_01", "fairy_12"]
const ORIGIN_ECHO_LABELS := {
	"static_hum": "Static Hum",
	"distant_bell": "Distant Bell",
	"wet_stone": "Wet Stone",
	"paper_names": "Paper Names",
}
const ORIGIN_ECHO_SUMMARIES := {
	"static_hum": "A clean machine tone under every memory.",
	"distant_bell": "A plague bell heard before any town has a name.",
	"wet_stone": "Water under old stone and locked corridors.",
	"paper_names": "Pages turning where birth records should be.",
}
const STARTING_RELIC_LABELS := {
	"cracked_saber": "Cracked Saber",
	"archive_needle": "Archive Needle",
	"guard_shard": "Guard Shard",
	"signal_knife": "Signal Knife",
}
const STARTING_RELIC_SUMMARIES := {
	"cracked_saber": "A balanced relic blade with a broken museum seal.",
	"archive_needle": "A precise relic for magic/status pressure and careful strikes.",
	"guard_shard": "A defensive relic fragment that remembers how to block.",
	"signal_knife": "A fast relic tuned to cuts, interrupts, and weak signals.",
}
const VOICE_BLIP_LABELS := {
	"soft_synthetic": "Soft Synthetic",
	"warm_human": "Warm Human",
	"low_quiet": "Low Quiet",
	"sharp_clear": "Sharp Clear",
}
const VOICE_BLIP_SUMMARIES := {
	"soft_synthetic": "A restrained synthetic text tone, close to Museum speech.",
	"warm_human": "A warmer text tone with a clear human edge.",
	"low_quiet": "A muted text tone for sparse, guarded delivery.",
	"sharp_clear": "A crisp text tone that cuts through interface noise.",
}
const STARTING_MEMORY_CARD_LABELS := {
	"locked_door": "A Locked Door",
	"calling_name": "Someone Calling",
	"ink_hands": "Ink on Hands",
	"bell_under_water": "Bell Under Water",
}
const STARTING_MEMORY_CARD_SUMMARIES := {
	"locked_door": "A damaged Memory Card showing a door the museum refuses to label.",
	"calling_name": "A damaged Memory Card holding a voice just before it becomes a name.",
	"ink_hands": "A damaged Memory Card stained by records copied too many times.",
	"bell_under_water": "A damaged Memory Card where a bell rings from below a black surface.",
}
const PORTRAIT_LABELS := {
	"dwarf_01": "Portrait D-01",
	"dwarf_12": "Portrait D-12",
	"halfling_01": "Portrait H-01",
	"halfling_12": "Portrait H-12",
	"orc_01": "Portrait O-01",
	"orc_12": "Portrait O-12",
	"demon_01": "Portrait Dm-01",
	"demon_12": "Portrait Dm-12",
	"fairy_01": "Portrait F-01",
	"fairy_12": "Portrait F-12",
}
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
const CLASS_SUMMARIES := {
	"vanguard": "Shielded relic bearer. Reliable front-line defense and steady strikes.",
	"spellblade": "Relic duelist. Balanced blade work, archive magic, and flexible turns.",
	"mystic": "Archive mystic. Strong recovery, contradiction magic, and fragile defenses.",
	"warden": "Museum warden. Guard skills, control effects, and patient counterplay.",
}
const SPRITE_REGIONS := {
	"hero_knight": Rect2(0, 0, 32, 32),
	"hero_cloak": Rect2(32, 0, 32, 32),
	"hero_scout": Rect2(64, 0, 32, 32),
	"hero_scholar": Rect2(96, 0, 32, 32),
}
const PALETTE_OPTIONS := [
	{"hair": "copper", "outfit_primary": "navy", "accent": "gold"},
	{"hair": "silver", "outfit_primary": "black", "accent": "teal"},
	{"hair": "umber", "outfit_primary": "maroon", "accent": "cream"},
	{"hair": "ash", "outfit_primary": "green", "accent": "brass"},
]

@onready var name_edit: LineEdit = %NameEdit
@onready var pronouns_label: Label = %PronounsValue
@onready var class_label: Label = %ClassValue
@onready var class_description_label: Label = %ClassDescription
@onready var stats_label: Label = %StatsValue
@onready var loadout_effect_label: Label = %LoadoutEffectValue
@onready var record_label: Label = %RecordValue
@onready var validation_label: Label = %ValidationValue
@onready var confirm_button: Button = %Confirm
@onready var sprite_label: Label = %SpriteValue
@onready var origin_echo_label: Label = %OriginEchoValue
@onready var origin_echo_description_label: Label = %OriginEchoDescription
@onready var starting_relic_label: Label = %StartingRelicValue
@onready var starting_relic_description_label: Label = %StartingRelicDescription
@onready var voice_blip_label: Label = %VoiceBlipValue
@onready var voice_blip_description_label: Label = %VoiceBlipDescription
@onready var starting_memory_card_label: Label = %StartingMemoryCardValue
@onready var starting_memory_card_description_label: Label = %StartingMemoryCardDescription
@onready var portrait_label: Label = %PortraitValue
@onready var portrait_preview: TextureRect = %PortraitPreview
@onready var dialogue_preview_label: Label = %DialoguePreviewValue
@onready var museum_id_label: Label = %MuseumIdValue
@onready var dossier_label: Label = %DossierValue
@onready var palette_label: Label = %PaletteValue
@onready var preview_panel: Panel = %PreviewPanel
@onready var sprite_preview: TextureRect = %SpritePreview

var player_name := "Sev"
var pronoun_index := 0
var class_index := 0
var sprite_index := 0
var origin_echo_index := 0
var starting_relic_index := 0
var voice_blip_index := 0
var starting_memory_card_index := 0
var portrait_index := 0
var palette_index := 0

func _ready() -> void:
	if name_edit:
		name_edit.text = player_name
		name_edit.text_changed.connect(set_player_name)
	_render()

func set_player_name(value: String) -> void:
	player_name = value
	_render()

func next_pronouns() -> void:
	pronoun_index = _next_index(pronoun_index, PRONOUN_OPTIONS.size())
	_render()

func previous_pronouns() -> void:
	pronoun_index = _previous_index(pronoun_index, PRONOUN_OPTIONS.size())
	_render()

func next_class() -> void:
	class_index = _next_index(class_index, CLASS_OPTIONS.size())
	_render()

func previous_class() -> void:
	class_index = _previous_index(class_index, CLASS_OPTIONS.size())
	_render()

func next_sprite() -> void:
	sprite_index = _next_index(sprite_index, SPRITE_OPTIONS.size())
	_render()

func previous_sprite() -> void:
	sprite_index = _previous_index(sprite_index, SPRITE_OPTIONS.size())
	_render()

func next_origin_echo() -> void:
	origin_echo_index = _next_index(origin_echo_index, ORIGIN_ECHO_OPTIONS.size())
	_render()

func previous_origin_echo() -> void:
	origin_echo_index = _previous_index(origin_echo_index, ORIGIN_ECHO_OPTIONS.size())
	_render()

func next_starting_relic() -> void:
	starting_relic_index = _next_index(starting_relic_index, STARTING_RELIC_OPTIONS.size())
	_render()

func previous_starting_relic() -> void:
	starting_relic_index = _previous_index(starting_relic_index, STARTING_RELIC_OPTIONS.size())
	_render()

func next_voice_blip() -> void:
	voice_blip_index = _next_index(voice_blip_index, VOICE_BLIP_OPTIONS.size())
	_render()

func previous_voice_blip() -> void:
	voice_blip_index = _previous_index(voice_blip_index, VOICE_BLIP_OPTIONS.size())
	_render()

func next_starting_memory_card() -> void:
	starting_memory_card_index = _next_index(starting_memory_card_index, STARTING_MEMORY_CARD_OPTIONS.size())
	_render()

func previous_starting_memory_card() -> void:
	starting_memory_card_index = _previous_index(starting_memory_card_index, STARTING_MEMORY_CARD_OPTIONS.size())
	_render()

func next_portrait() -> void:
	portrait_index = _next_index(portrait_index, PORTRAIT_OPTIONS.size())
	_render()

func previous_portrait() -> void:
	portrait_index = _previous_index(portrait_index, PORTRAIT_OPTIONS.size())
	_render()

func next_palette() -> void:
	palette_index = _next_index(palette_index, PALETTE_OPTIONS.size())
	_render()

func previous_palette() -> void:
	palette_index = _previous_index(palette_index, PALETTE_OPTIONS.size())
	_render()

func current_selection() -> Dictionary:
	return {
		"name": cleaned_player_name(),
		"pronouns": _current_pronouns(),
		"class_id": _current_class_id(),
		"sprite_preset": _current_sprite_preset(),
		"origin_echo": _current_origin_echo(),
		"starting_relic": _current_starting_relic(),
		"voice_blip": _current_voice_blip(),
		"starting_memory_card": _current_starting_memory_card(),
		"portrait_id": _current_portrait(),
		"palette": _current_palette().duplicate(true),
		"uncatalogued_dossier": uncatalogued_dossier(),
	}

func create_profile():
	return CharacterCreatorController.new().create_profile(current_selection())

func apply_profile(profile) -> void:
	if profile == null:
		reset_to_defaults()
		return
	player_name = profile.name
	pronoun_index = _index_or_default(PRONOUN_OPTIONS, profile.pronouns)
	class_index = _index_or_default(CLASS_OPTIONS, profile.class_id)
	sprite_index = _index_or_default(SPRITE_OPTIONS, profile.sprite_preset)
	origin_echo_index = _index_or_default(ORIGIN_ECHO_OPTIONS, profile.origin_echo)
	starting_relic_index = _index_or_default(STARTING_RELIC_OPTIONS, profile.starting_relic)
	voice_blip_index = _index_or_default(VOICE_BLIP_OPTIONS, profile.voice_blip)
	starting_memory_card_index = _index_or_default(STARTING_MEMORY_CARD_OPTIONS, profile.starting_memory_card)
	portrait_index = _index_or_default(PORTRAIT_OPTIONS, profile.portrait_id)
	palette_index = _palette_index_or_default(profile.palette)
	_render()

func reset_to_defaults() -> void:
	player_name = "Sev"
	pronoun_index = 0
	class_index = 0
	sprite_index = 0
	origin_echo_index = 0
	starting_relic_index = 0
	voice_blip_index = 0
	starting_memory_card_index = 0
	portrait_index = 0
	palette_index = 0
	_render()

func randomize_record(seed: int = 0) -> void:
	var offset := maxi(seed, 1)
	player_name = "Sev-%03d" % (abs(seed) % 1000)
	pronoun_index = offset % PRONOUN_OPTIONS.size()
	class_index = offset % CLASS_OPTIONS.size()
	sprite_index = (offset + 1) % SPRITE_OPTIONS.size()
	origin_echo_index = (offset + 2) % ORIGIN_ECHO_OPTIONS.size()
	starting_relic_index = (offset + 1) % STARTING_RELIC_OPTIONS.size()
	voice_blip_index = (offset + 2) % VOICE_BLIP_OPTIONS.size()
	starting_memory_card_index = (offset + 2) % STARTING_MEMORY_CARD_OPTIONS.size()
	portrait_index = offset % PORTRAIT_OPTIONS.size()
	palette_index = (offset + 1) % PALETTE_OPTIONS.size()
	_render()

func class_summary() -> String:
	return CLASS_SUMMARIES.get(_current_class_id(), "")

func sprite_region() -> Rect2:
	return SPRITE_REGIONS.get(_current_sprite_preset(), Rect2(0, 0, 32, 32))

func cleaned_player_name() -> String:
	return _clean_display_name(player_name)

func can_confirm() -> bool:
	return not player_name.strip_edges().is_empty()

func validation_message() -> String:
	if can_confirm():
		return "Record can be confirmed."
	return "Enter an uncatalogued name."

func starting_stats() -> Dictionary:
	return ClassCatalog.new().starting_stats(_current_class_id())

func preview_modified_stats() -> Dictionary:
	var stats := starting_stats()
	var content := ContentCatalog.new()
	var relic := content.item(_current_starting_relic())
	for stat_key in ["strength", "magic", "defense", "speed"]:
		if relic.has(stat_key):
			stats[stat_key] = int(stats.get(stat_key, 0)) + int(relic[stat_key])
	var card := content.memory_card(_current_starting_memory_card())
	var effect: Dictionary = card.get("effect", {})
	if effect.has("guard_bonus"):
		stats.defense = int(stats.get("defense", 0)) + int(effect.guard_bonus)
	if effect.has("turn_priority_bonus"):
		stats.speed = int(stats.get("speed", 0)) + int(effect.turn_priority_bonus)
	return stats

func loadout_effect_summary() -> String:
	var effects: Array[String] = []
	var content := ContentCatalog.new()
	var relic := content.item(_current_starting_relic())
	var stat_labels := {"strength": "STR", "magic": "MAG", "defense": "DEF", "speed": "SPD"}
	for stat_key in ["strength", "magic", "defense", "speed"]:
		if relic.has(stat_key):
			effects.append("%s +%d" % [stat_labels[stat_key], int(relic[stat_key])])
	var card := content.memory_card(_current_starting_memory_card())
	var effect: Dictionary = card.get("effect", {})
	if effect.has("guard_bonus"):
		effects.append("DEF +%d" % int(effect.guard_bonus))
	if effect.has("turn_priority_bonus"):
		effects.append("SPD +%d" % int(effect.turn_priority_bonus))
	if effects.is_empty():
		return "No loadout modifiers."
	return "Loadout Effects: " + ", ".join(effects)

func starting_relic_summary() -> String:
	return STARTING_RELIC_SUMMARIES[_current_starting_relic()]

func voice_blip_summary() -> String:
	return VOICE_BLIP_SUMMARIES[_current_voice_blip()]

func starting_memory_card_summary() -> String:
	return STARTING_MEMORY_CARD_SUMMARIES[_current_starting_memory_card()]

func portrait_path() -> String:
	return PORTRAIT_PATHS[_current_portrait()]

func dialogue_preview() -> String:
	return "CURATOR: %s remains outside assigned parameters. %s should report for correction." % [
		cleaned_player_name() if can_confirm() else "Unnamed",
		_subject_pronoun(),
	]

func museum_id_summary() -> String:
	return "MUSEUM ID\nName: %s\nPronouns: %s\nClass Record: %s\nRelic: %s\nMemory Card: %s\nVoice: %s\nNO EXHIBIT TAG FOUND\nClassification confidence: 17%%" % [
		cleaned_player_name() if can_confirm() else "Unnamed",
		_current_pronouns(),
		_current_class_id().capitalize(),
		STARTING_RELIC_LABELS[_current_starting_relic()],
		STARTING_MEMORY_CARD_LABELS[_current_starting_memory_card()],
		VOICE_BLIP_LABELS[_current_voice_blip()],
	]

func uncatalogued_dossier() -> Dictionary:
	return {
		"classification": "Uncatalogued Docent",
		"confidence": 17,
		"tags": [
			"class:%s" % _current_class_id(),
			"origin_echo:%s" % _current_origin_echo(),
			"memory_card:%s" % _current_starting_memory_card(),
			"relic:%s" % _current_starting_relic(),
			"voice:%s" % _current_voice_blip(),
			"portrait:%s" % _current_portrait(),
		],
		"flags": ["no_exhibit_tag", "classification_unstable"],
		"curator_line": dialogue_preview(),
	}

func dossier_summary() -> String:
	var dossier := uncatalogued_dossier()
	return "DOSSIER\nClassification: %s\nConfidence: %d%%\nTags: %s\nFlags: %s" % [
		dossier.classification,
		int(dossier.confidence),
		", ".join(dossier.tags),
		", ".join(dossier.flags),
	]

func record_summary() -> String:
	var palette: Dictionary = _current_palette()
	return "%s / %s / %s hair / %s. Exhibit origin unresolved." % [
		cleaned_player_name() if can_confirm() else "Unnamed",
		_current_pronouns(),
		String(palette.hair),
		ORIGIN_ECHO_LABELS[_current_origin_echo()],
	]

func confirm_profile() -> void:
	if not can_confirm():
		_play_audio("ui_cancel")
		_render()
		return
	_play_audio("ui_confirm")
	profile_confirmed.emit(create_profile())

func _render() -> void:
	_resolve_late_bound_nodes()
	if pronouns_label:
		pronouns_label.text = _current_pronouns()
	if class_label:
		class_label.text = _current_class_id().capitalize()
	if class_description_label:
		class_description_label.text = class_summary()
	if stats_label:
		stats_label.text = _format_stats(preview_modified_stats())
	if loadout_effect_label:
		loadout_effect_label.text = loadout_effect_summary()
	if record_label:
		record_label.text = record_summary()
	if validation_label:
		validation_label.text = validation_message()
	if confirm_button:
		confirm_button.disabled = not can_confirm()
	if sprite_label:
		sprite_label.text = _current_sprite_preset().replace("_", " ").capitalize()
	if origin_echo_label:
		origin_echo_label.text = ORIGIN_ECHO_LABELS[_current_origin_echo()]
	if origin_echo_description_label:
		origin_echo_description_label.text = ORIGIN_ECHO_SUMMARIES[_current_origin_echo()]
	if starting_relic_label:
		starting_relic_label.text = STARTING_RELIC_LABELS[_current_starting_relic()]
	if starting_relic_description_label:
		starting_relic_description_label.text = starting_relic_summary()
	if voice_blip_label:
		voice_blip_label.text = VOICE_BLIP_LABELS[_current_voice_blip()]
	if voice_blip_description_label:
		voice_blip_description_label.text = voice_blip_summary()
	if starting_memory_card_label:
		starting_memory_card_label.text = STARTING_MEMORY_CARD_LABELS[_current_starting_memory_card()]
	if starting_memory_card_description_label:
		starting_memory_card_description_label.text = starting_memory_card_summary()
	if portrait_label:
		portrait_label.text = PORTRAIT_LABELS[_current_portrait()]
	if portrait_preview:
		portrait_preview.texture = _load_texture_from_path(portrait_path())
	if dialogue_preview_label:
		dialogue_preview_label.text = dialogue_preview()
	if museum_id_label:
		museum_id_label.text = museum_id_summary()
	if dossier_label:
		dossier_label.text = dossier_summary()
	if palette_label:
		var palette: Dictionary = _current_palette()
		palette_label.text = "%s hair / %s coat" % [String(palette.hair).capitalize(), String(palette.outfit_primary).capitalize()]
	if preview_panel:
		preview_panel.modulate = _preview_color()
	if sprite_preview:
		sprite_preview.texture = _sprite_preview_texture()

func _resolve_late_bound_nodes() -> void:
	if dossier_label == null:
		dossier_label = get_node_or_null("%DossierValue")

func _sprite_preview_texture() -> Texture2D:
	var source := _load_preview_source()
	var atlas := AtlasTexture.new()
	atlas.atlas = source
	atlas.region = sprite_region()
	return atlas

func _load_preview_source() -> Texture2D:
	var path := "res://assets/vendor/cute_sckr/characters/herospritesheetrpg.png"
	return _load_texture_from_path(path)

func _load_texture_from_path(path: String) -> Texture2D:
	if ResourceLoader.exists(path, "Texture2D"):
		var loaded = load(path)
		if loaded is Texture2D:
			return loaded
	var image := Image.new()
	if image.load(path) != OK:
		var fallback := Image.create(32, 32, false, Image.FORMAT_RGBA8)
		fallback.fill(Color.WHITE)
		image = fallback
	return ImageTexture.create_from_image(image)

func _preview_color() -> Color:
	match _safe_index(palette_index, PALETTE_OPTIONS.size()):
		1:
			return Color(0.72, 0.92, 0.95)
		2:
			return Color(0.72, 0.28, 0.3)
		3:
			return Color(0.44, 0.62, 0.42)
		_:
			return Color(0.86, 0.56, 0.32)

func _format_stats(stats: Dictionary) -> String:
	return "HP %d   MP %d   STR %d   MAG %d   DEF %d   SPD %d" % [
		stats.get("max_hp", 0),
		stats.get("max_mp", 0),
		stats.get("strength", 0),
		stats.get("magic", 0),
		stats.get("defense", 0),
		stats.get("speed", 0),
	]

func _clean_display_name(value: String) -> String:
	var stripped := value.strip_edges()
	if stripped.is_empty():
		return "Unnamed"
	return stripped.substr(0, 24)

func _next_index(current: int, size: int) -> int:
	return (current + 1) % size

func _previous_index(current: int, size: int) -> int:
	return (current - 1 + size) % size

func _current_pronouns() -> String:
	return PRONOUN_OPTIONS[_safe_index(pronoun_index, PRONOUN_OPTIONS.size())]

func _current_class_id() -> String:
	return CLASS_OPTIONS[_safe_index(class_index, CLASS_OPTIONS.size())]

func _current_sprite_preset() -> String:
	return SPRITE_OPTIONS[_safe_index(sprite_index, SPRITE_OPTIONS.size())]

func _current_origin_echo() -> String:
	return ORIGIN_ECHO_OPTIONS[_safe_index(origin_echo_index, ORIGIN_ECHO_OPTIONS.size())]

func _current_starting_relic() -> String:
	return STARTING_RELIC_OPTIONS[_safe_index(starting_relic_index, STARTING_RELIC_OPTIONS.size())]

func _current_voice_blip() -> String:
	return VOICE_BLIP_OPTIONS[_safe_index(voice_blip_index, VOICE_BLIP_OPTIONS.size())]

func _current_starting_memory_card() -> String:
	return STARTING_MEMORY_CARD_OPTIONS[_safe_index(starting_memory_card_index, STARTING_MEMORY_CARD_OPTIONS.size())]

func _current_portrait() -> String:
	return PORTRAIT_OPTIONS[_safe_index(portrait_index, PORTRAIT_OPTIONS.size())]

func _current_palette() -> Dictionary:
	return PALETTE_OPTIONS[_safe_index(palette_index, PALETTE_OPTIONS.size())]

func _safe_index(value: int, size: int) -> int:
	if size <= 0:
		return 0
	if value < 0 or value >= size:
		return 0
	return value

func _index_or_default(options: Array, value) -> int:
	if typeof(value) != TYPE_STRING:
		return 0
	var found := options.find(value)
	return found if found >= 0 else 0

func _palette_index_or_default(value) -> int:
	if typeof(value) != TYPE_DICTIONARY:
		return 0
	for index in PALETTE_OPTIONS.size():
		var palette: Dictionary = PALETTE_OPTIONS[index]
		if palette.get("hair", "") == value.get("hair", "") and palette.get("outfit_primary", "") == value.get("outfit_primary", ""):
			return index
	return 0

func _subject_pronoun() -> String:
	match _current_pronouns():
		"she/her":
			return "she"
		"he/him":
			return "he"
		_:
			return "they"

func _on_pronouns_previous_pressed() -> void:
	_play_audio("ui_cancel")
	previous_pronouns()

func _on_pronouns_next_pressed() -> void:
	_play_audio("ui_confirm")
	next_pronouns()

func _on_class_previous_pressed() -> void:
	_play_audio("ui_cancel")
	previous_class()

func _on_class_next_pressed() -> void:
	_play_audio("ui_confirm")
	next_class()

func _on_sprite_previous_pressed() -> void:
	_play_audio("ui_cancel")
	previous_sprite()

func _on_sprite_next_pressed() -> void:
	_play_audio("ui_confirm")
	next_sprite()

func _on_origin_echo_previous_pressed() -> void:
	_play_audio("ui_cancel")
	previous_origin_echo()

func _on_origin_echo_next_pressed() -> void:
	_play_audio("ui_confirm")
	next_origin_echo()

func _on_starting_relic_previous_pressed() -> void:
	_play_audio("ui_cancel")
	previous_starting_relic()

func _on_starting_relic_next_pressed() -> void:
	_play_audio("ui_confirm")
	next_starting_relic()

func _on_voice_blip_previous_pressed() -> void:
	_play_audio("ui_cancel")
	previous_voice_blip()

func _on_voice_blip_next_pressed() -> void:
	_play_audio("ui_confirm")
	next_voice_blip()

func _on_starting_memory_card_previous_pressed() -> void:
	_play_audio("ui_cancel")
	previous_starting_memory_card()

func _on_starting_memory_card_next_pressed() -> void:
	_play_audio("ui_confirm")
	next_starting_memory_card()

func _on_portrait_previous_pressed() -> void:
	_play_audio("ui_cancel")
	previous_portrait()

func _on_portrait_next_pressed() -> void:
	_play_audio("ui_confirm")
	next_portrait()

func _on_palette_previous_pressed() -> void:
	_play_audio("ui_cancel")
	previous_palette()

func _on_palette_next_pressed() -> void:
	_play_audio("ui_confirm")
	next_palette()

func _on_confirm_pressed() -> void:
	confirm_profile()

func _on_randomize_pressed() -> void:
	_play_audio("ui_confirm")
	randomize_record(Time.get_ticks_msec() % 1000)

func _on_reset_pressed() -> void:
	_play_audio("ui_cancel")
	reset_to_defaults()

func _play_audio(event_id: String) -> void:
	if not is_inside_tree():
		return
	var audio := get_node_or_null("/root/Audio")
	if audio and audio.has_method("play_event"):
		audio.play_event(event_id)
