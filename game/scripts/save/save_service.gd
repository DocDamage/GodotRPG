class_name SaveService
extends RefCounted

const SCHEMA_VERSION := 1

func build_payload(state: Dictionary) -> Dictionary:
	return {
		"schema_version": SCHEMA_VERSION,
		"profile": state.get("profile", {}).duplicate(true),
		"accessibility": state.get("accessibility", {}).duplicate(true),
		"map_id": state.get("map_id", "overworld"),
		"position": state.get("position", Vector2.ZERO),
		"party": state.get("party", []).duplicate(true),
		"inventory": state.get("inventory", {}).duplicate(true),
		"memory_cards": state.get("memory_cards", {"owned": [], "equipped": []}).duplicate(true),
		"flags": state.get("flags", {}).duplicate(true),
	}

func migrate_payload(payload: Dictionary) -> Dictionary:
	var migrated := payload.duplicate(true)
	if not migrated.has("schema_version"):
		migrated.schema_version = 1
	migrated.accessibility = migrated.get("accessibility", {})
	migrated.position = migrated.get("position", Vector2.ZERO)
	migrated.party = migrated.get("party", [])
	migrated.inventory = migrated.get("inventory", {})
	migrated.memory_cards = migrated.get("memory_cards", {"owned": [], "equipped": []})
	migrated.flags = migrated.get("flags", {})
	return migrated

func save_slot(path: String, state: Dictionary) -> Error:
	var payload := build_payload(state)
	var file := FileAccess.open(path, FileAccess.WRITE)
	if file == null:
		return FileAccess.get_open_error()
	file.store_var(payload)
	return OK

func load_slot(path: String) -> Dictionary:
	if not FileAccess.file_exists(path):
		return {}
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		return {}
	return migrate_payload(file.get_var())
