extends CharacterBody2D

const FieldController = preload("res://scripts/field/field_controller.gd")

@export var speed: float = 96.0

var controller := FieldController.new()
var facing := "down"
var dialogue_locked := false

func _physics_process(_delta: float) -> void:
	if dialogue_locked:
		velocity = Vector2.ZERO
		if is_inside_tree():
			move_and_slide()
		return
	var direction := controller.input_movement_vector()
	if direction != Vector2.ZERO:
		facing = controller.facing_from_vector(direction, facing)
	velocity = direction * speed
	if is_inside_tree():
		move_and_slide()
		var game_state = get_node_or_null("/root/GameState")
		if game_state:
			game_state.player_position = global_position
