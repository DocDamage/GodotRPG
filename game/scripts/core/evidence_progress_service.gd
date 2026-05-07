class_name EvidenceProgressService
extends RefCounted

const PROP_MANIFEST_PATH := "res://data/maps/first_slice_prop_placements.json"


func first_slice_summary(flags: Dictionary) -> Dictionary:
	var manifest := _first_slice_manifest()
	var known_flags := _first_slice_discovery_flags(manifest)
	var found := 0
	for flag_id in known_flags:
		if bool(flags.get(flag_id, false)):
			found += 1
	var map_breakdown := _first_slice_map_breakdown(manifest, flags)
	var total := known_flags.size()
	return {
		"found": found,
		"total": total,
		"label": "Evidence Found: %d / %d" % [found, total],
		"maps": map_breakdown,
		"next_hint": _missing_map_hint(map_breakdown),
	}


func _first_slice_discovery_flags(manifest: Dictionary) -> Array[String]:
	var flags: Array[String] = []
	for map_data in manifest.get("maps", {}).values():
		for prop in map_data.get("props", []):
			if String(prop.get("category", "")) != "story":
				continue
			var flag_id := String(prop.get("discovery_flag", ""))
			if not flag_id.is_empty() and not flags.has(flag_id):
				flags.append(flag_id)
	return flags


func _first_slice_map_breakdown(manifest: Dictionary, flags: Dictionary) -> Dictionary:
	var breakdown := {}
	for map_id in manifest.get("maps", {}).keys():
		var map_data: Dictionary = manifest.maps[map_id]
		var total := 0
		var found := 0
		for prop in map_data.get("props", []):
			if String(prop.get("category", "")) != "story":
				continue
			total += 1
			if bool(flags.get(String(prop.get("discovery_flag", "")), false)):
				found += 1
		if total > 0:
			breakdown[map_id] = {
				"found": found,
				"total": total,
				"label": "%s: %d / %d" % [_format_map_name(String(map_id)), found, total],
			}
	return breakdown


func _missing_map_hint(map_breakdown: Dictionary) -> String:
	var missing: Array[String] = []
	for map_id in map_breakdown.keys():
		var entry: Dictionary = map_breakdown[map_id]
		if int(entry.get("found", 0)) < int(entry.get("total", 0)):
			missing.append(_format_map_name(String(map_id)))
		if missing.size() >= 3:
			break
	if missing.is_empty():
		return "Evidence Complete"
	return "Evidence Remaining: %s" % ", ".join(missing)


func _format_map_name(map_id: String) -> String:
	return map_id.replace("_", " ").capitalize()


func _first_slice_manifest() -> Dictionary:
	if not FileAccess.file_exists(PROP_MANIFEST_PATH):
		return {}
	var file := FileAccess.open(PROP_MANIFEST_PATH, FileAccess.READ)
	if file == null:
		return {}
	var parsed = JSON.parse_string(file.get_as_text())
	return parsed if parsed is Dictionary else {}
