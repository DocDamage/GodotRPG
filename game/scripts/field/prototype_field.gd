extends Node2D

signal battle_launch_requested(payload: Dictionary)

const FieldController = preload("res://scripts/field/field_controller.gd")
const EncounterTable = preload("res://scripts/field/encounter_table.gd")
const SevRecordService = preload("res://scripts/core/sev_record_service.gd")
const ContentCatalog = preload("res://scripts/core/content_catalog.gd")
const MapCatalog = preload("res://scripts/field/map_catalog.gd")
const TileAssetCatalog = preload("res://scripts/field/tile_asset_catalog.gd")
const FieldObjectiveCatalog = preload("res://scripts/field/field_objective_catalog.gd")
const FieldStoryTriggerCatalog = preload("res://scripts/field/field_story_trigger_catalog.gd")
const MapInteractable = preload("res://scripts/field/map_interactable.gd")
const DialogueBoxScene = preload("res://scenes/dialogue/dialogue_box.tscn")
const AUTHORED_MAP_SCENES := {
	"hallowmere_street": "res://scenes/field/maps/hallowmere_street_map.tscn",
	"mira_apothecary": "res://scenes/field/maps/mira_apothecary_map.tscn",
	"sainted_bell_chapel": "res://scenes/field/maps/sainted_bell_chapel_map.tscn",
	"underchapel_drain": "res://scenes/field/maps/underchapel_drain_map.tscn",
	"hidden_hospital_corridor": "res://scenes/field/maps/hidden_hospital_corridor_map.tscn",
	"bell_tower_boss_room": "res://scenes/field/maps/bell_tower_boss_room_map.tscn",
}
const ENEMIES_PATH := "res://data/combat/enemies.json"
const ENCOUNTERS_PATH := "res://data/encounters/plague_wing.json"
const BATTLE_SCENE_PATH := "res://scenes/battle/prototype_battle.tscn"
const ENCOUNTER_STEP_DISTANCE := 16.0

@onready var player: CharacterBody2D = %Player
@onready var status_label: Label = %StatusLabel
@onready var objective_label: Label = %ObjectiveLabel
@onready var phase_label: Label = %PhaseLabel

var field := FieldController.new()
var phase_metadata: Dictionary = {}
var vista_metadata: Dictionary = {}
var map_phase_id := ""
var current_map: Dictionary = {}
var active_transition_zones: Array = []
var max_unlocked_route_index := 0
var triggered_story_events: Array[String] = []
var active_dialogue_lines: Array = []
var active_dialogue_index := -1
var dialogue_box: Control = null
var steps_since_encounter_check := 0
var encounter_travel_pixels := 0.0
var last_encounter_player_position := Vector2.ZERO
var has_encounter_player_position := false
var game_state_override = null

const FIRST_SLICE_ROUTE := [
	"empty_rotunda",
	"broken_exhibit_door",
	"plague_town_street",
	"apothecary_house",
	"chapel",
	"underchapel_drain",
	"hidden_hospital_corridor",
	"bell_tower_boss_room",
]

const GRAYBOX_PALETTES := {
	"sterile_museum": {
		"floor": Color(0.28, 0.32, 0.34, 1.0),
		"wall": Color(0.12, 0.15, 0.17, 1.0),
	},
	"museum_plague_breach": {
		"floor": Color(0.25, 0.28, 0.28, 1.0),
		"wall": Color(0.16, 0.13, 0.16, 1.0),
	},
	"plague_mud": {
		"floor": Color(0.24, 0.19, 0.13, 1.0),
		"wall": Color(0.12, 0.10, 0.08, 1.0),
	},
	"warm_medicine": {
		"floor": Color(0.32, 0.24, 0.17, 1.0),
		"wall": Color(0.16, 0.10, 0.08, 1.0),
	},
	"cold_chapel": {
		"floor": Color(0.25, 0.25, 0.29, 1.0),
		"wall": Color(0.10, 0.10, 0.13, 1.0),
	},
	"sewer_museum_pipes": {
		"floor": Color(0.15, 0.23, 0.19, 1.0),
		"wall": Color(0.08, 0.12, 0.11, 1.0),
	},
	"white_corridor": {
		"floor": Color(0.48, 0.52, 0.50, 1.0),
		"wall": Color(0.20, 0.23, 0.24, 1.0),
	},
	"bell_saint": {
		"floor": Color(0.30, 0.24, 0.25, 1.0),
		"wall": Color(0.12, 0.08, 0.10, 1.0),
	},
}

