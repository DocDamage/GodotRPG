class_name ProgressionService
extends RefCounted

const ClassCatalog = preload("res://scripts/progression/class_catalog.gd")

func xp_for_level(level: int) -> int:
	return 100 + max(level - 1, 0) * 75

func apply_xp(member: Dictionary, xp_gained: int, class_id: String) -> Dictionary:
	var result := member.duplicate(true)
	result.level = result.get("level", 1)
	result.xp = result.get("xp", 0) + xp_gained
	result.stats = result.get("stats", {}).duplicate(true)
	var catalog := ClassCatalog.new()
	while result.xp >= xp_for_level(result.level):
		result.xp -= xp_for_level(result.level)
		result.level += 1
		_apply_growth(result.stats, catalog.growth_stats(class_id))
	return result

func _apply_growth(stats: Dictionary, growth: Dictionary) -> void:
	for key in growth:
		stats[key] = stats.get(key, 0) + growth[key]
