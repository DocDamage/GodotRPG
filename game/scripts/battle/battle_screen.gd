extends Node2D

signal battle_completed(payload: Dictionary)

const BattleController = preload("res://scripts/battle/battle_controller.gd")
const SevRecordService = preload("res://scripts/core/sev_record_service.gd")
const ContentCatalog = preload("res://scripts/core/content_catalog.gd")
const InputPromptService = preload("res://scripts/core/input_prompt_service.gd")

@onready var party_label: Label = %PartyLabel
@onready var enemy_label: Label = %EnemyLabel
@onready var log_label: Label = %LogLabel

var battle := BattleController.new()
var rewards := {}
var game_state_override = null
var enemy_sprite: Sprite2D = null
var enemy_sprites: Dictionary = {}
var party_sprite: Sprite2D = null
var selected_enemy_index := 0
var active_party_index := 0
var active_enemy_action_index := 0
var camera_shake_strength := 0.0
var commands_locked := false
var presentation_phase := "idle"
var action_presentation_timer_active := false
var pending_enemy_retaliation := false
var enemy_action_timer_active := false
var battle_inventory: Dictionary = {"clean_bandage": 1}
var command_ready_override := true
var animation_texture_cache: Dictionary = {}
var battler_animation_time: Dictionary = {"party": 0.0, "enemy": 0.0}
var battler_animation_index: Dictionary = {"party": 0, "enemy": 0}
var controller_focus_fallback := ""

func _ready() -> void:
	_ensure_party_sprite()
	var game_state = _game_state()
	var party: Array = game_state.party if game_state != null else []
	if party.is_empty():
		party = [{"id": "lead", "name": "Mira", "class_id": "vanguard", "level": 1, "xp": 0, "stats": {"max_hp": 120, "strength": 18, "defense": 8, "speed": 10}}]
	else:
		party = _party_with_stats(party)
	var enemies := _enemies_for_current_phase()
	battle.start_battle(party, enemies)
	apply_battler_animation_hooks()
	_update_labels("The Bell Saint descends." if enemies[0].id == "bell_saint" else "A wild slime blocks the path.")
	refresh_command_state()
	_ensure_controller_help_prompt()
	_configure_controller_focus()
	if bool(enemies[0].get("boss", false)):
		play_boss_intro()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("cancel"):
		handle_controller_cancel()

func _process(delta: float) -> void:
	if battle.party.is_empty() or battle.enemies.is_empty():
		return
	_advance_battler_animations(delta)
	if presentation_phase in ["action", "enemy_action", "party_defeat", "victory"]:
		return
	advance_battle_time(delta)
	refresh_command_state()

func _on_attack_pressed() -> void:
	if commands_locked:
		return
	set_commands_locked(true)
	presentation_phase = "action"
	focus_camera("enemy")
	play_party_attack_lunge()
	var target := _selected_enemy()
	var actor := _active_party_member()
	var result := battle.execute_command(String(actor.get("id", "")), "attack", String(target.get("id", "")))
	_play_audio("weapon_slice")
	if battle.is_victory():
		rewards = battle.resolve_victory()
		_attach_party_state_to_rewards(rewards)
		_play_audio("bell_clapper_relic" if not rewards.get("relics", []).is_empty() else "memory_card_reveal")
		focus_camera("wide")
		mark_enemy_hit()
		show_damage_popup(int(result.get("damage", 0)))
		present_victory()
		_update_labels(_victory_message(rewards))
		battle_completed.emit(rewards.duplicate(true))
	else:
		_play_audio("hit_impact")
		mark_enemy_hit()
		show_damage_popup(int(result.get("damage", 0)))
		queue_hit_shake(6.0)
		_update_labels("%s attacks for %d damage." % [actor.name, result.damage])
		_select_first_living_enemy_if_selected_defeated()
		_render_enemy_sprite()
		_render_enemy_status()
		render_target_menu()
		pending_enemy_retaliation = true
		_start_action_presentation_timer()

func _on_skill_pressed() -> void:
	if commands_locked:
		return
	render_target_menu()
	open_skill_menu()

func select_skill(skill_id: String) -> void:
	if commands_locked:
		return
	set_commands_locked(true)
	presentation_phase = "action"
	var skill := ContentCatalog.new().battle_skill(skill_id)
	var target_type := String(skill.get("target", "enemy"))
	var actor := _active_party_member()
	var target_id := ""
	if target_type == "ally":
		target_id = String(actor.get("id", ""))
	else:
		target_id = String(_selected_enemy().get("id", ""))
	var menu = get_node_or_null("%SkillMenu")
	if menu is VBoxContainer:
		menu.visible = false
	focus_camera("party" if target_type == "ally" else "enemy")
	if target_type == "enemy":
		play_party_attack_lunge()
	var result := battle.execute_command(String(actor.get("id", "")), "skill", target_id, {"skill_id": skill_id})
	_play_audio("weapon_slice")
	if result.has("damage"):
		mark_enemy_hit()
		show_damage_popup(int(result.damage))
		queue_hit_shake(6.0)
		_update_labels("%s uses %s for %d damage." % [actor.name, String(skill.get("display_name", skill_id)), int(result.damage)])
		_select_first_living_enemy_if_selected_defeated()
		_render_enemy_sprite()
		_render_enemy_status()
		render_target_menu()
	elif result.has("heal"):
		show_heal_popup(int(result.heal))
		_render_party_status()
		_update_labels("%s uses %s." % [actor.name, String(skill.get("display_name", skill_id))])
	if battle.is_victory():
		rewards = battle.resolve_victory()
		_attach_party_state_to_rewards(rewards)
		present_victory()
		_update_labels(_victory_message(rewards))
		battle_completed.emit(rewards.duplicate(true))
	else:
		pending_enemy_retaliation = true
		_start_action_presentation_timer()

