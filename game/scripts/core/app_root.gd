extends Control

const CharacterCreatorScene = preload("res://scenes/character_creator/character_creator_screen.tscn")
const PrototypeFieldScene = preload("res://scenes/field/prototype_field.tscn")
const PrototypeBattleScene = preload("res://scenes/battle/prototype_battle.tscn")
const StoryFlowService = preload("res://scripts/core/story_flow_service.gd")
const VistaCatalog = preload("res://scripts/core/vista_catalog.gd")

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
	game_state.add_inventory_items(payload.get("loot", {}))
	var relic_loot := {}
	for relic_id in payload.get("relics", []):
		relic_loot[relic_id] = int(relic_loot.get(relic_id, 0)) + 1
	game_state.add_inventory_items(relic_loot)
	for card_id in payload.get("memory_cards", []):
		game_state.acquire_memory_card(String(card_id))
	game_state.flags.erase("pending_battle_payload")
	var next_phase := String(payload.get("next_flow", "truth_recovered"))
	if not story_flow.go_to_phase(next_phase):
		story_flow.go_to_phase("truth_recovered")
	game_state.map_id = story_flow.current_phase()
	_sync_scene()
	_update_labels()

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