func _ready() -> void:
	_ensure_dialogue_box()
	load_phase_map()
	_render_phase_metadata()

func _physics_process(_delta: float) -> void:
	if check_player_transition():
		return
	record_player_travel_for_encounters()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		try_context_action()

func try_context_action() -> bool:
	if is_dialogue_active():
		return advance_dialogue()
	if _is_boss_room_ready():
		return request_battle_launch()
	return _try_interact()

func _try_interact() -> bool:
	var targets := []
	for node in get_tree().get_nodes_in_group("interactables"):
		if node is Node2D:
			targets.append({"id": node.name, "position": node.global_position, "radius": 16, "node": node})
	var target := field.find_facing_interaction(player.global_position, player.facing, targets)
	if target.is_empty():
		status_label.text = ""
		return false
	if target.node.has_method("interact"):
		var result: Dictionary = target.node.interact()
		var resolved := field.resolve_interaction_result(result)
		_play_audio(resolved.audio_event)
		status_label.text = resolved.status
		return true
	return false

func load_phase_map() -> void:
	var phase_id := map_phase_id
	if phase_id.is_empty():
		phase_id = String(phase_metadata.get("id", ""))
	if phase_id.is_empty():
		phase_id = String(phase_metadata.get("phase_id", ""))
	if phase_id.is_empty():
		phase_id = String(phase_metadata.get("display_name", "")).to_snake_case()
	current_map = MapCatalog.new().map_for_phase(phase_id)
	map_phase_id = phase_id
	steps_since_encounter_check = 0
	_unlock_route_through(phase_id)
	_render_map_content()
	_reset_encounter_travel_tracking()
	_render_current_objective()
	_render_phase_metadata()
	_render_boss_readiness()
	_run_entry_story_trigger(phase_id)

func active_transitions() -> Array:
	return active_transition_zones.duplicate(true)

func mounted_map_audio_profile() -> Dictionary:
	var authored_root := get_node_or_null("MapContent/AuthoredMap")
	if authored_root == null or authored_root.get_child_count() == 0:
		return {}
	var mounted_map := authored_root.get_child(0)
	if not mounted_map.has_meta("audio_profile"):
		return {}
	return mounted_map.get_meta("audio_profile", {}).duplicate(true)

func transition_at(position: Vector2) -> Dictionary:
	return field.resolve_transition(position, active_transition_zones)

func check_player_transition() -> bool:
	_resolve_late_bound_nodes()
	if player == null:
		return false
	var transition := transition_at(player.position)
	if transition.is_empty():
		return false
	var target_phase := String(transition.get("target_phase", ""))
	if not can_enter_phase(target_phase):
		_show_locked_transition_status(target_phase)
		return false
	return change_to_phase(target_phase, transition.get("spawn", Vector2.ZERO))

func change_to_phase(phase_id: String, spawn_position := Vector2.ZERO) -> bool:
	if phase_id.is_empty():
		return false
	if not can_enter_phase(phase_id):
		_show_locked_transition_status(phase_id)
		return false
	var target_map := MapCatalog.new().map_for_phase(phase_id)
	if target_map.is_empty():
		return false
	map_phase_id = phase_id
	steps_since_encounter_check = 0
	_unlock_route_through(phase_id)
	current_map = target_map
	_render_map_content(spawn_position)
	_reset_encounter_travel_tracking()
	_render_current_objective()
	_render_phase_metadata()
	_resolve_late_bound_nodes()
	if status_label != null:
		status_label.text = "Entered %s." % String(current_map.get("display_name", phase_id.capitalize()))
	_render_boss_readiness()
	_run_entry_story_trigger(phase_id)
	_play_audio("door_museum_open")
	return true

func is_dialogue_active() -> bool:
	return active_dialogue_index >= 0 and active_dialogue_index < active_dialogue_lines.size()

func current_dialogue_line() -> Dictionary:
	if not is_dialogue_active():
		return {}
	return active_dialogue_lines[active_dialogue_index]

func advance_dialogue() -> bool:
	if not is_dialogue_active():
		return false
	if active_dialogue_index + 1 >= active_dialogue_lines.size():
		active_dialogue_index = -1
		active_dialogue_lines.clear()
		_set_player_dialogue_lock(false)
		_hide_dialogue_box()
		return false
	active_dialogue_index += 1
	_show_current_dialogue_line()
	return true

