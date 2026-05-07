extends Control

const CharacterCreatorScene = preload("res://scenes/character_creator/character_creator_screen.tscn")
const PrototypeFieldScene = preload("res://scenes/field/prototype_field.tscn")
const PrototypeBattleScene = preload("res://scenes/battle/prototype_battle.tscn")
const StoryFlowService = preload("res://scripts/core/story_flow_service.gd")
const VistaCatalog = preload("res://scripts/core/vista_catalog.gd")
const ContentCatalog = preload("res://scripts/core/content_catalog.gd")

@onready var title_label: Label = %TitleLabel
@onready var flow_label: Label = %FlowLabel
@onready var scene_host: Node = %SceneHost

var story_flow := StoryFlowService.new()
var vista_catalog := VistaCatalog.new()
var game_state_override = null

func _ready() -> void:
	_resolve_late_bound_nodes()
	story_flow.load_first_slice()
	_sync_scene()
	_update_labels()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		_advance_flow()
	elif event.is_action_pressed("menu"):
		var game_state = _game_state()
		if game_state != null:
			game_state.save_manual_slot()
		_play_audio("curator_warning")

func _advance_flow() -> void:
	_play_audio("ui_confirm")
	if story_flow.current_phase() == "character_creator":
		return
	elif story_flow.current_phase() == "truth_recovered":
		var game_state = _game_state()
		if game_state != null and game_state.flags.has("pending_reward_dialogue"):
			game_state.flags.erase("pending_reward_dialogue")
	else:
		story_flow.advance()
		var game_state = _game_state()
		if game_state != null:
			game_state.map_id = story_flow.current_phase()
	_sync_scene()
	_update_labels()

func _on_character_profile_confirmed(profile) -> void:
	var game_state = _game_state()
	if game_state == null:
		return
	game_state.start_new_game(profile)
	story_flow.advance()
	game_state.map_id = story_flow.current_phase()
	_sync_scene()
	_update_labels()

func _on_field_battle_launch_requested(payload: Dictionary) -> void:
	if story_flow.phases.size() <= 1:
		story_flow.load_first_slice()
	var game_state = _game_state()
	if game_state == null:
		return
	game_state.flags.pending_battle_payload = payload.duplicate(true)
	game_state.map_id = "battle"
	story_flow.go_to_phase("battle")
	_sync_scene()
	_update_labels()

func _on_battle_completed(payload: Dictionary) -> void:
	var game_state = _game_state()
	if game_state == null:
		return
	var pending_battle_payload: Dictionary = game_state.flags.get("pending_battle_payload", {})
	game_state.apply_party_battle_state(payload.get("party_state", []))
	game_state.add_party_xp(int(payload.get("xp", 0)))
	game_state.add_inventory_items(payload.get("loot", {}))
	var relic_loot := {}
	for relic_id in payload.get("relics", []):
		if int(game_state.inventory.get(relic_id, 0)) <= 0:
			relic_loot[relic_id] = 1
	game_state.add_inventory_items(relic_loot)
	for card_id in payload.get("memory_cards", []):
		game_state.acquire_memory_card(String(card_id))
	_apply_bell_saint_completion_state(game_state, payload)
	game_state.flags.erase("pending_battle_payload")
	var next_phase := String(payload.get("next_flow", ""))
	if next_phase.is_empty():
		next_phase = String(pending_battle_payload.get("source_phase", ""))
		if pending_battle_payload.has("source_position"):
			game_state.player_position = pending_battle_payload.source_position
	if next_phase.is_empty():
		next_phase = "truth_recovered"
	if not story_flow.go_to_phase(next_phase):
		story_flow.go_to_phase("truth_recovered")
	game_state.map_id = story_flow.current_phase()
	_sync_scene()
	_update_labels()

func _apply_bell_saint_completion_state(game_state, payload: Dictionary) -> void:
	if not payload.get("relics", []).has("bell_clapper") and not payload.get("memory_cards", []).has("bell_saint"):
		return
	game_state.recruit_party_member("mira_venn")
	game_state.flags["mira_venn_recruited"] = true
	game_state.flags["chapter_01_complete"] = true
	game_state.flags["boss_bell_saint_defeated"] = true
	game_state.flags["pending_reward_dialogue"] = {
		"section": "rewards",
		"scene": "memory_card_unlock",
	}

func _update_labels() -> void:
	_resolve_late_bound_nodes()
	if title_label == null or flow_label == null:
		return
	title_label.text = story_flow.title
	var game_state = _game_state()
	var hero_name: String = game_state.profile.name if game_state != null and game_state.profile else "New hero"
	flow_label.text = "%s\nSlice: %s\nPhase: %s\nInteract advances the prototype flow. Menu saves the manual slot." % [
		hero_name,
		story_flow.slice_name,
		story_flow.format_phase_name(),
	]

