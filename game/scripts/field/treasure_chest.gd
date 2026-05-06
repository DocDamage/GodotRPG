extends Area2D

const TreasureService = preload("res://scripts/field/treasure_service.gd")

@export var treasure_id: String = "dungeon_chest_01"
@export var loot: Dictionary = {"potion": 1, "iron_ring": 1}

@onready var body: ColorRect = %Body

var collected := false

func _ready() -> void:
	var flag_id := "treasure_%s" % treasure_id
	var game_state = get_node_or_null("/root/GameState")
	collected = game_state.flags.get(flag_id, false) if game_state else false
	_update_visual()

func interact() -> Dictionary:
	var game_state = get_node_or_null("/root/GameState")
	if game_state == null:
		return {"collected": false}
	var result := TreasureService.new().pickup(game_state.to_save_state(), {
		"id": treasure_id,
		"loot": loot,
	})
	if result.get("collected", false):
		game_state.add_inventory_items(loot)
		game_state.flags[result.flag] = true
		collected = true
		_update_visual()
	return result

func _update_visual() -> void:
	if body:
		body.color = Color(0.35, 0.25, 0.14, 1) if collected else Color(0.75, 0.48, 0.18, 1)
