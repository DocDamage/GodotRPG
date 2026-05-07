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

func execute_command(actor_id: String, command: String, target_id: String = "", payload: Dictionary = {}) -> Dictionary:
	match command:
		"attack":
			return _execute_attack(actor_id, target_id)
		"skill":
			return _execute_skill(actor_id, target_id, payload)
		"item":
			return _execute_item(actor_id, target_id, payload)
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

func _execute_skill(actor_id: String, target_id: String, payload: Dictionary) -> Dictionary:
	var skill_id := String(payload.get("skill_id", ""))
	var skill := ContentCatalog.new().battle_skill(skill_id)
	if skill.is_empty():
		return {"command": "skill", "actor_id": actor_id, "target_id": target_id, "skill_id": skill_id, "error": "missing_skill"}
	match String(skill.get("kind", "")):
		"damage":
			return _execute_damage_skill(actor_id, target_id, skill_id, skill)
		"heal":
			return _execute_heal_skill(actor_id, target_id, skill_id, skill)
		_:
			return {"command": "skill", "actor_id": actor_id, "target_id": target_id, "skill_id": skill_id, "error": "unsupported_skill"}

func _execute_damage_skill(actor_id: String, target_id: String, skill_id: String, skill: Dictionary) -> Dictionary:
	var actor := _find_any_combatant(actor_id)
	var target := _find_any_combatant(target_id)
	if actor.is_empty() or target.is_empty():
		return {"command": "skill", "actor_id": actor_id, "target_id": target_id, "skill_id": skill_id, "error": "missing_combatant"}
	var stats: Dictionary = actor.get("stats", {})
	var stat_key := String(skill.get("stat", "strength"))
	var power := int(skill.get("power", 0))
	var stat_value := int(stats.get(stat_key, actor.get(stat_key, stats.get("strength", actor.get("strength", 1)))))
	var target_stats: Dictionary = target.get("stats", {})
	var target_defense := int(target_stats.get("defense", target.get("defense", 0)))
	var damage = max(1, stat_value + power - target_defense)
	target.hp = max(0, int(target.get("hp", 0)) - damage)
	var status: Dictionary = skill.get("status", {})
	if not status.is_empty():
		_apply_status_to_combatant(target, String(status.get("id", "")), status)
	clock.consume_turn(actor_id)
	return {"command": "skill", "actor_id": actor_id, "target_id": target_id, "skill_id": skill_id, "damage": damage}

func _execute_heal_skill(actor_id: String, target_id: String, skill_id: String, skill: Dictionary) -> Dictionary:
	var actor := _find_any_combatant(actor_id)
	var target := _find_any_combatant(target_id)
	if actor.is_empty() or target.is_empty():
		return {"command": "skill", "actor_id": actor_id, "target_id": target_id, "skill_id": skill_id, "error": "missing_combatant"}
	var heal := int(skill.get("heal_hp", 0))
	_heal_combatant(target, heal)
	clock.consume_turn(actor_id)
	return {"command": "skill", "actor_id": actor_id, "target_id": target_id, "skill_id": skill_id, "heal": heal}

func _execute_item(actor_id: String, target_id: String, payload: Dictionary) -> Dictionary:
	var item_id := String(payload.get("item_id", ""))
	var inventory: Dictionary = payload.get("inventory", {})
	if int(inventory.get(item_id, 0)) <= 0:
		return {"command": "item", "actor_id": actor_id, "target_id": target_id, "item_id": item_id, "error": "missing_item"}
	var item := ContentCatalog.new().item(item_id)
	if item.is_empty() or int(item.get("heal_hp", 0)) <= 0:
		return {"command": "item", "actor_id": actor_id, "target_id": target_id, "item_id": item_id, "error": "unsupported_item"}
	var actor := _find_combatant(actor_id, party)
	var target := _find_combatant(target_id, party)
	if actor.is_empty() or target.is_empty():
		return {"command": "item", "actor_id": actor_id, "target_id": target_id, "item_id": item_id, "error": "missing_combatant"}
	var heal := int(item.get("heal_hp", 0))
	_heal_combatant(target, heal)
	_consume_inventory_item(inventory, item_id)
	clock.consume_turn(actor_id)
	return {"command": "item", "actor_id": actor_id, "target_id": target_id, "item_id": item_id, "heal": heal}

