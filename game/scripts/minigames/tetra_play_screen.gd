class_name TetraPlayScreen
extends Control

signal match_finished(payload: Dictionary)

const TetraCardCatalogScript := preload("res://scripts/cards/tetra_card_catalog.gd")
const TetraBoardScript := preload("res://scripts/cards/tetra_board.gd")
const TetraRulesScript := preload("res://scripts/cards/tetra_rules.gd")
const InputPromptService := preload("res://scripts/core/input_prompt_service.gd")
const BOARD_TEXTURE_PATH := "res://assets/cards/boards/tetra_master_board.png"
const BOARD_NATIVE_SIZE := Vector2(371, 500)
const BOARD_POSITION := Vector2(184, 56)
const BOARD_SLOT_SIZE := Vector2(72, 72)
const BOARD_CARD_SIZE := Vector2(48, 67)
const DIRECTION_OFFSETS := {
	"N": Vector2i(0, -1),
	"NE": Vector2i(1, -1),
	"E": Vector2i(1, 0),
	"SE": Vector2i(1, 1),
	"S": Vector2i(0, 1),
	"SW": Vector2i(-1, 1),
	"W": Vector2i(-1, 0),
	"NW": Vector2i(-1, -1),
}

var catalog := TetraCardCatalogScript.new()
var board := TetraBoardScript.new()
var rules := TetraRulesScript.new()
var player_hand: Array[Dictionary] = []
var opponent_hand: Array[Dictionary] = []
var current_turn := 0
var selected_hand_index := -1
var auto_play_opponent := false
var _match_finished_emitted := false
var controller_focus_fallback := ""


func _ready() -> void:
	_ensure_nodes()


func setup_new_match() -> void:
	_ensure_nodes()
	board = TetraBoardScript.new()
	current_turn = 0
	selected_hand_index = -1
	_match_finished_emitted = false
	$BoardTexture.texture = _texture_from_file(BOARD_TEXTURE_PATH)
	$StatusLabel.text = "Memory Cards - Tetra Match"
	player_hand.clear()
	opponent_hand.clear()
	for card_id in catalog.starter_deck():
		player_hand.append(catalog.card(card_id))
		opponent_hand.append(catalog.card(card_id))
	_render_slot_markers()
	_render_board_slot_buttons()
	_clear_placed_cards()
	_refresh_match_status()
	_render_player_hand_buttons()


func set_player_hand(cards: Array) -> void:
	player_hand.clear()
	for card in cards:
		if typeof(card) == TYPE_DICTIONARY:
			player_hand.append(card.duplicate(true))
	selected_hand_index = -1
	_render_player_hand_buttons()
	_refresh_match_status()


func set_opponent_hand(cards: Array) -> void:
	opponent_hand.clear()
	for card in cards:
		if typeof(card) == TYPE_DICTIONARY:
			opponent_hand.append(card.duplicate(true))
	_refresh_match_status()


func choose_opponent_move() -> Dictionary:
	if opponent_hand.is_empty():
		return {}
	var best_move := {}
	var best_captures := -1
	for slot_index in 9:
		var grid := _slot_index_to_grid(slot_index)
		if not board.is_empty(grid.x, grid.y):
			continue
		for hand_index in opponent_hand.size():
			var capture_count := _capture_count_for_move(slot_index, opponent_hand[hand_index], 1)
			if capture_count > best_captures:
				best_captures = capture_count
				best_move = {
					"hand_index": hand_index,
					"slot_index": slot_index,
					"captures": capture_count,
				}
	return best_move


func play_opponent_turn() -> bool:
	var move := choose_opponent_move()
	if move.is_empty():
		return false
	var hand_index := int(move.hand_index)
	if hand_index < 0 or hand_index >= opponent_hand.size():
		return false
	var card := opponent_hand[hand_index]
	if not place_card_for_owner(int(move.slot_index), card, 1):
		return false
	opponent_hand.remove_at(hand_index)
	current_turn = 0
	_after_turn_completed()
	return true


func select_player_hand_card(hand_index: int) -> bool:
	if current_turn != 0 or is_match_over():
		return false
	if hand_index < 0 or hand_index >= player_hand.size():
		return false
	selected_hand_index = hand_index
	_render_player_hand_buttons()
	_focus_first_board_slot()
	return true


