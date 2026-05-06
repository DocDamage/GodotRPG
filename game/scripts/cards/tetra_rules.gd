class_name TetraRules
extends RefCounted

const DIRECTION_INDEX := {
	"N": 0,
	"NE": 1,
	"E": 2,
	"SE": 3,
	"S": 4,
	"SW": 5,
	"W": 6,
	"NW": 7,
}

func to_hex_stat(value: int) -> String:
	var clamped = clampi(value, 0, 15)
	if clamped < 10:
		return str(clamped)
	return ["A", "B", "C", "D", "E", "F"][clamped - 10]

func has_arrow(card: Dictionary, direction: String) -> bool:
	var index: int = DIRECTION_INDEX.get(direction, -1)
	if index < 0:
		return false
	var directions: Array = card.get("directions", [])
	if index >= directions.size():
		return false
	return bool(directions[index])

func attack_value(attacker: Dictionary) -> int:
	return int(attacker.get("power", 0))

func defense_value(attacker: Dictionary, defender: Dictionary) -> int:
	match attacker.get("card_type", "PHYSICAL"):
		"MAGICAL":
			return int(defender.get("magic_defense", 0))
		"FLEXIBLE":
			return mini(int(defender.get("physical_defense", 0)), int(defender.get("magic_defense", 0)))
		"ASSAULT":
			return mini(int(defender.get("physical_defense", 0)), int(defender.get("magic_defense", 0)))
		_:
			return int(defender.get("physical_defense", 0))