func open_skill_menu() -> void:
	var menu = get_node_or_null("%SkillMenu")
	if not menu is VBoxContainer or battle.party.is_empty():
		return
	for child in menu.get_children():
		child.queue_free()
	var skills: Array = _active_party_member().get("skills", ["archive_strike", "clean_wound"])
	var content := ContentCatalog.new()
	for skill_id in skills:
		var skill := content.battle_skill(String(skill_id))
		if skill.is_empty():
			continue
		var button := Button.new()
		button.name = "Skill%s" % String(skill_id).to_pascal_case()
		button.text = _format_skill_button_text(String(skill_id), skill)
		button.tooltip_text = _format_skill_tooltip(skill)
		button.focus_mode = Control.FOCUS_ALL
		button.set_meta("skill_id", String(skill_id))
		button.set_meta("skill_animation", String(skill.get("animation", "")))
		button.pressed.connect(Callable(self, "select_skill").bind(String(skill_id)))
		menu.add_child(button)
	menu.visible = true
	if menu.get_child_count() > 0 and menu.get_child(0) is Control:
		_remember_controller_focus(menu.get_child(0))

func render_target_menu() -> void:
	var menu = get_node_or_null("%TargetMenu")
	if not menu is HBoxContainer:
		return
	_clear_menu_children(menu)
	for index in range(battle.enemies.size()):
		var enemy: Dictionary = battle.enemies[index]
		var button := Button.new()
		button.text = "%s  %d/%d" % [
			String(enemy.get("name", "Enemy")),
			int(enemy.get("hp", 0)),
			int(enemy.get("max_hp", enemy.get("hp", 0))),
		]
		button.disabled = int(enemy.get("hp", 0)) <= 0
		button.toggle_mode = true
		button.button_pressed = index == selected_enemy_index
		button.set_meta("enemy_index", index)
		button.pressed.connect(Callable(self, "select_enemy_target").bind(index))
		menu.add_child(button)
	menu.visible = battle.enemies.size() > 1

func handle_controller_cancel() -> bool:
	var closed := false
	var skill_menu = get_node_or_null("%SkillMenu")
	if skill_menu is VBoxContainer and skill_menu.visible:
		skill_menu.visible = false
		closed = true
	var target_menu = get_node_or_null("%TargetMenu")
	if target_menu is HBoxContainer and target_menu.visible:
		target_menu.visible = false
		closed = true
	if closed:
		_play_audio("ui_cancel")
		var attack_button = get_node_or_null("%AttackButton")
		if attack_button is Button:
			_remember_controller_focus(attack_button)
		return true
	return false

func _clear_menu_children(menu: Container) -> void:
	for child in menu.get_children():
		menu.remove_child(child)
		child.free()

func _format_skill_button_text(skill_id: String, skill: Dictionary) -> String:
	var name := String(skill.get("display_name", skill_id))
	var target := String(skill.get("target", "enemy")).capitalize()
	match String(skill.get("kind", "")):
		"damage":
			var status: Dictionary = skill.get("status", {})
			var status_suffix := ""
			if not status.is_empty():
				status_suffix = " + %s" % String(status.get("id", "")).capitalize()
			return "%s  |  DMG %d  |  %s%s" % [name, int(skill.get("power", 0)), target, status_suffix]
		"heal":
			return "%s  |  HEAL %d  |  %s" % [name, int(skill.get("heal_hp", 0)), target]
		_:
			return "%s  |  %s" % [name, target]

func _format_skill_tooltip(skill: Dictionary) -> String:
	var lines := [String(skill.get("description", ""))]
	if skill.has("animation"):
		lines.append("Animation: %s" % String(skill.animation))
	var status: Dictionary = skill.get("status", {})
	if not status.is_empty():
		lines.append("Applies %s for %d turns." % [String(status.get("id", "")).capitalize(), int(status.get("turns", 1))])
	return "\n".join(lines)

func _refresh_target_buttons() -> void:
	var menu = get_node_or_null("%TargetMenu")
	if not menu is HBoxContainer:
		return
	for child in menu.get_children():
		if child is Button:
			var index := int(child.get_meta("enemy_index", -1))
			child.button_pressed = index == selected_enemy_index

func apply_battler_animation_hooks() -> void:
	var party := _ensure_party_sprite()
	if not battle.party.is_empty():
		party.set_meta("animation_set", String(_active_party_member().get("animation_set", "sev_placeholder")))
		_set_battler_animation_state(party, "party", "idle")
	var enemy := _ensure_enemy_sprite()
	for index in range(battle.enemies.size()):
		enemy = _ensure_enemy_sprite(index)
		enemy.set_meta("animation_set", String(battle.enemies[index].get("animation_set", battle.enemies[index].get("id", "enemy"))))
		_set_battler_animation_state(enemy, _enemy_role(index), "idle")

func select_enemy_target(index: int) -> void:
	if battle.enemies.is_empty():
		selected_enemy_index = 0
		return
	selected_enemy_index = clampi(index, 0, battle.enemies.size() - 1)
	_render_enemy_sprite()
	_render_enemy_status()
	_refresh_target_buttons()

func select_party_member(index: int) -> void:
	if battle.party.is_empty():
		active_party_index = 0
		return
	var next_index := clampi(index, 0, battle.party.size() - 1)
	if not _is_party_member_alive(battle.party[next_index]):
		_update_party_roster_label()
		return
	active_party_index = next_index
	_render_party_status()
	_update_party_roster_label()

func _on_item_pressed() -> void:
	if commands_locked:
		return
	set_commands_locked(true)
	presentation_phase = "action"
	focus_camera("party")
	var inventory := _battle_inventory()
	var actor := _active_party_member()
	var actor_id := String(actor.get("id", ""))
	var target_id := _most_wounded_living_party_member_id()
	var result := battle.execute_command(actor_id, "item", target_id, {"item_id": "clean_bandage", "inventory": inventory})
	if result.has("heal"):
		_focus_party_member_by_id(target_id)
		show_heal_popup(int(result.heal))
		_render_party_status()
		var target := _party_member_by_id(target_id)
		_update_labels("%s uses Clean Bandage on %s." % [actor.name, String(target.get("name", "ally"))])
		_start_action_presentation_timer()
	else:
		_update_labels("No Clean Bandage available.")
		complete_action_presentation()