func play_selected_card_to_slot(slot_index: int) -> bool:
	if selected_hand_index < 0:
		return false
	return place_player_card_from_hand(selected_hand_index, slot_index)


func place_player_card_from_hand(hand_index: int, slot_index: int) -> bool:
	if current_turn != 0 or is_match_over():
		return false
	if hand_index < 0 or hand_index >= player_hand.size():
		return false
	if slot_index < 0 or slot_index >= 9:
		return false
	var card := player_hand[hand_index]
	if not place_card_for_owner(slot_index, card, 0):
		return false
	player_hand.remove_at(hand_index)
	selected_hand_index = -1
	current_turn = 1
	_after_turn_completed()
	if auto_play_opponent and current_turn == 1 and not is_match_over():
		play_opponent_turn()
	return true


func place_card_for_owner(slot_index: int, card: Dictionary, owner: int) -> bool:
	if slot_index < 0 or slot_index >= 9:
		return false
	var grid := _slot_index_to_grid(slot_index)
	if not board.place_card(grid.x, grid.y, card, owner):
		return false
	_render_placed_card(slot_index, card, owner)
	var captures := board.resolve_captures_from(grid.x, grid.y)
	_update_captured_visuals(captures, owner)
	return true


func color_for_owner(owner: int) -> Color:
	return Color(0.12, 0.32, 0.75, 0.92) if owner == 0 else Color(0.65, 0.16, 0.12, 0.92)


func score() -> Dictionary:
	var result := {
		"player": 0,
		"opponent": 0,
		"empty": 0,
	}
	for y in 3:
		for x in 3:
			match board.owner_at(x, y):
				0:
					result.player += 1
				1:
					result.opponent += 1
				_:
					result.empty += 1
	return result


func is_match_over() -> bool:
	return score().empty == 0


func match_result() -> Dictionary:
	var current_score := score()
	var winner := "draw"
	if current_score.player > current_score.opponent:
		winner = "player"
	elif current_score.opponent > current_score.player:
		winner = "opponent"
	return {
		"winner": winner,
		"score": current_score,
	}


func refresh_match_status() -> void:
	_refresh_match_status()


func finish_payload() -> Dictionary:
	var result := match_result()
	result["remaining_player_cards"] = player_hand.size()
	result["remaining_opponent_cards"] = opponent_hand.size()
	return result


func board_slot_positions() -> Array[Vector2]:
	var origin := BOARD_POSITION + Vector2(52, 92)
	var spacing := Vector2(88, 88)
	var positions: Array[Vector2] = []
	for y in 3:
		for x in 3:
			positions.append(origin + Vector2(x * spacing.x, y * spacing.y))
	return positions


func board_display_size() -> Vector2:
	return $BoardTexture.size


func board_slot_size() -> Vector2:
	return BOARD_SLOT_SIZE


func board_card_size() -> Vector2:
	return BOARD_CARD_SIZE


func board_slots_do_not_overlap() -> bool:
	var positions := board_slot_positions()
	for a in positions.size():
		var rect_a := Rect2(positions[a], BOARD_SLOT_SIZE)
		for b in range(a + 1, positions.size()):
			var rect_b := Rect2(positions[b], BOARD_SLOT_SIZE)
			if rect_a.intersects(rect_b):
				return false
	return true


func slot_rect_for_index(index: int) -> Rect2:
	var positions := board_slot_positions()
	if index < 0 or index >= positions.size():
		return Rect2()
	return Rect2(positions[index], BOARD_SLOT_SIZE)


func card_rect_for_slot(index: int) -> Rect2:
	var slot_rect := slot_rect_for_index(index)
	if slot_rect.size == Vector2.ZERO:
		return Rect2()
	var offset := (slot_rect.size - BOARD_CARD_SIZE) * 0.5
	return Rect2(slot_rect.position + offset, BOARD_CARD_SIZE)