func can_enter_phase(phase_id: String) -> bool:
	var route_index := FIRST_SLICE_ROUTE.find(phase_id)
	if route_index == -1:
		return true
	return route_index <= max_unlocked_route_index + 1

func current_objective() -> Dictionary:
	return FieldObjectiveCatalog.new().objective_for_phase(map_phase_id)

func battle_launch_payload() -> Dictionary:
	var enemy_id := String(current_map.get("boss", ""))
	if enemy_id.is_empty():
		return {}
	if _is_boss_defeated(enemy_id):
		return {}
	var enemy := _enemy_definition(enemy_id)
	if enemy.is_empty():
		return {}
	return {
		"scene_path": BATTLE_SCENE_PATH,
		"source_phase": map_phase_id,
		"enemy_id": enemy_id,
		"enemy": enemy,
		"rewards": {
			"relic": String(enemy.get("relic", "")),
			"memory_card": String(enemy.get("memory_card", "")),
			"next_flow": String(enemy.get("next_flow", "")),
		},
	}

func encounter_battle_payload(table_id: String, encounter_id: String) -> Dictionary:
	var encounter := _encounter_definition(table_id, encounter_id)
	if encounter.is_empty():
		return {}
	var enemy_ids: Array = encounter.get("enemies", [])
	var enemies: Array = []
	for enemy_id in enemy_ids:
		var enemy := _enemy_definition(String(enemy_id))
		if not enemy.is_empty():
			enemies.append(enemy)
	if enemies.is_empty():
		return {}
	return {
		"scene_path": BATTLE_SCENE_PATH,
		"source_phase": map_phase_id,
		"source_position": player.position if player != null else Vector2.ZERO,
		"table_id": table_id,
		"encounter_id": encounter_id,
		"enemy_ids": enemy_ids.duplicate(true),
		"enemies": enemies,
	}

func request_battle_launch() -> bool:
	var payload := battle_launch_payload()
	if payload.is_empty():
		return false
	battle_launch_requested.emit(payload)
	return true

func request_random_encounter(roll: float = -1.0) -> bool:
	var table_id := String(current_map.get("encounter_table", ""))
	if table_id.is_empty():
		return false
	var table_data := _encounter_table_definition(table_id)
	if table_data.is_empty():
		return false
	var table := EncounterTable.new(
		table_id,
		table_data.get("entries", []),
		int(table_data.get("step_threshold", 16))
	)
	var encounter_id := table.pick(randf() if roll < 0.0 else roll)
	var payload := encounter_battle_payload(table_id, encounter_id)
	if payload.is_empty():
		return false
	battle_launch_requested.emit(payload)
	return true

func record_encounter_steps(step_count: int = 1, roll: float = -1.0) -> bool:
	var table_id := String(current_map.get("encounter_table", ""))
	if table_id.is_empty():
		return false
	var table_data := _encounter_table_definition(table_id)
	if table_data.is_empty():
		return false
	var table := EncounterTable.new(
		table_id,
		table_data.get("entries", []),
		int(table_data.get("step_threshold", 16))
	)
	steps_since_encounter_check += max(0, step_count)
	if not table.should_check(steps_since_encounter_check):
		return false
	steps_since_encounter_check = 0
	return request_random_encounter(roll)

func record_player_travel_for_encounters(roll: float = -1.0) -> bool:
	_resolve_late_bound_nodes()
	if player == null:
		return false
	if not has_encounter_player_position:
		last_encounter_player_position = player.position
		has_encounter_player_position = true
		return false
	var previous_position := last_encounter_player_position
	last_encounter_player_position = player.position
	var distance := previous_position.distance_to(player.position)
	if distance <= 0.0:
		return false
	encounter_travel_pixels += distance
	var step_count := int(floor(encounter_travel_pixels / ENCOUNTER_STEP_DISTANCE))
	if step_count <= 0:
		return false
	encounter_travel_pixels -= float(step_count) * ENCOUNTER_STEP_DISTANCE
	return record_encounter_steps(step_count, roll)

func _is_boss_room_ready() -> bool:
	return not battle_launch_payload().is_empty()