func _on_defend_pressed() -> void:
	if commands_locked:
		return
	focus_camera("party")
	var actor := _active_party_member()
	battle.execute_command(String(actor.get("id", "")), "defend")
	_play_audio("ui_confirm")
	_update_labels("%s braces for impact." % actor.name)

func _on_flee_pressed() -> void:
	if commands_locked:
		return
	focus_camera("wide")
	_play_audio("ui_cancel")
	_update_labels("There is no clean escape yet.")

func set_commands_locked(locked: bool) -> void:
	commands_locked = locked
	_apply_command_button_state()

func refresh_command_state() -> void:
	_ensure_active_party_member_can_act()
	_apply_command_button_state()

func advance_battle_time(delta: float) -> void:
	battle.advance(delta, commands_locked, "wait")

func is_lead_ready() -> bool:
	if battle.party.is_empty():
		return false
	_ensure_active_party_member_can_act()
	var lead_id := String(_active_party_member().get("id", ""))
	for combatant in battle.clock.combatants:
		if String(combatant.get("id", "")) == lead_id:
			return bool(combatant.get("ready", false))
	return command_ready_override

func _apply_command_button_state() -> void:
	var disabled := commands_locked or not is_lead_ready()
	for button_name in ["AttackButton", "SkillButton", "ItemButton", "DefendButton", "FleeButton"]:
		var button = get_node_or_null("%%%s" % button_name)
		if button is Button:
			button.disabled = disabled
	var item_button = get_node_or_null("%ItemButton")
	if item_button is Button and not disabled:
		item_button.disabled = int(_battle_inventory().get("clean_bandage", 0)) <= 0

func _configure_controller_focus() -> void:
	for button_name in ["AttackButton", "SkillButton", "ItemButton", "DefendButton", "FleeButton"]:
		var button = get_node_or_null("%%%s" % button_name)
		if button is Button:
			button.focus_mode = Control.FOCUS_ALL
	var attack_button = get_node_or_null("%AttackButton")
	if attack_button is Button:
		_remember_controller_focus(attack_button)

func _ensure_controller_help_prompt() -> void:
	var root_control = get_node_or_null("BattleUi/RootControl")
	if not root_control is Control or root_control.has_node("ControllerHelpPrompt"):
		return
	var prompt := Label.new()
	prompt.name = "ControllerHelpPrompt"
	prompt.position = Vector2(24, 12)
	prompt.size = Vector2(760, 22)
	prompt.text = "%s: command   %s: back   D-pad/left stick: navigate" % [
		InputPromptService.new().mixed_action_label("interact", "xbox"),
		InputPromptService.new().mixed_action_label("cancel", "xbox"),
	]
	root_control.add_child(prompt)

func controller_focus_owner_name() -> String:
	var skill_menu = get_node_or_null("%SkillMenu")
	if skill_menu is VBoxContainer and skill_menu.visible and skill_menu.get_child_count() > 0:
		return String(skill_menu.get_child(0).name)
	if controller_focus_fallback.is_empty():
		_configure_controller_focus()
	if not controller_focus_fallback.is_empty():
		return controller_focus_fallback
	var owner := get_viewport().gui_get_focus_owner() if is_inside_tree() else null
	if owner != null and is_ancestor_of(owner):
		return String(owner.name)
	return controller_focus_fallback

func _remember_controller_focus(control: Control) -> void:
	controller_focus_fallback = String(control.name)
	if control.is_inside_tree():
		control.grab_focus()

func focus_camera(target: String) -> void:
	var camera = get_node_or_null("ArenaCamera")
	if not camera is Camera2D:
		return
	match target:
		"party":
			camera.position = Vector2(392, 328)
			camera.zoom = Vector2(1.22, 1.22)
		"enemy":
			camera.position = Vector2(650, 282)
			camera.zoom = Vector2(1.24, 1.24)
		_:
			camera.position = Vector2(512, 300)
			camera.zoom = Vector2(1.08, 1.08)

func play_boss_intro() -> void:
	presentation_phase = "boss_intro"
	var camera = get_node_or_null("ArenaCamera")
	if camera is Camera2D:
		camera.position = Vector2(676, 262)
		camera.zoom = Vector2(1.34, 1.34)
	var sprite := _ensure_enemy_sprite()
	sprite.set_meta("presentation_state", "boss_intro")
	sprite.scale = sprite.scale * 1.08

func queue_hit_shake(strength: float) -> void:
	camera_shake_strength = maxf(0.0, strength)
	var camera = get_node_or_null("ArenaCamera")
	if camera is Camera2D:
		camera.offset = Vector2(camera_shake_strength * 0.35, -camera_shake_strength * 0.2)

func play_party_attack_lunge() -> void:
	var sprite := _ensure_party_sprite()
	var home: Vector2 = sprite.get_meta("home_position", sprite.position)
	sprite.set_meta("home_position", home)
	var lunge := home + Vector2(58, -10)
	sprite.position = lunge
	sprite.set_meta("lunge_position", lunge)
	sprite.set_meta("presentation_state", "attack_lunge")
	_set_battler_animation_state(sprite, "party", "attack")

func mark_enemy_hit() -> void:
	var sprite := _ensure_enemy_sprite(selected_enemy_index)
	sprite.modulate = Color(1.0, 0.58, 0.48, 1.0)
	sprite.set_meta("presentation_state", "hit_flash")
	_set_battler_animation_state(sprite, _enemy_role(selected_enemy_index), "hurt")

