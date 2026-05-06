class_name TetraBoard
extends RefCounted

const TetraRulesScript := preload("res://scripts/cards/tetra_rules.gd")
const SIZE := 3
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

var cells: Array = []
var rules := TetraRulesScript.new()

func _init() -> void:
	for y in SIZE:
		var row := []
		for x in SIZE:
			row.append({})
		cells.append(row)

func is_empty(x: int, y: int) -> bool:
	if not _in_bounds(x, y):
		return false
	return cells[y][x].is_empty()

func place_card(x: int, y: int, card: Dictionary, owner: int) -> bool:
	if not _in_bounds(x, y) or not is_empty(x, y):
		return false
	cells[y][x] = {
		"card": card.duplicate(true),
		"owner": owner,
	}
	return true

func owner_at(x: int, y: int) -> int:
	if not _in_bounds(x, y) or is_empty(x, y):
		return -1
	return int(cells[y][x].owner)

func card_at(x: int, y: int) -> Dictionary:
	if not _in_bounds(x, y) or is_empty(x, y):
		return {}
	return cells[y][x].card

func resolve_captures_from(x: int, y: int) -> Array[Vector2i]:
	if not _in_bounds(x, y) or is_empty(x, y):
		return []
	var captures: Array[Vector2i] = []
	var attacker_cell: Dictionary = cells[y][x]
	var attacker: Dictionary = attacker_cell.card
	var owner := int(attacker_cell.owner)

	for direction in DIRECTION_OFFSETS.keys():
		if not rules.has_arrow(attacker, direction):
			continue
		var offset: Vector2i = DIRECTION_OFFSETS[direction]
		var target := Vector2i(x + offset.x, y + offset.y)
		if not _in_bounds(target.x, target.y) or is_empty(target.x, target.y):
			continue
		if owner_at(target.x, target.y) == owner:
			continue
		var defender := card_at(target.x, target.y)
		if rules.attack_value(attacker) > rules.defense_value(attacker, defender):
			cells[target.y][target.x].owner = owner
			captures.append(target)

	return captures

func _in_bounds(x: int, y: int) -> bool:
	return x >= 0 and y >= 0 and x < SIZE and y < SIZE