func _render_phase_metadata() -> void:
	_resolve_late_bound_nodes()
	if phase_label == null:
		return
	var display_name: String = phase_metadata.get("display_name", "Prototype Field")
	if not current_map.is_empty():
		display_name = current_map.get("display_name", display_name)
	var mood: String = phase_metadata.get("mood", "")
	var beat: String = phase_metadata.get("beat", "")
	var map_kind: String = current_map.get("kind", "")
	var map_line := ""
	if not current_map.is_empty():
		map_line = "Map: %s%s" % [display_name, " / %s" % map_kind if not map_kind.is_empty() else ""]
	if vista_metadata.is_empty():
		phase_label.text = "%s\n%s\n%s\n%s\n\n%s" % [display_name, mood, beat, map_line, _sev_record_line()]
		return
	var vista_name: String = vista_metadata.get("display_name", "")
	var visible_lie: String = vista_metadata.get("visible_lie", "")
	var truth: String = vista_metadata.get("truth", "")
	phase_label.text = "%s\n%s\n%s\n%s\n\nVista: %s\n%s\nTruth: %s\n\n%s" % [
		display_name,
		mood,
		beat,
		map_line,
		vista_name,
		visible_lie,
		truth,
		_sev_record_line(),
	]

func _sev_record_line() -> String:
	if not is_inside_tree():
		return ""
	var game_state = get_node_or_null("/root/GameState")
	if game_state == null or game_state.profile == null:
		return ""
	return "Sev Record: %s" % SevRecordService.new().field_line(game_state.profile)

func _play_audio(event_id: String) -> void:
	if not is_inside_tree():
		return
	var audio = get_node_or_null("/root/Audio")
	if audio and audio.has_method("play_event"):
		audio.play_event(event_id)

func _resolve_late_bound_nodes() -> void:
	if player == null:
		player = get_node_or_null("%Player")
	if status_label == null:
		status_label = get_node_or_null("%StatusLabel")
	if objective_label == null:
		objective_label = get_node_or_null("%ObjectiveLabel")
	if phase_label == null:
		phase_label = get_node_or_null("%PhaseLabel")
	if dialogue_box == null:
		dialogue_box = get_node_or_null("DialogueLayer/DialogueBox")

func _unlock_route_through(phase_id: String) -> void:
	var route_index := FIRST_SLICE_ROUTE.find(phase_id)
	if route_index >= 0:
		max_unlocked_route_index = max(max_unlocked_route_index, route_index)

func _show_locked_transition_status(target_phase: String) -> void:
	_resolve_late_bound_nodes()
	if status_label != null:
		status_label.text = "Speak with the apothecary before entering %s." % _phase_display_name(target_phase)
	_play_audio("ui_cancel")

func _render_current_objective() -> void:
	_resolve_late_bound_nodes()
	if objective_label == null:
		return
	var objective := current_objective()
	if objective.is_empty():
		objective_label.text = ""
		return
	objective_label.text = "Objective: %s" % String(objective.get("text", ""))

func _render_boss_readiness() -> void:
	_resolve_late_bound_nodes()
	if status_label == null:
		return
	var boss_id := String(current_map.get("boss", ""))
	if not boss_id.is_empty() and _is_boss_defeated(boss_id):
		status_label.text = "Anchor recovered. The bell is silent."
		return
	var payload := battle_launch_payload()
	if payload.is_empty():
		return
	status_label.text = "Battle ready: %s." % String(payload.enemy.get("name", payload.enemy_id))

func _is_boss_defeated(enemy_id: String) -> bool:
	var game_state = _game_state()
	if game_state == null:
		return false
	return bool(game_state.flags.get("boss_%s_defeated" % enemy_id, false))

func _run_entry_story_trigger(phase_id: String) -> void:
	_resolve_late_bound_nodes()
	if status_label == null:
		return
	var trigger := FieldStoryTriggerCatalog.new().trigger_for_phase(phase_id)
	if trigger.is_empty():
		return
	var boss_id := String(current_map.get("boss", ""))
	if not boss_id.is_empty() and _is_boss_defeated(boss_id):
		return
	var trigger_id := String(trigger.get("id", ""))
	if bool(trigger.get("once", true)) and triggered_story_events.has(trigger_id):
		return
	var scene := ContentCatalog.new().dialogue_scene(
		String(trigger.get("dialogue_section", "")),
		String(trigger.get("dialogue_scene", ""))
	)
	if scene.is_empty():
		return
	var lines: Array = scene.get("lines", [])
	if lines.is_empty():
		return
	active_dialogue_lines = lines.duplicate(true)
	active_dialogue_index = 0
	_apply_entry_story_trigger_effects(trigger)
	_set_player_dialogue_lock(true)
	_show_current_dialogue_line()
	if not trigger_id.is_empty():
		triggered_story_events.append(trigger_id)