func show_damage_popup(amount: int) -> Label:
	var popup_parent = get_node_or_null("Arena/Presentation")
	if popup_parent == null:
		popup_parent = get_node_or_null("Arena")
	var existing = get_node_or_null("Arena/Presentation/DamagePopup")
	if existing != null:
		existing.queue_free()
	var popup := Label.new()
	popup.name = "DamagePopup"
	popup.text = str(max(0, amount))
	popup.position = _damage_popup_position()
	popup.scale = Vector2(1.5, 1.5)
	popup.modulate = Color(1.0, 0.92, 0.58, 1.0)
	popup.set_meta("presentation_role", "damage_popup")
	popup_parent.add_child(popup)
	return popup

func show_party_damage_popup(amount: int) -> Label:
	var popup_parent = get_node_or_null("Arena/Presentation")
	if popup_parent == null:
		popup_parent = get_node_or_null("Arena")
	var existing = get_node_or_null("Arena/Presentation/PartyDamagePopup")
	if existing != null:
		existing.queue_free()
	var popup := Label.new()
	popup.name = "PartyDamagePopup"
	popup.text = str(max(0, amount))
	popup.position = _party_damage_popup_position()
	popup.scale = Vector2(1.4, 1.4)
	popup.modulate = Color(1.0, 0.72, 0.62, 1.0)
	popup.set_meta("presentation_role", "party_damage_popup")
	popup_parent.add_child(popup)
	return popup

func show_heal_popup(amount: int) -> Label:
	var popup_parent = get_node_or_null("Arena/Presentation")
	if popup_parent == null:
		popup_parent = get_node_or_null("Arena")
	var existing = get_node_or_null("Arena/Presentation/HealPopup")
	if existing != null:
		existing.queue_free()
	var popup := Label.new()
	popup.name = "HealPopup"
	popup.text = "+%d" % max(0, amount)
	popup.position = _party_damage_popup_position()
	popup.scale = Vector2(1.35, 1.35)
	popup.modulate = Color(0.60, 1.0, 0.70, 1.0)
	popup.set_meta("presentation_role", "heal_popup")
	popup_parent.add_child(popup)
	return popup

func show_enemy_heal_popup(amount: int) -> Label:
	var popup_parent = get_node_or_null("Arena/Presentation")
	if popup_parent == null:
		popup_parent = get_node_or_null("Arena")
	var existing = get_node_or_null("Arena/Presentation/EnemyHealPopup")
	if existing != null:
		existing.queue_free()
	var popup := Label.new()
	popup.name = "EnemyHealPopup"
	popup.text = "+%d" % max(0, amount)
	popup.position = _damage_popup_position()
	popup.scale = Vector2(1.35, 1.35)
	popup.modulate = Color(0.60, 1.0, 0.70, 1.0)
	popup.set_meta("presentation_role", "enemy_heal_popup")
	popup_parent.add_child(popup)
	return popup

func _damage_popup_position() -> Vector2:
	var enemy_anchor = get_node_or_null("Arena/Battlers/EnemyAnchor")
	if enemy_anchor is Marker2D:
		return enemy_anchor.position + Vector2(0, -80)
	return Vector2(724, 206)

func _party_damage_popup_position() -> Vector2:
	var party_anchor = get_node_or_null("Arena/Battlers/PartyAnchor")
	if party_anchor is Marker2D:
		return party_anchor.position + Vector2(0, -92)
	return Vector2(300, 268)

func reset_battler_presentation() -> void:
	var lead := _ensure_party_sprite()
	lead.position = lead.get_meta("home_position", lead.position)
	lead.set_meta("presentation_state", "idle")
	_set_battler_animation_state(lead, "party", "idle")
	var enemy := _ensure_enemy_sprite(selected_enemy_index)
	enemy.modulate = Color.WHITE
	enemy.set_meta("presentation_state", "idle")
	_set_battler_animation_state(enemy, _enemy_role(selected_enemy_index), "idle")
	camera_shake_strength = 0.0
	presentation_phase = "idle"
	var camera = get_node_or_null("ArenaCamera")
	if camera is Camera2D:
		camera.offset = Vector2.ZERO
	set_commands_locked(false)

func complete_action_presentation() -> void:
	if pending_enemy_retaliation:
		pending_enemy_retaliation = false
		reset_battler_presentation()
		present_enemy_retaliation()
		return
	action_presentation_timer_active = false
	reset_battler_presentation()
	focus_camera("wide")

func _start_action_presentation_timer() -> void:
	action_presentation_timer_active = true
	var timer = get_node_or_null("ActionPresentationTimer")
	if timer is Timer and timer.is_inside_tree():
		timer.start()
	elif timer is Timer:
		timer.set_meta("pending_start", true)

func _on_action_presentation_timer_timeout() -> void:
	complete_action_presentation()

func present_enemy_retaliation() -> void:
	if battle.enemies.is_empty() or battle.party.is_empty():
		complete_enemy_retaliation()
		return
	set_commands_locked(true)
	presentation_phase = "enemy_action"
	active_enemy_action_index = _first_living_enemy_index()
	var acting_enemy: Dictionary = battle.enemies[active_enemy_action_index]
	var action := battle.choose_enemy_action(String(acting_enemy.get("id", "")))
	if String(action.get("command", "attack")) == "skill":
		present_enemy_skill(action)
		return
	focus_camera("party")
	var enemy := _ensure_enemy_sprite(active_enemy_action_index)
	var home: Vector2 = enemy.get_meta("home_position", enemy.position)
	enemy.set_meta("home_position", home)
	enemy.position = home + Vector2(-54, 8)
	enemy.set_meta("presentation_state", "enemy_lunge")
	_set_battler_animation_state(enemy, _enemy_role(active_enemy_action_index), "attack")
	var target_id := String(action.get("target_id", _active_party_member().get("id", "")))
	_focus_party_member_by_id(target_id)
	var party := _ensure_party_sprite()
	party.modulate = Color(1.0, 0.62, 0.50, 1.0)
	party.set_meta("presentation_state", "hit_flash")
	_set_battler_animation_state(party, "party", "hurt")
	var damage := _apply_enemy_retaliation_damage(active_enemy_action_index, target_id)
	show_party_damage_popup(damage)
	queue_hit_shake(4.0)
	if is_party_defeated():
		present_party_defeat()
	else:
		var target := _party_member_by_id(target_id)
		_update_labels("%s retaliates against %s for %d damage." % [acting_enemy.name, String(target.get("name", "ally")), damage])
		_start_enemy_action_timer()

