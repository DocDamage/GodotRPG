class_name ClassCatalog
extends RefCounted

const CLASSES := {
	"vanguard": {
		"display_name": "Vanguard",
		"stats": {"max_hp": 150, "max_mp": 18, "strength": 16, "magic": 6, "defense": 14, "speed": 8},
		"growth": {"max_hp": 34, "max_mp": 4, "strength": 4, "magic": 1, "defense": 3, "speed": 1},
	},
	"spellblade": {
		"display_name": "Spellblade",
		"stats": {"max_hp": 118, "max_mp": 34, "strength": 12, "magic": 11, "defense": 9, "speed": 10},
		"growth": {"max_hp": 26, "max_mp": 8, "strength": 3, "magic": 3, "defense": 2, "speed": 2},
	},
	"mystic": {
		"display_name": "Mystic",
		"stats": {"max_hp": 92, "max_mp": 52, "strength": 6, "magic": 17, "defense": 6, "speed": 9},
		"growth": {"max_hp": 20, "max_mp": 12, "strength": 1, "magic": 5, "defense": 1, "speed": 2},
	},
	"warden": {
		"display_name": "Warden",
		"stats": {"max_hp": 132, "max_mp": 28, "strength": 10, "magic": 9, "defense": 15, "speed": 7},
		"growth": {"max_hp": 30, "max_mp": 6, "strength": 2, "magic": 2, "defense": 4, "speed": 1},
	},
}

func starting_stats(class_id: String) -> Dictionary:
	return CLASSES.get(class_id, CLASSES.vanguard).stats.duplicate(true)

func growth_stats(class_id: String) -> Dictionary:
	return CLASSES.get(class_id, CLASSES.vanguard).growth.duplicate(true)