func _apply_entry_story_trigger_effects(trigger: Dictionary) -> void:
	var recruit_id := String(trigger.get("recruit_party_member", ""))
	if recruit_id.is_empty():
		return
	var game_state = _game_state()
	if game_state == null:
		return
	if game_state.has_method("recruit_party_member"):
		game_state.recruit_party_member(recruit_id)
	game_state.flags["%s_recruited" % recruit_id] = true

func _show_current_dialogue_line() -> void:
	_resolve_late_bound_nodes()
	if status_label == null:
		return
	var line := current_dialogue_line()
	if line.is_empty():
		return
	status_label.text = "%s: %s" % [String(line.get("speaker", "")), String(line.get("text", ""))]
	_show_dialogue_box_line(line)

func _ensure_dialogue_box() -> Control:
	var layer := get_node_or_null("DialogueLayer")
	if layer == null:
		layer = CanvasLayer.new()
		layer.name = "DialogueLayer"
		add_child(layer)
	dialogue_box = layer.get_node_or_null("DialogueBox")
	if dialogue_box == null:
		dialogue_box = DialogueBoxScene.instantiate()
		dialogue_box.name = "DialogueBox"
		layer.add_child(dialogue_box)
	dialogue_box.visible = false
	return dialogue_box

func _show_dialogue_box_line(line: Dictionary) -> void:
	var box := _ensure_dialogue_box()
	var profile := _dialogue_profile()
	if box.has_method("show_dialogue"):
		box.show_dialogue({
			"speaker": String(line.get("speaker", "")),
			"lines": [String(line.get("text", ""))],
		}, profile)
	box.visible = true

func _hide_dialogue_box() -> void:
	_resolve_late_bound_nodes()
	if dialogue_box != null:
		dialogue_box.visible = false

func _set_player_dialogue_lock(locked: bool) -> void:
	_resolve_late_bound_nodes()
	if player != null:
		player.set("dialogue_locked", locked)

func _dialogue_profile() -> Dictionary:
	var game_state = _game_state()
	if game_state != null and game_state.profile != null and game_state.profile.has_method("to_dict"):
		return game_state.profile.to_dict()
	return {}

func _game_state():
	if game_state_override != null:
		return game_state_override
	return get_node_or_null("/root/GameState") if is_inside_tree() else null

func _enemy_definition(enemy_id: String) -> Dictionary:
	var file := FileAccess.open(ENEMIES_PATH, FileAccess.READ)
	if file == null:
		return {}
	var parsed = JSON.parse_string(file.get_as_text())
	if not parsed is Dictionary:
		return {}
	var enemy: Dictionary = parsed.get(enemy_id, {})
	if enemy.is_empty():
		return {}
	var hydrated := enemy.duplicate(true)
	hydrated.id = enemy_id
	hydrated.hp = int(enemy.get("max_hp", enemy.get("hp", 1)))
	return hydrated

func _encounter_definition(table_id: String, encounter_id: String) -> Dictionary:
	var table := _encounter_table_definition(table_id)
	for entry in table.get("entries", []):
		if String(entry.get("id", "")) == encounter_id:
			return entry
	return {}

func _encounter_table_definition(table_id: String) -> Dictionary:
	var file := FileAccess.open(ENCOUNTERS_PATH, FileAccess.READ)
	if file == null:
		return {}
	var parsed = JSON.parse_string(file.get_as_text())
	if not parsed is Dictionary:
		return {}
	return parsed.get("tables", {}).get(table_id, {})

func _phase_display_name(phase_id: String) -> String:
	var map := MapCatalog.new().map_for_phase(phase_id)
	if map.is_empty():
		return phase_id.replace("_", " ").capitalize()
	return String(map.get("display_name", phase_id.replace("_", " ").capitalize()))

func _render_map_content(spawn_override: Variant = null) -> void:
	var roots := _ensure_map_content_nodes()
	_clear_children(roots.authored_map)
	_clear_children(roots.real_art)
	_clear_children(roots.graybox)
	_clear_children(roots.npcs)
	_clear_children(roots.interactables)
	_clear_children(roots.transitions)
	active_transition_zones.clear()
	if current_map.is_empty():
		return
	_render_authored_map(roots.authored_map)
	_render_real_tile_art(roots.real_art)
	_render_graybox_layout(roots.graybox)
	_move_player_to_spawn(spawn_override)
	for npc in current_map.get("npcs", []):
		roots.npcs.add_child(_create_interactable_marker(npc, "npc"))
	for interactable in current_map.get("interactables", []):
		roots.interactables.add_child(_create_interactable_marker(interactable, "interactable"))
	for transition in current_map.get("transitions", []):
		var marker := _create_transition_marker(transition)
		roots.transitions.add_child(marker)