func present_enemy_skill(action: Dictionary) -> void:
	var skill_id := String(action.get("skill_id", ""))
	var skill := ContentCatalog.new().battle_skill(skill_id)
	focus_camera("enemy")
	active_enemy_action_index = _enemy_index_for_id(String(action.get("actor_id", "")))
	var acting_enemy: Dictionary = battle.enemies[active_enemy_action_index]
	var enemy := _ensure_enemy_sprite(active_enemy_action_index)
	enemy.set_meta("presentation_state", "enemy_skill")
	_set_battler_animation_state(enemy, _enemy_role(active_enemy_action_index), "cast")
	var result := battle.execute_command(
		String(action.get("actor_id", acting_enemy.get("id", ""))),
		"skill",
		String(action.get("target_id", acting_enemy.get("id", ""))),
		{"skill_id": skill_id}
	)
	if result.has("heal"):
		show_enemy_heal_popup(int(result.heal))
		_render_enemy_status()
		_update_labels("%s uses %s." % [acting_enemy.name, String(skill.get("display_name", skill_id))])
	elif result.has("damage"):
		var target_id := String(action.get("target_id", ""))
		_focus_party_member_by_id(target_id)
		var party := _ensure_party_sprite()
		party.modulate = Color(1.0, 0.62, 0.50, 1.0)
		party.set_meta("presentation_state", "hit_flash")
		_set_battler_animation_state(party, "party", "hurt")
		show_party_damage_popup(int(result.damage))
		_render_party_status()
		queue_hit_shake(4.0)
		var target := _party_member_by_id(target_id)
		_update_labels("%s uses %s on %s for %d damage." % [acting_enemy.name, String(skill.get("display_name", skill_id)), String(target.get("name", "ally")), int(result.damage)])
	else:
		_update_labels("%s hesitates." % acting_enemy.name)
	if is_party_defeated():
		present_party_defeat()
	else:
		_start_enemy_action_timer()

func complete_enemy_retaliation() -> void:
	enemy_action_timer_active = false
	var enemy := _ensure_enemy_sprite(active_enemy_action_index)
	enemy.position = enemy.get_meta("home_position", enemy.position)
	enemy.set_meta("presentation_state", "idle")
	_set_battler_animation_state(enemy, _enemy_role(active_enemy_action_index), "idle")
	var party := _ensure_party_sprite()
	party.modulate = Color.WHITE
	party.set_meta("presentation_state", "idle")
	_set_battler_animation_state(party, "party", "idle")
	camera_shake_strength = 0.0
	presentation_phase = "idle"
	action_presentation_timer_active = false
	var camera = get_node_or_null("ArenaCamera")
	if camera is Camera2D:
		camera.offset = Vector2.ZERO
	focus_camera("wide")
	_advance_active_party_member()
	set_commands_locked(false)

func _start_enemy_action_timer() -> void:
	enemy_action_timer_active = true
	var timer = get_node_or_null("EnemyActionTimer")
	if timer is Timer and timer.is_inside_tree():
		timer.start()
	elif timer is Timer:
		timer.set_meta("pending_start", true)

func _on_enemy_action_timer_timeout() -> void:
	complete_enemy_retaliation()

func _apply_enemy_retaliation_damage(enemy_index: int = 0, target_id: String = "") -> int:
	var enemy: Dictionary = battle.enemies[clampi(enemy_index, 0, battle.enemies.size() - 1)]
	var member: Dictionary = _party_member_by_id(target_id)
	if member.is_empty():
		member = _active_party_member()
	var stats: Dictionary = member.get("stats", {})
	var max_hp := int(stats.get("max_hp", member.get("max_hp", member.get("hp", 1))))
	var current_hp := int(member.get("hp", max_hp))
	var damage = max(1, int(enemy.get("strength", 1)) - int(stats.get("defense", 0)))
	member.hp = max(0, current_hp - damage)
	return damage

func _party_member_by_id(member_id: String) -> Dictionary:
	if member_id.is_empty():
		return {}
	for member in battle.party:
		if String(member.get("id", "")) == member_id:
			return member
	return {}

func is_party_defeated() -> bool:
	if battle.party.is_empty():
		return false
	for member in battle.party:
		var stats: Dictionary = member.get("stats", {})
		var max_hp := int(stats.get("max_hp", member.get("max_hp", member.get("hp", 1))))
		if int(member.get("hp", max_hp)) > 0:
			return false
	return true

func present_party_defeat() -> void:
	set_commands_locked(true)
	presentation_phase = "party_defeat"
	enemy_action_timer_active = false
	action_presentation_timer_active = false
	var party := _ensure_party_sprite()
	party.modulate = Color(0.70, 0.70, 0.78, 1.0)
	party.rotation_degrees = 72.0
	party.set_meta("presentation_state", "ko")
	_set_battler_animation_state(party, "party", "ko")
	focus_camera("party")
	_update_labels("Docent unit offline. Recovery attempt pending.")

