class_name FieldController
extends RefCounted

const TILE_SIZE := 16.0

func movement_vector(actions: Dictionary) -> Vector2:
	var vector := Vector2.ZERO
	if actions.get("move_left", false):
		vector.x -= 1.0
	if actions.get("move_right", false):
		vector.x += 1.0
	if actions.get("move_up", false):
		vector.y -= 1.0
	if actions.get("move_down", false):
		vector.y += 1.0
	if vector.length_squared() > 1.0:
		return vector.normalized()
	return vector

func input_movement_vector() -> Vector2:
	return movement_vector({
		"move_left": Input.is_action_pressed("move_left"),
		"move_right": Input.is_action_pressed("move_right"),
		"move_up": Input.is_action_pressed("move_up"),
		"move_down": Input.is_action_pressed("move_down"),
	})

func facing_from_vector(vector: Vector2, fallback: String = "down") -> String:
	if vector == Vector2.ZERO:
		return fallback
	if absf(vector.x) > absf(vector.y):
		return "right" if vector.x > 0.0 else "left"
	return "down" if vector.y > 0.0 else "up"

func find_facing_interaction(origin: Vector2, facing: String, targets: Array) -> Dictionary:
	var probe := origin + _direction_for_facing(facing) * TILE_SIZE
	var best: Dictionary = {}
	var best_distance := INF
	for target in targets:
		var distance := probe.distance_to(target.get("position", Vector2.ZERO))
		if distance <= float(target.get("radius", TILE_SIZE)) and distance < best_distance:
			best = target
			best_distance = distance
	return best

func resolve_transition(position: Vector2, transitions: Array) -> Dictionary:
	for transition in transitions:
		var rect: Rect2 = transition.get("rect", Rect2())
		if rect.has_point(position):
			return transition
	return {}

func resolve_interaction_result(result: Dictionary) -> Dictionary:
	match result.get("type", ""):
		"minigame_host":
			return {
				"status": "Choose a minigame.",
				"audio_event": "ui_confirm",
				"open_minigame_menu": true,
				"payload": result,
			}
		"map_line":
			return {
				"status": String(result.get("status", result.get("line", ""))),
				"audio_event": String(result.get("audio_event", "ui_confirm")),
				"open_minigame_menu": false,
				"payload": result,
			}
		_:
			if result.get("collected", false):
				return {
					"status": "Found treasure.",
					"audio_event": "item_pickup",
					"open_minigame_menu": false,
					"payload": result,
				}
			return {
				"status": "Already opened.",
				"audio_event": "ui_cancel",
				"open_minigame_menu": false,
				"payload": result,
			}

func _direction_for_facing(facing: String) -> Vector2:
	match facing:
		"left":
			return Vector2.LEFT
		"right":
			return Vector2.RIGHT
		"up":
			return Vector2.UP
		_:
			return Vector2.DOWN