func _ensure_map_content_nodes() -> Dictionary:
	var content := get_node_or_null("MapContent")
	if content == null:
		content = Node2D.new()
		content.name = "MapContent"
		add_child(content)
	var graybox := content.get_node_or_null("Graybox")
	var authored_map := content.get_node_or_null("AuthoredMap")
	if authored_map == null:
		authored_map = Node2D.new()
		authored_map.name = "AuthoredMap"
		content.add_child(authored_map)
		content.move_child(authored_map, 0)
	var real_art := content.get_node_or_null("RealTileArt")
	if real_art == null:
		real_art = Node2D.new()
		real_art.name = "RealTileArt"
		content.add_child(real_art)
		content.move_child(real_art, min(1, content.get_child_count() - 1))
	if graybox == null:
		graybox = Node2D.new()
		graybox.name = "Graybox"
		content.add_child(graybox)
		content.move_child(graybox, min(1, content.get_child_count() - 1))
	var npcs := content.get_node_or_null("Npcs")
	if npcs == null:
		npcs = Node2D.new()
		npcs.name = "Npcs"
		content.add_child(npcs)
	var interactables := content.get_node_or_null("Interactables")
	if interactables == null:
		interactables = Node2D.new()
		interactables.name = "Interactables"
		content.add_child(interactables)
	var transitions := content.get_node_or_null("Transitions")
	if transitions == null:
		transitions = Node2D.new()
		transitions.name = "Transitions"
		content.add_child(transitions)
	return {
		"authored_map": authored_map,
		"real_art": real_art,
		"graybox": graybox,
		"npcs": npcs,
		"interactables": interactables,
		"transitions": transitions,
	}

func _clear_children(parent: Node) -> void:
	for child in parent.get_children():
		parent.remove_child(child)
		child.free()

func _create_interactable_marker(entry: Dictionary, kind: String) -> Node2D:
	var marker := MapInteractable.new()
	marker.configure(entry, kind)
	return marker

func _create_transition_marker(entry: Dictionary) -> Node2D:
	var rect := _rect_from_dict(entry.get("rect", {}))
	var zone := {
		"id": String(entry.get("id", "transition")),
		"target_phase": String(entry.get("target_phase", "")),
		"rect": rect,
		"spawn": _vector_from_dict(entry.get("spawn", {})),
	}
	active_transition_zones.append(zone)
	var marker := Node2D.new()
	marker.name = zone.id
	marker.set_meta("target_phase", zone.target_phase)
	marker.set_meta("rect", rect)
	var visual := ColorRect.new()
	visual.name = "Zone"
	visual.offset_left = rect.position.x
	visual.offset_top = rect.position.y
	visual.offset_right = rect.position.x + rect.size.x
	visual.offset_bottom = rect.position.y + rect.size.y
	visual.color = Color(0.2, 0.75, 0.55, 0.35)
	marker.add_child(visual)
	return marker

func _render_graybox_layout(parent: Node) -> void:
	var layout: Dictionary = current_map.get("layout", {})
	if layout.is_empty():
		return
	var floors := Node2D.new()
	floors.name = "Floors"
	parent.add_child(floors)
	var walls := Node2D.new()
	walls.name = "Walls"
	parent.add_child(walls)
	var palette := _graybox_palette(String(current_map.get("palette", "")))
	var tile_size := float(layout.get("tile_size", 16))
	for rect_data in layout.get("floor_rects", []):
		floors.add_child(_create_layout_rect(rect_data, tile_size, palette.floor, false))
	for rect_data in layout.get("wall_rects", []):
		walls.add_child(_create_layout_rect(rect_data, tile_size, palette.wall, true))