func present_victory() -> void:
	presentation_phase = "victory"
	pending_enemy_retaliation = false
	action_presentation_timer_active = false
	enemy_action_timer_active = false
	set_commands_locked(false)
	var enemy := _ensure_enemy_sprite(selected_enemy_index)
	enemy.set_meta("presentation_state", "defeated")
	_set_battler_animation_state(enemy, _enemy_role(selected_enemy_index), "defeated")
	enemy.visible = false
	camera_shake_strength = 0.0
	var camera = get_node_or_null("ArenaCamera")
	if camera is Camera2D:
		camera.offset = Vector2.ZERO

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
			if pending_payload.has("enemies"):
				return pending_payload.enemies.duplicate(true)
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
			"sprite_path": "res://assets/generated/pixellab/first_slice/bell_saint_boss.png",
			"animation_set": "bell_saint_generated",
		}]
	return [{"id": "slime", "name": "Slime", "hp": 35, "max_hp": 35, "strength": 6, "defense": 2, "speed": 6, "xp": 20, "loot": {"potion": 1}, "animation_set": "slime_contradiction"}]

func _attach_party_state_to_rewards(resolved_rewards: Dictionary) -> void:
	resolved_rewards.party_state = battle.party.map(func(member): return member.duplicate(true))

func _battle_inventory() -> Dictionary:
	var game_state = _game_state()
	if game_state != null:
		return game_state.inventory
	return battle_inventory

func _victory_message(resolved_rewards: Dictionary) -> String:
	if not resolved_rewards.get("memory_cards", []).is_empty():
		return "Victory. Anchor recovered: Bell Clapper. Memory Card acquired: The Bell Saint."
	return "Victory. Gained %d XP." % resolved_rewards.xp

func _update_labels(message: String) -> void:
	_resolve_late_bound_nodes()
	_render_enemy_sprite()
	_render_enemy_status()
	_render_party_status()
	if party_label == null or enemy_label == null or log_label == null:
		return
	var game_state = _game_state()
	var loadout_line := SevRecordService.new().battle_line(game_state.profile) if game_state != null and game_state.profile else ""
	_update_party_roster_label()
	if not loadout_line.is_empty():
		party_label.text += "\n\n" + loadout_line
	enemy_label.text = "Enemies\n" + "\n".join(battle.enemies.map(func(enemy): return "%s HP %d/%d" % [enemy.name, enemy.hp, enemy.max_hp]))
	log_label.text = message

func _update_party_roster_label() -> void:
	if party_label == null:
		return
	var rows: Array[String] = []
	for index in range(battle.party.size()):
		var member: Dictionary = battle.party[index]
		var marker := ">" if index == active_party_index else " "
		rows.append("%s %s Lv.%d" % [marker, String(member.get("name", "Hero")), int(member.get("level", 1))])
	party_label.text = "Party\n" + "\n".join(rows)
	_render_party_roster_buttons()

func _render_party_roster_buttons() -> void:
	var roster = get_node_or_null("%PartyRoster")
	if not roster is VBoxContainer:
		return
	if roster.get_child_count() == battle.party.size():
		for index in range(battle.party.size()):
			var child = roster.get_child(index)
			if child is Button:
				var member: Dictionary = battle.party[index]
				child.text = _party_roster_button_text(member)
				child.button_pressed = index == active_party_index
				child.disabled = not _is_party_member_alive(member)
		return
	_clear_menu_children(roster)
	for index in range(battle.party.size()):
		var member: Dictionary = battle.party[index]
		var button := Button.new()
		button.text = _party_roster_button_text(member)
		button.toggle_mode = true
		button.button_pressed = index == active_party_index
		button.disabled = not _is_party_member_alive(member)
		button.set_meta("party_index", index)
		button.pressed.connect(Callable(self, "select_party_member").bind(index))
		roster.add_child(button)

func _party_roster_button_text(member: Dictionary) -> String:
	var stats: Dictionary = member.get("stats", {})
	var max_hp := int(stats.get("max_hp", member.get("max_hp", member.get("hp", 1))))
	var hp := int(member.get("hp", max_hp))
	return "%s  Lv.%d  HP %d/%d" % [
		String(member.get("name", "Hero")),
		int(member.get("level", 1)),
		clampi(hp, 0, max_hp),
		max_hp,
	]

func _is_party_member_alive(member: Dictionary) -> bool:
	var stats: Dictionary = member.get("stats", {})
	var max_hp := int(stats.get("max_hp", member.get("max_hp", member.get("hp", 1))))
	return int(member.get("hp", max_hp)) > 0

func _most_wounded_living_party_member_id() -> String:
	var best_id := String(_active_party_member().get("id", ""))
	var largest_missing_hp := -1
	for member in battle.party:
		if not _is_party_member_alive(member):
			continue
		var stats: Dictionary = member.get("stats", {})
		var max_hp := int(stats.get("max_hp", member.get("max_hp", member.get("hp", 1))))
		var hp := int(member.get("hp", max_hp))
		var missing_hp := max_hp - hp
		if missing_hp > largest_missing_hp:
			largest_missing_hp = missing_hp
			best_id = String(member.get("id", best_id))
	return best_id

func _render_enemy_sprite() -> void:
	if battle.enemies.is_empty():
		return
	selected_enemy_index = clampi(selected_enemy_index, 0, battle.enemies.size() - 1)
	for index in range(battle.enemies.size()):
		var enemy: Dictionary = battle.enemies[index]
		var sprite_path := String(enemy.get("sprite_path", ""))
		var sprite := _ensure_enemy_sprite(index)
		sprite.set_meta("animation_set", String(enemy.get("animation_set", enemy.get("id", "enemy"))))
		if String(sprite.get_meta("animation_state", "")) == "":
			_set_battler_animation_state(sprite, _enemy_role(index), "idle")
		var texture := _animation_texture_for_sprite(sprite, _enemy_role(index))
		if texture == null and not sprite_path.is_empty():
			texture = _load_texture(sprite_path)
		sprite.texture = texture
		sprite.visible = texture != null and presentation_phase != "victory" and int(enemy.get("hp", 0)) > 0
		sprite.modulate = Color.WHITE if index == selected_enemy_index else Color(0.78, 0.78, 0.84, 1.0)
		sprite.set_meta("sprite_path", sprite_path)
		sprite.set_meta("enemy_id", String(enemy.get("id", "")))

