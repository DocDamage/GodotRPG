class_name MinigameHost
extends Control

signal minigame_launch_requested(payload: Dictionary)

const MinigameCatalogScript := preload("res://scripts/core/minigame_catalog.gd")

@export var location_id := "museum_hub"
@export var available_chapter := 0
@export var title := "Minigames"

var catalog := MinigameCatalogScript.new()


func _ready() -> void:
	refresh()


func available_games() -> Array[Dictionary]:
	var games: Array[Dictionary] = []
	for game in catalog.for_location(location_id):
		if int(game.get("unlock_chapter", 0)) <= available_chapter:
			games.append(game)
	return games


func launch_payload(game_id: String) -> Dictionary:
	for game in available_games():
		if game.get("id", "") == game_id:
			var payload := game.duplicate(true)
			payload["location_id"] = location_id
			return payload
	return {}


func request_launch(game_id: String) -> Dictionary:
	var payload := launch_payload(game_id)
	if payload.is_empty():
		return {}
	minigame_launch_requested.emit(payload)
	return payload


func refresh() -> void:
	_ensure_nodes()
	$TitleLabel.text = title
	var lines: Array[String] = []
	for game in available_games():
		lines.append("%s - %s" % [game.get("name", ""), game.get("description", "")])
	$GameListLabel.text = "\n".join(lines)


func interact() -> Dictionary:
	refresh()
	return {
		"type": "minigame_host",
		"location_id": location_id,
		"games": available_games(),
	}


func _ensure_nodes() -> void:
	custom_minimum_size = Vector2(320, 160)
	if has_node("TitleLabel"):
		return
	var title_label := Label.new()
	title_label.name = "TitleLabel"
	title_label.position = Vector2(8, 8)
	title_label.size = Vector2(304, 24)
	title_label.add_theme_font_size_override("font_size", 18)
	add_child(title_label)

	var game_list_label := Label.new()
	game_list_label.name = "GameListLabel"
	game_list_label.position = Vector2(8, 40)
	game_list_label.size = Vector2(304, 112)
	game_list_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	game_list_label.add_theme_font_size_override("font_size", 11)
	add_child(game_list_label)