func _heal_combatant(target: Dictionary, heal: int) -> void:
	var stats: Dictionary = target.get("stats", {})
	var max_hp := int(stats.get("max_hp", target.get("max_hp", target.get("hp", heal))))
	var current_hp := int(target.get("hp", max_hp))
	target.hp = min(max_hp, current_hp + max(0, heal))

func _consume_inventory_item(inventory: Dictionary, item_id: String) -> void:
	var remaining := int(inventory.get(item_id, 0)) - 1
	if remaining > 0:
		inventory[item_id] = remaining
	else:
		inventory.erase(item_id)

func apply_status(target_id: String, status_id: String, status_data: Dictionary) -> Dictionary:
	var target := _find_any_combatant(target_id)
	if target.is_empty() or status_id.is_empty():
		return {"error": "missing_combatant", "status_id": status_id}
	_apply_status_to_combatant(target, status_id, status_data)
	return {"target_id": target_id, "status_id": status_id, "status": target.statuses[status_id]}

func tick_status_effects(target_id: String) -> Dictionary:
	var target := _find_any_combatant(target_id)
	if target.is_empty():
		return {"error": "missing_combatant", "damage": 0, "expired": []}
	var statuses: Dictionary = target.get("statuses", {})
	var total_damage := 0
	var expired: Array = []
	for status_id in statuses.keys():
		var status: Dictionary = statuses[status_id]
		match status_id:
			"poison":
				var damage := int(status.get("potency", 0))
				target.hp = max(0, int(target.get("hp", 0)) - damage)
				total_damage += damage
		status.turns = int(status.get("turns", 1)) - 1
		if int(status.turns) <= 0:
			expired.append(status_id)
		else:
			statuses[status_id] = status
	for status_id in expired:
		statuses.erase(status_id)
	target.statuses = statuses
	return {"target_id": target_id, "damage": total_damage, "expired": expired}

func choose_enemy_action(enemy_id: String) -> Dictionary:
	var enemy := _find_combatant(enemy_id, enemies)
	if enemy.is_empty():
		return {"error": "missing_enemy"}
	var target_id := _first_living_party_member_id()
	var profile := String(enemy.get("ai_profile", "aggressive"))
	var skills: Array = enemy.get("skills", [])
	if profile == "support":
		var hp := int(enemy.get("hp", 0))
		var max_hp := int(enemy.get("max_hp", hp))
		if hp < max_hp / 2:
			return {"command": "skill", "actor_id": enemy_id, "target_id": enemy_id, "skill_id": _first_skill_of_kind(skills, "heal", "clean_wound")}
	if profile == "boss_bell_saint" and not skills.is_empty():
		return {"command": "skill", "actor_id": enemy_id, "target_id": target_id, "skill_id": String(skills[0])}
	return {"command": "attack", "actor_id": enemy_id, "target_id": target_id}

func _first_living_party_member_id() -> String:
	for member in party:
		var stats: Dictionary = member.get("stats", {})
		var max_hp := int(stats.get("max_hp", member.get("max_hp", member.get("hp", 1))))
		if int(member.get("hp", max_hp)) > 0:
			return String(member.get("id", ""))
	return String(party[0].get("id", "")) if not party.is_empty() else ""

func _first_skill_of_kind(skill_ids: Array, kind: String, fallback: String) -> String:
	var content := ContentCatalog.new()
	for skill_id in skill_ids:
		var skill := content.battle_skill(String(skill_id))
		if String(skill.get("kind", "")) == kind:
			return String(skill_id)
	return fallback

func _apply_status_to_combatant(target: Dictionary, status_id: String, status_data: Dictionary) -> void:
	if status_id.is_empty():
		return
	var statuses: Dictionary = target.get("statuses", {}).duplicate(true)
	statuses[status_id] = {
		"potency": int(status_data.get("potency", 0)),
		"turns": int(status_data.get("turns", 1)),
	}
	target.statuses = statuses

func _find_any_combatant(id: String) -> Dictionary:
	var found := _find_combatant(id, party)
	if not found.is_empty():
		return found
	return _find_combatant(id, enemies)

func _find_combatant(id: String, collection: Array) -> Dictionary:
	for combatant in collection:
		if combatant.get("id", "") == id:
			return combatant
	return {}