func _sync_scene() -> void:
	_resolve_late_bound_nodes()
	if scene_host == null:
		return
	for child in scene_host.get_children():
		scene_host.remove_child(child)
		child.queue_free()
	if story_flow.current_phase() == "character_creator":
		var creator_scene := CharacterCreatorScene.instantiate()
		creator_scene.profile_confirmed.connect(_on_character_profile_confirmed)
		scene_host.add_child(creator_scene)
	elif story_flow.is_field_phase():
		var field_scene := PrototypeFieldScene.instantiate()
		field_scene.set("phase_metadata", story_flow.phase_metadata())
		field_scene.set("vista_metadata", vista_catalog.vista_for_phase(story_flow.current_phase()))
		field_scene.battle_launch_requested.connect(_on_field_battle_launch_requested)
		scene_host.add_child(field_scene)
	elif story_flow.is_battle_phase():
		var battle_scene := PrototypeBattleScene.instantiate()
		battle_scene.battle_completed.connect(_on_battle_completed)
		scene_host.add_child(battle_scene)
	elif story_flow.current_phase() == "truth_recovered":
		scene_host.add_child(_create_reward_scene_panel())

func _create_reward_scene_panel() -> Control:
	var panel := PanelContainer.new()
	panel.name = "RewardScenePanel"
	panel.custom_minimum_size = Vector2(640, 240)
	var margin := MarginContainer.new()
	margin.name = "Content"
	margin.add_theme_constant_override("margin_left", 18)
	margin.add_theme_constant_override("margin_top", 18)
	margin.add_theme_constant_override("margin_right", 18)
	margin.add_theme_constant_override("margin_bottom", 18)
	panel.add_child(margin)
	var label := Label.new()
	label.name = "RewardText"
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.text = _reward_scene_text()
	margin.add_child(label)
	var prompt := Label.new()
	prompt.name = "AcknowledgePrompt"
	prompt.text = "Interact: continue"
	prompt.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	prompt.position = Vector2(0, 206)
	margin.add_child(prompt)
	return panel

func _reward_scene_text() -> String:
	var game_state = _game_state()
	var reward_scene: Dictionary = game_state.flags.get("pending_reward_dialogue", {}) if game_state != null else {}
	if reward_scene.is_empty():
		return "Chapter 1 Complete\n\nThe Bell Saint has fallen.\nThe Plague Wing anchor has been recovered."
	var section := String(reward_scene.get("section", "rewards"))
	var scene := String(reward_scene.get("scene", "memory_card_unlock"))
	var catalog := ContentCatalog.new()
	var dialogue := catalog.dialogue_scene(section, scene)
	var lines: Array = dialogue.get("lines", [])
	var text_lines: Array[String] = []
	text_lines.append_array(_reward_summary_lines(game_state, catalog))
	for line in lines:
		text_lines.append("%s: %s" % [String(line.get("speaker", "")), String(line.get("text", ""))])
	text_lines.append("CURATOR: Unauthorized truth recovered. Correction required.")
	return "\n".join(text_lines)

func _reward_summary_lines(game_state, catalog: ContentCatalog) -> Array[String]:
	if game_state == null:
		return []
	var lines: Array[String] = []
	if int(game_state.inventory.get("bell_clapper", 0)) > 0:
		var relic := catalog.item("bell_clapper")
		lines.append("Anchor Recovered: %s" % String(relic.get("display_name", "Bell Clapper")))
	if game_state.memory_cards.get("owned", []).has("bell_saint"):
		var card := catalog.memory_card("bell_saint")
		lines.append("Memory Card: %s" % String(card.get("display_name", "The Bell Saint")))
	if game_state.party.any(func(member): return String(member.get("id", "")) == "mira_venn"):
		lines.append("Mira Venn joined the party.")
	if not lines.is_empty():
		lines.append("")
	return lines

func _game_state():
	if game_state_override != null:
		return game_state_override
	return get_node_or_null("/root/GameState") if is_inside_tree() else null

func _play_audio(event_id: String) -> void:
	if not is_inside_tree():
		return
	var audio = get_node_or_null("/root/Audio")
	if audio and audio.has_method("play_event"):
		audio.play_event(event_id)

func _resolve_late_bound_nodes() -> void:
	if title_label == null:
		title_label = get_node_or_null("%TitleLabel")
	if flow_label == null:
		flow_label = get_node_or_null("%FlowLabel")
	if scene_host == null:
		scene_host = get_node_or_null("%SceneHost")