func _render_slot_markers() -> void:
	var marker_layer := $SlotMarkers
	for child in marker_layer.get_children():
		child.free()
	for index in board_slot_positions().size():
		var marker := ColorRect.new()
		marker.name = "Slot%d" % index
		marker.position = board_slot_positions()[index]
		marker.size = BOARD_SLOT_SIZE
		marker.color = Color(0.2, 0.8, 1.0, 0.14)
		marker_layer.add_child(marker)


func _render_board_slot_buttons() -> void:
	var button_layer := $BoardSlotButtons
	for child in button_layer.get_children():
		child.free()
	for index in board_slot_positions().size():
		var button := Button.new()
		button.name = "SlotButton%d" % index
		button.position = board_slot_positions()[index]
		button.size = BOARD_SLOT_SIZE
		button.text = ""
		button.modulate = Color(1, 1, 1, 0.25)
		button.focus_mode = Control.FOCUS_ALL
		button.pressed.connect(func(slot_index := index): play_selected_card_to_slot(slot_index))
		button_layer.add_child(button)


func _render_placed_card(slot_index: int, card: Dictionary, owner: int) -> void:
	var placed_layer := $PlacedCards
	var existing := placed_layer.get_node_or_null("Slot%d" % slot_index)
	if existing:
		existing.queue_free()
	var card_rect := card_rect_for_slot(slot_index)
	var node := ColorRect.new()
	node.name = "Slot%d" % slot_index
	node.position = card_rect.position
	node.size = card_rect.size
	node.color = color_for_owner(owner)
	node.set_meta("owner", owner)
	placed_layer.add_child(node)

	var name_label := Label.new()
	name_label.name = "NameLabel"
	name_label.position = Vector2(2, 2)
	name_label.size = Vector2(card_rect.size.x - 4, 24)
	name_label.text = str(card.get("name", ""))
	name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	name_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	name_label.add_theme_font_size_override("font_size", 7)
	node.add_child(name_label)


func _clear_placed_cards() -> void:
	for child in $PlacedCards.get_children():
		child.free()


func _update_captured_visuals(captures: Array[Vector2i], owner: int) -> void:
	for grid in captures:
		var slot_index := _grid_to_slot_index(grid)
		var node := $PlacedCards.get_node_or_null("Slot%d" % slot_index)
		if node is ColorRect:
			node.color = color_for_owner(owner)
			node.set_meta("owner", owner)


func _refresh_match_status() -> void:
	_ensure_nodes()
	var current_score := score()
	$PlayerHandLabel.text = "Player Hand: %d" % player_hand.size()
	$OpponentHandLabel.text = "Opponent Hand: %d" % opponent_hand.size()
	$ScoreLabel.text = "Score %d-%d" % [current_score.player, current_score.opponent]
	if is_match_over():
		$TurnLabel.text = "Match Over: %s" % match_result().winner.capitalize()
	else:
		$TurnLabel.text = "Player Turn" if current_turn == 0 else "Opponent Turn"


func _render_player_hand_buttons() -> void:
	_ensure_nodes()
	var hand_layer := $PlayerHandButtons
	for child in hand_layer.get_children():
		child.free()
	for index in player_hand.size():
		var card := player_hand[index]
		var button := Button.new()
		button.name = "HandButton%d" % index
		button.position = Vector2(16, 188 + index * 34)
		button.size = Vector2(152, 28)
		button.text = "%s  P:%s" % [card.get("name", ""), card.get("power", 0)]
		if index == selected_hand_index:
			button.text = "> %s" % button.text
		button.focus_mode = Control.FOCUS_ALL
		button.pressed.connect(func(hand_index := index): select_player_hand_card(hand_index))
		hand_layer.add_child(button)
	if selected_hand_index < 0:
		_focus_first_hand_button()


func _after_turn_completed() -> void:
	_refresh_match_status()
	_render_player_hand_buttons()
	if is_match_over() and not _match_finished_emitted:
		_match_finished_emitted = true
		match_finished.emit(finish_payload())