func _set_battler_animation_state(sprite: Sprite2D, role: String, state: String) -> void:
	if String(sprite.get_meta("animation_state", "")) != state:
		battler_animation_time[role] = 0.0
		battler_animation_index[role] = 0
	sprite.set_meta("animation_state", state)
	_apply_battler_animation_frame(sprite, role)

func _advance_battler_animations(delta: float) -> void:
	_advance_battler_animation(_ensure_party_sprite(), "party", delta)
	for index in range(battle.enemies.size()):
		_advance_battler_animation(_ensure_enemy_sprite(index), _enemy_role(index), delta)

func _advance_battler_animation(sprite: Sprite2D, role: String, delta: float) -> void:
	var state_data := _animation_state_data(sprite)
	var frames: Array = state_data.get("frames", [])
	if frames.is_empty():
		return
	var fps := maxf(1.0, float(state_data.get("fps", 6)))
	battler_animation_time[role] = float(battler_animation_time.get(role, 0.0)) + delta
	var frame_duration := 1.0 / fps
	if float(battler_animation_time[role]) < frame_duration:
		return
	battler_animation_time[role] = 0.0
	var next_index := int(battler_animation_index.get(role, 0)) + 1
	if next_index >= frames.size():
		next_index = 0 if bool(state_data.get("loop", true)) else frames.size() - 1
	battler_animation_index[role] = next_index
	_apply_battler_animation_frame(sprite, role)

func _apply_battler_animation_frame(sprite: Sprite2D, role: String) -> void:
	var texture := _animation_texture_for_sprite(sprite, role)
	if texture != null:
		sprite.texture = texture

func _animation_texture_for_sprite(sprite: Sprite2D, role: String) -> Texture2D:
	var state_data := _animation_state_data(sprite)
	var frames: Array = state_data.get("frames", [])
	if frames.is_empty():
		return null
	var index := clampi(int(battler_animation_index.get(role, 0)), 0, frames.size() - 1)
	return _load_texture_cached(String(frames[index]))

func _animation_state_data(sprite: Sprite2D) -> Dictionary:
	var set_id := String(sprite.get_meta("animation_set", ""))
	var state := String(sprite.get_meta("animation_state", "idle"))
	if set_id.is_empty():
		return {}
	var animation_set := ContentCatalog.new().battle_animation_set(set_id)
	var states: Dictionary = animation_set.get("states", {})
	var state_data: Dictionary = states.get(state, {})
	if state_data.is_empty() and state != "idle":
		state_data = states.get("idle", {})
	return state_data

func _load_texture_cached(path: String) -> Texture2D:
	if path.is_empty():
		return null
	if animation_texture_cache.has(path):
		return animation_texture_cache[path]
	var texture := _load_texture(path)
	if texture != null:
		animation_texture_cache[path] = texture
	return texture

func _render_enemy_status() -> void:
	if battle.enemies.is_empty():
		return
	var enemy: Dictionary = _selected_enemy()
	var name_label = get_node_or_null("%EnemyNameLabel")
	if name_label is Label:
		name_label.text = String(enemy.get("name", "Enemy"))
	var hp_bar = get_node_or_null("%EnemyHpBar")
	if hp_bar is ProgressBar:
		hp_bar.max_value = float(enemy.get("max_hp", enemy.get("hp", 1)))
		hp_bar.value = clampf(float(enemy.get("hp", 0)), 0.0, hp_bar.max_value)
	_render_status_label("%EnemyStatusEffects", enemy)

func _selected_enemy() -> Dictionary:
	if battle.enemies.is_empty():
		return {}
	selected_enemy_index = clampi(selected_enemy_index, 0, battle.enemies.size() - 1)
	return battle.enemies[selected_enemy_index]

func _select_first_living_enemy_if_selected_defeated() -> void:
	if battle.enemies.is_empty():
		selected_enemy_index = 0
		return
	selected_enemy_index = clampi(selected_enemy_index, 0, battle.enemies.size() - 1)
	if int(battle.enemies[selected_enemy_index].get("hp", 0)) > 0:
		return
	for index in range(battle.enemies.size()):
		if int(battle.enemies[index].get("hp", 0)) > 0:
			selected_enemy_index = index
			return

func _first_living_enemy_index() -> int:
	for index in range(battle.enemies.size()):
		if int(battle.enemies[index].get("hp", 0)) > 0:
			return index
	return 0

func _enemy_index_for_id(enemy_id: String) -> int:
	for index in range(battle.enemies.size()):
		if String(battle.enemies[index].get("id", "")) == enemy_id:
			return index
	return _first_living_enemy_index()

func _enemy_role(index: int) -> String:
	return "enemy_%d" % index

func _render_party_status() -> void:
	if battle.party.is_empty():
		return
	active_party_index = clampi(active_party_index, 0, battle.party.size() - 1)
	var member: Dictionary = _active_party_member()
	var stats: Dictionary = member.get("stats", {})
	var max_hp := float(stats.get("max_hp", member.get("max_hp", member.get("hp", 1))))
	var current_hp := float(member.get("hp", max_hp))
	var name_label = get_node_or_null("%PartyNameLabel")
	if name_label is Label:
		name_label.text = "%s Lv.%d" % [String(member.get("name", "Sev")), int(member.get("level", 1))]
	var role_label = get_node_or_null("%PartyRoleLabel")
	if role_label is Label:
		role_label.text = _format_class_name(String(member.get("class_id", "uncatalogued")))
	var hp_bar = get_node_or_null("%PartyHpBar")
	if hp_bar is ProgressBar:
		hp_bar.max_value = maxf(1.0, max_hp)
		hp_bar.value = clampf(current_hp, 0.0, hp_bar.max_value)
	_sync_active_party_sprite(member)
	_render_status_label("%PartyStatusEffects", member)

