extends Control

signal battle_completed(payload: Dictionary)

const BattleController = preload("res://scripts/battle/battle_controller.gd")
const SevRecordService = preload("res://scripts/core/sev_record_service.gd")

@onready var party_label: Label = %PartyLabel
@onready var enemy_label: Label = %EnemyLabel
@onready var log_label: Label = %LogLabel

var battle := BattleController.new()
var rewards := {}

func _ready() -> void:
	var game_state = _game_state()
	var party: Array = game_state.party if game_state != null else []
	if party.is_empty():
		party = [{"id": "lead", "name": "Mira", "class_id": "vanguard", "level": 1, "xp": 0, "stats": {"max_hp": 120, "strength": 18, "defense": 8, "speed": 10}}]
	else:
		party = _party_with_stats(party)
	var enemies := _enemies_for_current_phase()
	battle.start_battle(party, enemies)
	_update_labels("The Bell Saint descends." if enemies[0].id == "bell_saint" else "A wild slime blocks the path.")

func _on_attack_pressed() -> void:
	var result := battle.execute_command(battle.party[0].id, "attack", battle.enemies[0].id)
	_play_audio("weapon_slice")
	if battle.is_victory():
		rewards = battle.resolve_victory()
		_apply_rewards(rewards)
		_play_audio("bell_clapper_relic" if not rewards.get("relics", []).is_empty() else "memory_card_reveal")
		_update_labels(_victory_message(rewards))
		battle_completed.emit(rewards.duplicate(true))
	else:
		_play_audio("hit_impact")
		_update_labels("%s attacks for %d damage." % [battle.party[0].name, result.damage])

func _on_defend_pressed() -> void:
	battle.execute_command(battle.party[0].id, "defend")
	_play_audio("ui_confirm")
	_update_labels("%s braces for impact." % battle.party[0].name)

func _on_flee_pressed() -> void:
	_play_audio("ui_cancel")
	_update_labels("There is no clean escape yet.")

func _party_with_stats(raw_party: Array) -> Array:
	var hydrated := []
	for member in raw_party:
		var copy: Dictionary = member.duplicate(true)
		if not copy.has("stats"):
			copy.stats = {"max_hp": 120, "strength": 16, "defense": 8, "speed": 10}
		hydrated.append(copy)
	return hydrated

func _enemies_for_current_phase() -> Array:
	var game_state = _game_state()
	if game_state != null:
		var pending_payload: Dictionary = game_state.flags.get("pending_battle_payload", {})
		if not pending_payload.is_empty():
			return [pending_payload.enemy.duplicate(true)]
	if game_state != null and game_state.map_id == "battle":
		return [{
			"id": "bell_saint",
			"name": "The Bell Saint",
			"hp": 48,
			"max_hp": 48,
			"strength": 10,
			"defense": 3,
			"speed": 6,
			"xp": 150,
			"boss": true,
			"next_flow": "truth_recovered",
			"relic": "bell_clapper",
			"memory_card": "bell_saint",
		}]
	return [{"id": "slime", "name": "Slime", "hp": 35, "max_hp": 35, "strength": 6, "defense": 2, "speed": 6, "xp": 20, "loot": {"potion": 1}}]

func _apply_rewards(resolved_rewards: Dictionary) -> void:
	var game_state = _game_state()
	if game_state == null:
		return
	game_state.add_inventory_items(resolved_rewards.get("loot", {}))
	var relic_loot := {}
	for relic_id in resolved_rewards.get("relics", []):
		relic_loot[relic_id] = 1
	game_state.add_inventory_items(relic_loot)
	for card_id in resolved_rewards.get("memory_cards", []):
		game_state.acquire_memory_card(card_id)

func _victory_message(resolved_rewards: Dictionary) -> String:
	if not resolved_rewards.get("memory_cards", []).is_empty():
		return "Victory. Anchor recovered: Bell Clapper. Memory Card acquired: The Bell Saint."
	return "Victory. Gained %d XP." % resolved_rewards.xp

func _update_labels(message: String) -> void:
	_resolve_late_bound_nodes()
	if party_label == null or enemy_label == null or log_label == null:
		return
	var game_state = _game_state()
	var loadout_line := SevRecordService.new().battle_line(game_state.profile) if game_state != null and game_state.profile else ""
	party_label.text = "Party\n" + "\n".join(battle.party.map(func(member): return "%s Lv.%d" % [member.name, member.level]))
	if not loadout_line.is_empty():
		party_label.text += "\n\n" + loadout_line
	enemy_label.text = "Enemies\n" + "\n".join(battle.enemies.map(func(enemy): return "%s HP %d/%d" % [enemy.name, enemy.hp, enemy.max_hp]))
	log_label.text = message

func _game_state():
	return get_node_or_null("/root/GameState") if is_inside_tree() else null

func _play_audio(event_id: String) -> void:
	if not is_inside_tree():
		return
	var audio = get_node_or_null("/root/Audio")
	if audio and audio.has_method("play_event"):
		audio.play_event(event_id)

func _resolve_late_bound_nodes() -> void:
	if party_label == null:
		party_label = get_node_or_null("%PartyLabel")
	if enemy_label == null:
		enemy_label = get_node_or_null("%EnemyLabel")
	if log_label == null:
		log_label = get_node_or_null("%LogLabel")