func _ensure_nodes() -> void:
	custom_minimum_size = Vector2(768, 600)
	if has_node("BoardTexture"):
		return

	var board_texture := TextureRect.new()
	board_texture.name = "BoardTexture"
	board_texture.position = BOARD_POSITION
	board_texture.size = BOARD_NATIVE_SIZE
	board_texture.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	board_texture.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	add_child(board_texture)

	var slot_markers := Control.new()
	slot_markers.name = "SlotMarkers"
	slot_markers.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(slot_markers)

	var placed_cards := Control.new()
	placed_cards.name = "PlacedCards"
	placed_cards.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(placed_cards)

	var board_slot_buttons := Control.new()
	board_slot_buttons.name = "BoardSlotButtons"
	add_child(board_slot_buttons)

	var status_label := Label.new()
	status_label.name = "StatusLabel"
	status_label.position = Vector2(16, 16)
	status_label.size = Vector2(240, 24)
	status_label.add_theme_font_size_override("font_size", 16)
	add_child(status_label)

	var player_hand_label := Label.new()
	player_hand_label.name = "PlayerHandLabel"
	player_hand_label.position = Vector2(16, 64)
	player_hand_label.size = Vector2(150, 20)
	add_child(player_hand_label)

	var opponent_hand_label := Label.new()
	opponent_hand_label.name = "OpponentHandLabel"
	opponent_hand_label.position = Vector2(16, 88)
	opponent_hand_label.size = Vector2(170, 20)
	add_child(opponent_hand_label)

	var score_label := Label.new()
	score_label.name = "ScoreLabel"
	score_label.position = Vector2(16, 112)
	score_label.size = Vector2(150, 20)
	add_child(score_label)

	var turn_label := Label.new()
	turn_label.name = "TurnLabel"
	turn_label.position = Vector2(16, 136)
	turn_label.size = Vector2(180, 20)
	add_child(turn_label)

	var prompt := Label.new()
	prompt.name = "ControllerHelpPrompt"
	prompt.position = Vector2(16, 552)
	prompt.size = Vector2(560, 22)
	prompt.text = "D-pad/left stick: choose card/slot   %s: select/place   %s: back" % [
		InputPromptService.new().mixed_action_label("interact", "xbox"),
		InputPromptService.new().mixed_action_label("cancel", "xbox"),
	]
	add_child(prompt)

	var hand_buttons := Control.new()
	hand_buttons.name = "PlayerHandButtons"
	add_child(hand_buttons)


func _focus_first_hand_button() -> void:
	if not is_inside_tree() or not has_node("PlayerHandButtons"):
		return
	var hand_layer := $PlayerHandButtons
	if hand_layer.get_child_count() > 0 and hand_layer.get_child(0) is Control:
		_remember_controller_focus(hand_layer.get_child(0))


func _focus_first_board_slot() -> void:
	if not is_inside_tree() or not has_node("BoardSlotButtons"):
		return
	var slot_layer := $BoardSlotButtons
	if slot_layer.get_child_count() > 0 and slot_layer.get_child(0) is Control:
		_remember_controller_focus(slot_layer.get_child(0))


func controller_focus_owner_name() -> String:
	if controller_focus_fallback.is_empty():
		return "SlotButton0" if selected_hand_index >= 0 else "HandButton0"
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


func _texture_from_file(path: String) -> Texture2D:
	if ResourceLoader.exists(path):
		return load(path)
	var image := Image.new()
	if image.load(path) != OK:
		return null
	return ImageTexture.create_from_image(image)


func _slot_index_to_grid(slot_index: int) -> Vector2i:
	return Vector2i(slot_index % 3, slot_index / 3)


func _grid_to_slot_index(grid: Vector2i) -> int:
	return grid.y * 3 + grid.x


func _capture_count_for_move(slot_index: int, card: Dictionary, owner: int) -> int:
	var grid := _slot_index_to_grid(slot_index)
	var count := 0
	for direction in DIRECTION_OFFSETS.keys():
		if not rules.has_arrow(card, direction):
			continue
		var target: Vector2i = grid + DIRECTION_OFFSETS[direction]
		if target.x < 0 or target.y < 0 or target.x >= 3 or target.y >= 3:
			continue
		if board.is_empty(target.x, target.y) or board.owner_at(target.x, target.y) == owner:
			continue
		var defender := board.card_at(target.x, target.y)
		if rules.attack_value(card) > rules.defense_value(card, defender):
			count += 1
	return count