func _sync_active_party_sprite(member: Dictionary) -> void:
	var sprite := _ensure_party_sprite()
	var animation_set := String(member.get("animation_set", "sev_placeholder"))
	if animation_set.is_empty():
		animation_set = "sev_placeholder"
	sprite.set_meta("animation_set", animation_set)
	if String(sprite.get_meta("animation_state", "")) == "":
		_set_battler_animation_state(sprite, "party", "idle")
	else:
		_apply_battler_animation_frame(sprite, "party")

func _active_party_member() -> Dictionary:
	if battle.party.is_empty():
		return {}
	active_party_index = clampi(active_party_index, 0, battle.party.size() - 1)
	return battle.party[active_party_index]

func _focus_party_member_by_id(member_id: String) -> void:
	for index in range(battle.party.size()):
		if String(battle.party[index].get("id", "")) == member_id:
			active_party_index = index
			_render_party_status()
			_update_party_roster_label()
			return

func _advance_active_party_member() -> void:
	if battle.party.is_empty():
		active_party_index = 0
		return
	var start_index := active_party_index
	for offset in range(1, battle.party.size() + 1):
		var index := (start_index + offset) % battle.party.size()
		var member: Dictionary = battle.party[index]
		var stats: Dictionary = member.get("stats", {})
		var max_hp := int(stats.get("max_hp", member.get("max_hp", member.get("hp", 1))))
		if int(member.get("hp", max_hp)) > 0:
			active_party_index = index
			_render_party_status()
			_update_party_roster_label()
			return

func _ensure_active_party_member_can_act() -> void:
	if battle.party.is_empty():
		active_party_index = 0
		return
	active_party_index = clampi(active_party_index, 0, battle.party.size() - 1)
	if _is_party_member_alive(battle.party[active_party_index]):
		return
	_advance_active_party_member()

func _render_status_label(node_path: String, combatant: Dictionary) -> void:
	var label = get_node_or_null(node_path)
	if label is Label:
		label.text = _format_status_effects(combatant)

func _format_status_effects(combatant: Dictionary) -> String:
	var statuses: Dictionary = combatant.get("statuses", {})
	if statuses.is_empty():
		return "Status: Normal"
	var parts: Array[String] = []
	for status_id in statuses.keys():
		var status: Dictionary = statuses[status_id]
		parts.append("%s %d" % [String(status_id).capitalize(), int(status.get("turns", 1))])
	return "Status: %s" % ", ".join(parts)

func _format_class_name(class_id: String) -> String:
	var words := class_id.split("_", false)
	for index in range(words.size()):
		words[index] = String(words[index]).capitalize()
	return " ".join(words)

func _ensure_enemy_sprite(index: int = 0) -> Sprite2D:
	if enemy_sprites.has(index) and is_instance_valid(enemy_sprites[index]):
		return enemy_sprites[index]
	var existing = get_node_or_null("Arena/Battlers/EnemyAnchor/%s" % _enemy_sprite_name(index))
	if existing is Sprite2D:
		enemy_sprites[index] = existing
		if index == 0:
			enemy_sprite = existing
		return existing
	var sprite := Sprite2D.new()
	sprite.name = _enemy_sprite_name(index)
	sprite.position = _enemy_formation_position(index)
	sprite.scale = Vector2(2.25, 2.25)
	sprite.set_meta("presentation_role", "enemy")
	var enemy_anchor = get_node_or_null("Arena/Battlers/EnemyAnchor")
	if enemy_anchor != null:
		enemy_anchor.add_child(sprite)
	else:
		add_child(sprite)
	enemy_sprites[index] = sprite
	if index == 0:
		enemy_sprite = sprite
	return sprite

func _enemy_sprite_name(index: int) -> String:
	return "EnemyBattler" if index == 0 else "EnemyBattler_%d" % index

func _enemy_formation_position(index: int) -> Vector2:
	var positions := [
		Vector2(0, -54),
		Vector2(-82, 4),
		Vector2(72, -8),
		Vector2(-38, -84),
	]
	if index < positions.size():
		return positions[index]
	return Vector2(-82 + ((index - 1) * 52), 4 + ((index % 2) * -36))

func _ensure_party_sprite() -> Sprite2D:
	if party_sprite != null and is_instance_valid(party_sprite):
		return party_sprite
	var existing = get_node_or_null("Arena/Battlers/PartyAnchor/PartyBattler")
	if existing is Sprite2D:
		party_sprite = existing
	else:
		party_sprite = Sprite2D.new()
		party_sprite.name = "PartyBattler"
		var party_anchor = get_node_or_null("Arena/Battlers/PartyAnchor")
		if party_anchor != null:
			party_anchor.add_child(party_sprite)
		else:
			add_child(party_sprite)
	if party_sprite.texture == null:
		party_sprite.texture = _create_party_placeholder_texture()
	party_sprite.set_meta("presentation_role", "party_lead")
	return party_sprite

func _create_party_placeholder_texture() -> Texture2D:
	var image := Image.create(32, 48, false, Image.FORMAT_RGBA8)
	image.fill(Color(0, 0, 0, 0))
	for y in range(4, 44):
		for x in range(9, 23):
			if y < 14 and x >= 11 and x <= 20:
				image.set_pixel(x, y, Color(0.76, 0.78, 0.82, 1))
			elif y >= 14 and y < 32:
				image.set_pixel(x, y, Color(0.28, 0.36, 0.54, 1))
			elif y >= 32 and (x < 15 or x > 17):
				image.set_pixel(x, y, Color(0.12, 0.14, 0.20, 1))
	return ImageTexture.create_from_image(image)

func _load_texture(path: String) -> Texture2D:
	if not FileAccess.file_exists(path):
		return null
	var image := Image.new()
	var result := image.load(path)
	if result != OK:
		return null
	return ImageTexture.create_from_image(image)

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
	if party_label == null:
		party_label = get_node_or_null("%PartyLabel")
	if enemy_label == null:
		enemy_label = get_node_or_null("%EnemyLabel")
	if log_label == null:
		log_label = get_node_or_null("%LogLabel")