func _render_real_tile_art(parent: Node) -> void:
	var map_id := String(current_map.get("id", ""))
	if map_id.is_empty():
		return
	var assets := TileAssetCatalog.new().assets_for_map(map_id)
	for index in assets.size():
		var asset: Dictionary = assets[index]
		var texture := _load_runtime_texture(String(asset.get("runtime_path", "")))
		if texture == null:
			continue
		var sprite := Sprite2D.new()
		sprite.name = String(asset.get("id", "tile_art"))
		sprite.texture = texture
		sprite.centered = false
		sprite.position = _real_art_position(map_id, index)
		sprite.z_index = -20 + index
		sprite.modulate = Color(1, 1, 1, 0.82)
		sprite.set_meta("source_map", map_id)
		sprite.set_meta("tile_asset_id", String(asset.get("id", "")))
		parent.add_child(sprite)

func _render_authored_map(parent: Node) -> void:
	var map_id := String(current_map.get("id", ""))
	var scene_path := String(AUTHORED_MAP_SCENES.get(map_id, ""))
	if scene_path.is_empty():
		return
	var scene = load(scene_path)
	if scene == null:
		return
	var authored_map = scene.instantiate()
	authored_map.set_meta("source_map", map_id)
	parent.add_child(authored_map)

func _load_runtime_texture(path: String) -> Texture2D:
	if path.is_empty() or not FileAccess.file_exists(path):
		return null
	var image := Image.new()
	var error := image.load(path)
	if error != OK:
		return null
	return ImageTexture.create_from_image(image)

func _real_art_position(map_id: String, index: int) -> Vector2:
	if map_id == "hallowmere_street" and index == 1:
		return Vector2(72, 24)
	if map_id == "broken_exhibit_door" and index == 1:
		return Vector2(104, 28)
	return Vector2(16, 24)

func _create_layout_rect(rect_data: Dictionary, tile_size: float, color: Color, solid: bool) -> Node2D:
	var rect := _tile_rect_from_dict(rect_data, tile_size)
	var node := Node2D.new()
	node.name = "WallRect" if solid else "FloorRect"
	var visual := ColorRect.new()
	visual.name = "Visual"
	visual.offset_left = rect.position.x
	visual.offset_top = rect.position.y
	visual.offset_right = rect.position.x + rect.size.x
	visual.offset_bottom = rect.position.y + rect.size.y
	visual.color = color
	node.add_child(visual)
	if solid:
		var body := StaticBody2D.new()
		body.name = "Collision"
		body.position = rect.position + rect.size / 2.0
		var shape := CollisionShape2D.new()
		var rectangle := RectangleShape2D.new()
		rectangle.size = rect.size
		shape.shape = rectangle
		body.add_child(shape)
		node.add_child(body)
	return node

func _graybox_palette(palette_id: String) -> Dictionary:
	return GRAYBOX_PALETTES.get(palette_id, {
		"floor": Color(0.25, 0.25, 0.25, 1.0),
		"wall": Color(0.10, 0.10, 0.10, 1.0),
	})

func _move_player_to_spawn(spawn_override: Variant = null) -> void:
	_resolve_late_bound_nodes()
	if player != null:
		if spawn_override is Vector2:
			player.position = spawn_override
		elif _should_restore_saved_player_position():
			player.position = _game_state().player_position
		else:
			player.position = _vector_from_dict(current_map.get("spawn", {}))

func _should_restore_saved_player_position() -> bool:
	var game_state = _game_state()
	if game_state == null:
		return false
	return String(game_state.map_id) == String(current_map.get("id", ""))

func _reset_encounter_travel_tracking() -> void:
	_resolve_late_bound_nodes()
	encounter_travel_pixels = 0.0
	if player == null:
		has_encounter_player_position = false
		last_encounter_player_position = Vector2.ZERO
		return
	last_encounter_player_position = player.position
	has_encounter_player_position = true

func _vector_from_dict(value) -> Vector2:
	if value is Dictionary:
		return Vector2(float(value.get("x", 0.0)), float(value.get("y", 0.0)))
	return Vector2.ZERO

func _rect_from_dict(value) -> Rect2:
	if value is Dictionary:
		return Rect2(
			float(value.get("x", 0.0)),
			float(value.get("y", 0.0)),
			float(value.get("w", 0.0)),
			float(value.get("h", 0.0))
		)
	return Rect2()

func _tile_rect_from_dict(value: Dictionary, tile_size: float) -> Rect2:
	return Rect2(
		float(value.get("x", 0.0)) * tile_size,
		float(value.get("y", 0.0)) * tile_size,
		float(value.get("w", 0.0)) * tile_size,
		float(value.get("h", 0.0)) * tile_size
	)
