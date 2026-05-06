class_name BattleClock
extends RefCounted

const ATB_READY := 100.0

var combatants: Array[Dictionary] = []

func add_combatant(id: String, speed: int, hostile: bool = false) -> void:
	combatants.append({"id": id, "speed": speed, "hostile": hostile, "atb": 0.0, "ready": false})

func advance(delta: float, command_menu_open: bool, atb_mode: String) -> void:
	for combatant in combatants:
		if _is_paused(combatant, command_menu_open, atb_mode):
			continue
		combatant.atb = min(ATB_READY, combatant.atb + float(combatant.speed) * delta)
		combatant.ready = combatant.atb >= ATB_READY

func consume_turn(id: String) -> void:
	for combatant in combatants:
		if combatant.id == id:
			combatant.atb = 0.0
			combatant.ready = false
			return

func _is_paused(combatant: Dictionary, command_menu_open: bool, atb_mode: String) -> bool:
	return command_menu_open and atb_mode == "wait" and combatant.get("hostile", false)
