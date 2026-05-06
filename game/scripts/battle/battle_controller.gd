class_name BattleController
extends RefCounted

const BattleClock = preload("res://scripts/battle/battle_clock.gd")
const ContentCatalog = preload("res://scripts/core/content_catalog.gd")

var party: Array = []
var enemies: Array = []
var clock := BattleClock.new()
var victory_resolved := false

func start_battle(p_party: Array, p_enemies: Array) -> void:
	party = p_party.duplicate(true)
	_apply_relic_modifiers()
	_apply_memory_card_modifiers()
	enemies = p_enemies.duplicate(true)
	clock = BattleClock.new()
	victory_resolved = false
	for member in party:
		clock.add_combatant(member.get("id", ""), member.get("stats", {}).get("speed", 8), false)
	for enemy in enemies:
		clock.add_combatant(enemy.get("id", ""), enemy.get("speed", 8), true)

func _apply_relic_modifiers() -> void:
	var content := ContentCatalog.new()
	for member in party:
		var relic_id: String = member.get("equipped_relic", "")
		if relic_id.is_empty():
			continue
		var relic: Dictionary = content.item(relic_id)
		if relic.is_empty():
			continue
		var stats: Dictionary = member.get("stats", {}).duplicate(true)
		for stat_key in ["strength", "magic", "defense", "speed"]:
			if relic.has(stat_key):
				stats[stat_key] = int(stats.get(stat_key, 0)) + int(relic[stat_key])
		member.stats = stats

func _apply_memory_card_modifiers() -> void:
	var content := ContentCatalog.new()
	for member in party:
		var equipped_cards: Array = member.get("equipped_memory_cards", [])
		if equipped_cards.is_empty():
			continue
		var stats: Dictionary = member.get("stats", {}).duplicate(true)
		for card_id in equipped_cards:
			var card: Dictionary = content.memory_card(String(card_id))
			var effect: Dictionary = card.get("effect", {})
			if effect.has("guard_bonus"):
				stats.defense = int(stats.get("defense", 0)) + int(effect.guard_bonus)
			if effect.has("turn_priority_bonus"):
				stats.speed = int(stats.get("speed", 0)) + int(effect.turn_priority_bonus)
		member.stats = stats

func advance(delta: float, command_menu_open: bool, atb_mode: String = "wait") -> void:
	clock.advance(delta, command_menu_open, atb_mode)

func execute_command(actor_id: String, command: String, target_id: String = "") -> Dictionary:
	match command:
		"attack":
			return _execute_attack(actor_id, target_id)
		"defend":
			return {"command": "defend", "actor_id": actor_id}
		"flee":
			return {"command": "flee", "success": false}
		_:
			return {"command": command, "error": "unsupported_command"}

func is_victory() -> bool:
	for enemy in enemies:
		if enemy.get("hp", 0) > 0:
			return false
	return not enemies.is_empty()

func resolve_victory() -> Dictionary:
	if not is_victory():
		return {}
	victory_resolved = true
	var rewards := {"xp": 0, "loot": {}, "next_flow": "", "relics": [], "memory_cards": []}
	for enemy in enemies:
		rewards.xp += int(enemy.get("xp", 0))
		for item_id in enemy.get("loot", {}):
			rewards.loot[item_id] = rewards.loot.get(item_id, 0) + int(enemy.loot[item_id])
		if enemy.has("next_flow"):
			rewards.next_flow = enemy.next_flow
		elif enemy.get("boss", false):
			rewards.next_flow = "time_fracture"
		if enemy.has("relic"):
			rewards.relics.append(enemy.relic)
		if enemy.has("memory_card"):
			rewards.memory_cards.append(enemy.memory_card)
	return rewards

func _execute_attack(actor_id: String, target_id: String) -> Dictionary:
	var actor := _find_combatant(actor_id, party)
	var target := _find_combatant(target_id, enemies)
	if actor.is_empty() or target.is_empty():
		return {"command": "attack", "error": "missing_combatant"}
	var damage = max(1, int(actor.get("stats", {}).get("strength", 1)) - int(target.get("defense", 0)))
	target.hp = max(0, int(target.get("hp", 0)) - damage)
	clock.consume_turn(actor_id)
	return {"command": "attack", "actor_id": actor_id, "target_id": target_id, "damage": damage}

func _find_combatant(id: String, collection: Array) -> Dictionary:
	for combatant in collection:
		if combatant.get("id", "") == id:
			return combatant
	return {}
