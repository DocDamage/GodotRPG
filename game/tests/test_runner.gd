extends SceneTree

var failures: Array[String] = []

func _init() -> void:
	_run_tests()
	_cleanup_test_audio()
	if failures.is_empty():
		print("All tests passed.")
		quit(0)
	else:
		for failure in failures:
			push_error(failure)
		quit(1)

func _cleanup_test_audio() -> void:
	var audio = root.get_node_or_null("Audio")
	if audio and audio.has_method("stop_all"):
		audio.stop_all()

func _run_tests() -> void:
	_test_character_creator_profile_output()
	_test_character_creator_screen_selection_flow()
	_test_character_creator_relic_voice_card_and_preview_features()
	_test_character_creator_combined_loadout_preview()
	_test_character_creator_portrait_choice_persists_and_resolves()
	_test_character_creator_name_validation_and_record_cleaning()
	_test_character_creator_recovers_from_invalid_indices()
	_test_character_creator_controller_sanitizes_invalid_options()
	_test_player_profile_from_dict_sanitizes_creator_fields()
	_test_character_creator_applies_profile_and_resets_defaults()
	_test_character_creator_class_sets_starting_party_stats()
	_test_character_creator_generates_uncatalogued_dossier()
	_test_character_creator_renders_uncatalogued_dossier_summary()
	_test_character_creator_randomize_and_reset_controls()
	_test_character_creator_scene_has_completion_controls()
	_test_character_creator_scene_confirm_emits_complete_profile()
	_test_app_root_confirmed_creator_starts_game_flow()
	_test_player_profile_persists_uncatalogued_dossier()
	_test_sev_record_service_summarizes_creator_loadout()
	_test_content_catalog_loads_recruitable_party_members()
	_test_class_stats_and_leveling()
	_test_game_state_applies_battle_xp_to_party()
	_test_game_state_applies_battle_party_state()
	_test_game_state_recruits_party_member_once()
	_test_atb_wait_mode_pause()
	_test_encounter_selection()
	_test_first_slice_plague_encounters_defined()
	_test_first_slice_encounter_pacing_is_boss_safe()
	_test_bell_saint_boss_numbers_fit_first_slice_party()
	_test_prototype_field_builds_group_encounter_payload()
	_test_prototype_field_requests_random_encounter_from_current_map()
	_test_prototype_field_step_threshold_triggers_random_encounter()
	_test_prototype_field_player_travel_records_encounter_steps()
	_test_prototype_field_random_encounter_payload_records_source_position()
	_test_prototype_field_loads_saved_player_position_for_current_map()
	_test_save_payload_roundtrip()
	_test_save_payload_preserves_bell_saint_slice_checkpoints()
	_test_save_payload_preserves_first_slice_evidence_progress()
	_test_game_state_rebuilds_discovered_story_prop_list_from_legacy_flags()
	_test_field_movement_and_interactions()
	_test_slice_flow_route_matches_playable_bell_saint_path()
	_test_slice_flow_route_is_playable_and_rewarded()
	_test_first_slice_map_catalog_defines_town_and_dungeon()
	_test_first_slice_route_spawns_and_transitions_are_navigable()
	_test_first_slice_maps_add_side_quest_npcs()
	_test_prototype_field_resolves_first_slice_map_data()
	_test_prototype_field_generates_first_slice_map_markers()
	_test_map_interactable_returns_side_quest_payload()
	_test_prototype_field_completes_clean_cloth_side_quest()
	_test_prototype_field_does_not_duplicate_side_quest_rewards()
	_test_prototype_field_completes_wrong_chart_side_quest()
	_test_prototype_field_exposes_transition_zones()
	_test_first_slice_maps_define_visible_graybox_layouts()
	_test_prototype_field_renders_graybox_layout()
	_test_first_slice_prop_placement_manifest_defines_layers()
	_test_map_prop_renderer_resolves_and_instantiates_props()
	_test_map_prop_renderer_creates_prop_collision()
	_test_map_prop_renderer_forwards_discovery_flag_metadata()
	_test_first_slice_prop_manifest_assets_exist_and_story_props_are_inspectable()
	_test_first_slice_story_props_define_inspection_audio()
	_test_first_slice_story_props_define_discovery_flags()
	_test_evidence_progress_service_counts_first_slice_story_props()
	_test_evidence_progress_service_counts_discovered_story_props()
	_test_evidence_progress_service_returns_map_breakdown()
	_test_evidence_progress_service_formats_missing_map_hint()
	_test_first_slice_prop_manifest_marks_key_navigation_props_blocking()
	_test_first_slice_blocking_props_do_not_cover_spawns_or_transitions()
	_test_first_slice_tile_asset_catalog_defines_runtime_tiles()
	_test_prototype_field_renders_real_tile_art_layer()
	_test_hallowmere_authored_map_scene_renders_curated_props()
	_test_hallowmere_authored_map_defines_story_landmarks()
	_test_hallowmere_promoted_props_manifest_defines_runtime_assets()
	_test_hallowmere_authored_map_renders_sliced_props()
	_test_apothecary_authored_map_defines_interior_story_landmarks()
	_test_hospital_promoted_props_manifest_defines_runtime_assets()
	_test_hospital_authored_map_scene_renders_sliced_props()
	_test_chapel_promoted_props_manifest_defines_runtime_assets()
	_test_chapel_authored_map_scene_renders_sliced_props()
	_test_underchapel_promoted_props_manifest_defines_runtime_assets()
	_test_underchapel_authored_map_scene_renders_sliced_props()
	_test_bell_tower_promoted_props_manifest_defines_runtime_assets()
	_test_pixellab_promoted_assets_manifest_defines_runtime_assets()
	_test_bell_tower_authored_map_scene_renders_sliced_props()
	_test_apothecary_sliced_props_exist_and_render()
	_test_apothecary_slice_manifest_documents_exported_regions()
	_test_sprite_extractor_pipeline_exports_review_candidates()
	_test_sprite_extractor_contact_sheets_exist()
	_test_cut_sprite_folder_contact_sheets_exist()
	_test_pixellab_generation_manifest_is_style_locked()
	_test_apothecary_promoted_props_manifest_defines_runtime_assets()
	_test_prototype_field_mounts_authored_hallowmere_map()
	_test_prototype_field_mounts_authored_apothecary_map()
	_test_prototype_field_mounts_authored_hospital_map()
	_test_prototype_field_mounts_authored_chapel_map()
	_test_prototype_field_mounts_authored_underchapel_map()
	_test_prototype_field_mounts_authored_bell_tower_map()
	_test_prototype_field_exposes_mounted_map_audio_profile()
	_test_prototype_field_creates_story_prop_interactions()
	_test_prototype_field_story_prop_uses_manifest_inspection_audio()
	_test_prototype_field_story_prop_inspection_sets_discovery_flag()
	_test_prototype_field_first_story_prop_discovery_adds_evidence_feedback()
	_test_prototype_field_repeat_story_prop_inspection_does_not_repeat_evidence_feedback()
	_test_prototype_field_player_can_inspect_authored_story_prop()
	_test_prototype_field_plays_authored_map_entry_audio()
	_test_prototype_field_changes_maps_when_player_enters_transition()
	_test_prototype_field_blocks_out_of_order_slice_transitions()
	_test_field_story_trigger_catalog_maps_route_events()
	_test_prototype_field_runs_entry_story_trigger_once()
	_test_prototype_field_entry_trigger_recruits_mira()
	_test_prototype_field_queues_and_advances_entry_dialogue()
	_test_prototype_field_renders_entry_dialogue_in_dialogue_box()
	_test_dialogue_box_renders_continue_prompt()
	_test_field_player_locks_movement_during_dialogue()
	_test_first_slice_objective_catalog_tracks_route_goals()
	_test_prototype_field_renders_current_objective()
	_test_prototype_field_exposes_bell_saint_battle_payload()
	_test_prototype_field_emits_boss_battle_request()
	_test_prototype_field_interact_launches_boss_after_dialogue()
	_test_prototype_field_completed_bell_saint_does_not_launch_again()
	_test_app_root_handles_field_battle_request()
	_test_app_root_returns_random_encounters_to_source_phase()
	_test_app_root_restores_random_encounter_source_position()
	_test_battle_screen_emits_completion_payload()
	_test_battle_screen_uses_cinematic_arena_camera()
	_test_battle_screen_camera_focuses_battler_sides()
	_test_battle_screen_plays_boss_intro_presentation()
	_test_battle_screen_plays_attack_lunge_and_hit_reaction()
	_test_battle_screen_resets_battler_presentation()
	_test_battle_screen_shows_damage_popup_and_locks_commands()
	_test_battle_screen_completes_action_presentation_sequence()
	_test_battle_screen_starts_action_presentation_timer()
	_test_battle_screen_presents_enemy_retaliation()
	_test_battle_screen_retaliation_damages_ai_selected_party_target()
	_test_battle_screen_retaliation_log_names_target()
	_test_battle_screen_enemy_skill_damages_ai_selected_party_target()
	_test_battle_screen_enemy_skill_log_names_target()
	_test_battle_screen_starts_enemy_action_timer()
	_test_battle_screen_handles_party_defeat()
	_test_battle_screen_handles_victory_presentation()
	_test_battle_screen_exposes_skill_and_item_commands()
	_test_battle_screen_item_heals_most_wounded_living_party_member()
	_test_battle_screen_disables_item_command_without_bandages()
	_test_battle_screen_disables_item_command_after_last_bandage_used()
	_test_battle_screen_tracks_command_readiness()
	_test_battle_screen_command_state_skips_ko_active_member()
	_test_battle_screen_advances_command_readiness_during_process()
	_test_battle_screen_opens_selectable_skill_menu()
	_test_battle_screen_records_animation_hooks()
	_test_battle_screen_updates_party_animation_set_for_active_member()
	_test_battle_animation_assets_are_cataloged()
	_test_combat_enemies_have_animation_sets()
	_test_battle_screen_renders_generated_enemy_sprite()
	_test_battle_screen_renders_and_targets_multiple_enemies()
	_test_battle_screen_renders_target_buttons()
	_test_battle_screen_attack_uses_selected_enemy()
	_test_battle_screen_auto_selects_living_enemy_after_defeat()
	_test_battle_screen_retaliation_uses_living_enemy()
	_test_battle_screen_uses_pending_group_payload()
	_test_battle_screen_starts_with_recruited_mira_from_game_state()
	_test_battle_screen_marks_active_party_member_in_roster()
	_test_battle_screen_party_roster_buttons_select_active_member()
	_test_battle_screen_party_roster_buttons_show_hp()
	_test_battle_screen_prevents_selecting_ko_party_member()
	_test_battle_screen_uses_active_party_member_skills()
	_test_battle_screen_advances_active_party_member_after_enemy_action()
	_test_battle_screen_completion_includes_party_state()
	_test_battle_screen_does_not_persist_rewards_before_app_root()
	_test_battle_screen_uses_stable_visual_stage()
	_test_battle_screen_updates_enemy_visual_status()
	_test_battle_screen_updates_party_visual_status()
	_test_app_root_handles_battle_completion_rewards()
	_test_app_root_does_not_duplicate_anchor_relic_rewards()
	_test_app_root_applies_battle_xp_to_party()
	_test_app_root_applies_battle_party_state()
	_test_app_root_bell_saint_completion_recruits_mira_and_records_reward_scene()
	_test_app_root_bell_saint_completion_records_boss_defeat()
	_test_app_root_bell_saint_completion_records_autosave_feedback()
	_test_app_root_renders_bell_saint_reward_scene()
	_test_app_root_reward_scene_summarizes_evidence_progress()
	_test_app_root_reward_scene_renders_acknowledgement_prompt()
	_test_app_root_consumes_reward_dialogue_after_acknowledgement()
	_test_app_root_refreshes_reward_scene_after_acknowledgement()
	_test_dialogue_interpolation()
	_test_portrait_catalog_resolves_creator_portraits()
	_test_dialogue_box_uses_profile_portrait_for_sev()
	_test_voice_blip_catalog_resolves_creator_voice()
	_test_dialogue_box_uses_profile_voice_for_sev()
	_test_battle_attack_and_victory_rewards()
	_test_battle_skills_damage_and_heal()
	_test_battle_items_consume_inventory_and_heal()
	_test_battle_status_effects_apply_and_tick()
	_test_enemy_ai_profiles_choose_actions()
	_test_enemy_ai_targets_first_living_party_member()
	_test_starting_relic_modifies_battle_stats()
	_test_equipped_memory_card_modifies_battle_stats()
	_test_boss_victory_requests_time_fracture()
	_test_inventory_adds_and_consumes_items()
	_test_memory_cards_acquire_equip_and_effects()
	_test_treasure_pickup_sets_flag_and_merges_loot()
	_test_tetra_card_catalog_loads_unity_style_cards()
	_test_tetra_monster_card_generator_uses_enemy_database()
	_test_tetra_card_template_catalog_resolves_exported_templates()
	_test_tetra_card_view_formats_card_data()
	_test_tetra_card_view_scene_renders_card_nodes()
	_test_tetra_play_screen_uses_board_art_and_slots()
	_test_tetra_play_screen_places_visual_card_in_board_slot()
	_test_tetra_play_screen_rejects_invalid_card_placements()
	_test_tetra_play_screen_updates_visuals_after_capture()
	_test_tetra_play_screen_scores_board_ownership()
	_test_tetra_play_screen_opponent_turn_places_legal_card()
	_test_tetra_play_screen_opponent_turn_rejects_full_board()
	_test_tetra_play_screen_tracks_turn_and_match_over()
	_test_tetra_play_screen_renders_hand_score_and_turn_status()
	_test_tetra_play_screen_renders_match_over_status()
	_test_tetra_play_screen_renders_selectable_player_hand_buttons()
	_test_tetra_play_screen_selects_hand_and_plays_slot()
	_test_tetra_play_screen_player_move_can_auto_run_opponent_turn()
	_test_tetra_play_screen_emits_match_finished_payload()
	_test_tetra_play_screen_opponent_prefers_capturing_move()
	_test_tetra_rules_hex_and_arrow_pressure()
	_test_tetra_board_places_cards_and_tracks_owner()
	_test_tetra_board_flips_adjacent_cards_by_arrow_pressure()
	_test_minigame_catalog_maps_pixel_perfect_games_to_world_locations()
	_test_minigame_catalog_unlocks_by_story_chapter()
	_test_minigame_host_filters_location_and_chapter()
	_test_minigame_host_requests_launch_payload()
	_test_minigame_host_scene_smoke()
	_test_field_controller_resolves_minigame_interaction()
	_test_bell_saint_story_slice_data()
	_test_story_flow_service_loads_and_advances_slice()
	_test_story_flow_service_exposes_phase_metadata()
	_test_first_slice_items_and_memory_card_data()
	_test_chapter_one_dialogue_bank_data()
	_test_content_catalog_loads_items_cards_and_dialogue()
	_test_audio_event_catalog_defines_bell_saint_slice()
	_test_audio_event_catalog_uses_dedicated_bell_saint_map_cues()
	_test_audio_service_resolves_runtime_event()
	_test_audio_service_manages_looped_ambience()
	_test_authored_slice_maps_expose_audio_profiles()
	_test_authored_slice_props_expose_story_inspection_metadata()
	_test_vista_catalog_defines_bell_saint_vistas()

func _assert(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)

func _dictionary_with_id(entries: Array, entry_id: String) -> Dictionary:
	for entry in entries:
		if entry is Dictionary and String(entry.get("id", "")) == entry_id:
			return entry
	return {}

func _prop_manifest_asset_exists(prop: Dictionary, tile_catalog) -> bool:
	if prop.has("asset_path"):
		return FileAccess.file_exists(String(prop.asset_path))
	if prop.has("asset_id"):
		var asset = tile_catalog.asset_by_id(String(prop.asset_id))
		return not asset.is_empty() and FileAccess.file_exists(String(asset.get("runtime_path", "")))
	return String(prop.get("kind", "")) == "color"

func _prop_collision_rect(prop: Dictionary) -> Rect2:
	var position := _vector_from_map_point(prop.get("position", {}))
	var rect_data: Dictionary = prop.get("collision_rect", {})
	return Rect2(
		position + Vector2(float(rect_data.get("x", 0.0)), float(rect_data.get("y", 0.0))),
		Vector2(float(rect_data.get("w", 0.0)), float(rect_data.get("h", 0.0)))
	)

func _vector_from_map_point(point: Dictionary) -> Vector2:
	return Vector2(float(point.get("x", 0.0)), float(point.get("y", 0.0)))

func _rect_from_map_rect(rect: Dictionary) -> Rect2:
	return Rect2(
		float(rect.get("x", 0.0)),
		float(rect.get("y", 0.0)),
		float(rect.get("w", 0.0)),
		float(rect.get("h", 0.0))
	)

func _tile_rect_to_pixels(tile_rect: Dictionary, tile_size: int) -> Rect2:
	return Rect2(
		float(tile_rect.get("x", 0)) * tile_size,
		float(tile_rect.get("y", 0)) * tile_size,
		float(tile_rect.get("w", 0)) * tile_size,
		float(tile_rect.get("h", 0)) * tile_size
	)

func _point_is_on_floor(map: Dictionary, point: Vector2) -> bool:
	var layout: Dictionary = map.get("layout", {})
	var tile_size := int(layout.get("tile_size", 16))
	for floor_rect in layout.get("floor_rects", []):
		if _tile_rect_to_pixels(floor_rect, tile_size).has_point(point):
			return true
	return false

func _point_is_inside_wall(map: Dictionary, point: Vector2) -> bool:
	var layout: Dictionary = map.get("layout", {})
	var tile_size := int(layout.get("tile_size", 16))
	for wall_rect in layout.get("wall_rects", []):
		if _tile_rect_to_pixels(wall_rect, tile_size).has_point(point):
			return true
	return false

func _test_character_creator_profile_output() -> void:
	_assert(ResourceLoader.exists("res://scripts/character_creator/character_creator_controller.gd"), "character creator controller exists")
	var Controller = load("res://scripts/character_creator/character_creator_controller.gd")
	var controller = Controller.new()
	var profile = controller.create_profile({
		"name": "Mira",
		"pronouns": "they/them",
		"class_id": "spellblade",
		"sprite_preset": "hero_knight",
		"palette": {"hair": "copper", "outfit_primary": "navy"},
		"origin_echo": "paper_names",
	})
	_assert(profile.name == "Mira", "profile stores player name")
	_assert(profile.pronouns == "they/them", "profile stores pronouns")
	_assert(profile.class_id == "spellblade", "profile stores selected class")
	_assert(profile.origin_echo == "paper_names", "profile stores selected origin echo")
	_assert(profile.accessibility.atb_mode == "wait", "profile defaults ATB mode to wait")

func _test_character_creator_screen_selection_flow() -> void:
	_assert(ResourceLoader.exists("res://scripts/character_creator/character_creator_screen.gd"), "character creator screen script exists")
	var ScreenScript = load("res://scripts/character_creator/character_creator_screen.gd")
	var screen = ScreenScript.new()
	screen.set_player_name("Sev")
	screen.next_class()
	screen.next_pronouns()
	screen.next_sprite()
	screen.next_palette()
	screen.next_origin_echo()
	screen.next_starting_relic()
	screen.next_voice_blip()
	screen.next_starting_memory_card()
	screen.next_portrait()
	var selection = screen.current_selection()
	_assert(selection.name == "Sev", "character creator screen stores entered name")
	_assert(selection.class_id == "spellblade", "character creator screen cycles class choice")
	_assert(selection.pronouns == "she/her", "character creator screen cycles pronouns")
	_assert(selection.sprite_preset == "hero_cloak", "character creator screen cycles sprite preset")
	_assert(selection.palette.hair == "silver", "character creator screen cycles palette")
	_assert(selection.origin_echo == "distant_bell", "character creator screen cycles origin echo")
	_assert(selection.starting_relic == "archive_needle", "character creator screen cycles starting relic")
	_assert(selection.voice_blip == "warm_human", "character creator screen cycles voice blip")
	_assert(selection.starting_memory_card == "calling_name", "character creator screen cycles starting memory card")
	_assert(selection.portrait_id == "dwarf_12", "character creator screen cycles portrait")
	_assert(screen.class_summary().contains("Relic duelist"), "character creator exposes class summary")
	_assert(screen.sprite_region().size == Vector2(32, 32), "character creator exposes sprite preview region")
	_assert(screen.starting_stats().max_mp == 34, "character creator exposes selected class starting stats")
	_assert(screen.record_summary().contains("Sev"), "character creator record summary includes selected name")
	_assert(screen.record_summary().contains("silver"), "character creator record summary includes selected palette")
	_assert(screen.dialogue_preview().contains("she should report"), "character creator dialogue preview uses selected pronouns")
	_assert(screen.museum_id_summary().contains("NO EXHIBIT TAG FOUND"), "character creator exposes museum ID summary")
	var profile = screen.create_profile()
	_assert(profile.name == "Sev", "character creator screen creates profile")
	_assert(profile.class_id == "spellblade", "character creator profile uses selected class")
	_assert(profile.origin_echo == "distant_bell", "character creator profile stores origin echo")
	_assert(profile.starting_relic == "archive_needle", "character creator profile stores starting relic")
	_assert(profile.voice_blip == "warm_human", "character creator profile stores voice blip")
	_assert(profile.starting_memory_card == "calling_name", "character creator profile stores starting memory card")
	_assert(profile.portrait_id == "dwarf_12", "character creator profile stores portrait id")
	screen.free()

func _test_character_creator_relic_voice_card_and_preview_features() -> void:
	var ScreenScript = load("res://scripts/character_creator/character_creator_screen.gd")
	var screen = ScreenScript.new()
	_assert(screen.starting_relic_summary().contains("balanced"), "character creator describes default starting relic")
	_assert(screen.voice_blip_summary().contains("synthetic"), "character creator describes default voice blip")
	_assert(screen.starting_memory_card_summary().contains("door"), "character creator describes default starting memory card")
	_assert(screen.dialogue_preview().contains("they should report"), "character creator dialogue preview defaults to they/them")
	_assert(screen.museum_id_summary().contains("Classification confidence"), "character creator museum ID includes classification confidence")
	screen.free()

func _test_character_creator_combined_loadout_preview() -> void:
	var ScreenScript = load("res://scripts/character_creator/character_creator_screen.gd")
	var screen = ScreenScript.new()
	screen.next_starting_relic()
	screen.next_starting_memory_card()
	var modified_stats = screen.preview_modified_stats()
	_assert(modified_stats.magic == 10, "creator loadout preview applies archive needle magic bonus")
	_assert(modified_stats.speed == 9, "creator loadout preview applies calling name speed bonus")
	_assert(screen.loadout_effect_summary().contains("MAG +4"), "creator loadout summary includes relic stat bonus")
	_assert(screen.loadout_effect_summary().contains("SPD +1"), "creator loadout summary includes memory card stat bonus")
	screen.free()

func _test_character_creator_portrait_choice_persists_and_resolves() -> void:
	var ScreenScript = load("res://scripts/character_creator/character_creator_screen.gd")
	var screen = ScreenScript.new()
	_assert(screen.portrait_path().ends_with("portrait_dwarf_01.png"), "character creator default portrait path resolves")
	_assert(FileAccess.file_exists(screen.portrait_path()), "character creator default portrait file exists")
	screen.apply_profile(load("res://scripts/core/player_profile.gd").from_dict({"name": "Sev", "portrait_id": "demon_12"}))
	_assert(screen.current_selection().portrait_id == "demon_12", "character creator supports demon portraits")
	_assert(screen.portrait_path().ends_with("portrait_demon_12.png"), "character creator resolves demon portrait path")
	_assert(FileAccess.file_exists(screen.portrait_path()), "character creator demon portrait file exists")
	screen.apply_profile(load("res://scripts/core/player_profile.gd").from_dict({"name": "Sev", "portrait_id": "fairy_12"}))
	_assert(screen.current_selection().portrait_id == "fairy_12", "character creator supports fairy portraits")
	_assert(screen.portrait_path().ends_with("portrait_fairy_12.png"), "character creator resolves fairy portrait path")
	_assert(FileAccess.file_exists(screen.portrait_path()), "character creator fairy portrait file exists")
	screen.portrait_index = 999
	_assert(screen.current_selection().portrait_id == "dwarf_01", "character creator recovers invalid portrait index")
	screen.free()

func _test_character_creator_name_validation_and_record_cleaning() -> void:
	var ScreenScript = load("res://scripts/character_creator/character_creator_screen.gd")
	var screen = ScreenScript.new()
	screen.set_player_name("   ")
	_assert(not screen.can_confirm(), "character creator blocks blank names")
	_assert(screen.validation_message() == "Enter an uncatalogued name.", "character creator explains blank name validation")
	_assert(screen.record_summary().begins_with("Unnamed"), "blank creator record summary avoids misleading saved name")
	screen.set_player_name("   A Very Long Uncatalogued Docent Name   ")
	_assert(screen.can_confirm(), "character creator accepts nonblank names")
	_assert(screen.cleaned_player_name().length() == 24, "character creator previews truncated saved name")
	_assert(screen.record_summary().contains(screen.cleaned_player_name()), "record summary uses cleaned saved name")
	screen.free()

func _test_character_creator_recovers_from_invalid_indices() -> void:
	var ScreenScript = load("res://scripts/character_creator/character_creator_screen.gd")
	var screen = ScreenScript.new()
	screen.pronoun_index = 99
	screen.class_index = -12
	screen.sprite_index = 42
	screen.origin_echo_index = -4
	screen.palette_index = 77
	var selection = screen.current_selection()
	_assert(selection.pronouns == "they/them", "character creator recovers invalid pronoun index")
	_assert(selection.class_id == "vanguard", "character creator recovers invalid class index")
	_assert(selection.sprite_preset == "hero_knight", "character creator recovers invalid sprite index")
	_assert(selection.origin_echo == "static_hum", "character creator recovers invalid origin echo index")
	_assert(selection.palette.hair == "copper", "character creator recovers invalid palette index")
	_assert(screen.record_summary().contains("Static Hum"), "record summary survives invalid indices")
	screen.free()

func _test_character_creator_controller_sanitizes_invalid_options() -> void:
	var Controller = load("res://scripts/character_creator/character_creator_controller.gd")
	var profile = Controller.new().create_profile({
		"name": "Sev",
		"pronouns": "invalid",
		"class_id": "bad_class",
		"sprite_preset": "missing_sprite",
		"origin_echo": "bad_echo",
		"starting_relic": "bad_relic",
		"voice_blip": "bad_voice",
		"starting_memory_card": "bad_card",
		"portrait_id": "bad_portrait",
		"palette": "not a dictionary",
	})
	_assert(profile.pronouns == "they/them", "character creator controller falls back invalid pronouns")
	_assert(profile.class_id == "vanguard", "character creator controller falls back invalid class")
	_assert(profile.sprite_preset == "hero_knight", "character creator controller falls back invalid sprite preset")
	_assert(profile.origin_echo == "static_hum", "character creator controller falls back invalid origin echo")
	_assert(profile.starting_relic == "cracked_saber", "character creator controller falls back invalid starting relic")
	_assert(profile.voice_blip == "soft_synthetic", "character creator controller falls back invalid voice blip")
	_assert(profile.starting_memory_card == "locked_door", "character creator controller falls back invalid starting memory card")
	_assert(profile.portrait_id == "dwarf_01", "character creator controller falls back invalid portrait")
	_assert(profile.palette.is_empty(), "character creator controller ignores invalid palette payload")

func _test_player_profile_from_dict_sanitizes_creator_fields() -> void:
	var PlayerProfile = load("res://scripts/core/player_profile.gd")
	var profile = PlayerProfile.from_dict({
		"name": "  Sev  ",
		"pronouns": "wrong",
		"class_id": "missing_class",
		"sprite_preset": "bad_sprite",
		"origin_echo": "bad_echo",
		"starting_relic": "bad_relic",
		"voice_blip": "bad_voice",
		"starting_memory_card": "bad_card",
		"portrait_id": "bad_portrait",
		"palette": "bad_palette",
	})
	_assert(profile.name == "Sev", "profile load cleans stored name")
	_assert(profile.pronouns == "they/them", "profile load sanitizes pronouns")
	_assert(profile.class_id == "vanguard", "profile load sanitizes class")
	_assert(profile.sprite_preset == "hero_knight", "profile load sanitizes sprite")
	_assert(profile.origin_echo == "static_hum", "profile load sanitizes origin echo")
	_assert(profile.starting_relic == "cracked_saber", "profile load sanitizes starting relic")
	_assert(profile.voice_blip == "soft_synthetic", "profile load sanitizes voice blip")
	_assert(profile.starting_memory_card == "locked_door", "profile load sanitizes starting memory card")
	_assert(profile.portrait_id == "dwarf_01", "profile load sanitizes portrait")
	_assert(profile.palette.is_empty(), "profile load sanitizes palette")

func _test_character_creator_applies_profile_and_resets_defaults() -> void:
	var ScreenScript = load("res://scripts/character_creator/character_creator_screen.gd")
	var PlayerProfile = load("res://scripts/core/player_profile.gd")
	var profile = PlayerProfile.from_dict({
		"name": "Mira",
		"pronouns": "she/her",
		"class_id": "mystic",
		"sprite_preset": "hero_scout",
		"origin_echo": "paper_names",
		"starting_relic": "signal_knife",
		"voice_blip": "sharp_clear",
		"starting_memory_card": "bell_under_water",
		"portrait_id": "orc_12",
		"palette": {"hair": "ash", "outfit_primary": "green", "accent": "brass"},
	})
	var screen = ScreenScript.new()
	screen.apply_profile(profile)
	_assert(screen.current_selection().name == "Mira", "character creator applies profile name")
	_assert(screen.current_selection().class_id == "mystic", "character creator applies profile class")
	_assert(screen.current_selection().origin_echo == "paper_names", "character creator applies profile origin echo")
	_assert(screen.current_selection().starting_relic == "signal_knife", "character creator applies profile starting relic")
	_assert(screen.current_selection().voice_blip == "sharp_clear", "character creator applies profile voice blip")
	_assert(screen.current_selection().starting_memory_card == "bell_under_water", "character creator applies profile starting memory card")
	_assert(screen.current_selection().portrait_id == "orc_12", "character creator applies profile portrait")
	screen.reset_to_defaults()
	_assert(screen.current_selection().name == "Sev", "character creator reset restores default name")
	_assert(screen.current_selection().class_id == "vanguard", "character creator reset restores default class")
	_assert(screen.current_selection().starting_relic == "cracked_saber", "character creator reset restores default relic")
	_assert(screen.current_selection().portrait_id == "dwarf_01", "character creator reset restores default portrait")
	screen.free()

func _test_character_creator_class_sets_starting_party_stats() -> void:
	var Controller = load("res://scripts/character_creator/character_creator_controller.gd")
	var GameStateScript = load("res://scripts/core/game_state.gd")
	var state = GameStateScript.new()
	var profile = Controller.new().create_profile({"name": "Sev", "class_id": "spellblade"})
	state.start_new_game(profile)
	_assert(state.party[0].class_id == "spellblade", "new game uses creator class for lead party member")
	_assert(state.party[0].stats.max_mp == 34, "new game gives lead selected class starting stats")
	_assert(state.party[0].equipped_relic == "cracked_saber", "new game equips selected starting relic on lead")
	_assert(state.party[0].equipped_memory_cards == ["locked_door"], "new game equips selected starting memory card on lead")
	_assert(state.inventory.cracked_saber == 1, "new game grants selected starting relic")
	_assert(state.memory_cards.owned.has("locked_door"), "new game grants selected starting memory card")
	_assert(state.memory_cards.equipped.has("locked_door"), "new game equips selected starting memory card")
	state.free()

func _test_character_creator_generates_uncatalogued_dossier() -> void:
	var ScreenScript = load("res://scripts/character_creator/character_creator_screen.gd")
	var screen = ScreenScript.new()
	screen.set_player_name("Sev")
	screen.next_origin_echo()
	screen.next_starting_memory_card()
	var dossier = screen.uncatalogued_dossier()
	_assert(dossier.classification == "Uncatalogued Docent", "creator dossier uses story classification")
	_assert(dossier.confidence == 17, "creator dossier keeps low classification confidence")
	_assert(dossier.tags.has("origin_echo:distant_bell"), "creator dossier includes origin echo tag")
	_assert(dossier.tags.has("memory_card:calling_name"), "creator dossier includes starting memory card tag")
	_assert(dossier.flags.has("no_exhibit_tag"), "creator dossier includes no exhibit tag flag")
	_assert(dossier.curator_line.contains("Sev remains outside assigned parameters"), "creator dossier includes first Curator line")
	var profile = screen.create_profile()
	_assert(profile.uncatalogued_dossier.tags.has("origin_echo:distant_bell"), "created profile stores dossier tags")
	screen.free()

func _test_character_creator_renders_uncatalogued_dossier_summary() -> void:
	var ScreenScript = load("res://scripts/character_creator/character_creator_screen.gd")
	var screen = ScreenScript.new()
	screen.set_player_name("Sev")
	screen.next_origin_echo()
	var summary = screen.dossier_summary()
	_assert(summary.contains("Uncatalogued Docent"), "creator dossier summary includes classification")
	_assert(summary.contains("Confidence: 17%"), "creator dossier summary includes confidence")
	_assert(summary.contains("origin_echo:distant_bell"), "creator dossier summary includes current origin echo tag")
	_assert(summary.contains("no_exhibit_tag"), "creator dossier summary includes dossier flag")
	screen.free()
	_assert(ResourceLoader.exists("res://scenes/character_creator/character_creator_screen.tscn"), "character creator scene exists")
	var scene = load("res://scenes/character_creator/character_creator_screen.tscn")
	var scene_screen = scene.instantiate()
	root.add_child(scene_screen)
	scene_screen.set_player_name("Sev")
	scene_screen.next_origin_echo()
	_assert(scene_screen.get_node("%DossierValue").text.contains("origin_echo:distant_bell"), "character creator scene renders dossier label")
	scene_screen.queue_free()

func _test_character_creator_randomize_and_reset_controls() -> void:
	var ScreenScript = load("res://scripts/character_creator/character_creator_screen.gd")
	var screen = ScreenScript.new()
	var before = screen.current_selection()
	screen.randomize_record(7)
	var randomized = screen.current_selection()
	_assert(randomized.name == "Sev-007", "character creator randomize creates stable suggested name")
	_assert(randomized.class_id != before.class_id, "character creator randomize changes class")
	_assert(randomized.portrait_id != before.portrait_id, "character creator randomize changes portrait")
	_assert(screen.dossier_summary().contains(randomized.origin_echo), "randomized creator dossier follows selected origin echo")
	screen.reset_to_defaults()
	var reset = screen.current_selection()
	_assert(reset.name == "Sev", "character creator reset restores name")
	_assert(reset.class_id == "vanguard", "character creator reset restores class")
	_assert(reset.portrait_id == "dwarf_01", "character creator reset restores portrait")
	screen.free()

func _test_character_creator_scene_has_completion_controls() -> void:
	var scene = load("res://scenes/character_creator/character_creator_screen.tscn")
	var screen = scene.instantiate()
	root.add_child(screen)
	_assert(screen.get_node_or_null("%Randomize") != null, "character creator scene has randomize button")
	_assert(screen.get_node_or_null("%Reset") != null, "character creator scene has reset button")
	screen.get_node("%Randomize").pressed.emit()
	_assert(screen.current_selection().name.begins_with("Sev-"), "character creator randomize button changes suggested name")
	screen.get_node("%Reset").pressed.emit()
	_assert(screen.current_selection().name == "Sev", "character creator reset button restores default name")
	screen.queue_free()

func _test_character_creator_scene_confirm_emits_complete_profile() -> void:
	var scene = load("res://scenes/character_creator/character_creator_screen.tscn")
	var screen = scene.instantiate()
	var emitted: Array = []
	screen.profile_confirmed.connect(func(profile): emitted.append(profile))
	root.add_child(screen)
	screen.set_player_name("Sev")
	screen.next_class()
	screen.next_portrait()
	screen.next_starting_relic()
	screen.next_voice_blip()
	screen.next_starting_memory_card()
	screen.confirm_profile()
	_assert(emitted.size() == 1, "character creator confirm emits one profile")
	var profile = emitted[0]
	_assert(profile.name == "Sev", "confirmed profile includes name")
	_assert(profile.class_id == "spellblade", "confirmed profile includes class")
	_assert(profile.portrait_id == "dwarf_12", "confirmed profile includes portrait")
	_assert(profile.starting_relic == "archive_needle", "confirmed profile includes relic")
	_assert(profile.voice_blip == "warm_human", "confirmed profile includes voice")
	_assert(profile.starting_memory_card == "calling_name", "confirmed profile includes memory card")
	_assert(profile.uncatalogued_dossier.flags.has("no_exhibit_tag"), "confirmed profile includes dossier")
	screen.queue_free()

func _test_app_root_confirmed_creator_starts_game_flow() -> void:
	var StoryFlowService = load("res://scripts/core/story_flow_service.gd")
	var GameStateScript = load("res://scripts/core/game_state.gd")
	var PlayerProfile = load("res://scripts/core/player_profile.gd")
	var story_flow = StoryFlowService.new()
	var game_state = GameStateScript.new()
	story_flow.load_first_slice()
	_assert(story_flow.current_phase() == "character_creator", "app root starts in character creator")
	var profile = PlayerProfile.from_dict({"name": "Sev", "class_id": "spellblade"})
	game_state.start_new_game(profile)
	story_flow.advance()
	game_state.map_id = story_flow.current_phase()
	_assert(game_state.profile.name == "Sev", "app root stores confirmed creator profile")
	_assert(story_flow.current_phase() != "character_creator", "app root leaves creator after confirmation")
	_assert(game_state.party[0].class_id == "spellblade", "app root starts game with creator class")
	game_state.free()

func _test_player_profile_persists_uncatalogued_dossier() -> void:
	var PlayerProfile = load("res://scripts/core/player_profile.gd")
	var profile = PlayerProfile.from_dict({
		"name": "Sev",
		"uncatalogued_dossier": {
			"classification": "Uncatalogued Docent",
			"confidence": 17,
			"tags": ["origin_echo:paper_names"],
			"flags": ["no_exhibit_tag"],
			"curator_line": "Sev remains outside assigned parameters.",
		}
	})
	_assert(profile.uncatalogued_dossier.classification == "Uncatalogued Docent", "profile loads dossier classification")
	_assert(profile.uncatalogued_dossier.tags == ["origin_echo:paper_names"], "profile loads dossier tags")
	var saved = profile.to_dict()
	_assert(saved.uncatalogued_dossier.flags == ["no_exhibit_tag"], "profile saves dossier flags")

func _test_sev_record_service_summarizes_creator_loadout() -> void:
	_assert(ResourceLoader.exists("res://scripts/core/sev_record_service.gd"), "Sev record service exists")
	var SevRecordService = load("res://scripts/core/sev_record_service.gd")
	var PlayerProfile = load("res://scripts/core/player_profile.gd")
	var profile = PlayerProfile.from_dict({
		"name": "Sev",
		"class_id": "spellblade",
		"starting_relic": "archive_needle",
		"starting_memory_card": "bell_under_water",
		"voice_blip": "warm_human",
		"portrait_id": "fairy_12",
	})
	var summary = SevRecordService.new().summary(profile)
	_assert(summary.name == "Sev", "Sev record summary includes name")
	_assert(summary.class_name == "Spellblade", "Sev record summary includes class display")
	_assert(summary.relic_name == "Archive Needle", "Sev record summary includes relic display")
	_assert(summary.memory_card_name == "Bell Under Water", "Sev record summary includes memory card display")
	_assert(summary.voice_event == "voice_sev_warm_human", "Sev record summary includes voice event")
	_assert(summary.portrait_path.ends_with("portrait_fairy_12.png"), "Sev record summary includes portrait path")
	_assert(summary.dossier.classification == "Uncatalogued Docent", "Sev record summary includes dossier classification")
	_assert(summary.dossier.flags.has("no_exhibit_tag"), "Sev record summary includes dossier flags")
	_assert(SevRecordService.new().field_line(profile).contains("Archive Needle"), "Sev record field line includes relic")

func _test_content_catalog_loads_recruitable_party_members() -> void:
	var ContentCatalog = load("res://scripts/core/content_catalog.gd")
	var catalog = ContentCatalog.new()
	_assert(catalog.has_method("party_member"), "content catalog exposes party member records")
	if catalog.has_method("party_member"):
		var mira = catalog.party_member("mira_venn")
		_assert(mira.name == "Mira Venn", "content catalog loads Mira Venn party member")
		_assert(mira.class_id == "plague_apothecary", "Mira Venn uses plague apothecary class")
		_assert(mira.skills.has("clean_wound"), "Mira Venn starts with healing skill")

func _test_class_stats_and_leveling() -> void:
	_assert(ResourceLoader.exists("res://scripts/progression/class_catalog.gd"), "class catalog exists")
	_assert(ResourceLoader.exists("res://scripts/progression/progression_service.gd"), "progression service exists")
	var ClassCatalog = load("res://scripts/progression/class_catalog.gd")
	var ProgressionService = load("res://scripts/progression/progression_service.gd")
	var stats = ClassCatalog.new().starting_stats("vanguard")
	_assert(stats.max_hp > stats.max_mp, "vanguard starts with more HP than MP")
	var result = ProgressionService.new().apply_xp({"level": 1, "xp": 0, "stats": stats}, 125, "vanguard")
	_assert(result.level == 2, "125 XP advances a level-one character to level two")
	_assert(result.stats.max_hp > stats.max_hp, "level up increases max HP")

func _test_game_state_applies_battle_xp_to_party() -> void:
	var GameStateScript = load("res://scripts/core/game_state.gd")
	var game_state = GameStateScript.new()
	var party: Array[Dictionary] = [
		{"id": "lead", "name": "Sev", "class_id": "vanguard", "level": 1, "xp": 90, "stats": {"max_hp": 120, "max_mp": 12, "strength": 18, "magic": 4, "defense": 8, "speed": 10}},
		{"id": "mira", "name": "Mira", "class_id": "mystic", "level": 1, "xp": 0, "stats": {"max_hp": 84, "max_mp": 42, "strength": 5, "magic": 16, "defense": 4, "speed": 8}},
	]
	game_state.party = party
	_assert(game_state.has_method("add_party_xp"), "game state exposes party XP application")
	if game_state.has_method("add_party_xp"):
		game_state.add_party_xp(20)
		_assert(game_state.party[0].level == 2, "party XP can level up lead member")
		_assert(game_state.party[0].xp == 10, "party XP carries remainder after level up")
		_assert(game_state.party[0].stats.max_hp > 120, "lead member gains class growth on level up")
		_assert(game_state.party[1].xp == 20, "party XP applies to other active party members")
	game_state.free()

func _test_game_state_applies_battle_party_state() -> void:
	var GameStateScript = load("res://scripts/core/game_state.gd")
	var game_state = GameStateScript.new()
	var party: Array[Dictionary] = [
		{"id": "lead", "name": "Sev", "class_id": "vanguard", "level": 1, "xp": 0, "hp": 120, "stats": {"max_hp": 120, "defense": 8}},
		{"id": "mira", "name": "Mira", "class_id": "mystic", "level": 1, "xp": 0, "hp": 84, "stats": {"max_hp": 84, "magic": 16}},
	]
	game_state.party = party
	_assert(game_state.has_method("apply_party_battle_state"), "game state exposes party battle-state merge")
	if game_state.has_method("apply_party_battle_state"):
		game_state.apply_party_battle_state([
			{"id": "lead", "hp": 73, "statuses": {"poison": {"turns": 1}}},
			{"id": "mira", "hp": 0},
		])
		_assert(game_state.party[0].hp == 73, "party battle state persists lead HP")
		_assert(game_state.party[0].statuses.poison.turns == 1, "party battle state persists statuses")
		_assert(game_state.party[1].hp == 0, "party battle state can persist KO HP")
		_assert(game_state.party[0].stats.max_hp == 120, "party battle state preserves persistent stats")
	game_state.free()

func _test_game_state_recruits_party_member_once() -> void:
	var GameStateScript = load("res://scripts/core/game_state.gd")
	var game_state = GameStateScript.new()
	var party: Array[Dictionary] = [{"id": "lead", "name": "Sev", "class_id": "vanguard", "level": 1, "xp": 0, "stats": {"max_hp": 120}}]
	game_state.party = party
	_assert(game_state.has_method("recruit_party_member"), "game state exposes party recruitment")
	if game_state.has_method("recruit_party_member"):
		_assert(game_state.recruit_party_member("mira_venn"), "game state recruits Mira Venn")
		_assert(game_state.party.any(func(member): return member.id == "mira_venn"), "Mira Venn appears in active party")
		var mira = game_state.party.filter(func(member): return member.id == "mira_venn")[0]
		_assert(mira.class_id == "plague_apothecary", "Mira keeps plague apothecary class")
		_assert(mira.skills.has("clean_wound"), "Mira joins with healing skill")
		_assert(not game_state.recruit_party_member("mira_venn"), "recruiting Mira twice is ignored")
		_assert(game_state.party.filter(func(member): return member.id == "mira_venn").size() == 1, "duplicate Mira is not added")
	game_state.free()

func _test_atb_wait_mode_pause() -> void:
	_assert(ResourceLoader.exists("res://scripts/battle/battle_clock.gd"), "battle clock exists")
	var BattleClock = load("res://scripts/battle/battle_clock.gd")
	var clock = BattleClock.new()
	clock.add_combatant("hero", 20)
	clock.add_combatant("enemy", 10, true)
	clock.advance(1.0, false, "wait")
	var enemy_before = clock.combatants[1].atb
	clock.advance(1.0, true, "wait")
	_assert(clock.combatants[1].atb == enemy_before, "wait mode pauses enemy ATB while command menu is open")
	_assert(clock.combatants[0].atb > enemy_before, "player ATB can continue filling in wait mode")

func _test_encounter_selection() -> void:
	_assert(ResourceLoader.exists("res://scripts/field/encounter_table.gd"), "encounter table exists")
	var EncounterTable = load("res://scripts/field/encounter_table.gd")
	var table = EncounterTable.new("dungeon_depths", [{"id": "slime_pair", "weight": 3}, {"id": "bat_swarm", "weight": 1}], 12)
	_assert(not table.should_check(11), "encounter table waits until step threshold")
	_assert(table.should_check(12), "encounter table checks at step threshold")
	_assert(table.pick(0.0) == "slime_pair", "weighted pick selects first encounter at low roll")
	_assert(table.pick(0.95) == "bat_swarm", "weighted pick selects last encounter at high roll")

func _test_first_slice_plague_encounters_defined() -> void:
	var encounter_file := FileAccess.open("res://data/encounters/plague_wing.json", FileAccess.READ)
	_assert(encounter_file != null, "plague wing encounter data exists")
	var encounters = JSON.parse_string(encounter_file.get_as_text())
	_assert(encounters.tables.plague_wing_underchapel.entries[0].id == "fever_wretch_pair", "underchapel table starts with fever wretches")
	_assert(encounters.tables.plague_wing_hospital.entries.any(func(e): return e.id == "clean_man_patrol"), "hospital table includes clean men")
	var enemy_file := FileAccess.open("res://data/combat/enemies.json", FileAccess.READ)
	var enemies = JSON.parse_string(enemy_file.get_as_text())
	_assert(enemies.has("fever_wretch"), "enemy database includes Fever Wretch")
	_assert(enemies.has("clean_man"), "enemy database includes Clean Man")
	_assert(enemies.has("bell_saint"), "enemy database includes Bell Saint boss")

func _test_first_slice_encounter_pacing_is_boss_safe() -> void:
	var encounter_file := FileAccess.open("res://data/encounters/plague_wing.json", FileAccess.READ)
	var encounters = JSON.parse_string(encounter_file.get_as_text())
	var underchapel = encounters.tables.plague_wing_underchapel
	var hospital = encounters.tables.plague_wing_hospital
	_assert(int(underchapel.step_threshold) >= 18, "Underchapel waits long enough before random encounters")
	_assert(int(hospital.step_threshold) >= 14, "Hospital waits long enough before random encounters")
	_assert(underchapel.entries.size() <= 3, "Underchapel encounter table stays compact for the first dungeon")
	_assert(hospital.entries.size() <= 3, "Hospital encounter table stays compact before Bell Saint")
	_assert(float(underchapel.entries[0].weight) >= 5.0, "Underchapel favors the simpler Fever Wretch pair")
	_assert(hospital.entries.any(func(entry): return entry.id == "clean_man_patrol" and int(entry.enemies.size()) == 1), "Hospital uses a single Clean Man patrol before the boss")

func _test_bell_saint_boss_numbers_fit_first_slice_party() -> void:
	var enemy_file := FileAccess.open("res://data/combat/enemies.json", FileAccess.READ)
	var enemies = JSON.parse_string(enemy_file.get_as_text())
	var boss = enemies.bell_saint
	_assert(int(boss.max_hp) <= 360, "Bell Saint HP is tuned for the first Sev/Mira boss fight")
	_assert(int(boss.strength) <= 14, "Bell Saint strength leaves room for recovery after dungeon encounters")
	_assert(int(boss.defense) <= 7, "Bell Saint defense keeps basic attacks useful")
	_assert(int(boss.xp) >= 180, "Bell Saint still pays meaningful chapter-completion XP")
	_assert(boss.relic == "bell_clapper", "Bell Saint still grants Bell Clapper")
	_assert(boss.memory_card == "bell_saint", "Bell Saint still grants Bell Saint memory card")

func _test_prototype_field_builds_group_encounter_payload() -> void:
	var FieldScene = load("res://scenes/field/prototype_field.tscn")
	var field_scene = FieldScene.instantiate()
	root.add_child(field_scene)
	_assert(field_scene.has_method("encounter_battle_payload"), "prototype field exposes encounter battle payload builder")
	if field_scene.has_method("encounter_battle_payload"):
		var payload = field_scene.encounter_battle_payload("plague_wing_underchapel", "fever_wretch_pair")
		_assert(payload.scene_path == "res://scenes/battle/prototype_battle.tscn", "encounter payload points to battle scene")
		_assert(payload.encounter_id == "fever_wretch_pair", "encounter payload keeps encounter id")
		_assert(payload.enemy_ids.size() == 2, "encounter payload keeps all enemy ids")
		_assert(payload.enemies.size() == 2, "encounter payload resolves every enemy")
		_assert(payload.enemies[0].id == "fever_wretch", "first encounter enemy is hydrated")
		_assert(payload.enemies[1].id == "fever_wretch", "duplicate encounter enemies are preserved")
		_assert(payload.enemies[0].hp == payload.enemies[0].max_hp, "encounter enemy starts at full HP")
	field_scene.queue_free()

func _test_prototype_field_requests_random_encounter_from_current_map() -> void:
	var FieldScene = load("res://scenes/field/prototype_field.tscn")
	var field_scene = FieldScene.instantiate()
	var emitted: Array = []
	field_scene.battle_launch_requested.connect(func(payload): emitted.append(payload))
	root.add_child(field_scene)
	field_scene.set("map_phase_id", "underchapel_drain")
	field_scene.load_phase_map()
	_assert(field_scene.has_method("request_random_encounter"), "prototype field exposes random encounter battle request")
	if field_scene.has_method("request_random_encounter"):
		_assert(field_scene.request_random_encounter(0.0), "field can request encounter from current map table")
		_assert(emitted.size() == 1, "random encounter emits one battle launch payload")
		_assert(emitted[0].encounter_id == "fever_wretch_pair", "low roll selects first weighted encounter")
		_assert(emitted[0].enemies.size() == 2, "random encounter payload includes grouped enemies")
		_assert(emitted[0].source_phase == "underchapel_drain", "random encounter payload keeps source phase")
	field_scene.queue_free()

func _test_prototype_field_step_threshold_triggers_random_encounter() -> void:
	var FieldScene = load("res://scenes/field/prototype_field.tscn")
	var field_scene = FieldScene.instantiate()
	var emitted: Array = []
	field_scene.battle_launch_requested.connect(func(payload): emitted.append(payload))
	root.add_child(field_scene)
	field_scene.set("map_phase_id", "underchapel_drain")
	field_scene.load_phase_map()
	_assert(field_scene.has_method("record_encounter_steps"), "prototype field exposes step-based encounter checks")
	if field_scene.has_method("record_encounter_steps"):
		_assert(not field_scene.record_encounter_steps(17, 0.0), "encounter does not trigger before table threshold")
		_assert(emitted.is_empty(), "pre-threshold movement emits no battle payload")
		_assert(field_scene.record_encounter_steps(1, 0.0), "encounter triggers when accumulated steps reach threshold")
		_assert(emitted.size() == 1, "threshold encounter emits one battle payload")
		_assert(emitted[0].encounter_id == "fever_wretch_pair", "threshold encounter uses current table weighted pick")
		_assert(emitted[0].enemies.size() == 2, "threshold encounter payload keeps grouped enemies")
		_assert(not field_scene.record_encounter_steps(1, 0.0), "encounter step counter resets after a trigger")
		_assert(emitted.size() == 1, "post-trigger single step does not emit another battle")
	field_scene.queue_free()

func _test_prototype_field_player_travel_records_encounter_steps() -> void:
	var FieldScene = load("res://scenes/field/prototype_field.tscn")
	var field_scene = FieldScene.instantiate()
	var emitted: Array = []
	field_scene.battle_launch_requested.connect(func(payload): emitted.append(payload))
	root.add_child(field_scene)
	field_scene.set("map_phase_id", "underchapel_drain")
	field_scene.load_phase_map()
	var player = field_scene.get_node("%Player")
	_assert(field_scene.has_method("record_player_travel_for_encounters"), "prototype field records encounter steps from player travel")
	if field_scene.has_method("record_player_travel_for_encounters"):
		player.position += Vector2(16 * 17, 0)
		_assert(not field_scene.record_player_travel_for_encounters(0.0), "travel under threshold does not trigger an encounter")
		_assert(emitted.is_empty(), "under-threshold player travel emits no battle")
		player.position += Vector2(16, 0)
		_assert(field_scene.record_player_travel_for_encounters(0.0), "tile travel at threshold triggers an encounter")
		_assert(emitted.size() == 1, "player travel emits one encounter payload at threshold")
		_assert(emitted[0].encounter_id == "fever_wretch_pair", "player travel encounter uses current map table")
	field_scene.queue_free()

func _test_prototype_field_random_encounter_payload_records_source_position() -> void:
	var FieldScene = load("res://scenes/field/prototype_field.tscn")
	var field_scene = FieldScene.instantiate()
	var emitted: Array = []
	field_scene.battle_launch_requested.connect(func(payload): emitted.append(payload))
	root.add_child(field_scene)
	field_scene.set("map_phase_id", "underchapel_drain")
	field_scene.load_phase_map()
	var player = field_scene.get_node("%Player")
	player.position = Vector2(176, 92)
	_assert(field_scene.request_random_encounter(0.0), "field can request random encounter with player positioned")
	_assert(emitted.size() == 1, "positioned random encounter emits payload")
	_assert(emitted[0].has("source_position"), "random encounter payload records source position")
	if emitted.size() == 1 and emitted[0].has("source_position"):
		_assert(emitted[0].source_position == Vector2(176, 92), "random encounter source position matches player position")
	field_scene.queue_free()

func _test_prototype_field_loads_saved_player_position_for_current_map() -> void:
	var FieldScene = load("res://scenes/field/prototype_field.tscn")
	var GameStateScript = load("res://scripts/core/game_state.gd")
	var game_state = GameStateScript.new()
	game_state.map_id = "underchapel_drain"
	game_state.player_position = Vector2(184, 104)
	var field_scene = FieldScene.instantiate()
	field_scene.game_state_override = game_state
	root.add_child(field_scene)
	field_scene.set("map_phase_id", "underchapel_drain")
	field_scene.load_phase_map()
	var player = field_scene.get_node("%Player")
	_assert(player.position == Vector2(184, 104), "prototype field restores saved player position for current map")
	field_scene.queue_free()
	game_state.free()

func _test_save_payload_roundtrip() -> void:
	_assert(ResourceLoader.exists("res://scripts/save/save_service.gd"), "save service exists")
	var SaveService = load("res://scripts/save/save_service.gd")
	var service = SaveService.new()
	var payload = service.build_payload({
		"profile": {"name": "Mira", "class_id": "mystic"},
		"map_id": "town",
		"position": Vector2(4, 7),
		"inventory": {"potion": 2},
		"flags": {"met_elder": true}
	})
	_assert(payload.schema_version == 1, "save payload is versioned")
	_assert(payload.position.x == 4 and payload.position.y == 7, "save payload stores position")
	var migrated = service.migrate_payload({"profile": {}, "map_id": "overworld"})
	_assert(migrated.schema_version == 1, "legacy payload migrates to current schema")
	_assert(migrated.memory_cards.owned.is_empty(), "legacy payload gets empty memory card collection")

func _test_save_payload_preserves_bell_saint_slice_checkpoints() -> void:
	var GameStateScript = load("res://scripts/core/game_state.gd")
	var SaveService = load("res://scripts/save/save_service.gd")
	var service = SaveService.new()
	var checkpoints := [
		{
			"name": "mira recruited",
			"map_id": "chapel",
			"position": Vector2(224, 112),
			"party": [{"id": "lead", "hp": 100, "max_hp": 100}, {"id": "mira_venn", "hp": 84, "max_hp": 84}],
			"inventory": {"clean_bandage": 2},
			"memory_cards": {"owned": [], "equipped": []},
			"flags": {"mira_venn_recruited": true}
		},
		{
			"name": "before bell saint",
			"map_id": "bell_tower_boss_room",
			"position": Vector2(48, 96),
			"party": [{"id": "lead", "hp": 76, "max_hp": 100}, {"id": "mira_venn", "hp": 62, "max_hp": 84}],
			"inventory": {"clean_bandage": 1, "bitter_draught": 1},
			"memory_cards": {"owned": [], "equipped": []},
			"flags": {"mira_venn_recruited": true, "bell_tower_reached": true}
		},
		{
			"name": "after bell saint",
			"map_id": "truth_recovered",
			"position": Vector2(64, 64),
			"party": [{"id": "lead", "hp": 54, "max_hp": 100}, {"id": "mira_venn", "hp": 38, "max_hp": 84}],
			"inventory": {"bell_clapper": 1},
			"memory_cards": {"owned": ["bell_saint"], "equipped": ["bell_saint"]},
			"flags": {"mira_venn_recruited": true, "boss_bell_saint_defeated": true, "chapter_01_complete": true}
		},
	]
	for checkpoint in checkpoints:
		var state = GameStateScript.new()
		state.map_id = checkpoint.map_id
		state.player_position = checkpoint.position
		state.party.clear()
		for member in checkpoint.party:
			state.party.append(member.duplicate(true))
		state.inventory = checkpoint.inventory.duplicate(true)
		state.memory_cards = checkpoint.memory_cards.duplicate(true)
		state.flags = checkpoint.flags.duplicate(true)
		var payload = service.build_payload(state.to_save_state())
		var restored = GameStateScript.new()
		restored.apply_save_payload(service.migrate_payload(payload))
		_assert(restored.map_id == checkpoint.map_id, "%s checkpoint restores map id" % checkpoint.name)
		_assert(restored.player_position == checkpoint.position, "%s checkpoint restores position" % checkpoint.name)
		_assert(restored.party.size() == checkpoint.party.size(), "%s checkpoint restores party size" % checkpoint.name)
		_assert(restored.inventory == checkpoint.inventory, "%s checkpoint restores inventory" % checkpoint.name)
		_assert(restored.memory_cards == checkpoint.memory_cards, "%s checkpoint restores memory cards" % checkpoint.name)
		for flag_name in checkpoint.flags.keys():
			_assert(restored.flags.get(flag_name, false) == checkpoint.flags[flag_name], "%s checkpoint restores %s flag" % [checkpoint.name, flag_name])
		restored.free()
		state.free()

func _test_save_payload_preserves_first_slice_evidence_progress() -> void:
	var GameStateScript = load("res://scripts/core/game_state.gd")
	var SaveService = load("res://scripts/save/save_service.gd")
	var EvidenceProgressService = load("res://scripts/core/evidence_progress_service.gd")
	var state = GameStateScript.new()
	state.flags = {
		"discovered_prop_underchapel_museum_pipe": true,
		"discovered_prop_hospital_medical_chart": true,
		"discovered_story_props": [
			"discovered_prop_underchapel_museum_pipe",
			"discovered_prop_hospital_medical_chart",
		],
	}
	var payload = SaveService.new().build_payload(state.to_save_state())
	var restored = GameStateScript.new()
	restored.apply_save_payload(SaveService.new().migrate_payload(payload))
	var summary: Dictionary = EvidenceProgressService.new().first_slice_summary(restored.flags)
	_assert(restored.flags.get("discovered_story_props", []).has("discovered_prop_underchapel_museum_pipe"), "save roundtrip preserves discovered story prop list")
	_assert(int(summary.found) == 2, "save roundtrip preserves first-slice evidence progress count")
	restored.free()
	state.free()

func _test_game_state_rebuilds_discovered_story_prop_list_from_legacy_flags() -> void:
	var GameStateScript = load("res://scripts/core/game_state.gd")
	var restored = GameStateScript.new()
	restored.apply_save_payload({
		"profile": {},
		"map_id": "underchapel_drain",
		"position": Vector2(96, 72),
		"flags": {
			"discovered_prop_underchapel_museum_pipe": true,
			"discovered_prop_hospital_medical_chart": true,
		},
	})
	var discovered: Array = restored.flags.get("discovered_story_props", [])
	_assert(discovered.has("discovered_prop_underchapel_museum_pipe"), "legacy evidence flag rebuilds discovered story prop list")
	_assert(discovered.has("discovered_prop_hospital_medical_chart"), "legacy hospital evidence flag rebuilds discovered story prop list")
	restored.free()

func _test_field_movement_and_interactions() -> void:
	_assert(ResourceLoader.exists("res://scripts/field/field_controller.gd"), "field controller exists")
	var FieldController = load("res://scripts/field/field_controller.gd")
	var field = FieldController.new()
	var diagonal = field.movement_vector({"move_right": true, "move_down": true})
	_assert(is_equal_approx(diagonal.length(), 1.0), "diagonal movement is normalized")
	_assert(field.facing_from_vector(Vector2(0.2, -0.9)) == "up", "facing resolves from strongest axis")
	var interaction = field.find_facing_interaction(Vector2(64, 64), "right", [
		{"id": "elder", "position": Vector2(80, 64), "radius": 12},
		{"id": "chest", "position": Vector2(64, 96), "radius": 12},
	])
	_assert(interaction.id == "elder", "interaction resolves against facing direction")
	var transition = field.resolve_transition(Vector2(128, 64), [
		{"target_map": "town", "rect": Rect2(120, 48, 32, 32), "spawn": Vector2(16, 16)}
	])
	_assert(transition.target_map == "town", "trigger zone resolves map transition")

func _test_slice_flow_route_matches_playable_bell_saint_path() -> void:
	_assert(ResourceLoader.exists("res://data/maps/slice_flow.json"), "map slice flow exists")
	var file := FileAccess.open("res://data/maps/slice_flow.json", FileAccess.READ)
	var data = JSON.parse_string(file.get_as_text())
	var flow: Array = data.flow
	_assert(flow.front() == "character_creator", "Bell Saint route starts at character creator")
	_assert(flow.has("empty_rotunda"), "Bell Saint route includes Empty Rotunda")
	_assert(flow.has("underchapel_drain"), "Bell Saint route includes Underchapel Drain")
	_assert(flow.find("chapel") < flow.find("underchapel_drain"), "Underchapel follows chapel in slice route")
	_assert(flow.find("underchapel_drain") < flow.find("hidden_hospital_corridor"), "hospital follows Underchapel in slice route")
	_assert(flow.find("bell_tower_boss_room") < flow.find("battle"), "battle follows Bell Tower in slice route")
	_assert(flow.back() == "truth_recovered", "Bell Saint route ends on truth recovered reward scene")

func _test_slice_flow_route_is_playable_and_rewarded() -> void:
	var flow_file := FileAccess.open("res://data/maps/slice_flow.json", FileAccess.READ)
	var flow_data = JSON.parse_string(flow_file.get_as_text())
	var flow: Array = flow_data.flow
	var field_phases: Array[String] = []
	for phase_id in flow:
		if phase_id in ["character_creator", "battle", "truth_recovered"]:
			continue
		field_phases.append(String(phase_id))
	var MapCatalog = load("res://scripts/field/map_catalog.gd")
	var catalog = MapCatalog.new()
	var adjacency := {}
	for phase_id in field_phases:
		var map = catalog.map_for_phase(phase_id)
		_assert(not map.is_empty(), "%s resolves to playable map data" % phase_id)
		if map.is_empty():
			continue
		adjacency[phase_id] = []
		for transition in map.get("transitions", []):
			adjacency[phase_id].append(String(transition.target_phase))
	var reachable := {}
	var queue: Array[String] = ["empty_rotunda"]
	while not queue.is_empty():
		var current: String = queue.pop_front()
		if reachable.has(current):
			continue
		reachable[current] = true
		for next_phase in adjacency.get(current, []):
			if not reachable.has(next_phase):
				queue.append(next_phase)
	for phase_id in field_phases:
		_assert(reachable.has(phase_id), "%s is reachable from Empty Rotunda through map transitions" % phase_id)
	var boss_map = catalog.map_for_phase("bell_tower_boss_room")
	_assert(boss_map.boss == "bell_saint", "Bell Tower launches Bell Saint boss")
	var enemies_file := FileAccess.open("res://data/combat/enemies.json", FileAccess.READ)
	var enemies = JSON.parse_string(enemies_file.get_as_text())
	_assert(enemies.bell_saint.next_flow == "truth_recovered", "Bell Saint victory routes to truth recovered")
	_assert(enemies.bell_saint.relic == "bell_clapper", "Bell Saint victory grants Bell Clapper")
	_assert(enemies.bell_saint.memory_card == "bell_saint", "Bell Saint victory grants Bell Saint memory card")

func _test_first_slice_map_catalog_defines_town_and_dungeon() -> void:
	_assert(ResourceLoader.exists("res://scripts/field/map_catalog.gd"), "field map catalog exists")
	_assert(ResourceLoader.exists("res://data/maps/first_slice_maps.json"), "first slice map data exists")
	var MapCatalog = load("res://scripts/field/map_catalog.gd")
	var catalog = MapCatalog.new()
	var town = catalog.map_for_phase("plague_town_street")
	_assert(town.id == "hallowmere_street", "plague town phase maps to Hallowmere street")
	_assert(town.kind == "town", "Hallowmere street is a town map")
	_assert(town.npcs.size() >= 4, "Hallowmere street has ambient NPCs")
	_assert(town.transitions.any(func(t): return t.target_phase == "apothecary_house"), "Hallowmere street links to apothecary")
	var drain = catalog.map_for_phase("underchapel_drain")
	_assert(drain.kind == "dungeon", "Underchapel Drain is a dungeon map")
	_assert(drain.encounter_table == "plague_wing_underchapel", "Underchapel Drain uses plague encounter table")
	var hospital = catalog.map_for_phase("hidden_hospital_corridor")
	_assert(hospital.interactables.any(func(i): return i.id == "medical_chart"), "hospital corridor has medical chart interaction")

func _test_first_slice_route_spawns_and_transitions_are_navigable() -> void:
	var MapCatalog = load("res://scripts/field/map_catalog.gd")
	var catalog = MapCatalog.new()
	for phase_id in [
		"empty_rotunda",
		"broken_exhibit_door",
		"plague_town_street",
		"apothecary_house",
		"chapel",
		"underchapel_drain",
		"hidden_hospital_corridor",
		"bell_tower_boss_room",
	]:
		var map = catalog.map_for_phase(phase_id)
		var spawn := _vector_from_map_point(map.get("spawn", {}))
		_assert(_point_is_on_floor(map, spawn), "%s spawn is on walkable floor" % phase_id)
		_assert(not _point_is_inside_wall(map, spawn), "%s spawn is clear of wall collision" % phase_id)
		for transition in map.get("transitions", []):
			var rect := _rect_from_map_rect(transition.get("rect", {}))
			var center := rect.position + rect.size / 2.0
			_assert(_point_is_on_floor(map, center), "%s transition %s center is on walkable floor" % [phase_id, transition.id])
			_assert(not _point_is_inside_wall(map, center), "%s transition %s center is clear of wall collision" % [phase_id, transition.id])
			var target_map = catalog.map_for_phase(String(transition.target_phase))
			var target_spawn := _vector_from_map_point(transition.get("spawn", {}))
			_assert(_point_is_on_floor(target_map, target_spawn), "%s transition %s target spawn is on target floor" % [phase_id, transition.id])
			_assert(not _point_is_inside_wall(target_map, target_spawn), "%s transition %s target spawn is clear on target map" % [phase_id, transition.id])

func _test_first_slice_maps_add_side_quest_npcs() -> void:
	var MapCatalog = load("res://scripts/field/map_catalog.gd")
	var catalog = MapCatalog.new()
	var town = catalog.map_for_phase("plague_town_street")
	_assert(town.npcs.any(func(npc): return npc.id == "fever_child"), "Hallowmere includes fever child ambient NPC")
	_assert(town.npcs.any(func(npc): return npc.id == "corpse_cart_driver"), "Hallowmere includes corpse cart driver ambient NPC")
	var sick_woman = _dictionary_with_id(town.npcs, "sick_woman")
	_assert(sick_woman.has("quest"), "Sick Woman carries clean cloth side quest payload")
	_assert(String(sick_woman.get("quest", {}).get("id", "")) == "clean_cloth", "Sick Woman side quest id is clean cloth")
	var hospital = catalog.map_for_phase("hidden_hospital_corridor")
	_assert(hospital.npcs.any(func(npc): return npc.id == "nurse_echo"), "hospital corridor includes Nurse Echo NPC")
	var nurse_echo = _dictionary_with_id(hospital.npcs, "nurse_echo")
	_assert(nurse_echo.has("quest"), "Nurse Echo carries wrong chart side quest payload")
	_assert(String(nurse_echo.get("quest", {}).get("id", "")) == "wrong_chart", "Nurse Echo side quest id is wrong chart")

func _test_prototype_field_resolves_first_slice_map_data() -> void:
	var FieldScene = load("res://scenes/field/prototype_field.tscn")
	var field_scene = FieldScene.instantiate()
	root.add_child(field_scene)
	field_scene.set("phase_metadata", {"display_name": "Plague Town Street", "mood": "quarantine day repeating", "beat": "test"})
	field_scene.set("map_phase_id", "plague_town_street")
	field_scene.load_phase_map()
	_assert(field_scene.current_map.id == "hallowmere_street", "prototype field loads map data for phase")
	_assert(field_scene.get_node("%PhaseLabel").text.contains("Hallowmere"), "prototype field renders map display name")
	field_scene.queue_free()

func _test_prototype_field_generates_first_slice_map_markers() -> void:
	var FieldScene = load("res://scenes/field/prototype_field.tscn")
	var field_scene = FieldScene.instantiate()
	root.add_child(field_scene)
	field_scene.set("map_phase_id", "plague_town_street")
	field_scene.load_phase_map()
	_assert(field_scene.has_node("MapContent/Npcs/sick_woman"), "prototype field renders NPC marker from map data")
	_assert(field_scene.has_node("MapContent/Interactables/town_well"), "prototype field renders interactable marker from map data")
	_assert(field_scene.has_node("MapContent/Transitions/to_apothecary"), "prototype field renders transition marker from map data")
	var sick_woman = field_scene.get_node("MapContent/Npcs/sick_woman")
	_assert(sick_woman.is_in_group("interactables"), "generated NPC marker is interactable")
	var result = sick_woman.interact()
	_assert(result.type == "map_line", "generated NPC interaction returns map line result")
	_assert(result.status == "Sick Woman: Do not come near.", "generated NPC interaction includes speaker and line")
	field_scene.queue_free()

func _test_map_interactable_returns_side_quest_payload() -> void:
	var MapInteractable = load("res://scripts/field/map_interactable.gd")
	var marker = MapInteractable.new()
	marker.configure({
		"id": "quest_npc",
		"name": "Quest NPC",
		"position": {"x": 16, "y": 16},
		"line": "I have something for you.",
		"quest": {
			"id": "clean_cloth",
			"completion_flag": "quest_clean_cloth_complete",
			"reward_items": {"clean_bandage": 2},
			"complete_line": "Take this boiled cloth.",
			"repeat_line": "You already carry what I can spare."
		}
	}, "npc")
	var result = marker.interact()
	_assert(result.has("quest"), "map interactable forwards side quest payload")
	_assert(String(result.get("quest", {}).get("id", "")) == "clean_cloth", "side quest payload preserves id")
	_assert(String(result.get("display_name", "")) == "Quest NPC", "side quest payload includes display name")
	marker.free()

func _test_prototype_field_completes_clean_cloth_side_quest() -> void:
	var FieldScene = load("res://scenes/field/prototype_field.tscn")
	var GameStateScript = load("res://scripts/core/game_state.gd")
	var game_state = GameStateScript.new()
	var field_scene = FieldScene.instantiate()
	field_scene.game_state_override = game_state
	root.add_child(field_scene)
	field_scene.set("map_phase_id", "plague_town_street")
	field_scene.load_phase_map()
	field_scene.active_dialogue_index = -1
	field_scene.active_dialogue_lines.clear()
	var sick_woman = field_scene.get_node("MapContent/Npcs/sick_woman")
	field_scene.get_node("%Player").position = sick_woman.position + Vector2(-16, 0)
	field_scene.get_node("%Player").facing = "right"
	_assert(field_scene.try_context_action(), "field interaction completes clean cloth quest")
	_assert(bool(game_state.flags.get("quest_clean_cloth_complete", false)), "clean cloth quest completion flag is stored")
	_assert(int(game_state.inventory.get("clean_bandage", 0)) == 2, "clean cloth quest grants two clean bandages")
	_assert(field_scene.get_node("%StatusLabel").text.contains("Received Clean Bandage x2."), "clean cloth quest status reports reward")
	field_scene.game_state_override = null
	field_scene.queue_free()
	game_state.free()

func _test_prototype_field_does_not_duplicate_side_quest_rewards() -> void:
	var FieldScene = load("res://scenes/field/prototype_field.tscn")
	var GameStateScript = load("res://scripts/core/game_state.gd")
	var game_state = GameStateScript.new()
	var field_scene = FieldScene.instantiate()
	field_scene.game_state_override = game_state
	root.add_child(field_scene)
	field_scene.set("map_phase_id", "plague_town_street")
	field_scene.load_phase_map()
	field_scene.active_dialogue_index = -1
	field_scene.active_dialogue_lines.clear()
	var sick_woman = field_scene.get_node("MapContent/Npcs/sick_woman")
	field_scene.get_node("%Player").position = sick_woman.position + Vector2(-16, 0)
	field_scene.get_node("%Player").facing = "right"
	field_scene.try_context_action()
	field_scene.try_context_action()
	_assert(int(game_state.inventory.get("clean_bandage", 0)) == 2, "repeat clean cloth interaction does not duplicate rewards")
	_assert(field_scene.get_node("%StatusLabel").text.contains("already carry"), "repeat clean cloth interaction shows repeat line")
	field_scene.game_state_override = null
	field_scene.queue_free()
	game_state.free()

func _test_prototype_field_completes_wrong_chart_side_quest() -> void:
	var FieldScene = load("res://scenes/field/prototype_field.tscn")
	var GameStateScript = load("res://scripts/core/game_state.gd")
	var game_state = GameStateScript.new()
	var field_scene = FieldScene.instantiate()
	field_scene.game_state_override = game_state
	root.add_child(field_scene)
	field_scene.set("map_phase_id", "hidden_hospital_corridor")
	field_scene.load_phase_map()
	field_scene.active_dialogue_index = -1
	field_scene.active_dialogue_lines.clear()
	var nurse_echo = field_scene.get_node_or_null("MapContent/Npcs/nurse_echo")
	_assert(nurse_echo != null, "field renders Nurse Echo side quest NPC")
	if nurse_echo != null:
		field_scene.get_node("%Player").position = nurse_echo.position + Vector2(-16, 0)
		field_scene.get_node("%Player").facing = "right"
		_assert(field_scene.try_context_action(), "field interaction completes wrong chart quest")
	_assert(bool(game_state.flags.get("quest_wrong_chart_complete", false)), "wrong chart quest completion flag is stored")
	_assert(int(game_state.inventory.get("fever_charm", 0)) == 1, "wrong chart quest grants fever charm")
	_assert(field_scene.get_node("%StatusLabel").text.contains("Received Fever Charm x1."), "wrong chart quest status reports reward")
	field_scene.game_state_override = null
	field_scene.queue_free()
	game_state.free()

func _test_prototype_field_exposes_transition_zones() -> void:
	var FieldScene = load("res://scenes/field/prototype_field.tscn")
	var field_scene = FieldScene.instantiate()
	root.add_child(field_scene)
	field_scene.set("map_phase_id", "plague_town_street")
	field_scene.load_phase_map()
	var transitions = field_scene.active_transitions()
	_assert(transitions.any(func(t): return t.target_phase == "apothecary_house"), "prototype field exposes apothecary transition")
	var resolved = field_scene.transition_at(Vector2(360, 88))
	_assert(resolved.target_phase == "apothecary_house", "prototype field resolves transition under player position")
	_assert(resolved.spawn == Vector2(48, 64), "prototype field converts transition spawn to Vector2")
	field_scene.queue_free()

func _test_first_slice_maps_define_visible_graybox_layouts() -> void:
	var MapCatalog = load("res://scripts/field/map_catalog.gd")
	var catalog = MapCatalog.new()
	for phase_id in [
		"empty_rotunda",
		"broken_exhibit_door",
		"plague_town_street",
		"apothecary_house",
		"chapel",
		"underchapel_drain",
		"hidden_hospital_corridor",
		"bell_tower_boss_room",
	]:
		var map = catalog.map_for_phase(phase_id)
		_assert(map.has("layout"), "%s defines a visible graybox layout" % phase_id)
		_assert(map.layout.floor_rects.size() > 0, "%s has floor rectangles" % phase_id)
		_assert(map.layout.wall_rects.size() > 0, "%s has wall rectangles" % phase_id)
		_assert(int(map.layout.get("tile_size", 0)) == 16, "%s uses 16px tile grid" % phase_id)

func _test_prototype_field_renders_graybox_layout() -> void:
	var FieldScene = load("res://scenes/field/prototype_field.tscn")
	var field_scene = FieldScene.instantiate()
	root.add_child(field_scene)
	field_scene.set("map_phase_id", "plague_town_street")
	field_scene.load_phase_map()
	_assert(field_scene.has_node("MapContent/Graybox/Floors"), "prototype field renders floor layer")
	_assert(field_scene.has_node("MapContent/Graybox/Walls"), "prototype field renders wall layer")
	_assert(field_scene.get_node("MapContent/Graybox/Floors").get_child_count() >= 3, "Hallowmere renders multiple floor shapes")
	_assert(field_scene.get_node("MapContent/Graybox/Walls").get_child_count() >= 4, "Hallowmere renders wall shapes")
	_assert(field_scene.get_node("%Player").position == Vector2(48, 96), "prototype field moves player to map spawn")
	field_scene.queue_free()

func _test_first_slice_prop_placement_manifest_defines_layers() -> void:
	_assert(ResourceLoader.exists("res://data/maps/first_slice_prop_placements.json"), "first slice prop placement manifest exists")
	var file := FileAccess.open("res://data/maps/first_slice_prop_placements.json", FileAccess.READ)
	var manifest = JSON.parse_string(file.get_as_text())
	for map_id in [
		"hallowmere_street",
		"mira_apothecary",
		"sainted_bell_chapel",
		"underchapel_drain",
		"hidden_hospital_corridor",
		"bell_tower_boss_room",
	]:
		_assert(manifest.maps.has(map_id), "%s has prop placement data" % map_id)
		var categories := []
		for prop in manifest.maps[map_id].props:
			categories.append(String(prop.get("category", "")))
		_assert(categories.has("navigation"), "%s includes navigation props" % map_id)
		_assert(categories.has("story"), "%s includes story evidence props" % map_id)
		_assert(categories.has("atmosphere"), "%s includes atmosphere props" % map_id)

func _test_map_prop_renderer_resolves_and_instantiates_props() -> void:
	_assert(ResourceLoader.exists("res://scripts/field/map_prop_renderer.gd"), "map prop renderer script exists")
	var MapPropRenderer = load("res://scripts/field/map_prop_renderer.gd")
	var renderer = MapPropRenderer.new()
	var props = renderer.props_for_map("hallowmere_street")
	_assert(props.any(func(prop): return prop.id == "House01"), "renderer resolves Hallowmere prop data")
	var house_prop := _dictionary_with_id(props, "House01")
	var house = renderer.create_prop(house_prop)
	_assert(house is Sprite2D, "renderer creates sprite prop for House01")
	_assert(house.name == "House01", "renderer names prop from manifest id")
	_assert(house.get_meta("tile_asset_id", "") == "plague_town_house_01", "renderer records tile asset metadata")
	_assert(house.get_meta("prop_category", "") == "navigation", "renderer records prop category")
	house.free()

func _test_map_prop_renderer_creates_prop_collision() -> void:
	var MapPropRenderer = load("res://scripts/field/map_prop_renderer.gd")
	var renderer = MapPropRenderer.new()
	var props = renderer.props_for_map("hallowmere_street")
	var town_well_prop := _dictionary_with_id(props, "TownWell")
	_assert(town_well_prop.has("collision_rect"), "TownWell manifest entry defines collision")
	var town_well = renderer.create_prop(town_well_prop)
	_assert(town_well.has_node("PropCollision"), "renderer creates collision body for blocking prop")
	var collision = town_well.get_node("PropCollision")
	_assert(collision is StaticBody2D, "prop collision node is a StaticBody2D")
	_assert(collision.has_node("CollisionShape2D"), "prop collision body has a collision shape")
	town_well.free()

func _test_map_prop_renderer_forwards_discovery_flag_metadata() -> void:
	var MapPropRenderer = load("res://scripts/field/map_prop_renderer.gd")
	var renderer = MapPropRenderer.new()
	var props = renderer.props_for_map("underchapel_drain")
	var pipe_prop := _dictionary_with_id(props, "MuseumPipe")
	var pipe = renderer.create_prop(pipe_prop)
	_assert(pipe.get_meta("discovery_flag", "") == "discovered_prop_underchapel_museum_pipe", "renderer forwards discovery flag metadata")
	pipe.free()

func _test_first_slice_prop_manifest_assets_exist_and_story_props_are_inspectable() -> void:
	var file := FileAccess.open("res://data/maps/first_slice_prop_placements.json", FileAccess.READ)
	var manifest = JSON.parse_string(file.get_as_text())
	var TileAssetCatalog = load("res://scripts/field/tile_asset_catalog.gd")
	var tile_catalog = TileAssetCatalog.new()
	for map_id in manifest.maps.keys():
		for prop in manifest.maps[map_id].props:
			_assert(_prop_manifest_asset_exists(prop, tile_catalog), "%s/%s references an existing prop asset" % [map_id, prop.id])
			for child in prop.get("children", []):
				_assert(_prop_manifest_asset_exists(child, tile_catalog), "%s/%s/%s references an existing child prop asset" % [map_id, prop.id, child.id])
			if String(prop.get("category", "")) == "story":
				_assert(not String(prop.get("story_role", "")).is_empty(), "%s/%s story prop records story role" % [map_id, prop.id])
				_assert(not String(prop.get("inspect_text", "")).is_empty(), "%s/%s story prop records inspect text" % [map_id, prop.id])

func _test_first_slice_story_props_define_inspection_audio() -> void:
	var file := FileAccess.open("res://data/maps/first_slice_prop_placements.json", FileAccess.READ)
	var manifest = JSON.parse_string(file.get_as_text())
	var AudioEventCatalog = load("res://scripts/core/audio_event_catalog.gd")
	var audio_catalog = AudioEventCatalog.new()
	for map_id in manifest.maps.keys():
		for prop in manifest.maps[map_id].props:
			if String(prop.get("category", "")) != "story":
				continue
			var event_id := String(prop.get("inspect_audio", ""))
			_assert(not event_id.is_empty(), "%s/%s story prop defines inspect audio" % [map_id, prop.id])
			_assert(not audio_catalog.event(event_id).is_empty(), "%s/%s inspect audio event exists" % [map_id, prop.id])

func _test_first_slice_story_props_define_discovery_flags() -> void:
	var file := FileAccess.open("res://data/maps/first_slice_prop_placements.json", FileAccess.READ)
	var manifest = JSON.parse_string(file.get_as_text())
	for map_id in manifest.maps.keys():
		for prop in manifest.maps[map_id].props:
			if String(prop.get("category", "")) != "story":
				continue
			var flag_id := String(prop.get("discovery_flag", ""))
			_assert(flag_id.begins_with("discovered_prop_"), "%s/%s story prop defines stable discovery flag" % [map_id, prop.id])

func _test_evidence_progress_service_counts_first_slice_story_props() -> void:
	_assert(ResourceLoader.exists("res://scripts/core/evidence_progress_service.gd"), "evidence progress service exists")
	var EvidenceProgressService = load("res://scripts/core/evidence_progress_service.gd")
	var summary: Dictionary = EvidenceProgressService.new().first_slice_summary({})
	_assert(int(summary.total) == 16, "evidence progress counts all first-slice story props")
	_assert(int(summary.found) == 0, "empty flags find no evidence")
	_assert(String(summary.label) == "Evidence Found: 0 / 16", "evidence progress formats empty label")

func _test_evidence_progress_service_counts_discovered_story_props() -> void:
	var EvidenceProgressService = load("res://scripts/core/evidence_progress_service.gd")
	var summary: Dictionary = EvidenceProgressService.new().first_slice_summary({
		"discovered_prop_underchapel_museum_pipe": true,
		"discovered_prop_hospital_medical_chart": true,
		"discovered_prop_not_in_slice": true,
	})
	_assert(int(summary.total) == 16, "evidence progress keeps total stable when flags include unknowns")
	_assert(int(summary.found) == 2, "evidence progress counts discovered first-slice evidence only")
	_assert(String(summary.label) == "Evidence Found: 2 / 16", "evidence progress formats discovered label")

func _test_evidence_progress_service_returns_map_breakdown() -> void:
	var EvidenceProgressService = load("res://scripts/core/evidence_progress_service.gd")
	var summary: Dictionary = EvidenceProgressService.new().first_slice_summary({
		"discovered_prop_underchapel_museum_pipe": true,
		"discovered_prop_hospital_medical_chart": true,
	})
	var maps: Dictionary = summary.get("maps", {})
	_assert(int(maps.get("hallowmere_street", {}).get("total", 0)) == 3, "evidence progress counts Hallowmere story props")
	_assert(int(maps.get("underchapel_drain", {}).get("found", 0)) == 1, "evidence progress counts discovered Underchapel evidence")
	_assert(int(maps.get("hidden_hospital_corridor", {}).get("total", 0)) == 3, "evidence progress counts hospital story props")
	_assert(String(maps.get("hidden_hospital_corridor", {}).get("label", "")) == "Hidden Hospital Corridor: 1 / 3", "evidence progress formats map breakdown label")

func _test_evidence_progress_service_formats_missing_map_hint() -> void:
	var EvidenceProgressService = load("res://scripts/core/evidence_progress_service.gd")
	var summary: Dictionary = EvidenceProgressService.new().first_slice_summary({
		"discovered_prop_underchapel_museum_pipe": true,
		"discovered_prop_underchapel_pump_machine": true,
		"discovered_prop_underchapel_warning_panel": true,
		"discovered_prop_hospital_medical_chart": true,
	})
	_assert(String(summary.get("next_hint", "")) == "Evidence Remaining: Hallowmere Street, Mira Apothecary, Sainted Bell Chapel", "evidence progress lists earliest maps still missing evidence")

func _test_first_slice_prop_manifest_marks_key_navigation_props_blocking() -> void:
	var file := FileAccess.open("res://data/maps/first_slice_prop_placements.json", FileAccess.READ)
	var manifest = JSON.parse_string(file.get_as_text())
	var expected_blocking := {
		"hallowmere_street": ["House01", "House02", "CoffinStack", "TownWell"],
		"mira_apothecary": ["RestBed", "WorkTable"],
		"sainted_bell_chapel": ["ChapelBench", "StoneRail"],
		"underchapel_drain": ["DrainGrate", "ServiceLadder"],
		"hidden_hospital_corridor": ["HospitalDoor", "PatientBed"],
		"bell_tower_boss_room": ["BellRope", "AnchorDoor"],
	}
	for map_id in expected_blocking.keys():
		var props: Array = manifest.maps[map_id].props
		for prop_id in expected_blocking[map_id]:
			var prop := _dictionary_with_id(props, prop_id)
			_assert(prop.has("collision_rect"), "%s/%s has blocking collision rect" % [map_id, prop_id])

func _test_first_slice_blocking_props_do_not_cover_spawns_or_transitions() -> void:
	var file := FileAccess.open("res://data/maps/first_slice_prop_placements.json", FileAccess.READ)
	var manifest = JSON.parse_string(file.get_as_text())
	var MapCatalog = load("res://scripts/field/map_catalog.gd")
	var catalog = MapCatalog.new()
	for phase_id in [
		"plague_town_street",
		"apothecary_house",
		"chapel",
		"underchapel_drain",
		"hidden_hospital_corridor",
		"bell_tower_boss_room",
	]:
		var map = catalog.map_for_phase(phase_id)
		var prop_data = manifest.maps.get(map.id, {"props": []})
		for prop in prop_data.props:
			if not prop.has("collision_rect"):
				continue
			var collision_rect := _prop_collision_rect(prop)
			var spawn := _vector_from_map_point(map.get("spawn", {}))
			_assert(not collision_rect.has_point(spawn), "%s/%s blocking prop does not cover spawn" % [map.id, prop.id])
			for transition in map.get("transitions", []):
				var transition_rect := _rect_from_map_rect(transition.get("rect", {}))
				var center := transition_rect.position + transition_rect.size / 2.0
				_assert(not collision_rect.has_point(center), "%s/%s blocking prop does not cover transition %s" % [map.id, prop.id, transition.id])

func _test_first_slice_tile_asset_catalog_defines_runtime_tiles() -> void:
	_assert(ResourceLoader.exists("res://data/tilesets/first_slice_tile_assets.json"), "first slice tile asset manifest exists")
	_assert(ResourceLoader.exists("res://scripts/field/tile_asset_catalog.gd"), "tile asset catalog script exists")
	var TileAssetCatalog = load("res://scripts/field/tile_asset_catalog.gd")
	var catalog = TileAssetCatalog.new()
	var hallowmere = catalog.asset_for_map("hallowmere_street")
	_assert(hallowmere.id == "plague_town_ground", "Hallowmere maps to curated plague town tile art")
	_assert(String(hallowmere.runtime_path).begins_with("res://assets/tilesets/first_slice/"), "tile asset runtime path is curated under game assets")
	_assert(FileAccess.file_exists(hallowmere.runtime_path), "Hallowmere runtime tile art exists")
	var sewer = catalog.asset_for_map("underchapel_drain")
	_assert(sewer.id == "underchapel_sewer_tiles", "Underchapel uses curated sewer tile art")
	_assert(FileAccess.file_exists(sewer.runtime_path), "Underchapel runtime tile art exists")
	var hospital = catalog.asset_for_map("hidden_hospital_corridor")
	_assert(hospital.id == "hidden_hospital_lab_tiles", "Hidden hospital uses curated lab tile art")
	_assert(FileAccess.file_exists(hospital.runtime_path), "Hidden hospital runtime tile art exists")
	_assert(catalog.asset_for_map("missing_map").is_empty(), "missing map has no tile asset")

func _test_prototype_field_renders_real_tile_art_layer() -> void:
	var FieldScene = load("res://scenes/field/prototype_field.tscn")
	var field_scene = FieldScene.instantiate()
	root.add_child(field_scene)
	field_scene.set("map_phase_id", "plague_town_street")
	field_scene.load_phase_map()
	var real_art = field_scene.get_node_or_null("MapContent/RealTileArt")
	_assert(real_art != null, "prototype field creates real tile art layer")
	_assert(real_art.get_child_count() > 0, "prototype field renders real tile art sprite")
	var sprite = real_art.get_child(0)
	_assert(sprite is Sprite2D, "real tile art renders as a Sprite2D")
	_assert(sprite.texture != null, "real tile art sprite has a texture")
	_assert(sprite.get_meta("source_map") == "hallowmere_street", "real tile art records source map metadata")
	field_scene.queue_free()

func _test_hallowmere_authored_map_scene_renders_curated_props() -> void:
	_assert(ResourceLoader.exists("res://scenes/field/maps/hallowmere_street_map.tscn"), "Hallowmere authored map scene exists")
	var MapScene = load("res://scenes/field/maps/hallowmere_street_map.tscn")
	var map_scene = MapScene.instantiate()
	root.add_child(map_scene)
	_assert(map_scene.get("map_id") == "hallowmere_street", "Hallowmere authored map exposes map id")
	_assert(map_scene.has_node("GroundTiles"), "Hallowmere authored map renders ground tile art")
	_assert(map_scene.has_node("Landmarks/House01"), "Hallowmere authored map places a house landmark")
	_assert(map_scene.has_node("Collision/Walls"), "Hallowmere authored map exposes collision root")
	_assert(map_scene.get_node("Collision/Walls").get_child_count() >= 4, "Hallowmere authored map creates wall collision bodies")
	_assert(map_scene.get_node("Landmarks/House01").get_meta("tile_asset_id") == "plague_town_house_01", "Hallowmere landmark records source tile asset")
	map_scene.queue_free()

func _test_hallowmere_authored_map_defines_story_landmarks() -> void:
	var MapScene = load("res://scenes/field/maps/hallowmere_street_map.tscn")
	var map_scene = MapScene.instantiate()
	root.add_child(map_scene)
	var expected_landmarks := {
		"TownWell": Vector2(176, 128),
		"TollStall": Vector2(320, 96),
		"ApothecaryDoor": Vector2(352, 96),
		"ChapelRoad": Vector2(416, 80),
	}
	for landmark_id in expected_landmarks.keys():
		_assert(map_scene.has_node("Landmarks/%s" % landmark_id), "Hallowmere authored map includes %s landmark" % landmark_id)
		var landmark = map_scene.get_node("Landmarks/%s" % landmark_id)
		_assert(landmark.position.distance_to(expected_landmarks[landmark_id]) <= 8.0, "%s aligns with map data position" % landmark_id)
	_assert(map_scene.has_node("Atmosphere/PlagueFog"), "Hallowmere authored map includes plague fog atmosphere")
	_assert(map_scene.get_node("Atmosphere/PlagueFog").get_child_count() >= 3, "Hallowmere plague fog has multiple patches")
	_assert(map_scene.has_node("Landmarks/GraveMarker"), "Hallowmere authored map includes visible grave marker")
	map_scene.queue_free()

func _test_hallowmere_promoted_props_manifest_defines_runtime_assets() -> void:
	_assert(FileAccess.file_exists("res://data/tilesets/hallowmere_promoted_props.json"), "Hallowmere promoted props manifest exists")
	var file := FileAccess.open("res://data/tilesets/hallowmere_promoted_props.json", FileAccess.READ)
	if file == null:
		return
	var manifest = JSON.parse_string(file.get_as_text())
	_assert(manifest.promotions.size() >= 4, "Hallowmere promotion manifest defines runtime props")
	for promotion in manifest.promotions:
		_assert(not String(promotion.runtime_name).is_empty(), "%s promotion has runtime name" % promotion.id)
		_assert(String(promotion.output_path).begins_with("res://assets/tilesets/first_slice/hallowmere/sliced/"), "%s promotion targets Hallowmere runtime sliced folder" % promotion.id)
		_assert(FileAccess.file_exists(String(promotion.output_path)), "%s promoted output exists" % promotion.id)
		_assert(FileAccess.file_exists(String(promotion.source_path)), "%s source cut sprite exists" % promotion.id)

func _test_hallowmere_authored_map_renders_sliced_props() -> void:
	var MapScene = load("res://scenes/field/maps/hallowmere_street_map.tscn")
	var map_scene = MapScene.instantiate()
	root.add_child(map_scene)
	var expected_props := {
		"Landmarks/TollStall/TollStallSprite": "toll_stall.png",
		"Landmarks/ChapelRoad/ChapelSignSprite": "chapel_sign.png",
		"Landmarks/CoffinStack": "coffin_stack.png",
		"Landmarks/RefusePile": "refuse_pile.png",
	}
	for node_path in expected_props.keys():
		_assert(map_scene.has_node(node_path), "Hallowmere renders sliced prop %s" % node_path)
		if not map_scene.has_node(node_path):
			continue
		var sprite = map_scene.get_node(node_path)
		_assert(sprite is Sprite2D, "%s is a Sprite2D" % node_path)
		_assert(sprite.texture != null, "%s has sliced prop texture" % node_path)
		_assert(String(sprite.get_meta("slice_path", "")).ends_with(expected_props[node_path]), "%s records promoted runtime slice path" % node_path)
	map_scene.queue_free()

func _test_apothecary_authored_map_defines_interior_story_landmarks() -> void:
	_assert(ResourceLoader.exists("res://scenes/field/maps/mira_apothecary_map.tscn"), "Mira apothecary authored map scene exists")
	var MapScene = load("res://scenes/field/maps/mira_apothecary_map.tscn")
	var map_scene = MapScene.instantiate()
	root.add_child(map_scene)
	_assert(map_scene.get("map_id") == "mira_apothecary", "Mira apothecary authored map exposes map id")
	_assert(map_scene.has_node("InteriorFloor"), "Mira apothecary renders interior floor")
	var expected_landmarks := {
		"MedicineShelf": Vector2(128, 64),
		"RestBed": Vector2(160, 96),
		"WorkTable": Vector2(96, 80),
		"ExitDoor": Vector2(32, 64),
	}
	for landmark_id in expected_landmarks.keys():
		_assert(map_scene.has_node("Landmarks/%s" % landmark_id), "Mira apothecary includes %s landmark" % landmark_id)
		var landmark = map_scene.get_node("Landmarks/%s" % landmark_id)
		_assert(landmark.position.distance_to(expected_landmarks[landmark_id]) <= 8.0, "%s aligns with apothecary map data" % landmark_id)
	_assert(map_scene.has_node("Atmosphere/HerbSmoke"), "Mira apothecary includes medicine-room atmosphere")
	_assert(map_scene.get_node("Collision/Walls").get_child_count() >= 4, "Mira apothecary creates wall collision bodies")
	map_scene.queue_free()

func _test_hospital_promoted_props_manifest_defines_runtime_assets() -> void:
	_assert(FileAccess.file_exists("res://data/tilesets/hospital_promoted_props.json"), "Hospital promoted props manifest exists")
	var file := FileAccess.open("res://data/tilesets/hospital_promoted_props.json", FileAccess.READ)
	if file == null:
		return
	var manifest = JSON.parse_string(file.get_as_text())
	_assert(manifest.promotions.size() >= 5, "Hospital promotion manifest defines runtime props")
	for promotion in manifest.promotions:
		_assert(not String(promotion.runtime_name).is_empty(), "%s promotion has runtime name" % promotion.id)
		_assert(String(promotion.output_path).begins_with("res://assets/tilesets/first_slice/hospital/sliced/"), "%s promotion targets hospital runtime sliced folder" % promotion.id)
		_assert(FileAccess.file_exists(String(promotion.output_path)), "%s promoted output exists" % promotion.id)
		_assert(FileAccess.file_exists(String(promotion.source_path)), "%s source cut sprite exists" % promotion.id)

func _test_hospital_authored_map_scene_renders_sliced_props() -> void:
	_assert(ResourceLoader.exists("res://scenes/field/maps/hidden_hospital_corridor_map.tscn"), "Hidden hospital authored map scene exists")
	var MapScene = load("res://scenes/field/maps/hidden_hospital_corridor_map.tscn")
	if MapScene == null:
		return
	var map_scene = MapScene.instantiate()
	root.add_child(map_scene)
	_assert(map_scene.get("map_id") == "hidden_hospital_corridor", "Hidden hospital authored map exposes map id")
	_assert(map_scene.has_node("CorridorFloor"), "Hidden hospital renders corridor floor")
	for node_path in [
		"Landmarks/HospitalDoor",
		"Landmarks/PatientBed",
		"Landmarks/MedicineCabinet",
		"Landmarks/MedicalChart",
		"Landmarks/OperatingLight",
	]:
		_assert(map_scene.has_node(node_path), "Hidden hospital renders %s" % node_path)
		if not map_scene.has_node(node_path):
			continue
		var sprite = map_scene.get_node(node_path)
		_assert(sprite is Sprite2D, "%s is a Sprite2D" % node_path)
		_assert(sprite.texture != null, "%s has sliced prop texture" % node_path)
		_assert(String(sprite.get_meta("slice_path", "")).begins_with("res://assets/tilesets/first_slice/hospital/sliced/"), "%s records hospital slice path" % node_path)
	_assert(map_scene.has_node("Atmosphere/LightFlicker"), "Hidden hospital includes flickering light atmosphere")
	_assert(map_scene.has_node("Collision/Walls"), "Hidden hospital exposes collision root")
	map_scene.queue_free()

func _test_chapel_promoted_props_manifest_defines_runtime_assets() -> void:
	_assert(FileAccess.file_exists("res://data/tilesets/chapel_promoted_props.json"), "Chapel promoted props manifest exists")
	var file := FileAccess.open("res://data/tilesets/chapel_promoted_props.json", FileAccess.READ)
	if file == null:
		return
	var manifest = JSON.parse_string(file.get_as_text())
	_assert(manifest.promotions.size() >= 5, "Chapel promotion manifest defines runtime props")
	for promotion in manifest.promotions:
		_assert(not String(promotion.runtime_name).is_empty(), "%s promotion has runtime name" % promotion.id)
		_assert(String(promotion.output_path).begins_with("res://assets/tilesets/first_slice/chapel/sliced/"), "%s promotion targets chapel runtime sliced folder" % promotion.id)
		_assert(FileAccess.file_exists(String(promotion.output_path)), "%s promoted output exists" % promotion.id)
		_assert(FileAccess.file_exists(String(promotion.source_path)), "%s source cut sprite exists" % promotion.id)

func _test_chapel_authored_map_scene_renders_sliced_props() -> void:
	_assert(ResourceLoader.exists("res://scenes/field/maps/sainted_bell_chapel_map.tscn"), "Sainted Bell chapel authored map scene exists")
	var MapScene = load("res://scenes/field/maps/sainted_bell_chapel_map.tscn")
	if MapScene == null:
		return
	var map_scene = MapScene.instantiate()
	root.add_child(map_scene)
	_assert(map_scene.get("map_id") == "sainted_bell_chapel", "Sainted Bell chapel authored map exposes map id")
	_assert(map_scene.has_node("ChapelFloor"), "Sainted Bell chapel renders chapel floor")
	for node_path in [
		"Landmarks/ChapelArch",
		"Landmarks/SaintStatue",
		"Landmarks/CellarDoor",
		"Landmarks/ChapelLantern",
		"Landmarks/ChapelBench",
	]:
		_assert(map_scene.has_node(node_path), "Sainted Bell chapel renders %s" % node_path)
		if not map_scene.has_node(node_path):
			continue
		var sprite = map_scene.get_node(node_path)
		_assert(sprite is Sprite2D, "%s is a Sprite2D" % node_path)
		_assert(sprite.texture != null, "%s has sliced prop texture" % node_path)
		_assert(String(sprite.get_meta("slice_path", "")).begins_with("res://assets/tilesets/first_slice/chapel/sliced/"), "%s records chapel slice path" % node_path)
	_assert(map_scene.has_node("Atmosphere/BellDust"), "Sainted Bell chapel includes bell dust atmosphere")
	_assert(map_scene.has_node("Collision/Walls"), "Sainted Bell chapel exposes collision root")
	map_scene.queue_free()

func _test_underchapel_promoted_props_manifest_defines_runtime_assets() -> void:
	_assert(FileAccess.file_exists("res://data/tilesets/underchapel_promoted_props.json"), "Underchapel promoted props manifest exists")
	var file := FileAccess.open("res://data/tilesets/underchapel_promoted_props.json", FileAccess.READ)
	if file == null:
		return
	var manifest = JSON.parse_string(file.get_as_text())
	_assert(manifest.promotions.size() >= 5, "Underchapel promotion manifest defines runtime props")
	for promotion in manifest.promotions:
		_assert(not String(promotion.runtime_name).is_empty(), "%s promotion has runtime name" % promotion.id)
		_assert(String(promotion.output_path).begins_with("res://assets/tilesets/first_slice/underchapel/sliced/"), "%s promotion targets underchapel runtime sliced folder" % promotion.id)
		_assert(FileAccess.file_exists(String(promotion.output_path)), "%s promoted output exists" % promotion.id)
		_assert(FileAccess.file_exists(String(promotion.source_path)), "%s source cut sprite exists" % promotion.id)

func _test_underchapel_authored_map_scene_renders_sliced_props() -> void:
	_assert(ResourceLoader.exists("res://scenes/field/maps/underchapel_drain_map.tscn"), "Underchapel authored map scene exists")
	var MapScene = load("res://scenes/field/maps/underchapel_drain_map.tscn")
	if MapScene == null:
		return
	var map_scene = MapScene.instantiate()
	root.add_child(map_scene)
	_assert(map_scene.get("map_id") == "underchapel_drain", "Underchapel authored map exposes map id")
	_assert(map_scene.has_node("DrainFloor"), "Underchapel renders drain floor")
	for node_path in [
		"Landmarks/MuseumPipe",
		"Landmarks/PumpMachine",
		"Landmarks/DrainGrate",
		"Landmarks/ServiceLadder",
		"Landmarks/WarningPanel",
	]:
		_assert(map_scene.has_node(node_path), "Underchapel renders %s" % node_path)
		if not map_scene.has_node(node_path):
			continue
		var sprite = map_scene.get_node(node_path)
		_assert(sprite is Sprite2D, "%s is a Sprite2D" % node_path)
		_assert(sprite.texture != null, "%s has sliced prop texture" % node_path)
		_assert(String(sprite.get_meta("slice_path", "")).begins_with("res://assets/tilesets/first_slice/underchapel/sliced/"), "%s records underchapel slice path" % node_path)
	_assert(map_scene.has_node("Atmosphere/SewerMist"), "Underchapel includes sewer mist atmosphere")
	_assert(map_scene.has_node("Collision/Walls"), "Underchapel exposes collision root")
	map_scene.queue_free()

func _test_bell_tower_promoted_props_manifest_defines_runtime_assets() -> void:
	_assert(FileAccess.file_exists("res://data/tilesets/bell_tower_promoted_props.json"), "Bell tower promoted props manifest exists")
	var file := FileAccess.open("res://data/tilesets/bell_tower_promoted_props.json", FileAccess.READ)
	if file == null:
		return
	var manifest = JSON.parse_string(file.get_as_text())
	_assert(manifest.promotions.size() >= 5, "Bell tower promotion manifest defines runtime props")
	for promotion in manifest.promotions:
		_assert(not String(promotion.runtime_name).is_empty(), "%s promotion has runtime name" % promotion.id)
		_assert(String(promotion.output_path).begins_with("res://assets/tilesets/first_slice/bell_tower/sliced/"), "%s promotion targets bell tower runtime sliced folder" % promotion.id)
		_assert(FileAccess.file_exists(String(promotion.output_path)), "%s promoted output exists" % promotion.id)
		_assert(FileAccess.file_exists(String(promotion.source_path)), "%s source cut sprite exists" % promotion.id)

func _test_pixellab_promoted_assets_manifest_defines_runtime_assets() -> void:
	_assert(FileAccess.file_exists("res://data/generation/pixellab_promoted_assets.json"), "PixelLab promoted assets manifest exists")
	var file := FileAccess.open("res://data/generation/pixellab_promoted_assets.json", FileAccess.READ)
	if file == null:
		return
	var manifest = JSON.parse_string(file.get_as_text())
	_assert(manifest.promotions.size() >= 3, "PixelLab promotion manifest defines usable generated assets")
	for promotion in manifest.promotions:
		_assert(String(promotion.output_path).begins_with("res://assets/generated/pixellab/first_slice/"), "%s promotion targets generated runtime folder" % promotion.id)
		_assert(FileAccess.file_exists(String(promotion.output_path)), "%s promoted generated output exists" % promotion.id)
		_assert(FileAccess.file_exists(String(promotion.source_path)), "%s generated review source exists" % promotion.id)
		_assert(String(promotion.review_status) == "approved_candidate", "%s is explicitly approved for runtime candidate use" % promotion.id)

func _test_bell_tower_authored_map_scene_renders_sliced_props() -> void:
	_assert(ResourceLoader.exists("res://scenes/field/maps/bell_tower_boss_room_map.tscn"), "Bell tower authored map scene exists")
	var MapScene = load("res://scenes/field/maps/bell_tower_boss_room_map.tscn")
	if MapScene == null:
		return
	var map_scene = MapScene.instantiate()
	root.add_child(map_scene)
	_assert(map_scene.get("map_id") == "bell_tower_boss_room", "Bell tower authored map exposes map id")
	_assert(map_scene.has_node("BellTowerFloor"), "Bell tower renders boss room floor")
	for node_path in [
		"Landmarks/TowerStone",
		"Landmarks/BellSaintStatue",
		"Landmarks/BellRope",
		"Landmarks/PlagueBell",
		"Landmarks/AnchorDoor",
		"Landmarks/BloodMark",
	]:
		_assert(map_scene.has_node(node_path), "Bell tower renders %s" % node_path)
		if not map_scene.has_node(node_path):
			continue
		var sprite = map_scene.get_node(node_path)
		_assert(sprite is Sprite2D, "%s is a Sprite2D" % node_path)
		_assert(sprite.texture != null, "%s has sliced prop texture" % node_path)
		var slice_path := String(sprite.get_meta("slice_path", ""))
		_assert(slice_path.begins_with("res://assets/tilesets/first_slice/bell_tower/sliced/") or slice_path.begins_with("res://assets/generated/pixellab/first_slice/"), "%s records runtime sprite path" % node_path)
	_assert(map_scene.has_node("Atmosphere/JudgmentHaze"), "Bell tower includes judgment haze atmosphere")
	_assert(map_scene.has_node("Collision/Walls"), "Bell tower exposes collision root")
	map_scene.queue_free()

func _test_apothecary_sliced_props_exist_and_render() -> void:
	for path in [
		"res://assets/tilesets/first_slice/apothecary/sliced/medicine_shelf.png",
		"res://assets/tilesets/first_slice/apothecary/sliced/rest_bed.png",
		"res://assets/tilesets/first_slice/apothecary/sliced/work_table.png",
		"res://assets/tilesets/first_slice/apothecary/sliced/boiling_basin.png",
	]:
		_assert(FileAccess.file_exists(path), "%s sliced prop exists" % path)
	var MapScene = load("res://scenes/field/maps/mira_apothecary_map.tscn")
	var map_scene = MapScene.instantiate()
	root.add_child(map_scene)
	for landmark_id in ["MedicineShelf", "RestBed", "WorkTable", "BoilingBasin"]:
		var landmark = map_scene.get_node("Landmarks/%s" % landmark_id)
		_assert(landmark is Sprite2D, "%s renders as a sliced prop sprite" % landmark_id)
		_assert(landmark.texture != null, "%s has sliced prop texture" % landmark_id)
		_assert(String(landmark.get_meta("slice_path", "")).ends_with(".png"), "%s records sliced prop path" % landmark_id)
	map_scene.queue_free()

func _test_apothecary_slice_manifest_documents_exported_regions() -> void:
	_assert(ResourceLoader.exists("res://data/tilesets/apothecary_prop_slices.json"), "apothecary prop slice manifest exists")
	var file := FileAccess.open("res://data/tilesets/apothecary_prop_slices.json", FileAccess.READ)
	var manifest = JSON.parse_string(file.get_as_text())
	_assert(manifest.slices.size() >= 4, "apothecary slice manifest defines curated regions")
	for slice in manifest.slices:
		_assert(FileAccess.file_exists(String(slice.source_path)), "%s source sheet exists" % slice.id)
		_assert(FileAccess.file_exists(String(slice.output_path)), "%s exported slice exists" % slice.id)
		_assert(int(slice.rect.w) > 0 and int(slice.rect.h) > 0, "%s has positive crop size" % slice.id)
		_assert(String(slice.get("review_status", "")) == "needs_visual_review" or String(slice.get("review_status", "")) == "approved", "%s records visual review status" % slice.id)
		var image := Image.new()
		_assert(image.load(String(slice.output_path)) == OK, "%s output image loads" % slice.id)
		_assert(image.get_width() > 0 and image.get_height() > 0, "%s output has positive dimensions" % slice.id)

func _test_sprite_extractor_pipeline_exports_review_candidates() -> void:
	_assert(FileAccess.file_exists("res://tools/extract_sprites_from_sheet.py"), "sprite extractor CLI exists")
	for manifest_path in _local_extracted_asset_manifests():
		_assert(FileAccess.file_exists(manifest_path), "%s review manifest exists" % manifest_path)
		var file := FileAccess.open(manifest_path, FileAccess.READ)
		var manifest = JSON.parse_string(file.get_as_text())
		_assert(manifest.sprites.size() >= 8, "%s has extracted sprite candidates" % manifest_path)
		for sprite in manifest.sprites.slice(0, min(5, manifest.sprites.size())):
			_assert(FileAccess.file_exists(String(sprite.output_path)), "%s candidate file exists" % sprite.id)
			_assert(int(sprite.bounds.w) >= 10 and int(sprite.bounds.h) >= 10, "%s candidate has usable dimensions" % sprite.id)

func _test_sprite_extractor_contact_sheets_exist() -> void:
	_assert(FileAccess.file_exists("res://tools/build_sprite_contact_sheet.py"), "sprite contact sheet generator exists")
	for contact_sheet_path in _local_extracted_asset_contact_sheets():
		_assert(FileAccess.file_exists(contact_sheet_path), "%s contact sheet exists" % contact_sheet_path)
		var file := FileAccess.open(contact_sheet_path, FileAccess.READ)
		var html := file.get_as_text()
		_assert(html.contains("sprite_001"), "%s lists sprite ids" % contact_sheet_path)
		_assert(html.contains("<img"), "%s renders image previews" % contact_sheet_path)

func _test_cut_sprite_folder_contact_sheets_exist() -> void:
	_assert(FileAccess.file_exists("res://tools/build_folder_contact_sheet.py"), "cut sprite folder contact sheet generator exists")
	for contact_sheet_path in _local_cut_sprite_contact_sheets():
		_assert(FileAccess.file_exists(contact_sheet_path), "%s cut sprite contact sheet exists" % contact_sheet_path)
		var file := FileAccess.open(contact_sheet_path, FileAccess.READ)
		if file == null:
			continue
		var html := file.get_as_text()
		_assert(html.contains("Cut Sprite Contact Sheet"), "%s identifies folder contact sheet output" % contact_sheet_path)
		_assert(html.contains("<img"), "%s renders image previews" % contact_sheet_path)
		_assert(html.contains("data-source-path"), "%s records source sprite paths" % contact_sheet_path)

func _test_pixellab_generation_manifest_is_style_locked() -> void:
	_assert(FileAccess.file_exists("res://tools/pixellab_generate_assets.py"), "PixelLab generation tool exists")
	_assert(FileAccess.file_exists("res://data/generation/pixellab_first_slice_requests.json"), "PixelLab first-slice request manifest exists")
	var file := FileAccess.open("res://data/generation/pixellab_first_slice_requests.json", FileAccess.READ)
	if file == null:
		return
	var manifest = JSON.parse_string(file.get_as_text())
	_assert(manifest.has("processed_output_root"), "PixelLab manifest defines processed output root")
	_assert(manifest.shared.has("use_style_references"), "PixelLab manifest defines style reference mode")
	_assert(manifest.shared.has("palette_reference_paths"), "PixelLab manifest defines palette references")
	if not manifest.has("processed_output_root") or not manifest.shared.has("use_style_references") or not manifest.shared.has("palette_reference_paths"):
		return
	_assert(String(manifest.output_root).contains("Extracted Assets/generated/pixellab/first_slice"), "PixelLab outputs stay outside runtime assets")
	_assert(String(manifest.processed_output_root).contains("Extracted Assets/generated/pixellab/first_slice_processed"), "PixelLab processed outputs stay outside runtime assets")
	_assert(bool(manifest.shared.use_style_references) == false, "PixelLab generation defaults to no style references")
	_assert(manifest.shared.palette_reference_paths.size() >= 3, "PixelLab manifest defines palette references")
	for palette_reference_path in manifest.shared.palette_reference_paths:
		_assert(FileAccess.file_exists(String(palette_reference_path)), "PixelLab palette reference exists")
	_assert(manifest.requests.size() >= 5, "PixelLab manifest defines first missing asset batch")
	for request in manifest.requests:
		var image_size = request.get("image_size", manifest.shared.image_size)
		var no_background = request.get("no_background", manifest.shared.no_background)
		var style_description = String(request.get("style_description", manifest.shared.style_description))
		_assert(String(request.id).contains("_"), "%s request uses stable snake_case id" % request.id)
		_assert(String(request.output_name).ends_with(".png"), "%s request outputs png" % request.id)
		_assert(int(image_size.width) <= 200 and int(image_size.height) <= 200, "%s respects Bitforge size limit" % request.id)
		_assert(bool(no_background), "%s requests transparent background" % request.id)
		_assert(String(request.description).contains("The Last World Museum"), "%s prompt anchors project style" % request.id)
		_assert(style_description.contains("top-down JRPG"), "%s prompt describes top-down JRPG style" % request.id)

func _test_apothecary_promoted_props_manifest_defines_runtime_assets() -> void:
	_assert(FileAccess.file_exists("res://tools/promote_extracted_sprites.py"), "sprite promotion tool exists")
	_assert(FileAccess.file_exists("res://data/tilesets/apothecary_promoted_props.json"), "apothecary promoted props manifest exists")
	var file := FileAccess.open("res://data/tilesets/apothecary_promoted_props.json", FileAccess.READ)
	var manifest = JSON.parse_string(file.get_as_text())
	_assert(manifest.promotions.size() >= 4, "apothecary promotion manifest defines runtime props")
	for promotion in manifest.promotions:
		_assert(not String(promotion.runtime_name).is_empty(), "%s promotion has runtime name" % promotion.id)
		_assert(String(promotion.output_path).begins_with("res://assets/tilesets/first_slice/apothecary/sliced/"), "%s promotion targets runtime sliced folder" % promotion.id)
		_assert(FileAccess.file_exists(String(promotion.output_path)), "%s promoted output exists" % promotion.id)
		_assert(FileAccess.file_exists(String(promotion.source_path)), "%s source candidate exists" % promotion.id)
		_assert(not String(promotion.source_sprite_id).is_empty(), "%s records source sprite id" % promotion.id)

func _local_extracted_asset_contact_sheets() -> Array[String]:
	var workspace_root := ProjectSettings.globalize_path("res://").get_base_dir().get_base_dir()
	return [
		"%s/Extracted Assets/apothecary/furniture_fixtures/contact_sheet.html" % workspace_root,
		"%s/Extracted Assets/apothecary/jars_pots/contact_sheet.html" % workspace_root,
	]

func _local_cut_sprite_contact_sheets() -> Array[String]:
	var workspace_root := ProjectSettings.globalize_path("res://").get_base_dir().get_base_dir()
	return [
		"%s/Extracted Assets/contact_sheets/first_slice/plague_town.html" % workspace_root,
		"%s/Extracted Assets/contact_sheets/first_slice/abandoned_hospital.html" % workspace_root,
		"%s/Extracted Assets/contact_sheets/first_slice/medieval_dungeon.html" % workspace_root,
		"%s/Extracted Assets/contact_sheets/first_slice/medieval_town.html" % workspace_root,
		"%s/Extracted Assets/contact_sheets/first_slice/medieval_castle.html" % workspace_root,
		"%s/Extracted Assets/contact_sheets/first_slice/monster_pack_001_100.html" % workspace_root,
	]

func _local_extracted_asset_manifests() -> Array[String]:
	var workspace_root := ProjectSettings.globalize_path("res://").get_base_dir().get_base_dir()
	return [
		"%s/Extracted Assets/apothecary/furniture_fixtures/manifest.json" % workspace_root,
		"%s/Extracted Assets/apothecary/jars_pots/manifest.json" % workspace_root,
	]

func _test_prototype_field_mounts_authored_hallowmere_map() -> void:
	var FieldScene = load("res://scenes/field/prototype_field.tscn")
	var field_scene = FieldScene.instantiate()
	root.add_child(field_scene)
	field_scene.set("map_phase_id", "plague_town_street")
	field_scene.load_phase_map()
	var authored = field_scene.get_node_or_null("MapContent/AuthoredMap/HallowmereStreetMap")
	_assert(authored != null, "prototype field mounts authored Hallowmere map scene")
	_assert(authored.get("map_id") == "hallowmere_street", "mounted authored map matches current map")
	_assert(field_scene.has_node("MapContent/Graybox/Walls"), "prototype field keeps graybox walls while authored map is mounted")
	field_scene.queue_free()

func _test_prototype_field_mounts_authored_apothecary_map() -> void:
	var FieldScene = load("res://scenes/field/prototype_field.tscn")
	var field_scene = FieldScene.instantiate()
	root.add_child(field_scene)
	field_scene.set("map_phase_id", "apothecary_house")
	field_scene.max_unlocked_route_index = 3
	field_scene.load_phase_map()
	var authored = field_scene.get_node_or_null("MapContent/AuthoredMap/MiraApothecaryMap")
	_assert(authored != null, "prototype field mounts authored Mira apothecary map scene")
	_assert(authored.get("map_id") == "mira_apothecary", "mounted apothecary authored map matches current map")
	field_scene.queue_free()

func _test_prototype_field_mounts_authored_hospital_map() -> void:
	var FieldScene = load("res://scenes/field/prototype_field.tscn")
	var field_scene = FieldScene.instantiate()
	root.add_child(field_scene)
	field_scene.set("map_phase_id", "hidden_hospital_corridor")
	field_scene.max_unlocked_route_index = 6
	field_scene.load_phase_map()
	var authored = field_scene.get_node_or_null("MapContent/AuthoredMap/HiddenHospitalCorridorMap")
	_assert(authored != null, "prototype field mounts authored hidden hospital map scene")
	if authored != null:
		_assert(authored.get("map_id") == "hidden_hospital_corridor", "mounted authored hospital map matches current map")
	_assert(field_scene.has_node("MapContent/Graybox/Walls"), "prototype field keeps graybox walls while hospital map is mounted")
	field_scene.queue_free()

func _test_prototype_field_mounts_authored_chapel_map() -> void:
	var FieldScene = load("res://scenes/field/prototype_field.tscn")
	var field_scene = FieldScene.instantiate()
	root.add_child(field_scene)
	field_scene.set("map_phase_id", "chapel")
	field_scene.max_unlocked_route_index = 4
	field_scene.load_phase_map()
	var authored = field_scene.get_node_or_null("MapContent/AuthoredMap/SaintedBellChapelMap")
	_assert(authored != null, "prototype field mounts authored Sainted Bell chapel map scene")
	if authored != null:
		_assert(authored.get("map_id") == "sainted_bell_chapel", "mounted authored chapel map matches current map")
	_assert(field_scene.has_node("MapContent/Graybox/Walls"), "prototype field keeps graybox walls while chapel map is mounted")
	field_scene.queue_free()

func _test_prototype_field_mounts_authored_underchapel_map() -> void:
	var FieldScene = load("res://scenes/field/prototype_field.tscn")
	var field_scene = FieldScene.instantiate()
	root.add_child(field_scene)
	field_scene.set("map_phase_id", "underchapel_drain")
	field_scene.max_unlocked_route_index = 5
	field_scene.load_phase_map()
	var authored = field_scene.get_node_or_null("MapContent/AuthoredMap/UnderchapelDrainMap")
	_assert(authored != null, "prototype field mounts authored Underchapel map scene")
	if authored != null:
		_assert(authored.get("map_id") == "underchapel_drain", "mounted authored Underchapel map matches current map")
	_assert(field_scene.has_node("MapContent/Graybox/Walls"), "prototype field keeps graybox walls while Underchapel map is mounted")
	field_scene.queue_free()

func _test_prototype_field_mounts_authored_bell_tower_map() -> void:
	var FieldScene = load("res://scenes/field/prototype_field.tscn")
	var field_scene = FieldScene.instantiate()
	root.add_child(field_scene)
	field_scene.set("map_phase_id", "bell_tower_boss_room")
	field_scene.max_unlocked_route_index = 7
	field_scene.load_phase_map()
	var authored = field_scene.get_node_or_null("MapContent/AuthoredMap/BellTowerBossRoomMap")
	_assert(authored != null, "prototype field mounts authored Bell Tower boss room scene")
	if authored != null:
		_assert(authored.get("map_id") == "bell_tower_boss_room", "mounted authored Bell Tower map matches current map")
	_assert(field_scene.has_node("MapContent/Graybox/Walls"), "prototype field keeps graybox walls while Bell Tower map is mounted")
	field_scene.queue_free()

func _test_prototype_field_exposes_mounted_map_audio_profile() -> void:
	var FieldScene = load("res://scenes/field/prototype_field.tscn")
	var field_scene = FieldScene.instantiate()
	root.add_child(field_scene)
	field_scene.set("phase_metadata", {"id": "underchapel_drain", "display_name": "Underchapel Drain"})
	field_scene.set("map_phase_id", "underchapel_drain")
	field_scene.load_phase_map()
	_assert(field_scene.has_method("mounted_map_audio_profile"), "prototype field exposes mounted map audio profile")
	if field_scene.has_method("mounted_map_audio_profile"):
		var profile: Dictionary = field_scene.mounted_map_audio_profile()
		_assert(profile.get("map_id", "") == "underchapel_drain", "mounted audio profile comes from authored Underchapel map")
		_assert(profile.get("ambience", "") == "ambience_underchapel_drain", "mounted audio profile includes authored ambience")
		_assert(profile.get("museum_override", "") == "curator_warning", "mounted audio profile includes museum override")
	field_scene.queue_free()

func _test_prototype_field_creates_story_prop_interactions() -> void:
	var FieldScene = load("res://scenes/field/prototype_field.tscn")
	var field_scene = FieldScene.instantiate()
	root.add_child(field_scene)
	field_scene.set("map_phase_id", "hidden_hospital_corridor")
	field_scene.max_unlocked_route_index = 6
	field_scene.load_phase_map()
	var patient_bed = field_scene.get_node_or_null("MapContent/Interactables/InspectPatientBed")
	_assert(patient_bed != null, "prototype field creates inspect interaction for authored patient bed")
	if patient_bed != null:
		_assert(patient_bed.is_in_group("interactables"), "authored story prop inspect marker is interactable")
		var result: Dictionary = patient_bed.interact()
		_assert(result.kind == "story_prop", "authored story prop interaction keeps prop kind")
		_assert(String(result.status).begins_with("Inspect: "), "authored story prop interaction is presented as inspection text")
		_assert(String(result.status).contains("newer than Hallowmere"), "authored story prop interaction returns inspect text")
		_assert(result.audio_event == "plague_cough", "authored story prop interaction uses manifest audio")
	field_scene.queue_free()

func _test_prototype_field_story_prop_uses_manifest_inspection_audio() -> void:
	var FieldScene = load("res://scenes/field/prototype_field.tscn")
	var field_scene = FieldScene.instantiate()
	root.add_child(field_scene)
	field_scene.set("map_phase_id", "underchapel_drain")
	field_scene.max_unlocked_route_index = 5
	field_scene.load_phase_map()
	var museum_pipe = field_scene.get_node_or_null("MapContent/Interactables/InspectMuseumPipe")
	_assert(museum_pipe != null, "prototype field creates inspect interaction for museum pipe")
	if museum_pipe != null:
		var result: Dictionary = museum_pipe.interact()
		_assert(result.audio_event == "door_museum_open", "museum pipe inspection uses museum machinery cue")
	field_scene.queue_free()

func _test_prototype_field_story_prop_inspection_sets_discovery_flag() -> void:
	var FieldScene = load("res://scenes/field/prototype_field.tscn")
	var GameStateScript = load("res://scripts/core/game_state.gd")
	var game_state = GameStateScript.new()
	var field_scene = FieldScene.instantiate()
	field_scene.game_state_override = game_state
	root.add_child(field_scene)
	field_scene.set("map_phase_id", "underchapel_drain")
	field_scene.max_unlocked_route_index = 5
	field_scene.load_phase_map()
	var player = field_scene.get_node("%Player")
	player.position = Vector2(80, 72)
	player.facing = "right"
	_assert(field_scene.try_context_action(), "field can inspect museum pipe story prop")
	_assert(bool(game_state.flags.get("discovered_prop_underchapel_museum_pipe", false)), "story prop inspection stores discovery flag")
	_assert(game_state.flags.get("discovered_story_props", []).has("discovered_prop_underchapel_museum_pipe"), "story prop discovery is listed for later systems")
	field_scene.game_state_override = null
	field_scene.queue_free()
	game_state.free()

func _test_prototype_field_first_story_prop_discovery_adds_evidence_feedback() -> void:
	var FieldScene = load("res://scenes/field/prototype_field.tscn")
	var GameStateScript = load("res://scripts/core/game_state.gd")
	var game_state = GameStateScript.new()
	var field_scene = FieldScene.instantiate()
	field_scene.game_state_override = game_state
	root.add_child(field_scene)
	field_scene.set("map_phase_id", "underchapel_drain")
	field_scene.max_unlocked_route_index = 5
	field_scene.load_phase_map()
	var player = field_scene.get_node("%Player")
	player.position = Vector2(80, 72)
	player.facing = "right"
	_assert(field_scene.try_context_action(), "field can inspect museum pipe for evidence feedback")
	_assert(field_scene.get_node("%StatusLabel").text.contains("Evidence recovered."), "first story prop discovery tells player evidence was recovered")
	field_scene.game_state_override = null
	field_scene.queue_free()
	game_state.free()

func _test_prototype_field_repeat_story_prop_inspection_does_not_repeat_evidence_feedback() -> void:
	var FieldScene = load("res://scenes/field/prototype_field.tscn")
	var GameStateScript = load("res://scripts/core/game_state.gd")
	var game_state = GameStateScript.new()
	var field_scene = FieldScene.instantiate()
	field_scene.game_state_override = game_state
	root.add_child(field_scene)
	field_scene.set("map_phase_id", "underchapel_drain")
	field_scene.max_unlocked_route_index = 5
	field_scene.load_phase_map()
	var player = field_scene.get_node("%Player")
	player.position = Vector2(80, 72)
	player.facing = "right"
	_assert(field_scene.try_context_action(), "field can inspect museum pipe first time")
	_assert(field_scene.try_context_action(), "field can inspect museum pipe second time")
	_assert(not field_scene.get_node("%StatusLabel").text.contains("Evidence recovered."), "repeat story prop inspection does not replay evidence feedback")
	_assert(game_state.flags.get("discovered_story_props", []).count("discovered_prop_underchapel_museum_pipe") == 1, "repeat story prop inspection keeps one discovery list entry")
	field_scene.game_state_override = null
	field_scene.queue_free()
	game_state.free()

func _test_prototype_field_player_can_inspect_authored_story_prop() -> void:
	var FieldScene = load("res://scenes/field/prototype_field.tscn")
	var field_scene = FieldScene.instantiate()
	root.add_child(field_scene)
	field_scene.set("map_phase_id", "underchapel_drain")
	field_scene.max_unlocked_route_index = 5
	field_scene.load_phase_map()
	var player = field_scene.get_node("%Player")
	player.position = Vector2(80, 72)
	player.facing = "right"
	_assert(field_scene.try_context_action(), "prototype field lets player inspect authored story prop through normal interact")
	_assert(field_scene.get_node("%StatusLabel").text.contains("Inspect: "), "normal inspect interaction writes inspection status")
	_assert(field_scene.get_node("%StatusLabel").text.contains("pipe sweats"), "normal inspect interaction shows prop inspect text")
	field_scene.queue_free()

func _test_prototype_field_plays_authored_map_entry_audio() -> void:
	var FieldScene = load("res://scenes/field/prototype_field.tscn")
	var field_scene = FieldScene.instantiate()
	root.add_child(field_scene)
	field_scene.set("map_phase_id", "underchapel_drain")
	field_scene.max_unlocked_route_index = 5
	field_scene.load_phase_map()
	_assert(field_scene.get("last_map_ambience_audio_event") == "ambience_underchapel_drain", "prototype field records authored map ambience cue")
	_assert(field_scene.get("last_map_entry_audio_event") == "door_museum_open", "prototype field records authored map entry audio cue")
	field_scene.change_to_phase("hidden_hospital_corridor", Vector2(48, 96))
	_assert(field_scene.get("last_map_ambience_audio_event") == "ambience_hidden_hospital", "prototype field updates ambience cue after authored map change")
	_assert(field_scene.get("last_map_entry_audio_event") == "curator_warning", "prototype field updates entry audio cue after authored map change")
	field_scene.queue_free()

func _test_prototype_field_changes_maps_when_player_enters_transition() -> void:
	var FieldScene = load("res://scenes/field/prototype_field.tscn")
	var field_scene = FieldScene.instantiate()
	root.add_child(field_scene)
	field_scene.set("map_phase_id", "plague_town_street")
	field_scene.load_phase_map()
	field_scene.get_node("%Player").position = Vector2(360, 88)
	_assert(field_scene.check_player_transition(), "prototype field detects player standing in transition")
	_assert(field_scene.current_map.id == "mira_apothecary", "prototype field loads target map after transition")
	_assert(field_scene.map_phase_id == "apothecary_house", "prototype field tracks target phase after transition")
	_assert(field_scene.get_node("%Player").position == Vector2(48, 64), "prototype field uses transition spawn after map change")
	_assert(field_scene.get_node("%PhaseLabel").text.contains("Mira's Apothecary"), "prototype field updates phase label after transition")
	_assert(not field_scene.get_node("%StatusLabel").text.is_empty(), "prototype field reports transition or story status")
	field_scene.queue_free()

func _test_prototype_field_blocks_out_of_order_slice_transitions() -> void:
	var FieldScene = load("res://scenes/field/prototype_field.tscn")
	var field_scene = FieldScene.instantiate()
	root.add_child(field_scene)
	field_scene.set("map_phase_id", "plague_town_street")
	field_scene.load_phase_map()
	field_scene.get_node("%Player").position = Vector2(424, 56)
	_assert(not field_scene.check_player_transition(), "prototype field blocks chapel before apothecary")
	_assert(field_scene.current_map.id == "hallowmere_street", "blocked transition keeps current map")
	_assert(field_scene.get_node("%StatusLabel").text.contains("Speak with the apothecary"), "blocked transition explains required next step")
	field_scene.get_node("%Player").position = Vector2(360, 88)
	_assert(field_scene.check_player_transition(), "prototype field still allows next route step")
	field_scene.get_node("%Player").position = Vector2(32, 56)
	_assert(field_scene.check_player_transition(), "prototype field allows returning to an earlier route map")
	field_scene.get_node("%Player").position = Vector2(424, 56)
	_assert(field_scene.check_player_transition(), "prototype field unlocks chapel after apothecary route step")
	_assert(field_scene.current_map.id == "sainted_bell_chapel", "prototype field reaches chapel after route unlock")
	field_scene.queue_free()

func _test_field_story_trigger_catalog_maps_route_events() -> void:
	_assert(ResourceLoader.exists("res://scripts/field/field_story_trigger_catalog.gd"), "field story trigger catalog exists")
	_assert(ResourceLoader.exists("res://data/story/field_story_triggers.json"), "field story trigger data exists")
	var TriggerCatalog = load("res://scripts/field/field_story_trigger_catalog.gd")
	var catalog = TriggerCatalog.new()
	var apothecary = catalog.trigger_for_phase("apothecary_house")
	_assert(apothecary.id == "apothecary_first_meeting", "apothecary phase maps to first meeting trigger")
	_assert(apothecary.dialogue_section == "plague_wing", "apothecary trigger points at plague dialogue")
	_assert(apothecary.dialogue_scene == "apothecary_first_meeting", "apothecary trigger points at Mira meeting scene")
	_assert(catalog.trigger_for_phase("missing_phase").is_empty(), "missing phase has no field trigger")

func _test_prototype_field_runs_entry_story_trigger_once() -> void:
	var FieldScene = load("res://scenes/field/prototype_field.tscn")
	var field_scene = FieldScene.instantiate()
	root.add_child(field_scene)
	field_scene.set("map_phase_id", "plague_town_street")
	field_scene.load_phase_map()
	field_scene.change_to_phase("apothecary_house", Vector2(48, 64))
	_assert(field_scene.get_node("%StatusLabel").text.contains("ACOLYTE: The Warden has forbidden treatment"), "field scene shows entry story trigger dialogue")
	_assert(field_scene.triggered_story_events.has("apothecary_first_meeting"), "field scene records triggered story event")
	field_scene.change_to_phase("plague_town_street", Vector2(352, 96))
	field_scene.change_to_phase("apothecary_house", Vector2(48, 64))
	_assert(field_scene.get_node("%StatusLabel").text == "Entered Mira's Apothecary.", "field scene does not repeat one-shot trigger")
	field_scene.queue_free()

func _test_prototype_field_entry_trigger_recruits_mira() -> void:
	var FieldScene = load("res://scenes/field/prototype_field.tscn")
	var GameStateScript = load("res://scripts/core/game_state.gd")
	var game_state = GameStateScript.new()
	var party: Array[Dictionary] = [{"id": "lead", "name": "Sev", "class_id": "vanguard", "level": 1, "xp": 0, "stats": {"max_hp": 120}}]
	game_state.party = party
	var field_scene = FieldScene.instantiate()
	field_scene.game_state_override = game_state
	root.add_child(field_scene)
	field_scene.set("map_phase_id", "apothecary_house")
	field_scene.load_phase_map()
	field_scene.change_to_phase("chapel", Vector2(48, 64))
	_assert(game_state.party.any(func(member): return member.id == "mira_venn"), "mira_joins field trigger recruits Mira before dungeon")
	_assert(game_state.flags.get("mira_venn_recruited", false), "mira_joins field trigger records recruitment flag")
	field_scene.change_to_phase("apothecary_house", Vector2(48, 64))
	field_scene.change_to_phase("chapel", Vector2(48, 64))
	_assert(game_state.party.filter(func(member): return member.id == "mira_venn").size() == 1, "mira_joins field trigger does not duplicate Mira")
	field_scene.queue_free()
	game_state.free()

func _test_prototype_field_queues_and_advances_entry_dialogue() -> void:
	var FieldScene = load("res://scenes/field/prototype_field.tscn")
	var field_scene = FieldScene.instantiate()
	root.add_child(field_scene)
	field_scene.set("map_phase_id", "plague_town_street")
	field_scene.load_phase_map()
	field_scene.change_to_phase("apothecary_house", Vector2(48, 64))
	_assert(field_scene.is_dialogue_active(), "field scene starts dialogue sequence on entry trigger")
	_assert(field_scene.current_dialogue_line().speaker == "ACOLYTE", "field scene exposes first dialogue speaker")
	_assert(field_scene.current_dialogue_line().text.contains("forbidden treatment"), "field scene exposes first dialogue text")
	_assert(field_scene.advance_dialogue(), "field scene advances active dialogue")
	_assert(field_scene.current_dialogue_line().speaker == "MIRA", "field scene advances to next speaker")
	_assert(field_scene.current_dialogue_line().text.contains("rain"), "field scene advances to next line text")
	while field_scene.advance_dialogue():
		pass
	_assert(not field_scene.is_dialogue_active(), "field scene ends dialogue after final line")
	_assert(field_scene.get_node("%StatusLabel").text == "MIRA: Depends who is asking.", "field scene leaves final dialogue line visible")
	field_scene.queue_free()

func _test_prototype_field_renders_entry_dialogue_in_dialogue_box() -> void:
	var FieldScene = load("res://scenes/field/prototype_field.tscn")
	var field_scene = FieldScene.instantiate()
	root.add_child(field_scene)
	field_scene.set("map_phase_id", "plague_town_street")
	field_scene.load_phase_map()
	field_scene.change_to_phase("apothecary_house", Vector2(48, 64))
	_assert(field_scene.has_node("DialogueLayer/DialogueBox"), "field scene creates dialogue box UI")
	var dialogue_box = field_scene.get_node("DialogueLayer/DialogueBox")
	_assert(dialogue_box.visible, "dialogue box is visible during active dialogue")
	_assert(dialogue_box.get_node("%SpeakerLabel").text == "ACOLYTE", "dialogue box renders current speaker")
	_assert(dialogue_box.get_node("%LineLabel").text.contains("forbidden treatment"), "dialogue box renders current line")
	field_scene.advance_dialogue()
	_assert(dialogue_box.get_node("%SpeakerLabel").text == "MIRA", "dialogue box updates speaker after advance")
	_assert(dialogue_box.get_node("%LineLabel").text.contains("rain"), "dialogue box updates line after advance")
	while field_scene.advance_dialogue():
		pass
	_assert(not dialogue_box.visible, "dialogue box hides after dialogue sequence ends")
	field_scene.queue_free()

func _test_dialogue_box_renders_continue_prompt() -> void:
	var scene = load("res://scenes/dialogue/dialogue_box.tscn")
	var box = scene.instantiate()
	root.add_child(box)
	box.show_dialogue({"speaker": "MIRA", "lines": ["Fear is not an excuse to stand still."]}, {})
	_assert(box.has_node("%ContinuePrompt"), "dialogue box has a continue prompt")
	_assert(box.get_node("%ContinuePrompt").text.contains("Interact"), "dialogue prompt names the continue input")
	_assert(box.get_node("%ContinuePrompt").visible, "dialogue prompt is visible during dialogue")
	box.queue_free()

func _test_field_player_locks_movement_during_dialogue() -> void:
	var PlayerScript = load("res://scripts/field/field_player.gd")
	var player = PlayerScript.new()
	player.dialogue_locked = true
	Input.action_press("move_right")
	player._physics_process(0.016)
	Input.action_release("move_right")
	_assert(player.velocity == Vector2.ZERO, "field player does not move while dialogue locked")
	player.dialogue_locked = false
	Input.action_press("move_right")
	player._physics_process(0.016)
	Input.action_release("move_right")
	_assert(player.velocity.x > 0.0, "field player resumes movement when dialogue unlocks")
	player.queue_free()

func _test_first_slice_objective_catalog_tracks_route_goals() -> void:
	_assert(ResourceLoader.exists("res://data/story/first_slice_objectives.json"), "first slice objective data exists")
	_assert(ResourceLoader.exists("res://scripts/field/field_objective_catalog.gd"), "field objective catalog exists")
	var ObjectiveCatalog = load("res://scripts/field/field_objective_catalog.gd")
	var catalog = ObjectiveCatalog.new()
	_assert(catalog.objective_for_phase("plague_town_street").text == "Find a way into Hallowmere.", "town phase objective is defined")
	_assert(catalog.objective_for_phase("apothecary_house").text == "Speak with the apothecary.", "apothecary objective is defined")
	_assert(catalog.objective_for_phase("hidden_hospital_corridor").text == "Explore the white corridor beneath the town.", "hospital objective is defined")
	_assert(catalog.objective_for_phase("missing_phase").is_empty(), "missing objective returns empty dictionary")

func _test_prototype_field_renders_current_objective() -> void:
	var FieldScene = load("res://scenes/field/prototype_field.tscn")
	var field_scene = FieldScene.instantiate()
	root.add_child(field_scene)
	field_scene.set("map_phase_id", "plague_town_street")
	field_scene.load_phase_map()
	_assert(field_scene.has_node("%ObjectiveLabel"), "prototype field has objective label")
	_assert(field_scene.current_objective().text == "Find a way into Hallowmere.", "prototype field exposes current objective")
	_assert(field_scene.get_node("%ObjectiveLabel").text.contains("Find a way into Hallowmere."), "prototype field renders current objective")
	field_scene.change_to_phase("apothecary_house", Vector2(48, 64))
	_assert(field_scene.current_objective().text == "Speak with the apothecary.", "prototype field updates objective on transition")
	_assert(field_scene.get_node("%ObjectiveLabel").text.contains("Speak with the apothecary."), "objective label updates on transition")
	field_scene.queue_free()

func _test_prototype_field_exposes_bell_saint_battle_payload() -> void:
	var FieldScene = load("res://scenes/field/prototype_field.tscn")
	var field_scene = FieldScene.instantiate()
	root.add_child(field_scene)
	field_scene.set("map_phase_id", "bell_tower_boss_room")
	field_scene.load_phase_map()
	var payload = field_scene.battle_launch_payload()
	_assert(payload.enemy_id == "bell_saint", "boss room battle payload uses Bell Saint enemy id")
	_assert(payload.scene_path == "res://scenes/battle/prototype_battle.tscn", "boss room payload points to battle scene")
	_assert(payload.source_phase == "bell_tower_boss_room", "boss room payload includes source phase")
	_assert(payload.enemy.name == "The Bell Saint", "boss room payload resolves enemy database")
	_assert(payload.enemy.boss, "boss room payload keeps boss flag")
	_assert(payload.rewards.relic == "bell_clapper", "boss room payload exposes anchor relic reward")
	_assert(field_scene.get_node("%StatusLabel").text.to_upper().contains("BELL SAINT"), "boss room reports battle readiness")
	field_scene.queue_free()

func _test_prototype_field_emits_boss_battle_request() -> void:
	var FieldScene = load("res://scenes/field/prototype_field.tscn")
	var field_scene = FieldScene.instantiate()
	var emitted: Array = []
	field_scene.battle_launch_requested.connect(func(payload): emitted.append(payload))
	root.add_child(field_scene)
	field_scene.set("map_phase_id", "bell_tower_boss_room")
	field_scene.load_phase_map()
	_assert(field_scene.request_battle_launch(), "boss room accepts battle launch request")
	_assert(emitted.size() == 1, "boss room emits one battle launch payload")
	_assert(emitted[0].enemy_id == "bell_saint", "emitted battle payload targets Bell Saint")
	field_scene.queue_free()

func _test_prototype_field_interact_launches_boss_after_dialogue() -> void:
	var FieldScene = load("res://scenes/field/prototype_field.tscn")
	var field_scene = FieldScene.instantiate()
	var emitted: Array = []
	field_scene.battle_launch_requested.connect(func(payload): emitted.append(payload))
	root.add_child(field_scene)
	field_scene.set("map_phase_id", "bell_tower_boss_room")
	field_scene.load_phase_map()
	field_scene.try_context_action()
	_assert(emitted.is_empty(), "boss room does not launch while dialogue is active")
	while field_scene.advance_dialogue():
		pass
	_assert(not field_scene.is_dialogue_active(), "boss room dialogue can be completed")
	_assert(field_scene.try_context_action(), "boss room context action launches boss battle")
	_assert(emitted.size() == 1, "boss room context action emits battle payload")
	_assert(emitted[0].enemy_id == "bell_saint", "boss room context action launches Bell Saint")
	field_scene.queue_free()

func _test_prototype_field_completed_bell_saint_does_not_launch_again() -> void:
	var FieldScene = load("res://scenes/field/prototype_field.tscn")
	var GameStateScript = load("res://scripts/core/game_state.gd")
	var game_state = GameStateScript.new()
	game_state.flags["boss_bell_saint_defeated"] = true
	var field_scene = FieldScene.instantiate()
	field_scene.game_state_override = game_state
	var emitted: Array = []
	field_scene.battle_launch_requested.connect(func(payload): emitted.append(payload))
	root.add_child(field_scene)
	field_scene.set("map_phase_id", "bell_tower_boss_room")
	field_scene.load_phase_map()
	_assert(field_scene.battle_launch_payload().is_empty(), "completed Bell Saint room has no boss payload")
	_assert(not field_scene.request_battle_launch(), "completed Bell Saint room refuses battle launch")
	_assert(emitted.is_empty(), "completed Bell Saint room does not emit battle launch")
	var status_label = field_scene.get_node_or_null("%StatusLabel")
	_assert(status_label is Label and status_label.text.contains("Anchor recovered"), "completed Bell Saint room reports recovered anchor")
	field_scene.queue_free()
	game_state.free()

func _test_app_root_handles_field_battle_request() -> void:
	var AppRootScene = load("res://scenes/app/app_root.tscn")
	var GameStateScript = load("res://scripts/core/game_state.gd")
	var app = AppRootScene.instantiate()
	var game_state = GameStateScript.new()
	app.game_state_override = game_state
	root.add_child(app)
	var payload = {
		"scene_path": "res://scenes/battle/prototype_battle.tscn",
		"source_phase": "bell_tower_boss_room",
		"enemy_id": "bell_saint",
		"enemy": {"id": "bell_saint", "name": "The Bell Saint", "hp": 48, "max_hp": 48, "strength": 10, "defense": 3, "speed": 6, "xp": 150, "boss": true, "relic": "bell_clapper", "memory_card": "bell_saint", "next_flow": "truth_recovered"},
	}
	app._on_field_battle_launch_requested(payload)
	_assert(game_state.map_id == "battle", "app root switches GameState to battle")
	_assert(game_state.flags.pending_battle_payload.enemy_id == "bell_saint", "app root stores pending battle payload")
	_assert(app.story_flow.current_phase() == "battle", "app root moves story flow to battle phase")
	_assert(app.get_node("%SceneHost").get_child(0).name == "PrototypeBattle", "app root displays battle scene")
	app.queue_free()
	game_state.free()

func _test_app_root_returns_random_encounters_to_source_phase() -> void:
	var AppRootScene = load("res://scenes/app/app_root.tscn")
	var GameStateScript = load("res://scripts/core/game_state.gd")
	var app = AppRootScene.instantiate()
	var game_state = GameStateScript.new()
	app.game_state_override = game_state
	root.add_child(app)
	game_state.flags["pending_battle_payload"] = {
		"scene_path": "res://scenes/battle/prototype_battle.tscn",
		"source_phase": "underchapel_drain",
		"encounter_id": "fever_wretch_pair",
		"enemy_ids": ["fever_wretch", "fever_wretch"],
		"enemies": [
			{"id": "fever_wretch_a", "name": "Fever Wretch", "hp": 0, "max_hp": 42, "xp": 24},
			{"id": "fever_wretch_b", "name": "Fever Wretch", "hp": 0, "max_hp": 42, "xp": 24}
		]
	}
	app.story_flow.load_first_slice()
	app.story_flow.go_to_phase("battle")
	game_state.map_id = "battle"
	app._on_battle_completed({"xp": 48, "loot": {}, "relics": [], "memory_cards": [], "next_flow": ""})
	_assert(game_state.map_id == "underchapel_drain", "random encounter completion returns GameState to source phase")
	_assert(app.story_flow.current_phase() == "underchapel_drain", "random encounter completion returns story flow to source phase")
	_assert(not game_state.flags.has("pending_battle_payload"), "random encounter completion clears pending battle payload")
	app.queue_free()
	game_state.free()

func _test_app_root_restores_random_encounter_source_position() -> void:
	var AppRootScene = load("res://scenes/app/app_root.tscn")
	var GameStateScript = load("res://scripts/core/game_state.gd")
	var app = AppRootScene.instantiate()
	var game_state = GameStateScript.new()
	app.game_state_override = game_state
	root.add_child(app)
	game_state.flags["pending_battle_payload"] = {
		"scene_path": "res://scenes/battle/prototype_battle.tscn",
		"source_phase": "underchapel_drain",
		"source_position": Vector2(176, 92),
		"encounter_id": "fever_wretch_pair",
		"enemies": [{"id": "fever_wretch", "name": "Fever Wretch", "hp": 0, "max_hp": 42, "xp": 24}]
	}
	app.story_flow.load_first_slice()
	app.story_flow.go_to_phase("battle")
	game_state.map_id = "battle"
	game_state.player_position = Vector2.ZERO
	app._on_battle_completed({"xp": 24, "loot": {}, "relics": [], "memory_cards": [], "next_flow": ""})
	_assert(game_state.map_id == "underchapel_drain", "random encounter source position restore keeps source map")
	_assert(game_state.player_position == Vector2(176, 92), "random encounter completion restores source player position")
	app.queue_free()
	game_state.free()

func _test_battle_screen_emits_completion_payload() -> void:
	var BattleScene = load("res://scenes/battle/prototype_battle.tscn")
	var screen = BattleScene.instantiate()
	var emitted: Array = []
	screen.battle_completed.connect(func(payload): emitted.append(payload))
	root.add_child(screen)
	screen.battle.start_battle(
		[{"id": "lead", "name": "Sev", "class_id": "vanguard", "level": 1, "xp": 0, "stats": {"max_hp": 120, "strength": 18, "defense": 8, "speed": 10}}],
		[{"id": "bell_saint", "name": "The Bell Saint", "hp": 1, "max_hp": 48, "strength": 10, "defense": 3, "speed": 6, "xp": 150, "boss": true, "relic": "bell_clapper", "memory_card": "bell_saint", "next_flow": "truth_recovered"}]
	)
	screen.battle.enemies[0].hp = 1
	screen._on_attack_pressed()
	_assert(emitted.size() == 1, "battle screen emits completion once on victory")
	_assert(emitted[0].next_flow == "truth_recovered", "battle completion includes next story flow")
	_assert(emitted[0].relics == ["bell_clapper"], "battle completion includes Bell Clapper reward")
	_assert(emitted[0].memory_cards == ["bell_saint"], "battle completion includes Bell Saint memory card")
	screen.queue_free()

func _test_battle_screen_uses_cinematic_arena_camera() -> void:
	var BattleScene = load("res://scenes/battle/prototype_battle.tscn")
	var screen = BattleScene.instantiate()
	root.add_child(screen)
	_assert(screen is Node2D, "battle scene uses a world-space Node2D arena root")
	var camera = screen.get_node_or_null("ArenaCamera")
	var arena = screen.get_node_or_null("Arena")
	var party_anchor = screen.get_node_or_null("Arena/Battlers/PartyAnchor")
	var enemy_anchor = screen.get_node_or_null("Arena/Battlers/EnemyAnchor")
	var party_sprite = screen.get_node_or_null("Arena/Battlers/PartyAnchor/PartyBattler")
	var enemy_sprite = screen.get_node_or_null("Arena/Battlers/EnemyAnchor/EnemyBattler")
	var ui = screen.get_node_or_null("BattleUi")
	_assert(camera is Camera2D, "battle scene has a Camera2D")
	if camera is Camera2D:
		_assert(camera.enabled, "battle camera is enabled")
	_assert(arena is Node2D, "battle scene has world-space arena content")
	_assert(party_anchor is Marker2D, "battle arena has a party anchor")
	_assert(enemy_anchor is Marker2D, "battle arena has an enemy anchor")
	_assert(party_sprite is Sprite2D, "party battler is a world-space sprite")
	_assert(enemy_sprite is Sprite2D, "enemy battler is a world-space sprite")
	_assert(ui is CanvasLayer, "battle commands and status live on a separate UI overlay")
	screen.queue_free()

func _test_battle_screen_camera_focuses_battler_sides() -> void:
	var BattleScene = load("res://scenes/battle/prototype_battle.tscn")
	var screen = BattleScene.instantiate()
	root.add_child(screen)
	var camera = screen.get_node_or_null("ArenaCamera")
	_assert(camera is Camera2D, "battle scene exposes camera for presentation control")
	_assert(screen.has_method("focus_camera"), "battle screen exposes camera focus method")
	_assert(screen.has_method("queue_hit_shake"), "battle screen exposes hit shake method")
	if camera is Camera2D and screen.has_method("focus_camera"):
		screen.focus_camera("enemy")
		_assert(camera.position.x > 560.0, "enemy camera focus moves toward enemy side")
		_assert(camera.zoom.x > 1.0, "enemy camera focus pushes in")
		screen.focus_camera("party")
		_assert(camera.position.x < 460.0, "party camera focus moves toward party side")
		screen.focus_camera("wide")
		_assert(camera.position.distance_to(Vector2(512, 300)) < 2.0, "wide camera focus returns to arena center")
	if screen.has_method("queue_hit_shake"):
		screen.queue_hit_shake(10.0)
		_assert(float(screen.get("camera_shake_strength")) == 10.0, "hit shake stores requested shake strength")
	screen.queue_free()

func _test_battle_screen_plays_boss_intro_presentation() -> void:
	var BattleScene = load("res://scenes/battle/prototype_battle.tscn")
	var screen = BattleScene.instantiate()
	root.add_child(screen)
	screen.battle.start_battle(
		[{"id": "lead", "name": "Sev", "class_id": "vanguard", "level": 1, "xp": 0, "stats": {"max_hp": 120, "strength": 18, "defense": 8, "speed": 10}}],
		[{"id": "bell_saint", "name": "The Bell Saint", "hp": 48, "max_hp": 48, "strength": 10, "defense": 3, "speed": 6, "xp": 150, "boss": true, "sprite_path": "res://assets/generated/pixellab/first_slice/bell_saint_boss.png"}]
	)
	_assert(screen.has_method("play_boss_intro"), "battle screen exposes boss intro presentation")
	if screen.has_method("play_boss_intro"):
		screen.play_boss_intro()
		var camera = screen.get_node_or_null("ArenaCamera")
		var enemy_sprite = screen.get_node_or_null("Arena/Battlers/EnemyAnchor/EnemyBattler")
		_assert(String(screen.get("presentation_phase")) == "boss_intro", "boss intro records presentation phase")
		if camera is Camera2D:
			_assert(camera.position.x > 600.0, "boss intro frames enemy side")
			_assert(camera.zoom.x >= 1.3, "boss intro pushes camera in farther than normal focus")
		if enemy_sprite is Sprite2D:
			_assert(String(enemy_sprite.get_meta("presentation_state", "")) == "boss_intro", "boss intro marks enemy sprite")
	screen.queue_free()

func _test_battle_screen_plays_attack_lunge_and_hit_reaction() -> void:
	var BattleScene = load("res://scenes/battle/prototype_battle.tscn")
	var screen = BattleScene.instantiate()
	root.add_child(screen)
	screen.battle.start_battle(
		[{"id": "lead", "name": "Sev", "class_id": "vanguard", "level": 1, "xp": 0, "stats": {"max_hp": 120, "strength": 18, "defense": 8, "speed": 10}}],
		[{"id": "clean_man", "name": "Clean Man", "hp": 88, "max_hp": 88, "strength": 11, "defense": 6, "speed": 8, "xp": 55, "sprite_path": "res://assets/generated/pixellab/first_slice/clean_man_enemy.png"}]
	)
	screen._update_labels("Presentation check.")
	_assert(screen.has_method("play_party_attack_lunge"), "battle screen exposes attack lunge presentation")
	_assert(screen.has_method("mark_enemy_hit"), "battle screen exposes enemy hit presentation")
	if screen.has_method("play_party_attack_lunge") and screen.has_method("mark_enemy_hit"):
		var party_sprite = screen.get_node_or_null("Arena/Battlers/PartyAnchor/PartyBattler")
		var enemy_sprite = screen.get_node_or_null("Arena/Battlers/EnemyAnchor/EnemyBattler")
		var party_home: Vector2 = party_sprite.position if party_sprite is Sprite2D else Vector2.ZERO
		screen.play_party_attack_lunge()
		_assert(party_sprite is Sprite2D, "party attack lunge uses the world-space party sprite")
		if party_sprite is Sprite2D:
			_assert(party_sprite.position.x > party_home.x, "party lunge moves toward the enemy side")
			_assert(String(party_sprite.get_meta("presentation_state", "")) == "attack_lunge", "party lunge records presentation state")
			_assert(party_sprite.get_meta("home_position", Vector2.ZERO) == party_home, "party lunge preserves home position")
		screen.mark_enemy_hit()
		_assert(enemy_sprite is Sprite2D, "enemy hit reaction uses the world-space enemy sprite")
		if enemy_sprite is Sprite2D:
			_assert(String(enemy_sprite.get_meta("presentation_state", "")) == "hit_flash", "enemy hit reaction records presentation state")
			_assert(enemy_sprite.modulate.r > enemy_sprite.modulate.g, "enemy hit reaction warms enemy sprite color")
	screen.queue_free()

func _test_battle_screen_resets_battler_presentation() -> void:
	var BattleScene = load("res://scenes/battle/prototype_battle.tscn")
	var screen = BattleScene.instantiate()
	root.add_child(screen)
	screen.battle.start_battle(
		[{"id": "lead", "name": "Sev", "class_id": "vanguard", "level": 1, "xp": 0, "stats": {"max_hp": 120, "strength": 18, "defense": 8, "speed": 10}}],
		[{"id": "clean_man", "name": "Clean Man", "hp": 88, "max_hp": 88, "strength": 11, "defense": 6, "speed": 8, "xp": 55, "sprite_path": "res://assets/generated/pixellab/first_slice/clean_man_enemy.png"}]
	)
	screen._update_labels("Reset check.")
	_assert(screen.has_method("reset_battler_presentation"), "battle screen exposes presentation reset")
	if screen.has_method("play_party_attack_lunge") and screen.has_method("mark_enemy_hit") and screen.has_method("reset_battler_presentation"):
		var party_sprite = screen.get_node_or_null("Arena/Battlers/PartyAnchor/PartyBattler")
		var enemy_sprite = screen.get_node_or_null("Arena/Battlers/EnemyAnchor/EnemyBattler")
		var party_home: Vector2 = party_sprite.position if party_sprite is Sprite2D else Vector2.ZERO
		screen.play_party_attack_lunge()
		screen.mark_enemy_hit()
		screen.reset_battler_presentation()
		if party_sprite is Sprite2D:
			_assert(party_sprite.position == party_home, "presentation reset returns party battler home")
			_assert(String(party_sprite.get_meta("presentation_state", "")) == "idle", "presentation reset returns party state to idle")
		if enemy_sprite is Sprite2D:
			_assert(enemy_sprite.modulate == Color.WHITE, "presentation reset clears enemy hit flash")
			_assert(String(enemy_sprite.get_meta("presentation_state", "")) == "idle", "presentation reset returns enemy state to idle")
	screen.queue_free()

func _test_battle_screen_shows_damage_popup_and_locks_commands() -> void:
	var BattleScene = load("res://scenes/battle/prototype_battle.tscn")
	var screen = BattleScene.instantiate()
	root.add_child(screen)
	screen.battle.start_battle(
		[{"id": "lead", "name": "Sev", "class_id": "vanguard", "level": 1, "xp": 0, "stats": {"max_hp": 120, "strength": 18, "defense": 8, "speed": 10}}],
		[{"id": "clean_man", "name": "Clean Man", "hp": 88, "max_hp": 88, "strength": 11, "defense": 6, "speed": 8, "xp": 55, "sprite_path": "res://assets/generated/pixellab/first_slice/clean_man_enemy.png"}]
	)
	screen._update_labels("Damage check.")
	_assert(screen.has_method("show_damage_popup"), "battle screen exposes damage popup presentation")
	_assert(screen.has_method("set_commands_locked"), "battle screen exposes command lock presentation")
	if screen.has_method("show_damage_popup") and screen.has_method("set_commands_locked"):
		screen.set_commands_locked(true)
		var attack_button = screen.get_node_or_null("%AttackButton")
		var defend_button = screen.get_node_or_null("%DefendButton")
		var flee_button = screen.get_node_or_null("%FleeButton")
		_assert(bool(screen.get("commands_locked")), "battle screen records command lock")
		_assert(attack_button is Button and attack_button.disabled, "attack command disables while presentation is locked")
		_assert(defend_button is Button and defend_button.disabled, "defend command disables while presentation is locked")
		_assert(flee_button is Button and flee_button.disabled, "flee command disables while presentation is locked")
		screen.show_damage_popup(12)
		var popup = screen.get_node_or_null("Arena/Presentation/DamagePopup")
		_assert(popup is Label, "damage popup is a world-space label")
		if popup is Label:
			_assert(popup.text == "12", "damage popup shows damage amount")
			_assert(popup.position.distance_to(Vector2(724, 206)) < 64.0, "damage popup appears near enemy side")
			_assert(String(popup.get_meta("presentation_role", "")) == "damage_popup", "damage popup records presentation role")
		screen.set_commands_locked(false)
		_assert(not bool(screen.get("commands_locked")), "battle screen clears command lock")
		_assert(attack_button is Button and attack_button.disabled, "attack command stays disabled until ATB is ready")
	screen.queue_free()

func _test_battle_screen_completes_action_presentation_sequence() -> void:
	var BattleScene = load("res://scenes/battle/prototype_battle.tscn")
	var screen = BattleScene.instantiate()
	root.add_child(screen)
	screen.battle.start_battle(
		[{"id": "lead", "name": "Sev", "class_id": "vanguard", "level": 1, "xp": 0, "stats": {"max_hp": 120, "strength": 18, "defense": 8, "speed": 10}}],
		[{"id": "clean_man", "name": "Clean Man", "hp": 88, "max_hp": 88, "strength": 11, "defense": 6, "speed": 8, "xp": 55, "sprite_path": "res://assets/generated/pixellab/first_slice/clean_man_enemy.png"}]
	)
	screen._update_labels("Sequence check.")
	var party_sprite = screen.get_node_or_null("Arena/Battlers/PartyAnchor/PartyBattler")
	var party_home: Vector2 = party_sprite.position if party_sprite is Sprite2D else Vector2.ZERO
	_assert(screen.has_method("complete_action_presentation"), "battle screen exposes action presentation completion")
	screen._on_attack_pressed()
	_assert(bool(screen.get("commands_locked")), "attack keeps commands locked during presentation")
	_assert(String(screen.get("presentation_phase")) == "action", "attack records action presentation phase")
	if party_sprite is Sprite2D:
		_assert(party_sprite.position != party_home, "attack presentation leaves party in lunge until completion")
	if screen.has_method("complete_action_presentation"):
		screen.complete_action_presentation()
		_assert(bool(screen.get("commands_locked")), "presentation completion stays locked for enemy retaliation")
		_assert(String(screen.get("presentation_phase")) == "enemy_action", "presentation completion advances to enemy action")
		if party_sprite is Sprite2D:
			_assert(party_sprite.position == party_home, "presentation completion returns party battler home")
		var enemy_sprite = screen.get_node_or_null("Arena/Battlers/EnemyAnchor/EnemyBattler")
		if enemy_sprite is Sprite2D:
			_assert(String(enemy_sprite.get_meta("presentation_state", "")) == "enemy_lunge", "presentation completion stages enemy retaliation")
		if screen.has_method("complete_enemy_retaliation"):
			screen.complete_enemy_retaliation()
			_assert(not bool(screen.get("commands_locked")), "enemy retaliation completion unlocks commands")
			_assert(String(screen.get("presentation_phase")) == "idle", "enemy retaliation completion returns phase to idle")
	screen.queue_free()

func _test_battle_screen_starts_action_presentation_timer() -> void:
	var BattleScene = load("res://scenes/battle/prototype_battle.tscn")
	var screen = BattleScene.instantiate()
	root.add_child(screen)
	screen.battle.start_battle(
		[{"id": "lead", "name": "Sev", "class_id": "vanguard", "level": 1, "xp": 0, "stats": {"max_hp": 120, "strength": 18, "defense": 8, "speed": 10}}],
		[{"id": "clean_man", "name": "Clean Man", "hp": 88, "max_hp": 88, "strength": 11, "defense": 6, "speed": 8, "xp": 55, "sprite_path": "res://assets/generated/pixellab/first_slice/clean_man_enemy.png"}]
	)
	screen._update_labels("Timer check.")
	var timer = screen.get_node_or_null("ActionPresentationTimer")
	_assert(timer is Timer, "battle scene has an action presentation timer")
	if timer is Timer:
		_assert(timer.one_shot, "action presentation timer is one-shot")
		_assert(timer.wait_time > 0.1 and timer.wait_time < 1.5, "action presentation timer uses a short battle-presentation duration")
	screen._on_attack_pressed()
	if timer is Timer:
		_assert(bool(screen.get("action_presentation_timer_active")), "attack marks action presentation timer active")
	_assert(String(screen.get("presentation_phase")) == "action", "timer-backed attack enters action phase")
	if screen.has_method("_on_action_presentation_timer_timeout"):
		screen._on_action_presentation_timer_timeout()
		_assert(String(screen.get("presentation_phase")) == "enemy_action", "timer timeout advances to enemy action")
		_assert(bool(screen.get("commands_locked")), "timer timeout keeps commands locked during enemy action")
		if screen.has_method("complete_enemy_retaliation"):
			screen.complete_enemy_retaliation()
			_assert(String(screen.get("presentation_phase")) == "idle", "enemy action completion returns to idle")
			_assert(not bool(screen.get("commands_locked")), "enemy action completion unlocks commands")
	screen.queue_free()

func _test_battle_screen_presents_enemy_retaliation() -> void:
	var BattleScene = load("res://scenes/battle/prototype_battle.tscn")
	var screen = BattleScene.instantiate()
	root.add_child(screen)
	screen.battle.start_battle(
		[{"id": "lead", "name": "Sev", "class_id": "vanguard", "level": 1, "xp": 0, "hp": 120, "stats": {"max_hp": 120, "strength": 18, "defense": 8, "speed": 10}}],
		[{"id": "clean_man", "name": "Clean Man", "hp": 88, "max_hp": 88, "strength": 11, "defense": 6, "speed": 8, "xp": 55, "sprite_path": "res://assets/generated/pixellab/first_slice/clean_man_enemy.png"}]
	)
	screen._update_labels("Retaliation check.")
	_assert(screen.has_method("present_enemy_retaliation"), "battle screen exposes enemy retaliation presentation")
	if screen.has_method("present_enemy_retaliation"):
		var party_sprite = screen.get_node_or_null("Arena/Battlers/PartyAnchor/PartyBattler")
		var enemy_sprite = screen.get_node_or_null("Arena/Battlers/EnemyAnchor/EnemyBattler")
		var enemy_home: Vector2 = enemy_sprite.position if enemy_sprite is Sprite2D else Vector2.ZERO
		screen.present_enemy_retaliation()
		_assert(String(screen.get("presentation_phase")) == "enemy_action", "enemy retaliation enters enemy action phase")
		_assert(bool(screen.get("commands_locked")), "enemy retaliation keeps commands locked")
		_assert(int(screen.battle.party[0].hp) == 117, "enemy retaliation applies damage after defense")
		if enemy_sprite is Sprite2D:
			_assert(enemy_sprite.position.x < enemy_home.x, "enemy retaliation lunges toward party side")
			_assert(String(enemy_sprite.get_meta("presentation_state", "")) == "enemy_lunge", "enemy retaliation records enemy lunge state")
		if party_sprite is Sprite2D:
			_assert(String(party_sprite.get_meta("presentation_state", "")) == "hit_flash", "enemy retaliation marks party hit")
			_assert(party_sprite.modulate.r > party_sprite.modulate.g, "enemy retaliation warms party hit color")
		var popup = screen.get_node_or_null("Arena/Presentation/PartyDamagePopup")
		_assert(popup is Label, "enemy retaliation shows party-side damage popup")
		if popup is Label:
			_assert(popup.text == "3", "party-side damage popup shows damage amount")
	screen.queue_free()

func _test_battle_screen_retaliation_damages_ai_selected_party_target() -> void:
	var BattleScene = load("res://scenes/battle/prototype_battle.tscn")
	var screen = BattleScene.instantiate()
	root.add_child(screen)
	screen.battle.start_battle(
		[
			{"id": "lead", "name": "Sev", "class_id": "vanguard", "level": 1, "xp": 0, "hp": 0, "stats": {"max_hp": 120, "strength": 18, "defense": 8, "speed": 10}},
			{"id": "mira_venn", "name": "Mira Venn", "class_id": "plague_apothecary", "level": 1, "xp": 0, "hp": 92, "stats": {"max_hp": 92, "magic": 15, "defense": 5, "speed": 8}, "skills": ["clean_wound", "rot_needle"]},
		],
		[{"id": "clean_man", "name": "Clean Man", "hp": 88, "max_hp": 88, "strength": 11, "defense": 6, "speed": 8, "xp": 55, "ai_profile": "aggressive"}]
	)
	screen._update_labels("Retaliation target check.")
	screen.present_enemy_retaliation()
	_assert(screen.battle.party[0].hp == 0, "retaliation leaves already-KO Sev untouched")
	_assert(screen.battle.party[1].hp == 86, "retaliation damages AI-selected living target Mira")
	_assert(int(screen.get("active_party_index")) == 1, "retaliation status focuses the damaged living target")
	screen.queue_free()

func _test_battle_screen_retaliation_log_names_target() -> void:
	var BattleScene = load("res://scenes/battle/prototype_battle.tscn")
	var screen = BattleScene.instantiate()
	root.add_child(screen)
	screen.battle.start_battle(
		[
			{"id": "lead", "name": "Sev", "class_id": "vanguard", "level": 1, "xp": 0, "hp": 0, "stats": {"max_hp": 120, "strength": 18, "defense": 8, "speed": 10}},
			{"id": "mira_venn", "name": "Mira Venn", "class_id": "plague_apothecary", "level": 1, "xp": 0, "hp": 92, "stats": {"max_hp": 92, "magic": 15, "defense": 5, "speed": 8}},
		],
		[{"id": "clean_man", "name": "Clean Man", "hp": 88, "max_hp": 88, "strength": 11, "defense": 6, "speed": 8, "xp": 55, "ai_profile": "aggressive"}]
	)
	screen.present_enemy_retaliation()
	var log_label = screen.get_node_or_null("%LogLabel")
	_assert(log_label is Label and log_label.text.contains("Mira Venn"), "enemy retaliation log names the party member that was hit")
	screen.queue_free()

func _test_battle_screen_enemy_skill_damages_ai_selected_party_target() -> void:
	var BattleScene = load("res://scenes/battle/prototype_battle.tscn")
	var screen = BattleScene.instantiate()
	root.add_child(screen)
	screen.battle.start_battle(
		[
			{"id": "lead", "name": "Sev", "class_id": "vanguard", "level": 1, "xp": 0, "hp": 0, "stats": {"max_hp": 120, "strength": 18, "defense": 8, "speed": 10}},
			{"id": "mira_venn", "name": "Mira Venn", "class_id": "plague_apothecary", "level": 1, "xp": 0, "hp": 92, "stats": {"max_hp": 92, "magic": 15, "defense": 5, "speed": 8}, "skills": ["clean_wound", "rot_needle"]},
		],
		[{"id": "bell_saint", "name": "The Bell Saint", "hp": 48, "max_hp": 48, "strength": 10, "defense": 3, "speed": 6, "xp": 150, "boss": true, "ai_profile": "boss_bell_saint", "skills": ["rot_needle"]}]
	)
	screen._update_labels("Enemy skill target check.")
	screen.present_enemy_retaliation()
	_assert(screen.battle.party[0].hp == 0, "enemy skill leaves already-KO Sev untouched")
	_assert(screen.battle.party[1].hp < 92, "enemy skill damages AI-selected living target Mira")
	_assert(int(screen.get("active_party_index")) == 1, "enemy skill status focuses the damaged living target")
	screen.queue_free()

func _test_battle_screen_enemy_skill_log_names_target() -> void:
	var BattleScene = load("res://scenes/battle/prototype_battle.tscn")
	var screen = BattleScene.instantiate()
	root.add_child(screen)
	screen.battle.start_battle(
		[
			{"id": "lead", "name": "Sev", "class_id": "vanguard", "level": 1, "xp": 0, "hp": 0, "stats": {"max_hp": 120, "strength": 18, "defense": 8, "speed": 10}},
			{"id": "mira_venn", "name": "Mira Venn", "class_id": "plague_apothecary", "level": 1, "xp": 0, "hp": 92, "stats": {"max_hp": 92, "magic": 15, "defense": 5, "speed": 8}},
		],
		[{"id": "bell_saint", "name": "The Bell Saint", "hp": 48, "max_hp": 48, "strength": 10, "defense": 3, "speed": 6, "xp": 150, "boss": true, "ai_profile": "boss_bell_saint", "skills": ["rot_needle"]}]
	)
	screen.present_enemy_retaliation()
	var log_label = screen.get_node_or_null("%LogLabel")
	_assert(log_label is Label and log_label.text.contains("Mira Venn"), "enemy skill log names the party member that was hit")
	screen.queue_free()

func _test_battle_screen_starts_enemy_action_timer() -> void:
	var BattleScene = load("res://scenes/battle/prototype_battle.tscn")
	var screen = BattleScene.instantiate()
	root.add_child(screen)
	screen.battle.start_battle(
		[{"id": "lead", "name": "Sev", "class_id": "vanguard", "level": 1, "xp": 0, "hp": 120, "stats": {"max_hp": 120, "strength": 18, "defense": 8, "speed": 10}}],
		[{"id": "clean_man", "name": "Clean Man", "hp": 88, "max_hp": 88, "strength": 11, "defense": 6, "speed": 8, "xp": 55, "sprite_path": "res://assets/generated/pixellab/first_slice/clean_man_enemy.png"}]
	)
	screen._update_labels("Enemy timer check.")
	var timer = screen.get_node_or_null("EnemyActionTimer")
	_assert(timer is Timer, "battle scene has an enemy action timer")
	if timer is Timer:
		_assert(timer.one_shot, "enemy action timer is one-shot")
		_assert(timer.wait_time > 0.1 and timer.wait_time < 1.5, "enemy action timer uses a short presentation duration")
	screen.present_enemy_retaliation()
	_assert(screen.get("enemy_action_timer_active") == true, "enemy retaliation marks enemy action timer active")
	if screen.has_method("_on_enemy_action_timer_timeout"):
		screen._on_enemy_action_timer_timeout()
		_assert(screen.get("enemy_action_timer_active") == false, "enemy timer timeout clears active flag")
		_assert(String(screen.get("presentation_phase")) == "idle", "enemy timer timeout returns presentation to idle")
		_assert(not bool(screen.get("commands_locked")), "enemy timer timeout unlocks commands")
	screen.queue_free()

func _test_battle_screen_handles_party_defeat() -> void:
	var BattleScene = load("res://scenes/battle/prototype_battle.tscn")
	var screen = BattleScene.instantiate()
	root.add_child(screen)
	screen.battle.start_battle(
		[{"id": "lead", "name": "Sev", "class_id": "vanguard", "level": 1, "xp": 0, "hp": 2, "stats": {"max_hp": 120, "strength": 18, "defense": 1, "speed": 10}}],
		[{"id": "clean_man", "name": "Clean Man", "hp": 88, "max_hp": 88, "strength": 11, "defense": 6, "speed": 8, "xp": 55, "sprite_path": "res://assets/generated/pixellab/first_slice/clean_man_enemy.png"}]
	)
	screen._update_labels("Defeat check.")
	_assert(screen.has_method("is_party_defeated"), "battle screen exposes party defeat check")
	_assert(screen.has_method("present_party_defeat"), "battle screen exposes party defeat presentation")
	screen.present_enemy_retaliation()
	_assert(int(screen.battle.party[0].hp) == 0, "lethal retaliation clamps party HP to zero")
	if screen.has_method("is_party_defeated"):
		_assert(screen.is_party_defeated(), "party defeat check returns true at zero HP")
	_assert(String(screen.get("presentation_phase")) == "party_defeat", "party defeat sets defeat presentation phase")
	_assert(bool(screen.get("commands_locked")), "party defeat keeps commands locked")
	var party_sprite = screen.get_node_or_null("Arena/Battlers/PartyAnchor/PartyBattler")
	if party_sprite is Sprite2D:
		_assert(String(party_sprite.get_meta("presentation_state", "")) == "ko", "party defeat marks party battler KO")
		_assert(party_sprite.rotation_degrees > 20.0, "party defeat visually drops party battler")
	var log_label = screen.get_node_or_null("%LogLabel")
	if log_label is Label:
		_assert(log_label.text.contains("Docent unit offline"), "party defeat updates battle log")
	screen.queue_free()

func _test_battle_screen_handles_victory_presentation() -> void:
	var BattleScene = load("res://scenes/battle/prototype_battle.tscn")
	var screen = BattleScene.instantiate()
	var emitted: Array = []
	screen.battle_completed.connect(func(payload): emitted.append(payload))
	root.add_child(screen)
	screen.battle.start_battle(
		[{"id": "lead", "name": "Sev", "class_id": "vanguard", "level": 1, "xp": 0, "stats": {"max_hp": 120, "strength": 18, "defense": 8, "speed": 10}}],
		[{"id": "clean_man", "name": "Clean Man", "hp": 1, "max_hp": 88, "strength": 11, "defense": 6, "speed": 8, "xp": 55, "sprite_path": "res://assets/generated/pixellab/first_slice/clean_man_enemy.png"}]
	)
	screen._update_labels("Victory check.")
	_assert(screen.has_method("present_victory"), "battle screen exposes victory presentation")
	screen._on_attack_pressed()
	_assert(emitted.size() == 1, "victory still emits completion payload")
	_assert(String(screen.get("presentation_phase")) == "victory", "victory sets victory presentation phase")
	_assert(not bool(screen.get("commands_locked")), "victory unlocks commands before transition")
	var enemy_sprite = screen.get_node_or_null("Arena/Battlers/EnemyAnchor/EnemyBattler")
	if enemy_sprite is Sprite2D:
		_assert(String(enemy_sprite.get_meta("presentation_state", "")) == "defeated", "victory marks enemy defeated")
		_assert(enemy_sprite.visible == false, "victory hides defeated enemy sprite")
	screen.queue_free()

func _test_battle_screen_exposes_skill_and_item_commands() -> void:
	var BattleScene = load("res://scenes/battle/prototype_battle.tscn")
	var screen = BattleScene.instantiate()
	root.add_child(screen)
	screen.battle.start_battle(
		[{"id": "lead", "name": "Sev", "class_id": "spellblade", "level": 1, "xp": 0, "hp": 45, "stats": {"max_hp": 100, "strength": 12, "magic": 9, "defense": 5, "speed": 8}}],
		[{"id": "clean_man", "name": "Clean Man", "hp": 88, "max_hp": 88, "strength": 11, "defense": 6, "speed": 8, "xp": 55, "sprite_path": "res://assets/generated/pixellab/first_slice/clean_man_enemy.png"}]
	)
	screen._update_labels("Command check.")
	var skill_button = screen.get_node_or_null("%SkillButton")
	var item_button = screen.get_node_or_null("%ItemButton")
	_assert(skill_button is Button, "battle UI exposes Skill command")
	_assert(item_button is Button, "battle UI exposes Item command")
	_assert(screen.has_method("_on_skill_pressed"), "battle screen handles Skill command")
	_assert(screen.has_method("_on_item_pressed"), "battle screen handles Item command")
	if screen.has_method("_on_skill_pressed") and screen.has_method("select_skill"):
		screen._on_skill_pressed()
		var menu = screen.get_node_or_null("%SkillMenu")
		_assert(menu is VBoxContainer and menu.visible, "Skill command opens selectable skill menu")
		screen.select_skill("archive_strike")
		_assert(screen.battle.enemies[0].hp < 88, "Skill command damages enemy")
		_assert(String(screen.get("presentation_phase")) == "action", "Skill command enters action presentation")
		screen.complete_action_presentation()
		if screen.has_method("complete_enemy_retaliation"):
			screen.complete_enemy_retaliation()
	if screen.has_method("_on_item_pressed"):
		screen.battle.party[0].hp = 45
		screen.battle_inventory = {"clean_bandage": 1}
		screen._on_item_pressed()
		_assert(screen.battle.party[0].hp == 80, "Item command heals party with Clean Bandage")
		_assert(not screen.battle_inventory.has("clean_bandage"), "Item command consumes battle inventory")
		var popup = screen.get_node_or_null("Arena/Presentation/HealPopup")
		_assert(popup is Label, "Item command shows healing popup")
	screen.queue_free()

func _test_battle_screen_item_heals_most_wounded_living_party_member() -> void:
	var BattleScene = load("res://scenes/battle/prototype_battle.tscn")
	var screen = BattleScene.instantiate()
	root.add_child(screen)
	screen.battle_inventory = {"clean_bandage": 1}
	screen.battle.start_battle(
		[
			{"id": "lead", "name": "Sev", "class_id": "vanguard", "level": 1, "xp": 0, "hp": 120, "stats": {"max_hp": 120, "strength": 18, "defense": 8, "speed": 10}},
			{"id": "mira_venn", "name": "Mira Venn", "class_id": "plague_apothecary", "level": 1, "xp": 0, "hp": 40, "stats": {"max_hp": 92, "magic": 15, "defense": 5, "speed": 8}, "skills": ["clean_wound", "rot_needle"]},
		],
		[{"id": "clean_man", "name": "Clean Man", "hp": 88, "max_hp": 88, "strength": 11, "defense": 6, "speed": 8, "xp": 55}]
	)
	screen._on_item_pressed()
	_assert(screen.battle.party[0].hp == 120, "item use leaves full-health Sev unchanged")
	_assert(screen.battle.party[1].hp == 75, "item use heals most wounded living party member")
	_assert(int(screen.get("active_party_index")) == 1, "item use focuses healed party member")
	screen.queue_free()

func _test_battle_screen_disables_item_command_without_bandages() -> void:
	var BattleScene = load("res://scenes/battle/prototype_battle.tscn")
	var screen = BattleScene.instantiate()
	root.add_child(screen)
	screen.battle_inventory = {}
	screen.battle.start_battle(
		[{"id": "lead", "name": "Sev", "class_id": "vanguard", "level": 1, "xp": 0, "hp": 70, "stats": {"max_hp": 120, "strength": 18, "defense": 8, "speed": 10}}],
		[{"id": "clean_man", "name": "Clean Man", "hp": 88, "max_hp": 88, "strength": 11, "defense": 6, "speed": 8, "xp": 55}]
	)
	for combatant in screen.battle.clock.combatants:
		if combatant.id == "lead":
			combatant.atb = 100.0
			combatant.ready = true
	screen.refresh_command_state()
	var attack_button = screen.get_node_or_null("%AttackButton")
	var item_button = screen.get_node_or_null("%ItemButton")
	_assert(attack_button is Button and not attack_button.disabled, "attack remains available when actor is ready")
	_assert(item_button is Button and item_button.disabled, "item command disables when no Clean Bandage is available")
	screen.queue_free()

func _test_battle_screen_disables_item_command_after_last_bandage_used() -> void:
	var BattleScene = load("res://scenes/battle/prototype_battle.tscn")
	var screen = BattleScene.instantiate()
	root.add_child(screen)
	screen.battle_inventory = {"clean_bandage": 1}
	screen.battle.start_battle(
		[{"id": "lead", "name": "Sev", "class_id": "vanguard", "level": 1, "xp": 0, "hp": 70, "stats": {"max_hp": 120, "strength": 18, "defense": 8, "speed": 10}}],
		[{"id": "clean_man", "name": "Clean Man", "hp": 88, "max_hp": 88, "strength": 11, "defense": 6, "speed": 8, "xp": 55}]
	)
	screen._on_item_pressed()
	screen.complete_action_presentation()
	for combatant in screen.battle.clock.combatants:
		if combatant.id == "lead":
			combatant.atb = 100.0
			combatant.ready = true
	screen.refresh_command_state()
	var item_button = screen.get_node_or_null("%ItemButton")
	_assert(not screen.battle_inventory.has("clean_bandage"), "using the last Clean Bandage consumes it")
	_assert(item_button is Button and item_button.disabled, "item command disables after the last Clean Bandage is consumed")
	screen.queue_free()

func _test_battle_screen_tracks_command_readiness() -> void:
	var BattleScene = load("res://scenes/battle/prototype_battle.tscn")
	var screen = BattleScene.instantiate()
	root.add_child(screen)
	screen.battle.start_battle(
		[{"id": "lead", "name": "Sev", "class_id": "vanguard", "level": 1, "xp": 0, "stats": {"max_hp": 120, "strength": 18, "defense": 8, "speed": 20}}],
		[{"id": "clean_man", "name": "Clean Man", "hp": 88, "max_hp": 88, "strength": 11, "defense": 6, "speed": 8, "xp": 55, "sprite_path": "res://assets/generated/pixellab/first_slice/clean_man_enemy.png"}]
	)
	_assert(screen.has_method("is_lead_ready"), "battle screen exposes lead readiness check")
	_assert(screen.has_method("advance_battle_time"), "battle screen exposes ATB advance method")
	_assert(screen.has_method("refresh_command_state"), "battle screen exposes command-state refresh")
	if screen.has_method("is_lead_ready") and screen.has_method("advance_battle_time") and screen.has_method("refresh_command_state"):
		screen.refresh_command_state()
		var attack_button = screen.get_node_or_null("%AttackButton")
		_assert(not screen.is_lead_ready(), "lead starts without a ready command")
		_assert(attack_button is Button and attack_button.disabled, "commands are disabled until ATB is ready")
		screen.advance_battle_time(6.0)
		screen.refresh_command_state()
		_assert(screen.is_lead_ready(), "lead becomes ready after ATB advances")
		_assert(attack_button is Button and not attack_button.disabled, "commands enable when lead is ready")
	screen.queue_free()

func _test_battle_screen_command_state_skips_ko_active_member() -> void:
	var BattleScene = load("res://scenes/battle/prototype_battle.tscn")
	var screen = BattleScene.instantiate()
	root.add_child(screen)
	screen.battle.start_battle(
		[
			{"id": "lead", "name": "Sev", "class_id": "vanguard", "level": 1, "xp": 0, "hp": 0, "stats": {"max_hp": 120, "strength": 18, "defense": 8, "speed": 10}},
			{"id": "mira_venn", "name": "Mira Venn", "class_id": "plague_apothecary", "level": 1, "xp": 0, "hp": 92, "stats": {"max_hp": 92, "magic": 15, "defense": 5, "speed": 8}, "skills": ["clean_wound", "rot_needle"]},
		],
		[{"id": "clean_man", "name": "Clean Man", "hp": 88, "max_hp": 88, "strength": 11, "defense": 6, "speed": 8, "xp": 55}]
	)
	for combatant in screen.battle.clock.combatants:
		if combatant.id == "mira_venn":
			combatant.atb = 100.0
			combatant.ready = true
	screen.set("active_party_index", 0)
	screen.refresh_command_state()
	var attack_button = screen.get_node_or_null("%AttackButton")
	_assert(int(screen.get("active_party_index")) == 1, "command refresh advances from KO active member to living party member")
	_assert(screen.is_lead_ready(), "command readiness follows the living active party member")
	_assert(attack_button is Button and not attack_button.disabled, "commands enable for ready living party member")
	screen.queue_free()

func _test_battle_screen_advances_command_readiness_during_process() -> void:
	var BattleScene = load("res://scenes/battle/prototype_battle.tscn")
	var screen = BattleScene.instantiate()
	root.add_child(screen)
	screen.battle.start_battle(
		[{"id": "lead", "name": "Sev", "class_id": "vanguard", "level": 1, "xp": 0, "stats": {"max_hp": 120, "strength": 18, "defense": 8, "speed": 20}}],
		[{"id": "clean_man", "name": "Clean Man", "hp": 88, "max_hp": 88, "strength": 11, "defense": 6, "speed": 8, "xp": 55, "sprite_path": "res://assets/generated/pixellab/first_slice/clean_man_enemy.png"}]
	)
	screen._update_labels("Process readiness check.")
	screen.refresh_command_state()
	var attack_button = screen.get_node_or_null("%AttackButton")
	_assert(attack_button is Button and attack_button.disabled, "process test starts with commands disabled")
	screen._process(6.0)
	_assert(screen.is_lead_ready(), "battle screen process advances lead ATB")
	_assert(attack_button is Button and not attack_button.disabled, "battle screen process refreshes command buttons when ready")
	screen.queue_free()

func _test_battle_screen_opens_selectable_skill_menu() -> void:
	var BattleScene = load("res://scenes/battle/prototype_battle.tscn")
	var screen = BattleScene.instantiate()
	root.add_child(screen)
	screen.battle.start_battle(
		[{"id": "lead", "name": "Sev", "class_id": "spellblade", "level": 1, "xp": 0, "stats": {"max_hp": 100, "strength": 12, "magic": 9, "defense": 5, "speed": 20}, "skills": ["archive_strike", "clean_wound"]}],
		[{"id": "clean_man", "name": "Clean Man", "hp": 88, "max_hp": 88, "strength": 11, "defense": 6, "speed": 8, "xp": 55, "sprite_path": "res://assets/generated/pixellab/first_slice/clean_man_enemy.png"}]
	)
	_assert(screen.has_method("open_skill_menu"), "battle screen exposes skill menu opener")
	_assert(screen.has_method("select_skill"), "battle screen exposes skill selection")
	if screen.has_method("open_skill_menu") and screen.has_method("select_skill"):
		screen.open_skill_menu()
		var menu = screen.get_node_or_null("%SkillMenu")
		_assert(menu is VBoxContainer, "battle UI has selectable skill menu")
		if menu is VBoxContainer:
			_assert(menu.visible, "skill menu becomes visible")
			_assert(menu.get_child_count() >= 2, "skill menu creates one button per known skill")
			var first = menu.get_child(0)
			_assert(first is Button and first.text.contains("Archive Strike"), "skill menu renders skill display name")
		screen.select_skill("archive_strike")
		_assert(screen.battle.enemies[0].hp < 88, "selecting Archive Strike executes the selected skill")
	screen.queue_free()

func _test_battle_screen_records_animation_hooks() -> void:
	var BattleScene = load("res://scenes/battle/prototype_battle.tscn")
	var screen = BattleScene.instantiate()
	root.add_child(screen)
	screen.battle.start_battle(
		[{"id": "lead", "name": "Sev", "class_id": "spellblade", "level": 1, "xp": 0, "stats": {"max_hp": 100, "strength": 12, "magic": 9, "defense": 5, "speed": 20}, "animation_set": "sev_placeholder"}],
		[{"id": "clean_man", "name": "Clean Man", "hp": 88, "max_hp": 88, "strength": 11, "defense": 6, "speed": 8, "xp": 55, "sprite_path": "res://assets/generated/pixellab/first_slice/clean_man_enemy.png", "animation_set": "clean_man_generated"}]
	)
	_assert(screen.has_method("apply_battler_animation_hooks"), "battle screen exposes animation hook application")
	if screen.has_method("apply_battler_animation_hooks"):
		screen.apply_battler_animation_hooks()
		var party_sprite = screen.get_node_or_null("Arena/Battlers/PartyAnchor/PartyBattler")
		var enemy_sprite = screen.get_node_or_null("Arena/Battlers/EnemyAnchor/EnemyBattler")
		if party_sprite is Sprite2D:
			_assert(String(party_sprite.get_meta("animation_set", "")) == "sev_placeholder", "party battler records animation set")
			_assert(String(party_sprite.get_meta("animation_state", "")) == "idle", "party battler records idle animation state")
		if enemy_sprite is Sprite2D:
			_assert(String(enemy_sprite.get_meta("animation_set", "")) == "clean_man_generated", "enemy battler records animation set")
			_assert(String(enemy_sprite.get_meta("animation_state", "")) == "idle", "enemy battler records idle animation state")
	screen.queue_free()

func _test_battle_screen_updates_party_animation_set_for_active_member() -> void:
	var BattleScene = load("res://scenes/battle/prototype_battle.tscn")
	var screen = BattleScene.instantiate()
	root.add_child(screen)
	screen.battle.start_battle(
		[
			{"id": "lead", "name": "Sev", "class_id": "spellblade", "level": 1, "xp": 0, "stats": {"max_hp": 100, "strength": 12, "defense": 5, "speed": 20}, "animation_set": "sev_placeholder"},
			{"id": "mira_venn", "name": "Mira Venn", "class_id": "plague_apothecary", "level": 1, "xp": 0, "stats": {"max_hp": 92, "magic": 15, "defense": 5, "speed": 8}, "skills": ["clean_wound"], "animation_set": "mira_placeholder"},
		],
		[{"id": "clean_man", "name": "Clean Man", "hp": 88, "max_hp": 88, "strength": 11, "defense": 6, "speed": 8, "xp": 55, "animation_set": "clean_man_generated"}]
	)
	screen.apply_battler_animation_hooks()
	screen.select_party_member(1)
	var party_sprite = screen.get_node_or_null("Arena/Battlers/PartyAnchor/PartyBattler")
	_assert(party_sprite is Sprite2D and String(party_sprite.get_meta("animation_set", "")) == "mira_placeholder", "party battler uses active member animation set after roster selection")
	screen.queue_free()

func _test_battle_animation_assets_are_cataloged() -> void:
	_assert(FileAccess.file_exists("res://data/battle/animation_sets.json"), "battle animation set data exists")
	_assert(FileAccess.file_exists("res://assets/battle/animations/clean_man_generated/idle_01.png"), "Clean Man idle animation frame exists")
	_assert(FileAccess.file_exists("res://assets/battle/animations/bell_saint_generated/attack_03.png"), "Bell Saint attack animation frame exists")
	_assert(FileAccess.file_exists("res://assets/battle/animations/sev_placeholder/hurt_02.png"), "Sev placeholder hurt animation frame exists")
	var ContentCatalog = load("res://scripts/core/content_catalog.gd")
	var catalog = ContentCatalog.new()
	var clean_set = catalog.battle_animation_set("clean_man_generated")
	_assert(clean_set.get("states", {}).has("idle"), "content catalog loads Clean Man idle animation state")
	_assert(clean_set.states.idle.frames.size() == 4, "Clean Man idle animation has four frames")
	var BattleScene = load("res://scenes/battle/prototype_battle.tscn")
	var screen = BattleScene.instantiate()
	root.add_child(screen)
	screen.battle.start_battle(
		[{"id": "lead", "name": "Sev", "class_id": "spellblade", "level": 1, "xp": 0, "stats": {"max_hp": 100, "strength": 12, "magic": 9, "defense": 5, "speed": 20}, "animation_set": "sev_placeholder"}],
		[{"id": "clean_man", "name": "Clean Man", "hp": 88, "max_hp": 88, "strength": 11, "defense": 6, "speed": 8, "xp": 55, "animation_set": "clean_man_generated"}]
	)
	screen.apply_battler_animation_hooks()
	var enemy_sprite = screen.get_node_or_null("Arena/Battlers/EnemyAnchor/EnemyBattler")
	_assert(enemy_sprite is Sprite2D and enemy_sprite.texture != null, "battle screen applies cataloged enemy animation frame")
	if enemy_sprite is Sprite2D:
		screen.mark_enemy_hit()
		_assert(String(enemy_sprite.get_meta("animation_state", "")) == "hurt", "enemy hurt animation state is applied")
		_assert(enemy_sprite.texture != null, "enemy hurt animation frame is loaded")
	screen.queue_free()

func _test_combat_enemies_have_animation_sets() -> void:
	var file := FileAccess.open("res://data/combat/enemies.json", FileAccess.READ)
	_assert(file != null, "combat enemy data exists")
	if file == null:
		return
	var enemies = JSON.parse_string(file.get_as_text())
	_assert(enemies is Dictionary, "combat enemy data parses")
	if not enemies is Dictionary:
		return
	var ContentCatalog = load("res://scripts/core/content_catalog.gd")
	var catalog = ContentCatalog.new()
	for enemy_id in enemies.keys():
		var enemy: Dictionary = enemies[enemy_id]
		var animation_set_id := String(enemy.get("animation_set", ""))
		_assert(not animation_set_id.is_empty(), "%s has an animation set" % enemy_id)
		if not animation_set_id.is_empty():
			var animation_set = catalog.battle_animation_set(animation_set_id)
			_assert(not animation_set.is_empty(), "%s animation set is cataloged" % enemy_id)
			_assert(animation_set.get("states", {}).has("idle"), "%s animation set has idle frames" % enemy_id)
			_assert(animation_set.get("states", {}).has("attack"), "%s animation set has attack frames" % enemy_id)

func _test_battle_screen_renders_generated_enemy_sprite() -> void:
	_assert(FileAccess.file_exists("res://assets/generated/pixellab/first_slice/clean_man_enemy.png"), "Clean Man generated runtime sprite exists")
	_assert(FileAccess.file_exists("res://assets/generated/pixellab/first_slice/bell_saint_boss.png"), "Bell Saint generated runtime sprite exists")
	var file := FileAccess.open("res://data/combat/enemies.json", FileAccess.READ)
	var enemies = JSON.parse_string(file.get_as_text())
	_assert(String(enemies.clean_man.get("sprite_path", "")) == "res://assets/generated/pixellab/first_slice/clean_man_enemy.png", "Clean Man enemy data uses generated sprite")
	_assert(String(enemies.bell_saint.get("sprite_path", "")) == "res://assets/generated/pixellab/first_slice/bell_saint_boss.png", "Bell Saint enemy data uses generated sprite")
	var BattleScene = load("res://scenes/battle/prototype_battle.tscn")
	var screen = BattleScene.instantiate()
	root.add_child(screen)
	screen.battle.start_battle(
		[{"id": "lead", "name": "Sev", "class_id": "vanguard", "level": 1, "xp": 0, "stats": {"max_hp": 120, "strength": 18, "defense": 8, "speed": 10}}],
		[{"id": "bell_saint", "name": "The Bell Saint", "hp": 48, "max_hp": 48, "strength": 10, "defense": 3, "speed": 6, "xp": 150, "sprite_path": "res://assets/generated/pixellab/first_slice/bell_saint_boss.png"}]
	)
	screen._update_labels("Sprite check.")
	var enemy_sprite = screen.get_node_or_null("Arena/Battlers/EnemyAnchor/EnemyBattler")
	_assert(enemy_sprite is Sprite2D, "battle screen uses a world-space enemy sprite")
	if enemy_sprite is Sprite2D:
		_assert(enemy_sprite.texture != null, "battle screen loads generated enemy texture")
		_assert(String(enemy_sprite.get_meta("sprite_path", "")) == "res://assets/generated/pixellab/first_slice/bell_saint_boss.png", "battle screen records displayed enemy sprite path")
	screen.queue_free()

func _test_battle_screen_renders_and_targets_multiple_enemies() -> void:
	var BattleScene = load("res://scenes/battle/prototype_battle.tscn")
	var screen = BattleScene.instantiate()
	root.add_child(screen)
	screen.battle.start_battle(
		[{"id": "lead", "name": "Sev", "class_id": "spellblade", "level": 1, "xp": 0, "stats": {"max_hp": 100, "strength": 12, "magic": 9, "defense": 5, "speed": 20}, "skills": ["archive_strike"], "animation_set": "sev_placeholder"}],
		[
			{"id": "wretch", "name": "Fever Wretch", "hp": 42, "max_hp": 42, "strength": 7, "defense": 2, "speed": 7, "xp": 24, "animation_set": "plague_wretch"},
			{"id": "choir", "name": "Rot Choir", "hp": 64, "max_hp": 64, "strength": 6, "defense": 3, "speed": 5, "xp": 38, "animation_set": "rot_choir"}
		]
	)
	screen.apply_battler_animation_hooks()
	screen._update_labels("Multi target check.")
	_assert(screen.has_method("select_enemy_target"), "battle screen exposes enemy target selection")
	var enemy_anchor = screen.get_node_or_null("Arena/Battlers/EnemyAnchor")
	_assert(enemy_anchor is Marker2D, "battle screen has enemy anchor for enemy formation")
	if enemy_anchor is Marker2D:
		_assert(enemy_anchor.get_node_or_null("EnemyBattler") is Sprite2D, "first enemy uses primary enemy battler sprite")
		_assert(enemy_anchor.get_node_or_null("EnemyBattler_1") is Sprite2D, "second enemy gets a world-space battler sprite")
	if screen.has_method("select_enemy_target"):
		screen.select_enemy_target(1)
		screen.select_skill("archive_strike")
		_assert(screen.battle.enemies[0].hp == 42, "selected skill leaves non-target enemy HP unchanged")
		_assert(screen.battle.enemies[1].hp < 64, "selected skill damages selected enemy")
	screen.queue_free()

func _test_battle_screen_renders_target_buttons() -> void:
	var BattleScene = load("res://scenes/battle/prototype_battle.tscn")
	var screen = BattleScene.instantiate()
	root.add_child(screen)
	screen.battle.start_battle(
		[{"id": "lead", "name": "Sev", "class_id": "spellblade", "level": 1, "xp": 0, "stats": {"max_hp": 100, "strength": 12, "magic": 9, "defense": 5, "speed": 20}, "skills": ["archive_strike"], "animation_set": "sev_placeholder"}],
		[
			{"id": "wretch", "name": "Fever Wretch", "hp": 42, "max_hp": 42, "strength": 7, "defense": 2, "speed": 7, "xp": 24, "animation_set": "plague_wretch"},
			{"id": "choir", "name": "Rot Choir", "hp": 64, "max_hp": 64, "strength": 6, "defense": 3, "speed": 5, "xp": 38, "animation_set": "rot_choir"}
		]
	)
	screen._update_labels("Target UI check.")
	_assert(screen.has_method("render_target_menu"), "battle screen exposes target menu rendering")
	if screen.has_method("render_target_menu"):
		screen.render_target_menu()
	var target_menu = screen.get_node_or_null("%TargetMenu")
	_assert(target_menu is HBoxContainer, "battle UI has target menu container")
	if target_menu is HBoxContainer:
		_assert(target_menu.visible, "target menu becomes visible for enemy groups")
		_assert(target_menu.get_child_count() == 2, "target menu creates one button per enemy")
		var second = target_menu.get_child(1)
		_assert(second is Button and second.text.contains("Rot Choir"), "target button names the enemy")
		if second is Button:
			second.pressed.emit()
			var enemy_name = screen.get_node_or_null("%EnemyNameLabel")
			_assert(enemy_name is Label and enemy_name.text == "Rot Choir", "pressing target button selects that enemy")
	screen.queue_free()

func _test_battle_screen_attack_uses_selected_enemy() -> void:
	var BattleScene = load("res://scenes/battle/prototype_battle.tscn")
	var screen = BattleScene.instantiate()
	root.add_child(screen)
	screen.battle.start_battle(
		[{"id": "lead", "name": "Sev", "class_id": "vanguard", "level": 1, "xp": 0, "stats": {"max_hp": 100, "strength": 18, "defense": 5, "speed": 20}, "animation_set": "sev_placeholder"}],
		[
			{"id": "wretch", "name": "Fever Wretch", "hp": 42, "max_hp": 42, "strength": 7, "defense": 2, "speed": 7, "xp": 24, "animation_set": "plague_wretch"},
			{"id": "choir", "name": "Rot Choir", "hp": 64, "max_hp": 64, "strength": 6, "defense": 3, "speed": 5, "xp": 38, "animation_set": "rot_choir"}
		]
	)
	screen.apply_battler_animation_hooks()
	screen._update_labels("Attack target check.")
	screen.select_enemy_target(1)
	screen._on_attack_pressed()
	_assert(screen.battle.enemies[0].hp == 42, "basic attack leaves non-target enemy HP unchanged")
	_assert(screen.battle.enemies[1].hp < 64, "basic attack damages selected enemy")
	screen.queue_free()

func _test_battle_screen_auto_selects_living_enemy_after_defeat() -> void:
	var BattleScene = load("res://scenes/battle/prototype_battle.tscn")
	var screen = BattleScene.instantiate()
	root.add_child(screen)
	screen.battle.start_battle(
		[{"id": "lead", "name": "Sev", "class_id": "vanguard", "level": 1, "xp": 0, "stats": {"max_hp": 100, "strength": 18, "defense": 5, "speed": 20}, "animation_set": "sev_placeholder"}],
		[
			{"id": "wretch", "name": "Fever Wretch", "hp": 6, "max_hp": 42, "strength": 7, "defense": 2, "speed": 7, "xp": 24, "animation_set": "plague_wretch"},
			{"id": "choir", "name": "Rot Choir", "hp": 64, "max_hp": 64, "strength": 6, "defense": 3, "speed": 5, "xp": 38, "animation_set": "rot_choir"}
		]
	)
	screen.apply_battler_animation_hooks()
	screen._update_labels("Auto target check.")
	screen.render_target_menu()
	screen.select_enemy_target(0)
	screen._on_attack_pressed()
	_assert(screen.battle.enemies[0].hp == 0, "attack can defeat selected enemy")
	_assert(int(screen.get("selected_enemy_index")) == 1, "battle screen selects a living enemy after selected target is defeated")
	var enemy_name = screen.get_node_or_null("%EnemyNameLabel")
	_assert(enemy_name is Label and enemy_name.text == "Rot Choir", "enemy status panel follows auto-selected living target")
	var target_menu = screen.get_node_or_null("%TargetMenu")
	if target_menu is HBoxContainer and target_menu.get_child_count() >= 2:
		var defeated_button = target_menu.get_child(0)
		var living_button = target_menu.get_child(1)
		_assert(defeated_button is Button and defeated_button.disabled, "defeated target button is disabled")
		_assert(living_button is Button and living_button.button_pressed, "living target button becomes selected")
	screen.queue_free()

func _test_battle_screen_retaliation_uses_living_enemy() -> void:
	var BattleScene = load("res://scenes/battle/prototype_battle.tscn")
	var screen = BattleScene.instantiate()
	root.add_child(screen)
	screen.battle.start_battle(
		[{"id": "lead", "name": "Sev", "class_id": "vanguard", "level": 1, "xp": 0, "hp": 100, "stats": {"max_hp": 100, "strength": 18, "defense": 5, "speed": 20}, "animation_set": "sev_placeholder"}],
		[
			{"id": "wretch", "name": "Fever Wretch", "hp": 0, "max_hp": 42, "strength": 7, "defense": 2, "speed": 7, "xp": 24, "animation_set": "plague_wretch"},
			{"id": "choir", "name": "Rot Choir", "hp": 64, "max_hp": 64, "strength": 14, "defense": 3, "speed": 5, "xp": 38, "animation_set": "rot_choir"}
		]
	)
	screen.apply_battler_animation_hooks()
	screen._update_labels("Retaliation check.")
	screen.present_enemy_retaliation()
	_assert(screen.battle.party[0].hp == 91, "retaliation damage comes from the first living enemy")
	var log_label = screen.get_node_or_null("%LogLabel")
	_assert(log_label is Label and log_label.text.contains("Rot Choir retaliates"), "retaliation log names the living enemy")
	screen.queue_free()

func _test_battle_screen_uses_pending_group_payload() -> void:
	var GameStateScript = load("res://scripts/core/game_state.gd")
	var game_state = GameStateScript.new()
	game_state.name = "GameState"
	var party: Array[Dictionary] = [{"id": "lead", "name": "Sev", "class_id": "vanguard", "level": 1, "xp": 0, "stats": {"max_hp": 100, "strength": 18, "defense": 5, "speed": 20}, "animation_set": "sev_placeholder"}]
	game_state.party = party
	game_state.flags["pending_battle_payload"] = {
		"scene_path": "res://scenes/battle/prototype_battle.tscn",
		"encounter_id": "fever_wretch_pair",
		"enemy_ids": ["fever_wretch", "fever_wretch"],
		"enemies": [
			{"id": "fever_wretch_a", "name": "Fever Wretch", "hp": 42, "max_hp": 42, "strength": 7, "defense": 2, "speed": 7, "xp": 24, "animation_set": "plague_wretch"},
			{"id": "fever_wretch_b", "name": "Fever Wretch", "hp": 42, "max_hp": 42, "strength": 7, "defense": 2, "speed": 7, "xp": 24, "animation_set": "plague_wretch"}
		]
	}
	var BattleScene = load("res://scenes/battle/prototype_battle.tscn")
	var screen = BattleScene.instantiate()
	screen.game_state_override = game_state
	root.add_child(screen)
	screen._ready()
	_assert(screen.battle.enemies.size() == 2, "battle screen starts all enemies from pending group payload")
	_assert(screen.get_node_or_null("Arena/Battlers/EnemyAnchor/EnemyBattler_1") is Sprite2D, "pending group payload renders second enemy")
	screen.queue_free()
	game_state.free()

func _test_battle_screen_starts_with_recruited_mira_from_game_state() -> void:
	var GameStateScript = load("res://scripts/core/game_state.gd")
	var game_state = GameStateScript.new()
	var party: Array[Dictionary] = [
		{"id": "lead", "name": "Sev", "class_id": "vanguard", "level": 1, "xp": 0, "stats": {"max_hp": 120, "strength": 18, "defense": 8, "speed": 10}},
		{"id": "mira_venn", "name": "Mira Venn", "class_id": "plague_apothecary", "level": 1, "xp": 0, "stats": {"max_hp": 92, "max_mp": 38, "magic": 15, "defense": 5, "speed": 8}, "skills": ["clean_wound", "rot_needle"]},
	]
	game_state.party = party
	game_state.flags["pending_battle_payload"] = {
		"scene_path": "res://scenes/battle/prototype_battle.tscn",
		"enemy": {"id": "bell_saint", "name": "The Bell Saint", "hp": 48, "max_hp": 48, "strength": 10, "defense": 3, "speed": 6, "xp": 150, "boss": true, "animation_set": "bell_saint_generated"}
	}
	var BattleScene = load("res://scenes/battle/prototype_battle.tscn")
	var screen = BattleScene.instantiate()
	screen.game_state_override = game_state
	root.add_child(screen)
	screen._ready()
	_assert(screen.battle.party.size() == 2, "battle screen starts with recruited party members from GameState")
	_assert(screen.battle.party[1].id == "mira_venn", "Mira Venn is present in battle party")
	_assert(screen.battle.party[1].skills.has("clean_wound"), "Mira Venn keeps healer skills in battle")
	screen.queue_free()
	game_state.free()

func _test_battle_screen_marks_active_party_member_in_roster() -> void:
	var BattleScene = load("res://scenes/battle/prototype_battle.tscn")
	var screen = BattleScene.instantiate()
	root.add_child(screen)
	screen.battle.start_battle(
		[
			{"id": "lead", "name": "Sev", "class_id": "vanguard", "level": 1, "xp": 0, "stats": {"max_hp": 120, "strength": 18, "defense": 8, "speed": 10}},
			{"id": "mira_venn", "name": "Mira Venn", "class_id": "plague_apothecary", "level": 1, "xp": 0, "stats": {"max_hp": 92, "magic": 15, "defense": 5, "speed": 8}, "skills": ["clean_wound", "rot_needle"]},
		],
		[{"id": "clean_man", "name": "Clean Man", "hp": 88, "max_hp": 88, "strength": 11, "defense": 6, "speed": 8, "xp": 55, "animation_set": "clean_man_generated"}]
	)
	_assert(screen.has_method("select_party_member"), "battle screen exposes active party member selection")
	if screen.has_method("select_party_member"):
		screen.select_party_member(1)
	screen._update_labels("Active party check.")
	var party_label = screen.get_node_or_null("%PartyLabel")
	var active_name = screen.get_node_or_null("%PartyNameLabel")
	_assert(party_label is Label and party_label.text.contains("> Mira Venn"), "party roster marks active Mira")
	_assert(active_name is Label and active_name.text.contains("Mira Venn"), "party status panel follows active party member")
	screen.queue_free()

func _test_battle_screen_party_roster_buttons_select_active_member() -> void:
	var BattleScene = load("res://scenes/battle/prototype_battle.tscn")
	var screen = BattleScene.instantiate()
	root.add_child(screen)
	screen.battle.start_battle(
		[
			{"id": "lead", "name": "Sev", "class_id": "vanguard", "level": 1, "xp": 0, "stats": {"max_hp": 120, "strength": 18, "defense": 8, "speed": 10}, "skills": ["archive_strike"]},
			{"id": "mira_venn", "name": "Mira Venn", "class_id": "plague_apothecary", "level": 1, "xp": 0, "stats": {"max_hp": 92, "magic": 15, "defense": 5, "speed": 8}, "skills": ["clean_wound", "rot_needle"]},
		],
		[{"id": "clean_man", "name": "Clean Man", "hp": 88, "max_hp": 88, "strength": 11, "defense": 6, "speed": 8, "xp": 55, "animation_set": "clean_man_generated"}]
	)
	screen._update_labels("Roster button check.")
	var roster = screen.get_node_or_null("%PartyRoster")
	_assert(roster is VBoxContainer, "battle screen exposes a party roster button container")
	if roster is VBoxContainer:
		_assert(roster.get_child_count() == 2, "party roster renders one button per party member")
		if roster.get_child_count() >= 2 and roster.get_child(1) is Button:
			roster.get_child(1).pressed.emit()
			_assert(int(screen.get("active_party_index")) == 1, "pressing Mira's roster button selects Mira")
			_assert(roster.get_child(1).button_pressed, "selected party roster button is visibly pressed")
	screen.queue_free()

func _test_battle_screen_party_roster_buttons_show_hp() -> void:
	var BattleScene = load("res://scenes/battle/prototype_battle.tscn")
	var screen = BattleScene.instantiate()
	root.add_child(screen)
	screen.battle.start_battle(
		[
			{"id": "lead", "name": "Sev", "class_id": "vanguard", "level": 1, "xp": 0, "hp": 77, "stats": {"max_hp": 120, "strength": 18, "defense": 8, "speed": 10}},
			{"id": "mira_venn", "name": "Mira Venn", "class_id": "plague_apothecary", "level": 1, "xp": 0, "hp": 52, "stats": {"max_hp": 92, "magic": 15, "defense": 5, "speed": 8}, "skills": ["clean_wound", "rot_needle"]},
		],
		[{"id": "clean_man", "name": "Clean Man", "hp": 88, "max_hp": 88, "strength": 11, "defense": 6, "speed": 8, "xp": 55}]
	)
	screen._update_labels("Roster HP check.")
	var roster = screen.get_node_or_null("%PartyRoster")
	_assert(roster is VBoxContainer, "battle screen renders party roster buttons for HP display")
	if roster is VBoxContainer and roster.get_child_count() >= 2:
		_assert(roster.get_child(0).text.contains("77/120"), "Sev roster button shows current and max HP")
		_assert(roster.get_child(1).text.contains("52/92"), "Mira roster button shows current and max HP")
	screen.queue_free()

func _test_battle_screen_prevents_selecting_ko_party_member() -> void:
	var BattleScene = load("res://scenes/battle/prototype_battle.tscn")
	var screen = BattleScene.instantiate()
	root.add_child(screen)
	screen.battle.start_battle(
		[
			{"id": "lead", "name": "Sev", "class_id": "vanguard", "level": 1, "xp": 0, "hp": 77, "stats": {"max_hp": 120, "strength": 18, "defense": 8, "speed": 10}},
			{"id": "mira_venn", "name": "Mira Venn", "class_id": "plague_apothecary", "level": 1, "xp": 0, "hp": 0, "stats": {"max_hp": 92, "magic": 15, "defense": 5, "speed": 8}, "skills": ["clean_wound", "rot_needle"]},
		],
		[{"id": "clean_man", "name": "Clean Man", "hp": 88, "max_hp": 88, "strength": 11, "defense": 6, "speed": 8, "xp": 55}]
	)
	screen.select_party_member(1)
	_assert(int(screen.get("active_party_index")) == 0, "KO party members cannot become active through direct selection")
	screen._update_labels("KO roster check.")
	var roster = screen.get_node_or_null("%PartyRoster")
	if roster is VBoxContainer and roster.get_child_count() >= 2:
		_assert(roster.get_child(1).disabled, "KO party member roster button is disabled")
	screen.queue_free()

func _test_battle_screen_uses_active_party_member_skills() -> void:
	var BattleScene = load("res://scenes/battle/prototype_battle.tscn")
	var screen = BattleScene.instantiate()
	root.add_child(screen)
	screen.battle.start_battle(
		[
			{"id": "lead", "name": "Sev", "class_id": "vanguard", "level": 1, "xp": 0, "stats": {"max_hp": 120, "strength": 18, "defense": 8, "speed": 10}, "skills": ["archive_strike"]},
			{"id": "mira_venn", "name": "Mira Venn", "class_id": "plague_apothecary", "level": 1, "xp": 0, "hp": 40, "stats": {"max_hp": 92, "magic": 15, "defense": 5, "speed": 8}, "skills": ["clean_wound", "rot_needle"]},
		],
		[{"id": "clean_man", "name": "Clean Man", "hp": 88, "max_hp": 88, "strength": 11, "defense": 6, "speed": 8, "xp": 55, "animation_set": "clean_man_generated"}]
	)
	_assert(screen.has_method("select_party_member"), "battle screen exposes active party member selection for skills")
	if not screen.has_method("select_party_member"):
		screen.queue_free()
		return
	screen.select_party_member(1)
	screen.open_skill_menu()
	var menu = screen.get_node_or_null("%SkillMenu")
	_assert(menu is VBoxContainer and menu.get_child_count() == 2, "skill menu shows active Mira's skills")
	if menu is VBoxContainer and menu.get_child_count() >= 2:
		_assert(menu.get_child(0).text.contains("Clean Wound"), "skill menu includes Mira healing skill")
		_assert(menu.get_child(1).text.contains("Rot Needle"), "skill menu includes Mira plague skill")
	screen.select_skill("clean_wound")
	_assert(screen.battle.party[1].hp == 75, "Mira heals herself as active party member")
	screen.queue_free()

func _test_battle_screen_advances_active_party_member_after_enemy_action() -> void:
	var BattleScene = load("res://scenes/battle/prototype_battle.tscn")
	var screen = BattleScene.instantiate()
	root.add_child(screen)
	screen.battle.start_battle(
		[
			{"id": "lead", "name": "Sev", "class_id": "vanguard", "level": 1, "xp": 0, "hp": 120, "stats": {"max_hp": 120, "strength": 18, "defense": 8, "speed": 10}},
			{"id": "mira_venn", "name": "Mira Venn", "class_id": "plague_apothecary", "level": 1, "xp": 0, "hp": 92, "stats": {"max_hp": 92, "magic": 15, "defense": 5, "speed": 8}, "skills": ["clean_wound", "rot_needle"]},
		],
		[{"id": "clean_man", "name": "Clean Man", "hp": 88, "max_hp": 88, "strength": 11, "defense": 6, "speed": 8, "xp": 55, "animation_set": "clean_man_generated"}]
	)
	_assert(screen.has_method("select_party_member"), "battle screen exposes active party member selection before rotation")
	if not screen.has_method("select_party_member"):
		screen.queue_free()
		return
	screen.select_party_member(0)
	screen.present_enemy_retaliation()
	screen.complete_enemy_retaliation()
	_assert(int(screen.get("active_party_index")) == 1, "active party member advances after enemy action")
	screen._update_labels("Next actor check.")
	var active_name = screen.get_node_or_null("%PartyNameLabel")
	_assert(active_name is Label and active_name.text.contains("Mira Venn"), "party status panel follows next active member")
	screen.queue_free()

func _test_battle_screen_completion_includes_party_state() -> void:
	var BattleScene = load("res://scenes/battle/prototype_battle.tscn")
	var screen = BattleScene.instantiate()
	var emitted: Array = []
	screen.battle_completed.connect(func(payload): emitted.append(payload))
	root.add_child(screen)
	screen.battle.start_battle(
		[
			{"id": "lead", "name": "Sev", "class_id": "vanguard", "level": 1, "xp": 0, "hp": 77, "stats": {"max_hp": 120, "strength": 18, "defense": 8, "speed": 10}},
			{"id": "mira_venn", "name": "Mira Venn", "class_id": "plague_apothecary", "level": 1, "xp": 0, "hp": 52, "stats": {"max_hp": 92, "magic": 15, "defense": 5, "speed": 8}, "skills": ["clean_wound", "rot_needle"]},
		],
		[{"id": "clean_man", "name": "Clean Man", "hp": 1, "max_hp": 88, "strength": 11, "defense": 6, "speed": 8, "xp": 55, "sprite_path": "res://assets/generated/pixellab/first_slice/clean_man_enemy.png"}]
	)
	screen._on_attack_pressed()
	_assert(emitted.size() == 1, "battle screen emits completion payload for HP persistence check")
	if emitted.size() == 1:
		_assert(emitted[0].has("party_state"), "battle completion payload includes party state")
		if emitted[0].has("party_state"):
			_assert(emitted[0].party_state[0].id == "lead", "party state keeps party member id")
			_assert(emitted[0].party_state[0].hp == 77, "party state keeps current HP")
			_assert(emitted[0].party_state[0].stats.max_hp == 120, "party state keeps max HP context")
			_assert(emitted[0].party_state.size() == 2, "party state includes recruited party members")
			_assert(emitted[0].party_state[1].id == "mira_venn", "party state includes Mira Venn")
			_assert(emitted[0].party_state[1].hp == 52, "party state keeps Mira's current HP")
	screen.queue_free()

func _test_battle_screen_does_not_persist_rewards_before_app_root() -> void:
	var GameStateScript = load("res://scripts/core/game_state.gd")
	var game_state = GameStateScript.new()
	game_state.inventory = {}
	game_state.memory_cards = {"owned": [], "equipped": []}
	var party: Array[Dictionary] = [{"id": "lead", "name": "Sev", "class_id": "vanguard", "level": 1, "xp": 0, "stats": {"max_hp": 120, "strength": 18, "defense": 8, "speed": 10}}]
	game_state.party = party
	var BattleScene = load("res://scenes/battle/prototype_battle.tscn")
	var screen = BattleScene.instantiate()
	screen.game_state_override = game_state
	var emitted: Array = []
	screen.battle_completed.connect(func(payload): emitted.append(payload))
	root.add_child(screen)
	screen.battle.start_battle(
		party,
		[{"id": "bell_saint", "name": "The Bell Saint", "hp": 1, "max_hp": 48, "strength": 10, "defense": 3, "speed": 6, "xp": 150, "boss": true, "relic": "bell_clapper", "memory_card": "bell_saint", "next_flow": "truth_recovered"}]
	)
	screen._on_attack_pressed()
	_assert(emitted.size() == 1, "battle screen emits rewards for app root persistence")
	_assert(not game_state.inventory.has("bell_clapper"), "battle screen does not persist relic rewards directly")
	_assert(not game_state.memory_cards.owned.has("bell_saint"), "battle screen does not persist memory cards directly")
	screen.queue_free()
	game_state.free()

func _test_battle_screen_uses_stable_visual_stage() -> void:
	var BattleScene = load("res://scenes/battle/prototype_battle.tscn")
	var screen = BattleScene.instantiate()
	root.add_child(screen)
	screen.battle.start_battle(
		[{"id": "lead", "name": "Sev", "class_id": "vanguard", "level": 1, "xp": 0, "stats": {"max_hp": 120, "strength": 18, "defense": 8, "speed": 10}}],
		[{"id": "bell_saint", "name": "The Bell Saint", "hp": 48, "max_hp": 48, "strength": 10, "defense": 3, "speed": 6, "xp": 150, "sprite_path": "res://assets/generated/pixellab/first_slice/bell_saint_boss.png"}]
	)
	screen._update_labels("Stage check.")
	var arena = screen.get_node_or_null("Arena")
	var party_anchor = screen.get_node_or_null("Arena/Battlers/PartyAnchor")
	var enemy_anchor = screen.get_node_or_null("Arena/Battlers/EnemyAnchor")
	var enemy_sprite = screen.get_node_or_null("Arena/Battlers/EnemyAnchor/EnemyBattler")
	_assert(arena is Node2D, "battle screen has a world-space visual stage")
	_assert(party_anchor is Marker2D, "battle stage reserves a party-side anchor")
	_assert(enemy_anchor is Marker2D, "battle stage reserves an enemy-side anchor")
	_assert(enemy_sprite is Sprite2D, "enemy sprite lives under the enemy anchor")
	if party_anchor is Marker2D and enemy_anchor is Marker2D:
		_assert(enemy_anchor.position.x > party_anchor.position.x, "enemy anchor is staged opposite the party")
	screen.queue_free()

func _test_battle_screen_updates_enemy_visual_status() -> void:
	var BattleScene = load("res://scenes/battle/prototype_battle.tscn")
	var screen = BattleScene.instantiate()
	root.add_child(screen)
	screen.battle.start_battle(
		[{"id": "lead", "name": "Sev", "class_id": "vanguard", "level": 1, "xp": 0, "stats": {"max_hp": 120, "strength": 18, "defense": 8, "speed": 10}}],
		[{"id": "clean_man", "name": "Clean Man", "hp": 88, "max_hp": 88, "strength": 11, "defense": 6, "speed": 8, "xp": 55, "sprite_path": "res://assets/generated/pixellab/first_slice/clean_man_enemy.png"}]
	)
	screen._update_labels("Status check.")
	var enemy_name = screen.get_node_or_null("BattleUi/RootControl/BottomPanel/Margin/UiStack/StatusRow/EnemyStatus/EnemyNameLabel")
	var enemy_hp = screen.get_node_or_null("BattleUi/RootControl/BottomPanel/Margin/UiStack/StatusRow/EnemyStatus/EnemyHpBar")
	_assert(enemy_name is Label, "battle UI includes enemy name label")
	_assert(enemy_hp is ProgressBar, "battle UI includes enemy HP bar")
	if enemy_name is Label:
		_assert(enemy_name.text == "Clean Man", "enemy visual name matches current enemy")
	if enemy_hp is ProgressBar:
		_assert(enemy_hp.max_value == 88.0, "enemy HP bar max matches enemy max HP")
		_assert(enemy_hp.value == 88.0, "enemy HP bar value matches current enemy HP")
	screen.battle.enemies[0].hp = 27
	screen._update_labels("Damaged.")
	if enemy_hp is ProgressBar:
		_assert(enemy_hp.value == 27.0, "enemy HP bar updates after enemy damage")
	screen.queue_free()

func _test_battle_screen_updates_party_visual_status() -> void:
	var BattleScene = load("res://scenes/battle/prototype_battle.tscn")
	var screen = BattleScene.instantiate()
	root.add_child(screen)
	screen.battle.start_battle(
		[{"id": "lead", "name": "Sev", "class_id": "vanguard", "level": 3, "xp": 0, "hp": 97, "stats": {"max_hp": 120, "strength": 18, "defense": 8, "speed": 10}}],
		[{"id": "clean_man", "name": "Clean Man", "hp": 88, "max_hp": 88, "strength": 11, "defense": 6, "speed": 8, "xp": 55, "sprite_path": "res://assets/generated/pixellab/first_slice/clean_man_enemy.png"}]
	)
	screen._update_labels("Party status check.")
	var party_name = screen.get_node_or_null("BattleUi/RootControl/BottomPanel/Margin/UiStack/StatusRow/PartyStatus/PartyNameLabel")
	var party_hp = screen.get_node_or_null("BattleUi/RootControl/BottomPanel/Margin/UiStack/StatusRow/PartyStatus/PartyHpBar")
	var party_role = screen.get_node_or_null("BattleUi/RootControl/BottomPanel/Margin/UiStack/StatusRow/PartyStatus/PartyRoleLabel")
	_assert(party_name is Label, "battle UI includes party name label")
	_assert(party_hp is ProgressBar, "battle UI includes party HP bar")
	_assert(party_role is Label, "battle UI includes party role label")
	if party_name is Label:
		_assert(party_name.text == "Sev Lv.3", "party visual name includes level")
	if party_hp is ProgressBar:
		_assert(party_hp.max_value == 120.0, "party HP bar max matches max HP")
		_assert(party_hp.value == 97.0, "party HP bar value uses current HP")
	if party_role is Label:
		_assert(party_role.text == "Vanguard", "party role label formats class id")
	screen.battle.party[0].hp = 42
	screen._update_labels("Party damaged.")
	if party_hp is ProgressBar:
		_assert(party_hp.value == 42.0, "party HP bar updates after party damage")
	screen.queue_free()

func _test_app_root_handles_battle_completion_rewards() -> void:
	var AppRootScene = load("res://scenes/app/app_root.tscn")
	var GameStateScript = load("res://scripts/core/game_state.gd")
	var app = AppRootScene.instantiate()
	var game_state = GameStateScript.new()
	app.game_state_override = game_state
	root.add_child(app)
	app.story_flow.load_first_slice()
	app.story_flow.go_to_phase("battle")
	var payload = {"next_flow": "truth_recovered", "relics": ["bell_clapper"], "memory_cards": ["bell_saint"], "loot": {}}
	app._on_battle_completed(payload)
	_assert(game_state.map_id == "truth_recovered", "app root moves GameState to post-boss phase")
	_assert(app.story_flow.current_phase() == "truth_recovered", "app root moves story flow to post-boss phase")
	_assert(game_state.inventory.bell_clapper == 1, "app root grants Bell Clapper on battle completion")
	_assert(game_state.memory_cards.owned.has("bell_saint"), "app root grants Bell Saint memory card on battle completion")
	_assert(not game_state.flags.has("pending_battle_payload"), "app root clears pending battle payload after completion")
	app.queue_free()
	game_state.free()

func _test_app_root_does_not_duplicate_anchor_relic_rewards() -> void:
	var AppRootScene = load("res://scenes/app/app_root.tscn")
	var GameStateScript = load("res://scripts/core/game_state.gd")
	var app = AppRootScene.instantiate()
	var game_state = GameStateScript.new()
	game_state.inventory["bell_clapper"] = 1
	app.game_state_override = game_state
	root.add_child(app)
	app.story_flow.load_first_slice()
	app.story_flow.go_to_phase("battle")
	app._on_battle_completed({"next_flow": "truth_recovered", "relics": ["bell_clapper"], "memory_cards": ["bell_saint"], "loot": {}})
	_assert(game_state.inventory.bell_clapper == 1, "anchor relic rewards stay unique when already owned")
	app.queue_free()
	game_state.free()

func _test_app_root_applies_battle_xp_to_party() -> void:
	var AppRootScene = load("res://scenes/app/app_root.tscn")
	var GameStateScript = load("res://scripts/core/game_state.gd")
	var app = AppRootScene.instantiate()
	var game_state = GameStateScript.new()
	var party: Array[Dictionary] = [
		{"id": "lead", "name": "Sev", "class_id": "vanguard", "level": 1, "xp": 90, "stats": {"max_hp": 120, "max_mp": 12, "strength": 18, "magic": 4, "defense": 8, "speed": 10}},
	]
	game_state.party = party
	app.game_state_override = game_state
	root.add_child(app)
	app.story_flow.load_first_slice()
	app.story_flow.go_to_phase("battle")
	game_state.flags["pending_battle_payload"] = {"source_phase": "underchapel_drain", "source_position": Vector2(96, 80)}
	app._on_battle_completed({"xp": 20, "loot": {}, "relics": [], "memory_cards": [], "next_flow": ""})
	_assert(game_state.party[0].level == 2, "app root applies battle XP to party on completion")
	_assert(game_state.party[0].xp == 10, "app root keeps XP remainder after level up")
	app.queue_free()
	game_state.free()

func _test_app_root_applies_battle_party_state() -> void:
	var AppRootScene = load("res://scenes/app/app_root.tscn")
	var GameStateScript = load("res://scripts/core/game_state.gd")
	var app = AppRootScene.instantiate()
	var game_state = GameStateScript.new()
	var party: Array[Dictionary] = [
		{"id": "lead", "name": "Sev", "class_id": "vanguard", "level": 1, "xp": 0, "hp": 120, "stats": {"max_hp": 120, "max_mp": 12, "strength": 18, "magic": 4, "defense": 8, "speed": 10}},
	]
	game_state.party = party
	app.game_state_override = game_state
	root.add_child(app)
	app.story_flow.load_first_slice()
	app.story_flow.go_to_phase("battle")
	game_state.flags["pending_battle_payload"] = {"source_phase": "underchapel_drain", "source_position": Vector2(96, 80)}
	app._on_battle_completed({
		"xp": 0,
		"loot": {},
		"relics": [],
		"memory_cards": [],
		"next_flow": "",
		"party_state": [{"id": "lead", "hp": 43, "statuses": {"poison": {"turns": 1}}}]
	})
	_assert(game_state.party[0].hp == 43, "app root persists party HP from battle completion")
	_assert(game_state.party[0].has("statuses"), "app root persists party status container from battle completion")
	if game_state.party[0].has("statuses"):
		_assert(game_state.party[0].statuses.poison.turns == 1, "app root persists party statuses from battle completion")
	app.queue_free()
	game_state.free()

func _test_app_root_bell_saint_completion_recruits_mira_and_records_reward_scene() -> void:
	var AppRootScene = load("res://scenes/app/app_root.tscn")
	var GameStateScript = load("res://scripts/core/game_state.gd")
	var app = AppRootScene.instantiate()
	var game_state = GameStateScript.new()
	var party: Array[Dictionary] = [{"id": "lead", "name": "Sev", "class_id": "vanguard", "level": 1, "xp": 0, "stats": {"max_hp": 120}}]
	game_state.party = party
	app.game_state_override = game_state
	root.add_child(app)
	app.story_flow.load_first_slice()
	app.story_flow.go_to_phase("battle")
	app._on_battle_completed({
		"xp": 180,
		"loot": {},
		"relics": ["bell_clapper"],
		"memory_cards": ["bell_saint"],
		"next_flow": "truth_recovered",
		"party_state": [{"id": "lead", "hp": 90}]
	})
	_assert(game_state.party.any(func(member): return member.id == "mira_venn"), "Bell Saint completion recruits Mira Venn")
	_assert(game_state.flags.get("mira_venn_recruited", false), "Bell Saint completion records Mira recruitment flag")
	_assert(game_state.flags.get("chapter_01_complete", false), "Bell Saint completion marks chapter one complete")
	_assert(game_state.flags.get("pending_reward_dialogue", {}).get("scene", "") == "memory_card_unlock", "Bell Saint completion records reward dialogue scene")
	_assert(game_state.inventory.bell_clapper == 1, "Bell Saint completion still grants Bell Clapper")
	_assert(game_state.memory_cards.owned.has("bell_saint"), "Bell Saint completion still grants Bell Saint memory card")
	app.queue_free()
	game_state.free()

func _test_app_root_bell_saint_completion_records_boss_defeat() -> void:
	var AppRootScene = load("res://scenes/app/app_root.tscn")
	var GameStateScript = load("res://scripts/core/game_state.gd")
	var app = AppRootScene.instantiate()
	var game_state = GameStateScript.new()
	var party: Array[Dictionary] = [{"id": "lead", "name": "Sev", "class_id": "vanguard", "level": 1, "xp": 0, "stats": {"max_hp": 120}}]
	game_state.party = party
	app.game_state_override = game_state
	root.add_child(app)
	app.story_flow.load_first_slice()
	app.story_flow.go_to_phase("battle")
	app._on_battle_completed({
		"xp": 180,
		"loot": {},
		"relics": ["bell_clapper"],
		"memory_cards": ["bell_saint"],
		"next_flow": "truth_recovered",
		"party_state": [{"id": "lead", "hp": 90}]
	})
	_assert(game_state.flags.get("boss_bell_saint_defeated", false), "Bell Saint completion records defeated boss flag")
	app.queue_free()
	game_state.free()

func _test_app_root_bell_saint_completion_records_autosave_feedback() -> void:
	var AppRootScene = load("res://scenes/app/app_root.tscn")
	var GameStateScript = load("res://scripts/core/game_state.gd")
	var app = AppRootScene.instantiate()
	var game_state = GameStateScript.new()
	var party: Array[Dictionary] = [{"id": "lead", "name": "Sev", "class_id": "vanguard", "level": 1, "xp": 0, "stats": {"max_hp": 120}}]
	game_state.party = party
	app.game_state_override = game_state
	root.add_child(app)
	app.story_flow.load_first_slice()
	app.story_flow.go_to_phase("battle")
	app._on_battle_completed({
		"xp": 180,
		"loot": {},
		"relics": ["bell_clapper"],
		"memory_cards": ["bell_saint"],
		"next_flow": "truth_recovered",
		"party_state": [{"id": "lead", "hp": 90}]
	})
	_assert(game_state.flags.get("last_save_status", "").contains("Autosaved"), "Bell Saint completion records autosave feedback")
	var text_label = app.get_node_or_null("%SceneHost/RewardScenePanel/Content/RewardText")
	_assert(text_label is Label, "Bell Saint reward scene renders after autosave")
	if text_label is Label:
		_assert(text_label.text.contains("Autosaved"), "Bell Saint reward scene tells player progress is saved")
		_assert(text_label.text.contains("safe to stop"), "Bell Saint reward scene tells player it is safe to stop")
	app.queue_free()
	game_state.free()

func _test_app_root_renders_bell_saint_reward_scene() -> void:
	var AppRootScene = load("res://scenes/app/app_root.tscn")
	var GameStateScript = load("res://scripts/core/game_state.gd")
	var app = AppRootScene.instantiate()
	var game_state = GameStateScript.new()
	game_state.inventory["bell_clapper"] = 1
	game_state.memory_cards["owned"] = ["bell_saint"]
	var party: Array[Dictionary] = [
		{"id": "lead", "name": "Sev", "class_id": "vanguard", "level": 1, "xp": 0, "stats": {"max_hp": 120}},
		{"id": "mira_venn", "name": "Mira Venn", "class_id": "plague_apothecary", "level": 1, "xp": 0, "stats": {"max_hp": 92}},
	]
	game_state.party = party
	app.game_state_override = game_state
	root.add_child(app)
	app.story_flow.load_first_slice()
	game_state.flags["pending_reward_dialogue"] = {"section": "rewards", "scene": "memory_card_unlock"}
	app.story_flow.go_to_phase("truth_recovered")
	app._sync_scene()
	var panel = app.get_node_or_null("%SceneHost/RewardScenePanel")
	_assert(panel is Control, "app root renders reward scene panel after Bell Saint")
	if panel is Control:
		var text_label = panel.get_node_or_null("Content/RewardText")
		_assert(text_label is Label, "reward scene panel contains reward text label")
		if text_label is Label:
			_assert(text_label.text.contains("Evidence"), "reward scene includes Sev evidence line")
			_assert(text_label.text.contains("Unauthorized truth recovered"), "reward scene includes Curator correction line")
			_assert(text_label.text.contains("Anchor Recovered: Bell Clapper"), "reward scene summarizes recovered anchor relic")
			_assert(text_label.text.contains("Memory Card: The Bell Saint"), "reward scene summarizes acquired memory card")
			_assert(text_label.text.contains("Mira Venn joined"), "reward scene summarizes Mira joining the party")
	app.queue_free()
	game_state.free()

func _test_app_root_reward_scene_summarizes_evidence_progress() -> void:
	var AppRootScene = load("res://scenes/app/app_root.tscn")
	var GameStateScript = load("res://scripts/core/game_state.gd")
	var app = AppRootScene.instantiate()
	var game_state = GameStateScript.new()
	game_state.inventory["bell_clapper"] = 1
	game_state.memory_cards["owned"] = ["bell_saint"]
	game_state.flags["discovered_prop_underchapel_museum_pipe"] = true
	game_state.flags["discovered_prop_hospital_medical_chart"] = true
	game_state.flags["pending_reward_dialogue"] = {"section": "rewards", "scene": "memory_card_unlock"}
	app.game_state_override = game_state
	root.add_child(app)
	app.story_flow.load_first_slice()
	app.story_flow.go_to_phase("truth_recovered")
	app._sync_scene()
	var text_label = app.get_node_or_null("%SceneHost/RewardScenePanel/Content/RewardText")
	_assert(text_label is Label, "reward scene renders text for evidence progress")
	if text_label is Label:
		_assert(text_label.text.contains("Evidence Found: 2 / 16"), "reward scene summarizes first-slice evidence progress")
		_assert(text_label.text.contains("Evidence Remaining: Hallowmere Street, Mira Apothecary, Sainted Bell Chapel"), "reward scene summarizes earliest maps with missing evidence")
	app.queue_free()
	game_state.free()

func _test_app_root_reward_scene_renders_acknowledgement_prompt() -> void:
	var AppRootScene = load("res://scenes/app/app_root.tscn")
	var GameStateScript = load("res://scripts/core/game_state.gd")
	var app = AppRootScene.instantiate()
	var game_state = GameStateScript.new()
	app.game_state_override = game_state
	root.add_child(app)
	app.story_flow.load_first_slice()
	game_state.flags["pending_reward_dialogue"] = {"section": "rewards", "scene": "memory_card_unlock"}
	app.story_flow.go_to_phase("truth_recovered")
	app._sync_scene()
	var prompt = app.get_node_or_null("%SceneHost/RewardScenePanel/Content/AcknowledgePrompt")
	_assert(prompt is Label, "reward scene renders acknowledgement prompt")
	if prompt is Label:
		_assert(prompt.text.contains("Interact"), "reward scene prompt names the input that continues")
	app.queue_free()
	game_state.free()

func _test_app_root_consumes_reward_dialogue_after_acknowledgement() -> void:
	var AppRootScene = load("res://scenes/app/app_root.tscn")
	var GameStateScript = load("res://scripts/core/game_state.gd")
	var app = AppRootScene.instantiate()
	var game_state = GameStateScript.new()
	app.game_state_override = game_state
	root.add_child(app)
	app.story_flow.load_first_slice()
	app.story_flow.go_to_phase("truth_recovered")
	game_state.map_id = "truth_recovered"
	game_state.flags["pending_reward_dialogue"] = {"section": "rewards", "scene": "memory_card_unlock"}
	app._advance_flow()
	_assert(not game_state.flags.has("pending_reward_dialogue"), "acknowledging reward scene consumes pending reward dialogue")
	_assert(game_state.map_id == "truth_recovered", "acknowledging final reward scene stays on truth recovered phase")
	app.queue_free()
	game_state.free()

func _test_app_root_refreshes_reward_scene_after_acknowledgement() -> void:
	var AppRootScene = load("res://scenes/app/app_root.tscn")
	var GameStateScript = load("res://scripts/core/game_state.gd")
	var app = AppRootScene.instantiate()
	var game_state = GameStateScript.new()
	app.game_state_override = game_state
	root.add_child(app)
	app.story_flow.load_first_slice()
	app.story_flow.go_to_phase("truth_recovered")
	game_state.map_id = "truth_recovered"
	game_state.flags["pending_reward_dialogue"] = {"section": "rewards", "scene": "memory_card_unlock"}
	app._sync_scene()
	app._advance_flow()
	var text_label = app.get_node_or_null("%SceneHost/RewardScenePanel/Content/RewardText")
	_assert(text_label is Label, "reward panel remains mounted after acknowledgement")
	if text_label is Label:
		_assert(not text_label.text.contains("Unauthorized truth recovered"), "acknowledged reward panel no longer shows one-time Curator correction")
		_assert(text_label.text.contains("Chapter 1 Complete"), "acknowledged reward panel shows stable chapter completion state")
	app.queue_free()
	game_state.free()

func _test_dialogue_interpolation() -> void:
	_assert(ResourceLoader.exists("res://scripts/dialogue/dialogue_service.gd"), "dialogue service exists")
	var DialogueService = load("res://scripts/dialogue/dialogue_service.gd")
	var service = DialogueService.new()
	var line = service.interpolate("{player_name} checks {they} blade.", {
		"name": "Mira",
		"pronouns": "they/them"
	})
	_assert(line == "Mira checks their blade.", "dialogue interpolates name and pronoun forms")

func _test_portrait_catalog_resolves_creator_portraits() -> void:
	_assert(ResourceLoader.exists("res://scripts/core/portrait_catalog.gd"), "portrait catalog exists")
	var PortraitCatalog = load("res://scripts/core/portrait_catalog.gd")
	var catalog = PortraitCatalog.new()
	_assert(catalog.path_for_id("fairy_12").ends_with("portrait_fairy_12.png"), "portrait catalog resolves fairy portrait")
	_assert(FileAccess.file_exists(catalog.path_for_id("demon_01")), "portrait catalog points to existing demon portrait file")
	_assert(catalog.path_for_id("bad_portrait").ends_with("portrait_dwarf_01.png"), "portrait catalog falls back invalid portrait id")

func _test_dialogue_box_uses_profile_portrait_for_sev() -> void:
	_assert(ResourceLoader.exists("res://scripts/dialogue/dialogue_box.gd"), "dialogue box exists")
	var DialogueBox = load("res://scripts/dialogue/dialogue_box.gd")
	var box = DialogueBox.new()
	var path = box.resolve_portrait_path({"speaker": "SEV"}, {"portrait_id": "orc_12"})
	_assert(path.ends_with("portrait_orc_12.png"), "dialogue box resolves player portrait for Sev")
	var curator_path = box.resolve_portrait_path({"speaker": "CURATOR"}, {"portrait_id": "orc_12"})
	_assert(curator_path == "", "dialogue box does not use player portrait for non-player speaker")
	box.free()

func _test_voice_blip_catalog_resolves_creator_voice() -> void:
	_assert(ResourceLoader.exists("res://scripts/core/voice_blip_catalog.gd"), "voice blip catalog exists")
	var VoiceBlipCatalog = load("res://scripts/core/voice_blip_catalog.gd")
	var catalog = VoiceBlipCatalog.new()
	_assert(catalog.event_for_id("warm_human") == "voice_sev_warm_human", "voice blip catalog resolves warm human voice")
	_assert(catalog.event_for_id("bad_voice") == "voice_sev_soft_synthetic", "voice blip catalog falls back invalid voice")

func _test_dialogue_box_uses_profile_voice_for_sev() -> void:
	var DialogueBox = load("res://scripts/dialogue/dialogue_box.gd")
	var box = DialogueBox.new()
	var event_id = box.resolve_voice_event({"speaker": "SEV"}, {"voice_blip": "sharp_clear"})
	_assert(event_id == "voice_sev_sharp_clear", "dialogue box resolves player voice event for Sev")
	var curator_event = box.resolve_voice_event({"speaker": "CURATOR"}, {"voice_blip": "sharp_clear"})
	_assert(curator_event == "voice_curator", "dialogue box resolves Curator voice event")
	box.free()

func _test_battle_attack_and_victory_rewards() -> void:
	_assert(ResourceLoader.exists("res://scripts/battle/battle_controller.gd"), "battle controller exists")
	var BattleController = load("res://scripts/battle/battle_controller.gd")
	var battle = BattleController.new()
	battle.start_battle([
		{"id": "lead", "name": "Mira", "class_id": "vanguard", "level": 1, "xp": 0, "stats": {"max_hp": 120, "strength": 18, "defense": 8, "speed": 10}}
	], [
		{"id": "slime", "name": "Slime", "hp": 12, "max_hp": 12, "strength": 4, "defense": 1, "speed": 5, "xp": 25, "loot": {"potion": 1}}
	])
	var result = battle.execute_command("lead", "attack", "slime")
	_assert(result.damage >= 17, "attack damage uses attacker strength and enemy defense")
	_assert(battle.enemies[0].hp <= 0, "attack can defeat an enemy")
	_assert(battle.is_victory(), "battle detects victory when enemies are defeated")
	var rewards = battle.resolve_victory()
	_assert(rewards.xp == 25, "victory grants enemy XP")
	_assert(rewards.loot.potion == 1, "victory grants enemy loot")

func _test_battle_skills_damage_and_heal() -> void:
	_assert(FileAccess.file_exists("res://data/battle/skills.json"), "battle skills data exists")
	var ContentCatalog = load("res://scripts/core/content_catalog.gd")
	var catalog = ContentCatalog.new()
	_assert(catalog.battle_skill("archive_strike").display_name == "Archive Strike", "content catalog loads battle skills")
	var BattleController = load("res://scripts/battle/battle_controller.gd")
	var battle = BattleController.new()
	battle.start_battle([
		{"id": "lead", "name": "Sev", "class_id": "spellblade", "level": 1, "xp": 0, "hp": 50, "stats": {"max_hp": 100, "strength": 12, "magic": 9, "defense": 5, "speed": 8}}
	], [
		{"id": "wretch", "name": "Wretch", "hp": 40, "max_hp": 40, "strength": 4, "defense": 3, "speed": 5, "xp": 10}
	])
	var damage_result = battle.execute_command("lead", "skill", "wretch", {"skill_id": "archive_strike"})
	_assert(damage_result.skill_id == "archive_strike", "skill result records skill id")
	_assert(damage_result.damage > 12, "Archive Strike deals skill damage beyond basic strength")
	_assert(battle.enemies[0].hp == 40 - damage_result.damage, "damage skill reduces enemy HP")
	var heal_result = battle.execute_command("lead", "skill", "lead", {"skill_id": "clean_wound"})
	_assert(heal_result.heal == 35, "Clean Wound heals configured HP amount")
	_assert(battle.party[0].hp == min(100, 50 + heal_result.heal), "healing skill restores party HP up to max")

func _test_battle_items_consume_inventory_and_heal() -> void:
	var BattleController = load("res://scripts/battle/battle_controller.gd")
	var battle = BattleController.new()
	var inventory := {"clean_bandage": 1}
	battle.start_battle([
		{"id": "lead", "name": "Sev", "class_id": "vanguard", "level": 1, "xp": 0, "hp": 40, "stats": {"max_hp": 120, "strength": 18, "defense": 8, "speed": 10}}
	], [
		{"id": "wretch", "name": "Wretch", "hp": 30, "max_hp": 30, "strength": 4, "defense": 2, "speed": 5, "xp": 10}
	])
	var result = battle.execute_command("lead", "item", "lead", {"item_id": "clean_bandage", "inventory": inventory})
	_assert(result.item_id == "clean_bandage", "item result records item id")
	_assert(result.heal == 35, "Clean Bandage heals configured HP amount")
	_assert(battle.party[0].hp == 75, "battle item restores target HP")
	_assert(not inventory.has("clean_bandage"), "battle item consumes inventory stack")
	var missing = battle.execute_command("lead", "item", "lead", {"item_id": "clean_bandage", "inventory": inventory})
	_assert(missing.error == "missing_item", "battle item command fails when inventory is empty")

func _test_battle_status_effects_apply_and_tick() -> void:
	var BattleController = load("res://scripts/battle/battle_controller.gd")
	var battle = BattleController.new()
	battle.start_battle([
		{"id": "lead", "name": "Sev", "class_id": "vanguard", "level": 1, "xp": 0, "hp": 100, "stats": {"max_hp": 100, "strength": 10, "defense": 5, "speed": 8}}
	], [
		{"id": "wretch", "name": "Wretch", "hp": 40, "max_hp": 40, "strength": 4, "defense": 2, "speed": 5, "xp": 10}
	])
	_assert(battle.has_method("apply_status"), "battle controller exposes status application")
	_assert(battle.has_method("tick_status_effects"), "battle controller exposes status ticking")
	if battle.has_method("apply_status") and battle.has_method("tick_status_effects"):
		battle.apply_status("wretch", "poison", {"potency": 6, "turns": 2})
		_assert(battle.enemies[0].statuses.poison.turns == 2, "status application stores turns")
		var tick = battle.tick_status_effects("wretch")
		_assert(tick.damage == 6, "poison tick deals configured damage")
		_assert(battle.enemies[0].hp == 34, "status tick reduces HP")
		_assert(battle.enemies[0].statuses.poison.turns == 1, "status tick decrements duration")
		battle.tick_status_effects("wretch")
		_assert(not battle.enemies[0].statuses.has("poison"), "status expires when turns reach zero")

func _test_enemy_ai_profiles_choose_actions() -> void:
	var BattleController = load("res://scripts/battle/battle_controller.gd")
	var battle = BattleController.new()
	battle.start_battle([
		{"id": "lead", "name": "Sev", "class_id": "vanguard", "level": 1, "xp": 0, "hp": 30, "stats": {"max_hp": 100, "strength": 10, "defense": 5, "speed": 8}}
	], [
		{"id": "rot_choir", "name": "Rot Choir", "hp": 20, "max_hp": 64, "strength": 6, "defense": 3, "speed": 5, "xp": 38, "ai_profile": "support"}
	])
	_assert(battle.has_method("choose_enemy_action"), "battle controller exposes enemy AI action choice")
	if battle.has_method("choose_enemy_action"):
		var action = battle.choose_enemy_action("rot_choir")
		_assert(action.command == "skill", "support AI chooses a skill action")
		_assert(action.skill_id == "clean_wound", "support AI chooses healing when low HP")
	battle.enemies[0].hp = 64
	battle.enemies[0].ai_profile = "aggressive"
	if battle.has_method("choose_enemy_action"):
		var aggressive = battle.choose_enemy_action("rot_choir")
		_assert(aggressive.command == "attack", "aggressive AI chooses attack")
		_assert(aggressive.target_id == "lead", "enemy AI targets lead party member")

func _test_enemy_ai_targets_first_living_party_member() -> void:
	var BattleController = load("res://scripts/battle/battle_controller.gd")
	var battle = BattleController.new()
	battle.start_battle([
		{"id": "lead", "name": "Sev", "class_id": "vanguard", "level": 1, "xp": 0, "hp": 0, "stats": {"max_hp": 100, "strength": 10, "defense": 5, "speed": 8}},
		{"id": "mira_venn", "name": "Mira Venn", "class_id": "plague_apothecary", "level": 1, "xp": 0, "hp": 72, "stats": {"max_hp": 92, "magic": 15, "defense": 5, "speed": 8}},
	], [
		{"id": "clean_man", "name": "Clean Man", "hp": 88, "max_hp": 88, "strength": 11, "defense": 6, "speed": 8, "xp": 55, "ai_profile": "aggressive"}
	])
	var action = battle.choose_enemy_action("clean_man")
	_assert(action.target_id == "mira_venn", "enemy AI targets the first living party member when lead is KO")

func _test_starting_relic_modifies_battle_stats() -> void:
	var BattleController = load("res://scripts/battle/battle_controller.gd")
	var battle = BattleController.new()
	battle.start_battle([
		{"id": "lead", "name": "Sev", "class_id": "spellblade", "level": 1, "xp": 0, "stats": {"max_hp": 100, "strength": 10, "magic": 7, "defense": 5, "speed": 8}, "equipped_relic": "archive_needle"}
	], [
		{"id": "wretch", "name": "Wretch", "hp": 30, "max_hp": 30, "strength": 4, "defense": 2, "speed": 5, "xp": 10}
	])
	_assert(battle.party[0].stats.magic == 11, "archive needle increases battle magic")
	var result = battle.execute_command("lead", "attack", "wretch")
	_assert(result.damage == 8, "archive needle does not increase physical attack damage")
	var guard_battle = BattleController.new()
	guard_battle.start_battle([
		{"id": "lead", "name": "Sev", "class_id": "warden", "level": 1, "xp": 0, "stats": {"max_hp": 100, "strength": 10, "magic": 7, "defense": 5, "speed": 8}, "equipped_relic": "guard_shard"}
	], [
		{"id": "wretch", "name": "Wretch", "hp": 30, "max_hp": 30, "strength": 4, "defense": 2, "speed": 5, "xp": 10}
	])
	_assert(guard_battle.party[0].stats.defense == 9, "guard shard increases battle defense")

func _test_equipped_memory_card_modifies_battle_stats() -> void:
	var BattleController = load("res://scripts/battle/battle_controller.gd")
	var battle = BattleController.new()
	battle.start_battle([
		{"id": "lead", "name": "Sev", "class_id": "vanguard", "level": 1, "xp": 0, "stats": {"max_hp": 100, "strength": 10, "magic": 7, "defense": 5, "speed": 8}, "equipped_memory_cards": ["locked_door", "calling_name"]}
	], [
		{"id": "wretch", "name": "Wretch", "hp": 30, "max_hp": 30, "strength": 4, "defense": 2, "speed": 5, "xp": 10}
	])
	_assert(battle.party[0].stats.defense == 6, "locked door memory card increases defense")
	_assert(battle.party[0].stats.speed == 9, "calling name memory card increases speed")

func _test_boss_victory_requests_time_fracture() -> void:
	var BattleController = load("res://scripts/battle/battle_controller.gd")
	var battle = BattleController.new()
	battle.start_battle([
		{"id": "lead", "name": "Mira", "class_id": "spellblade", "level": 2, "xp": 0, "stats": {"max_hp": 140, "strength": 40, "defense": 10, "speed": 12}}
	], [
		{"id": "bell_saint", "name": "Bell Saint", "hp": 10, "max_hp": 10, "strength": 14, "defense": 3, "speed": 9, "xp": 150, "boss": true, "next_flow": "anchor_recovered", "relic": "bell_clapper", "memory_card": "bell_saint"}
	])
	battle.execute_command("lead", "attack", "bell_saint")
	var rewards = battle.resolve_victory()
	_assert(rewards.next_flow == "anchor_recovered", "boss victory requests configured story transition")
	_assert(rewards.relics == ["bell_clapper"], "boss victory grants configured anchor relic")
	_assert(rewards.memory_cards == ["bell_saint"], "boss victory grants configured memory card")

func _test_inventory_adds_and_consumes_items() -> void:
	_assert(ResourceLoader.exists("res://scripts/progression/inventory_service.gd"), "inventory service exists")
	var InventoryService = load("res://scripts/progression/inventory_service.gd")
	var service = InventoryService.new()
	var inventory = {"potion": 1}
	service.add_items(inventory, {"potion": 2, "iron_ring": 1})
	_assert(inventory.potion == 3, "inventory merges item stacks")
	_assert(inventory.iron_ring == 1, "inventory adds new item stacks")
	_assert(service.consume_item(inventory, "potion"), "inventory consumes existing item")
	_assert(inventory.potion == 2, "consume decrements item stack")
	_assert(not service.consume_item(inventory, "ether"), "consume fails for missing item")

func _test_memory_cards_acquire_equip_and_effects() -> void:
	_assert(ResourceLoader.exists("res://scripts/progression/memory_card_service.gd"), "memory card service exists")
	var MemoryCardService = load("res://scripts/progression/memory_card_service.gd")
	var service = MemoryCardService.new()
	var state = {"owned": [], "equipped": []}
	_assert(service.acquire_card(state, "bell_saint"), "acquiring a new memory card succeeds")
	_assert(not service.acquire_card(state, "bell_saint"), "acquiring a duplicate memory card is ignored")
	_assert(state.owned.size() == 1, "duplicate acquisition does not duplicate owned cards")
	_assert(not service.equip_card(state, "the_empty_train"), "cannot equip an unowned memory card")
	_assert(service.equip_card(state, "bell_saint"), "owned memory card can be equipped")
	_assert(state.equipped == ["bell_saint"], "equipped memory card is tracked")
	var effects = service.equipped_effects(state)
	_assert(effects.disease_damage_multiplier == 0.9, "equipped Bell Saint card applies disease damage modifier")

func _test_treasure_pickup_sets_flag_and_merges_loot() -> void:
	_assert(ResourceLoader.exists("res://scripts/field/treasure_service.gd"), "treasure service exists")
	var TreasureService = load("res://scripts/field/treasure_service.gd")
	var service = TreasureService.new()
	var state = {"inventory": {"potion": 1}, "flags": {}}
	var result = service.pickup(state, {
		"id": "dungeon_chest_01",
		"loot": {"potion": 1, "iron_ring": 1}
	})
	_assert(result.collected, "first treasure pickup succeeds")
	_assert(state.inventory.potion == 2, "treasure merges stackable loot")
	_assert(state.inventory.iron_ring == 1, "treasure adds new loot")
	_assert(state.flags.treasure_dungeon_chest_01, "treasure pickup sets story flag")
	var second = service.pickup(state, {"id": "dungeon_chest_01", "loot": {"potion": 99}})
	_assert(not second.collected, "already collected treasure cannot be collected again")
	_assert(state.inventory.potion == 2, "already collected treasure does not duplicate loot")

func _test_tetra_card_catalog_loads_unity_style_cards() -> void:
	_assert(ResourceLoader.exists("res://data/tetra/tetra_cards.json"), "tetra card data exists")
	_assert(ResourceLoader.exists("res://scripts/cards/tetra_card_catalog.gd"), "tetra card catalog exists")
	var TetraCardCatalog = load("res://scripts/cards/tetra_card_catalog.gd")
	var catalog = TetraCardCatalog.new()
	var goblin = catalog.card("goblin_wretch")
	_assert(goblin.name == "Goblin Wretch", "tetra catalog loads card name")
	_assert(goblin.power == 1, "tetra catalog loads card power")
	_assert(goblin.physical_defense == 2, "tetra catalog maps physical defense")
	_assert(goblin.magic_defense == 0, "tetra catalog maps magic defense")
	_assert(goblin.card_type == "PHYSICAL", "tetra catalog loads card type")
	_assert(goblin.directions.size() == 8, "tetra catalog stores eight arrow directions")
	_assert(catalog.starter_deck().size() == 5, "tetra catalog exposes starter deck")

func _test_tetra_monster_card_generator_uses_enemy_database() -> void:
	_assert(ResourceLoader.exists("res://scripts/cards/tetra_monster_card_generator.gd"), "tetra monster card generator exists")
	var Generator = load("res://scripts/cards/tetra_monster_card_generator.gd")
	var generator = Generator.new()
	var slime = generator.card_for_enemy("slime")
	_assert(slime.id == "monster_slime", "monster card generator creates stable card id")
	_assert(slime.name == "Slime", "monster card generator title-cases enemy id")
	_assert(slime.power == 2, "monster card generator derives power from strength")
	_assert(slime.physical_defense == 1, "monster card generator derives physical defense")
	_assert(slime.magic_defense == 1, "monster card generator derives magic defense")
	_assert(slime.directions.size() == 8, "monster card generator creates eight arrows")
	_assert(slime.image.ends_with("face_character_01.png"), "monster card generator assigns curated card art")
	var all_cards = generator.all_enemy_cards()
	_assert(all_cards.has("monster_slime"), "monster card generator includes slime in all cards")
	_assert(all_cards.has("monster_chronal_warden"), "monster card generator includes boss cards")

func _test_tetra_card_template_catalog_resolves_exported_templates() -> void:
	_assert(ResourceLoader.exists("res://scripts/cards/tetra_card_template_catalog.gd"), "tetra card template catalog exists")
	var TemplateCatalog = load("res://scripts/cards/tetra_card_template_catalog.gd")
	var catalog = TemplateCatalog.new()
	_assert(catalog.path_for_id("vintage").ends_with("vintage_frame_template.png"), "template catalog resolves vintage frame")
	_assert(FileAccess.file_exists(catalog.path_for_id("frame")), "template catalog frame file exists")
	_assert(catalog.path_for_id("bad_template").ends_with("card_frame_template.png"), "template catalog falls back invalid template")

func _test_tetra_card_view_formats_card_data() -> void:
	_assert(ResourceLoader.exists("res://scripts/cards/tetra_card_view.gd"), "tetra card view script exists")
	var CardView = load("res://scripts/cards/tetra_card_view.gd")
	var view = CardView.new()
	var display = view.display_data({
		"name": "Goblin Wretch",
		"power": 15,
		"physical_defense": 3,
		"magic_defense": 1,
		"card_type": "PHYSICAL",
		"directions": [true, false, true, false, false, false, false, false],
		"image": "res://assets/cards/faces/face_character_01.png"
	})
	_assert(display.power == "F", "tetra card view formats power as hex")
	_assert(display.card_type == "P", "tetra card view shortens physical type")
	_assert(display.active_directions == ["N", "E"], "tetra card view lists active arrows")
	view.free()

func _test_tetra_card_view_scene_renders_card_nodes() -> void:
	_assert(ResourceLoader.exists("res://scenes/cards/tetra_card_view.tscn"), "tetra card view scene exists")
	var scene = load("res://scenes/cards/tetra_card_view.tscn")
	var view = scene.instantiate()
	root.add_child(view)
	view.apply_card({
		"name": "Bell Acolyte",
		"power": 10,
		"physical_defense": 1,
		"magic_defense": 4,
		"card_type": "MAGICAL",
		"directions": [false, true, false, false, true, false, false, false],
		"image": "res://assets/cards/faces/face_character_02.png",
		"template": "vintage"
	})
	_assert(view.get_node("PowerLabel").text == "A", "tetra card scene renders hex power")
	_assert(view.get_node("TypeLabel").text == "M", "tetra card scene renders card type")
	_assert(view.get_node("ArrowLabel").text == "NE S", "tetra card scene renders active arrows")
	view.queue_free()

func _test_tetra_rules_hex_and_arrow_pressure() -> void:
	_assert(ResourceLoader.exists("res://scripts/cards/tetra_rules.gd"), "tetra rules exists")
	var TetraRules = load("res://scripts/cards/tetra_rules.gd")
	var rules = TetraRules.new()
	_assert(rules.to_hex_stat(15) == "F", "tetra rules formats 15 as F")
	_assert(rules.to_hex_stat(16) == "F", "tetra rules clamps high values to F")
	_assert(rules.to_hex_stat(-1) == "0", "tetra rules clamps low values to 0")
	var attacker = {"power": 5, "physical_defense": 1, "magic_defense": 0, "card_type": "PHYSICAL", "directions": [true, false, false, false, false, false, false, false]}
	var defender = {"power": 2, "physical_defense": 3, "magic_defense": 1, "card_type": "MAGICAL", "directions": [false, false, false, false, true, false, false, false]}
	_assert(rules.has_arrow(attacker, "N"), "tetra rules reads named arrows")
	_assert(rules.has_arrow(defender, "S"), "tetra rules reads opposite arrows")
	_assert(rules.attack_value(attacker) == 5, "physical tetra attack uses power")
	_assert(rules.defense_value(attacker, defender) == 3, "physical tetra attack targets physical defense")

func _test_tetra_board_places_cards_and_tracks_owner() -> void:
	_assert(ResourceLoader.exists("res://scripts/cards/tetra_board.gd"), "tetra board exists")
	var TetraBoard = load("res://scripts/cards/tetra_board.gd")
	var board = TetraBoard.new()
	_assert(board.is_empty(1, 1), "new tetra board starts empty")
	_assert(board.place_card(1, 1, {"id": "goblin_wretch"}, 0), "tetra board places card")
	_assert(not board.is_empty(1, 1), "tetra board slot is occupied after placement")
	_assert(board.owner_at(1, 1) == 0, "tetra board tracks owner")
	_assert(not board.place_card(1, 1, {"id": "bell_acolyte"}, 1), "tetra board rejects occupied slot")
	_assert(not board.place_card(3, 0, {"id": "bad"}, 1), "tetra board rejects out of bounds slot")

func _test_tetra_board_flips_adjacent_cards_by_arrow_pressure() -> void:
	var TetraBoard = load("res://scripts/cards/tetra_board.gd")
	var board = TetraBoard.new()
	var attacker = {
		"id": "attacker",
		"power": 5,
		"physical_defense": 1,
		"magic_defense": 1,
		"card_type": "PHYSICAL",
		"directions": [true, false, true, false, false, false, false, false]
	}
	var weak_defender = {
		"id": "weak_defender",
		"power": 1,
		"physical_defense": 2,
		"magic_defense": 1,
		"card_type": "PHYSICAL",
		"directions": [false, false, false, false, false, false, false, false]
	}
	var sturdy_defender = {
		"id": "sturdy_defender",
		"power": 1,
		"physical_defense": 8,
		"magic_defense": 1,
		"card_type": "PHYSICAL",
		"directions": [false, false, false, false, false, false, false, false]
	}
	board.place_card(1, 0, weak_defender, 1)
	board.place_card(2, 1, sturdy_defender, 1)
	_assert(board.place_card(1, 1, attacker, 0), "tetra board places attacker before capture")
	var captured = board.resolve_captures_from(1, 1)
	_assert(captured == [Vector2i(1, 0)], "tetra board reports captured positions")
	_assert(board.owner_at(1, 0) == 0, "tetra board flips weak adjacent defender")
	_assert(board.owner_at(2, 1) == 1, "tetra board does not flip sturdy defender")

func _test_minigame_catalog_maps_pixel_perfect_games_to_world_locations() -> void:
	_assert(ResourceLoader.exists("res://scripts/core/minigame_catalog.gd"), "minigame catalog exists")
	var MinigameCatalog = load("res://scripts/core/minigame_catalog.gd")
	var catalog = MinigameCatalog.new()
	var arcade_games = catalog.for_location("modern_arcade")
	_assert(arcade_games.size() >= 2, "modern arcade has multiple minigames")
	_assert(arcade_games[0].has("asset_source"), "minigame entries keep source asset folder")
	_assert(arcade_games[0].asset_source.begins_with("C:/dev/Godot Game/Assets/PIXEL PERFECT ULTIMATE GAME COMPONENT KIT'"), "minigame asset source points to Pixel Perfect kit")
	var living_room_games = catalog.for_location("living_room")
	_assert(living_room_games.any(func(game): return game.id == "archive_reversi"), "living rooms can host Reversi")
	var game_rooms = catalog.for_location("game_room")
	_assert(game_rooms.any(func(game): return game.id == "museum_pool"), "game rooms can host pool")

func _test_minigame_catalog_unlocks_by_story_chapter() -> void:
	var MinigameCatalog = load("res://scripts/core/minigame_catalog.gd")
	var catalog = MinigameCatalog.new()
	var prologue_games = catalog.unlocked_for_chapter(0)
	_assert(prologue_games.any(func(game): return game.id == "memory_cards_tetra"), "Tetra card game is available from the opening hub")
	_assert(catalog.get_minigame("memory_cards_tetra").scene_path == "res://scenes/minigames/tetra_play_screen.tscn", "Tetra minigame points to playable scene")
	_assert(ResourceLoader.exists(catalog.get_minigame("memory_cards_tetra").scene_path), "Tetra minigame scene path exists")
	_assert(not prologue_games.any(func(game): return game.id == "trench_dominoes"), "later-era minigames stay locked at prologue")
	var modern_games = catalog.unlocked_for_chapter(6)
	_assert(modern_games.any(func(game): return game.id == "trench_dominoes"), "WWI table games unlock by modern chapter")
	_assert(modern_games.any(func(game): return game.id == "bunker_poker"), "poker unlocks for later social spaces")

func _test_minigame_host_filters_location_and_chapter() -> void:
	_assert(ResourceLoader.exists("res://scripts/minigames/minigame_host.gd"), "minigame host script exists")
	var MinigameHost = load("res://scripts/minigames/minigame_host.gd")
	var host = MinigameHost.new()
	host.location_id = "modern_arcade"
	host.available_chapter = 0
	var early_games = host.available_games()
	_assert(early_games.any(func(game): return game.id == "memory_cards_tetra"), "host exposes early Tetra game")
	_assert(not early_games.any(func(game): return game.id == "museum_pool"), "host hides locked modern games")
	host.available_chapter = 6
	var later_games = host.available_games()
	_assert(later_games.any(func(game): return game.id == "museum_pool"), "host exposes later location games after unlock")
	host.free()

func _test_minigame_host_requests_launch_payload() -> void:
	var MinigameHost = load("res://scripts/minigames/minigame_host.gd")
	var host = MinigameHost.new()
	host.location_id = "game_room"
	host.available_chapter = 6
	var payload = host.launch_payload("museum_pool")
	_assert(payload.id == "museum_pool", "host launch payload includes game id")
	_assert(payload.location_id == "game_room", "host launch payload includes source location")
	_assert(payload.asset_source.ends_with("Pool and Snooker"), "host launch payload includes resolved asset source")
	_assert(host.launch_payload("trench_dominoes").is_empty(), "host rejects games not available at this location")
	host.free()

func _test_minigame_host_scene_smoke() -> void:
	_assert(ResourceLoader.exists("res://scenes/minigames/minigame_host.tscn"), "minigame host scene exists")
	var scene = load("res://scenes/minigames/minigame_host.tscn")
	var host = scene.instantiate()
	host.location_id = "living_room"
	host.available_chapter = 6
	root.add_child(host)
	host.refresh()
	_assert(host.get_node("TitleLabel").text == "Minigames", "host scene renders title")
	_assert(host.get_node("GameListLabel").text.contains("Archive Reversi"), "host scene renders available games")
	host.queue_free()

func _test_tetra_play_screen_uses_board_art_and_slots() -> void:
	_assert(FileAccess.file_exists("res://assets/cards/boards/tetra_master_board.png"), "curated tetra board art exists")
	_assert(ResourceLoader.exists("res://scenes/minigames/tetra_play_screen.tscn"), "tetra play screen scene exists")
	var scene = load("res://scenes/minigames/tetra_play_screen.tscn")
	var screen = scene.instantiate()
	root.add_child(screen)
	screen.setup_new_match()
	_assert(screen.get_node("BoardTexture").texture != null, "tetra play screen loads board texture")
	_assert(screen.board_display_size() == Vector2(371, 500), "tetra play screen displays board at native size")
	_assert(screen.board_slot_positions().size() == 9, "tetra play screen exposes nine board slots")
	_assert(screen.board_card_size().x <= screen.board_slot_size().x, "tetra board card width fits inside slot")
	_assert(screen.board_card_size().y <= screen.board_slot_size().y, "tetra board card height fits inside slot")
	_assert(screen.board_slots_do_not_overlap(), "tetra board slots do not overlap")
	_assert(screen.card_rect_for_slot(4).size == screen.board_card_size(), "tetra card placement rect uses board card size")
	_assert(screen.slot_rect_for_index(4).encloses(screen.card_rect_for_slot(4)), "tetra placed card rect stays inside slot")
	_assert(screen.player_hand.size() == 5, "tetra play screen loads five starter hand cards")
	_assert(screen.get_node("StatusLabel").text.contains("Memory Cards"), "tetra play screen renders match title")
	screen.queue_free()

func _test_tetra_play_screen_places_visual_card_in_board_slot() -> void:
	var scene = load("res://scenes/minigames/tetra_play_screen.tscn")
	var screen = scene.instantiate()
	root.add_child(screen)
	screen.setup_new_match()
	_assert(screen.place_player_card_from_hand(0, 4), "tetra play screen places first hand card in center slot")
	_assert(screen.player_hand.size() == 4, "placing card removes it from player hand")
	var card_node = screen.get_node("PlacedCards/Slot4")
	_assert(card_node != null, "tetra play screen creates placed card node")
	_assert(card_node.size == screen.board_card_size(), "placed card node uses board card size")
	_assert(screen.slot_rect_for_index(4).encloses(Rect2(card_node.position, card_node.size)), "placed card node fits inside board slot")
	_assert(screen.board.owner_at(1, 1) == 0, "placing card updates board owner")
	screen.queue_free()

func _test_tetra_play_screen_rejects_invalid_card_placements() -> void:
	var scene = load("res://scenes/minigames/tetra_play_screen.tscn")
	var screen = scene.instantiate()
	root.add_child(screen)
	screen.setup_new_match()
	_assert(not screen.place_player_card_from_hand(-1, 0), "tetra play screen rejects negative hand index")
	_assert(not screen.place_player_card_from_hand(0, 9), "tetra play screen rejects out of range slot")
	_assert(screen.player_hand.size() == 5, "invalid placement does not consume hand card")
	_assert(screen.place_player_card_from_hand(0, 0), "tetra play screen accepts first valid placement")
	_assert(not screen.place_player_card_from_hand(0, 0), "tetra play screen rejects occupied slot")
	_assert(screen.player_hand.size() == 4, "occupied slot rejection does not consume another hand card")
	screen.queue_free()

func _test_tetra_play_screen_updates_visuals_after_capture() -> void:
	var scene = load("res://scenes/minigames/tetra_play_screen.tscn")
	var screen = scene.instantiate()
	root.add_child(screen)
	screen.setup_new_match()
	var weak_defender = {
		"id": "weak_defender",
		"name": "Weak Defender",
		"power": 1,
		"physical_defense": 1,
		"magic_defense": 1,
		"card_type": "PHYSICAL",
		"directions": [false, false, false, false, false, false, false, false]
	}
	var strong_attacker = {
		"id": "strong_attacker",
		"name": "Strong Attacker",
		"power": 5,
		"physical_defense": 1,
		"magic_defense": 1,
		"card_type": "PHYSICAL",
		"directions": [true, false, false, false, false, false, false, false]
	}
	_assert(screen.place_card_for_owner(1, weak_defender, 1), "tetra play screen places opponent setup card")
	screen.set_player_hand([strong_attacker])
	_assert(screen.place_player_card_from_hand(0, 4), "tetra play screen places capturing card")
	_assert(screen.board.owner_at(1, 0) == 0, "capture changes board owner")
	var captured_node = screen.get_node("PlacedCards/Slot1")
	_assert(captured_node.get_meta("owner") == 0, "capture updates placed card visual owner metadata")
	_assert(captured_node.color == screen.color_for_owner(0), "capture updates placed card visual color")
	screen.queue_free()

func _test_tetra_play_screen_scores_board_ownership() -> void:
	var scene = load("res://scenes/minigames/tetra_play_screen.tscn")
	var screen = scene.instantiate()
	root.add_child(screen)
	screen.setup_new_match()
	screen.place_card_for_owner(0, {"id": "p1", "name": "P1", "power": 1, "directions": []}, 0)
	screen.place_card_for_owner(1, {"id": "p2", "name": "P2", "power": 1, "directions": []}, 0)
	screen.place_card_for_owner(8, {"id": "o1", "name": "O1", "power": 1, "directions": []}, 1)
	var score = screen.score()
	_assert(score.player == 2, "tetra score counts player owned cards")
	_assert(score.opponent == 1, "tetra score counts opponent owned cards")
	_assert(score.empty == 6, "tetra score counts empty board slots")
	screen.queue_free()

func _test_tetra_play_screen_opponent_turn_places_legal_card() -> void:
	var scene = load("res://scenes/minigames/tetra_play_screen.tscn")
	var screen = scene.instantiate()
	root.add_child(screen)
	screen.setup_new_match()
	screen.place_player_card_from_hand(0, 0)
	var opponent_card = {
		"id": "opponent_basic",
		"name": "Opponent Basic",
		"power": 1,
		"physical_defense": 1,
		"magic_defense": 1,
		"card_type": "PHYSICAL",
		"directions": [false, false, false, false, false, false, false, false]
	}
	screen.set_opponent_hand([opponent_card])
	var move = screen.choose_opponent_move()
	_assert(move.hand_index == 0, "opponent chooses first card from hand")
	_assert(move.slot_index != 0, "opponent chooses an empty slot")
	_assert(screen.play_opponent_turn(), "opponent turn places legal card")
	_assert(screen.opponent_hand.size() == 0, "opponent turn consumes card")
	_assert(screen.score().opponent == 1, "opponent turn updates score")
	_assert(screen.get_node("PlacedCards/Slot%d" % move.slot_index).get_meta("owner") == 1, "opponent turn renders opponent-owned card")
	screen.queue_free()

func _test_tetra_play_screen_opponent_turn_rejects_full_board() -> void:
	var scene = load("res://scenes/minigames/tetra_play_screen.tscn")
	var screen = scene.instantiate()
	root.add_child(screen)
	screen.setup_new_match()
	for index in 9:
		screen.place_card_for_owner(index, {"id": "fill_%d" % index, "name": "Fill", "power": 1, "directions": []}, 0)
	screen.set_opponent_hand([{"id": "opponent_basic", "name": "Opponent Basic", "power": 1, "directions": []}])
	_assert(screen.choose_opponent_move().is_empty(), "opponent has no move on full board")
	_assert(not screen.play_opponent_turn(), "opponent turn fails on full board")
	_assert(screen.opponent_hand.size() == 1, "failed opponent turn does not consume hand")
	screen.queue_free()

func _test_tetra_play_screen_tracks_turn_and_match_over() -> void:
	var scene = load("res://scenes/minigames/tetra_play_screen.tscn")
	var screen = scene.instantiate()
	root.add_child(screen)
	screen.setup_new_match()
	_assert(screen.current_turn == 0, "tetra match starts on player turn")
	screen.place_player_card_from_hand(0, 0)
	_assert(screen.current_turn == 1, "player placement passes turn to opponent")
	screen.set_opponent_hand([{"id": "opponent_basic", "name": "Opponent Basic", "power": 1, "directions": []}])
	screen.play_opponent_turn()
	_assert(screen.current_turn == 0, "opponent placement passes turn to player")
	for index in range(2, 9):
		screen.place_card_for_owner(index, {"id": "fill_%d" % index, "name": "Fill", "power": 1, "directions": []}, 0)
	_assert(screen.is_match_over(), "tetra match reports over when board is full")
	_assert(screen.match_result().winner == "player", "tetra match result reports current winner")
	screen.queue_free()

func _test_tetra_play_screen_renders_hand_score_and_turn_status() -> void:
	var scene = load("res://scenes/minigames/tetra_play_screen.tscn")
	var screen = scene.instantiate()
	root.add_child(screen)
	screen.setup_new_match()
	_assert(screen.get_node("PlayerHandLabel").text.contains("Player Hand: 5"), "tetra screen renders player hand count")
	_assert(screen.get_node("OpponentHandLabel").text.contains("Opponent Hand: 5"), "tetra screen renders opponent hand count")
	_assert(screen.get_node("ScoreLabel").text == "Score 0-0", "tetra screen renders initial score")
	_assert(screen.get_node("TurnLabel").text == "Player Turn", "tetra screen renders player turn")
	screen.place_player_card_from_hand(0, 0)
	_assert(screen.get_node("PlayerHandLabel").text.contains("Player Hand: 4"), "tetra screen updates player hand count after placement")
	_assert(screen.get_node("ScoreLabel").text == "Score 1-0", "tetra screen updates score after placement")
	_assert(screen.get_node("TurnLabel").text == "Opponent Turn", "tetra screen updates turn after player placement")
	screen.queue_free()

func _test_tetra_play_screen_renders_match_over_status() -> void:
	var scene = load("res://scenes/minigames/tetra_play_screen.tscn")
	var screen = scene.instantiate()
	root.add_child(screen)
	screen.setup_new_match()
	for index in 9:
		screen.place_card_for_owner(index, {"id": "fill_%d" % index, "name": "Fill", "power": 1, "directions": []}, 0)
	screen.refresh_match_status()
	_assert(screen.get_node("TurnLabel").text == "Match Over: Player", "tetra screen renders match over status")
	_assert(screen.get_node("ScoreLabel").text == "Score 9-0", "tetra screen renders final score")
	screen.queue_free()

func _test_tetra_play_screen_renders_selectable_player_hand_buttons() -> void:
	var scene = load("res://scenes/minigames/tetra_play_screen.tscn")
	var screen = scene.instantiate()
	root.add_child(screen)
	screen.setup_new_match()
	_assert(screen.get_node("PlayerHandButtons").get_child_count() == 5, "tetra screen renders one button per player hand card")
	var first_button = screen.get_node("PlayerHandButtons").get_child(0)
	_assert(first_button.text.contains(screen.player_hand[0].name), "tetra hand button uses card name")
	_assert(first_button.text.contains("P:"), "tetra hand button shows power")
	screen.queue_free()

func _test_tetra_play_screen_selects_hand_and_plays_slot() -> void:
	var scene = load("res://scenes/minigames/tetra_play_screen.tscn")
	var screen = scene.instantiate()
	root.add_child(screen)
	screen.setup_new_match()
	_assert(screen.select_player_hand_card(0), "tetra screen selects player hand card")
	_assert(screen.selected_hand_index == 0, "tetra screen tracks selected hand index")
	_assert(screen.play_selected_card_to_slot(4), "tetra screen plays selected card to slot")
	_assert(screen.selected_hand_index == -1, "tetra screen clears selection after play")
	_assert(screen.board.owner_at(1, 1) == 0, "tetra selected play updates board")
	_assert(screen.get_node("PlayerHandButtons").get_child_count() == 4, "tetra selected play rerenders hand buttons")
	screen.queue_free()

func _test_tetra_play_screen_player_move_can_auto_run_opponent_turn() -> void:
	var scene = load("res://scenes/minigames/tetra_play_screen.tscn")
	var screen = scene.instantiate()
	root.add_child(screen)
	screen.setup_new_match()
	screen.auto_play_opponent = true
	screen.set_opponent_hand([{"id": "opponent_basic", "name": "Opponent Basic", "power": 1, "directions": []}])
	screen.select_player_hand_card(0)
	_assert(screen.play_selected_card_to_slot(0), "tetra screen accepts player move")
	_assert(screen.current_turn == 0, "auto opponent turn returns control to player")
	_assert(screen.score().player == 1, "auto flow keeps player card")
	_assert(screen.score().opponent == 1, "auto flow places opponent card")
	_assert(screen.opponent_hand.is_empty(), "auto opponent turn consumes opponent hand card")
	screen.queue_free()

func _test_tetra_play_screen_emits_match_finished_payload() -> void:
	var scene = load("res://scenes/minigames/tetra_play_screen.tscn")
	var screen = scene.instantiate()
	var emitted: Array = []
	screen.match_finished.connect(func(payload): emitted.append(payload))
	root.add_child(screen)
	screen.setup_new_match()
	for index in range(0, 8):
		screen.place_card_for_owner(index, {"id": "fill_%d" % index, "name": "Fill", "power": 1, "directions": []}, 0)
	screen.set_player_hand([{"id": "last", "name": "Last", "power": 1, "directions": []}])
	_assert(screen.place_player_card_from_hand(0, 8), "tetra final player placement succeeds")
	_assert(emitted.size() == 1, "tetra screen emits match finished once")
	_assert(emitted[0].winner == "player", "tetra match finished payload includes winner")
	_assert(emitted[0].score.player == 9, "tetra match finished payload includes final score")
	screen.queue_free()

func _test_tetra_play_screen_opponent_prefers_capturing_move() -> void:
	var scene = load("res://scenes/minigames/tetra_play_screen.tscn")
	var screen = scene.instantiate()
	root.add_child(screen)
	screen.setup_new_match()
	var weak_player = {
		"id": "weak_player",
		"name": "Weak Player",
		"power": 1,
		"physical_defense": 1,
		"magic_defense": 1,
		"card_type": "PHYSICAL",
		"directions": [false, false, false, false, false, false, false, false]
	}
	var capturing_card = {
		"id": "capture",
		"name": "Capture",
		"power": 5,
		"physical_defense": 1,
		"magic_defense": 1,
		"card_type": "PHYSICAL",
		"directions": [false, false, true, false, false, false, false, false]
	}
	screen.place_card_for_owner(4, weak_player, 0)
	screen.set_opponent_hand([capturing_card])
	var move = screen.choose_opponent_move()
	_assert(move.slot_index == 3, "opponent chooses slot that captures adjacent card")
	screen.play_opponent_turn()
	_assert(screen.board.owner_at(1, 1) == 1, "opponent capture flips player card")
	screen.queue_free()

func _test_field_controller_resolves_minigame_interaction() -> void:
	var FieldController = load("res://scripts/field/field_controller.gd")
	var field = FieldController.new()
	var result = field.resolve_interaction_result({
		"type": "minigame_host",
		"location_id": "game_room",
		"games": [{"id": "museum_pool", "name": "Museum Pool"}]
	})
	_assert(result.status == "Choose a minigame.", "field controller labels minigame interactions")
	_assert(result.audio_event == "ui_confirm", "field controller uses confirm audio for minigame host")
	_assert(result.open_minigame_menu, "field controller requests minigame menu")

func _test_bell_saint_story_slice_data() -> void:
	_assert(ResourceLoader.exists("res://data/story/first_slice.json"), "first slice story data exists")
	var file := FileAccess.open("res://data/story/first_slice.json", FileAccess.READ)
	var data = JSON.parse_string(file.get_as_text())
	_assert(data.title == "The Last World Museum", "story data uses final working title")
	_assert(data.slice_name == "The Bell Saint", "story data names first slice")
	_assert(data.anchor_relic.id == "bell_clapper", "plague anchor relic is the Bell Clapper")
	_assert(data.flow.has("empty_rotunda"), "first slice starts in the museum rotunda")
	_assert(data.flow.has("underchapel_drain"), "first slice includes Underchapel Drain dungeon")
	_assert(data.flow.has("bell_tower_boss_room"), "first slice reaches the bell tower boss room")
	_assert(data.boss.id == "bell_saint", "first slice boss is the Bell Saint")
	_assert(data.curator_hook == "Unauthorized truth recovered. Correction required.", "Curator hook line is preserved")

func _test_story_flow_service_loads_and_advances_slice() -> void:
	_assert(ResourceLoader.exists("res://scripts/core/story_flow_service.gd"), "story flow service exists")
	var StoryFlowService = load("res://scripts/core/story_flow_service.gd")
	var flow = StoryFlowService.new()
	flow.load_first_slice()
	_assert(flow.title == "The Last World Museum", "story flow loads title")
	_assert(flow.slice_name == "The Bell Saint", "story flow loads slice name")
	_assert(flow.current_phase() == "character_creator", "story flow starts at character creator")
	_assert(flow.advance() == "empty_rotunda", "story flow advances into the empty rotunda")
	flow.advance()
	_assert(flow.current_phase() == "broken_exhibit_door", "story flow advances through story data")
	_assert(flow.is_field_phase("plague_town_street"), "story flow classifies story maps as field phases")
	_assert(flow.is_battle_phase("battle"), "story flow classifies battle phase")

func _test_story_flow_service_exposes_phase_metadata() -> void:
	var StoryFlowService = load("res://scripts/core/story_flow_service.gd")
	var flow = StoryFlowService.new()
	flow.load_first_slice()
	var rotunda = flow.phase_metadata("empty_rotunda")
	_assert(rotunda.display_name == "Empty Rotunda", "phase metadata includes display name")
	_assert(rotunda.mood == "sterile museum breach", "phase metadata includes mood")
	var plague_street = flow.phase_metadata("plague_town_street")
	_assert(plague_street.beat.contains("quarantine day"), "phase metadata includes story beat")
	var unknown = flow.phase_metadata("missing_phase")
	_assert(unknown.display_name == "Missing Phase", "unknown phase gets a readable fallback name")

func _test_first_slice_items_and_memory_card_data() -> void:
	var item_file := FileAccess.open("res://data/items/items.json", FileAccess.READ)
	var items = JSON.parse_string(item_file.get_as_text())
	_assert(items.clean_bandage.display_name == "Clean Bandage", "first slice includes Clean Bandage")
	_assert(items.bitter_draught.kind == "consumable", "first slice includes Bitter Draught as consumable")
	_assert(items.fever_charm.display_name == "Fever Charm", "first slice includes Fever Charm side quest reward")
	_assert(items.bell_clapper.kind == "anchor_relic", "Bell Clapper is an anchor relic item")
	_assert(ResourceLoader.exists("res://data/cards/memory_cards.json"), "memory cards data exists")
	var card_file := FileAccess.open("res://data/cards/memory_cards.json", FileAccess.READ)
	var cards = JSON.parse_string(card_file.get_as_text())
	_assert(cards.bell_saint.display_name == "The Bell Saint", "Bell Saint memory card exists")
	_assert(cards.bell_saint.type == "Monster Memory", "Bell Saint card is monster memory")
	_assert(cards.bell_saint.effect.disease_damage_multiplier == 0.9, "Bell Saint card reduces disease damage")

func _test_chapter_one_dialogue_bank_data() -> void:
	_assert(ResourceLoader.exists("res://data/dialogue/chapter_01_bell_saint.json"), "chapter one dialogue bank exists")
	var dialogue_file := FileAccess.open("res://data/dialogue/chapter_01_bell_saint.json", FileAccess.READ)
	var dialogue = JSON.parse_string(dialogue_file.get_as_text())
	_assert(dialogue.prologue.sev_wakes.lines[0].speaker == "CURATOR", "prologue starts with Curator wake line")
	_assert(dialogue.plague_wing.apothecary_first_meeting.lines[0].speaker == "ACOLYTE", "apothecary scene starts with acolyte conflict")
	_assert(dialogue.plague_wing.bell_saint_battle.lines.any(func(line): return line.text == "A lie with a bell around it."), "Bell Saint battle keeps core Sev line")
	_assert(dialogue.rewards.memory_card_unlock.reward_card == "bell_saint", "memory card unlock rewards Bell Saint card")

func _test_content_catalog_loads_items_cards_and_dialogue() -> void:
	_assert(ResourceLoader.exists("res://scripts/core/content_catalog.gd"), "content catalog exists")
	var ContentCatalog = load("res://scripts/core/content_catalog.gd")
	var catalog = ContentCatalog.new()
	_assert(catalog.item("clean_bandage").display_name == "Clean Bandage", "content catalog loads item definitions")
	_assert(catalog.memory_card("bell_saint").type == "Monster Memory", "content catalog loads memory cards")
	var scene = catalog.dialogue_scene("plague_wing", "apothecary_first_meeting")
	_assert(scene.location == "Apothecary Exterior", "content catalog loads dialogue scenes")
	_assert(catalog.item("missing_item").is_empty(), "missing item returns empty dictionary")

func _test_audio_event_catalog_defines_bell_saint_slice() -> void:
	_assert(ResourceLoader.exists("res://data/audio/audio_events.json"), "audio event catalog data exists")
	_assert(ResourceLoader.exists("res://scripts/core/audio_event_catalog.gd"), "audio event catalog script exists")
	var AudioEventCatalog = load("res://scripts/core/audio_event_catalog.gd")
	var catalog = AudioEventCatalog.new()
	var curator = catalog.event("curator_warning")
	_assert(curator.layer == "Museum", "Curator warning is a Museum-layer sound")
	_assert(curator.bus == "UI", "Curator warning routes to UI bus")
	var card = catalog.event("memory_card_reveal")
	_assert(card.layer == "Museum", "Memory card reveal is Museum-layer sound")
	_assert(card.path.ends_with(".ogg"), "runtime audio events use OGG")
	var cough = catalog.event("plague_cough")
	_assert(cough.layer == "Exhibit", "plague cough is an Exhibit-layer sound")
	var voice = catalog.event("voice_sev_warm_human")
	_assert(voice.layer == "Dialogue", "Sev voice blip uses Dialogue layer")
	_assert(voice.bus == "Dialogue", "Sev voice blip routes to Dialogue bus")
	_assert(voice.path.ends_with(".ogg"), "Sev voice blip uses OGG")
	_assert(FileAccess.file_exists(voice.path), "Sev voice blip runtime file exists")
	var curator_voice = catalog.event("voice_curator")
	_assert(curator_voice.path.ends_with(".ogg"), "Curator voice blip uses OGG")
	_assert(catalog.events_for_chapter("bell_saint").has("bell_clapper_relic"), "Bell Saint chapter includes relic cue")

func _test_audio_event_catalog_uses_dedicated_bell_saint_map_cues() -> void:
	var AudioEventCatalog = load("res://scripts/core/audio_event_catalog.gd")
	var catalog = AudioEventCatalog.new()
	var expected_paths := {
		"door_museum_open": "res://assets/audio/environment/door_museum_open_01.ogg",
		"ambience_plague_town": "res://assets/audio/environment/ambience_plague_town_01.ogg",
		"ambience_apothecary": "res://assets/audio/environment/ambience_apothecary_01.ogg",
		"ambience_chapel_bell": "res://assets/audio/environment/ambience_chapel_bell_01.ogg",
		"ambience_underchapel_drain": "res://assets/audio/environment/ambience_underchapel_drain_01.ogg",
		"ambience_hidden_hospital": "res://assets/audio/environment/ambience_hidden_hospital_01.ogg",
		"ambience_bell_tower": "res://assets/audio/environment/ambience_bell_tower_01.ogg",
	}
	for event_id in expected_paths.keys():
		var event: Dictionary = catalog.event(event_id)
		_assert(event.path == expected_paths[event_id], "%s uses its dedicated first-slice map cue" % event_id)
		_assert(String(event.path).ends_with(".ogg"), "%s uses OGG runtime audio" % event_id)
		_assert(FileAccess.file_exists(String(event.path)), "%s runtime OGG exists" % event_id)
		_assert(String(event.get("source", "")).begins_with("generated:"), "%s records generated cue provenance" % event_id)

func _test_audio_service_resolves_runtime_event() -> void:
	_assert(ResourceLoader.exists("res://scripts/core/audio_service.gd"), "audio service script exists")
	var AudioServiceScript = load("res://scripts/core/audio_service.gd")
	var service = AudioServiceScript.new()
	var resolved = service.resolve_event("curator_warning")
	_assert(resolved.id == "curator_warning", "audio service resolves event id")
	_assert(resolved.bus == "UI", "audio service preserves configured bus")
	_assert(resolved.path.ends_with(".ogg"), "audio service resolves OGG path")
	_assert(FileAccess.file_exists(resolved.path), "resolved audio file exists")
	_assert(service.resolve_event("missing_event").is_empty(), "missing audio event returns empty dictionary")
	service.free()

func _test_audio_service_manages_looped_ambience() -> void:
	var AudioServiceScript = load("res://scripts/core/audio_service.gd")
	var service = AudioServiceScript.new()
	root.add_child(service)
	_assert(service.has_method("play_ambience"), "audio service exposes ambience playback method")
	_assert(service.has_method("stop_ambience"), "audio service exposes ambience stop method")
	if not service.has_method("play_ambience") or not service.has_method("stop_ambience"):
		service.queue_free()
		return
	var first = service.play_ambience("ambience_underchapel_drain")
	_assert(first is AudioStreamPlayer, "audio service creates ambience player")
	if first is AudioStreamPlayer:
		_assert(first.bus == "Environment", "ambience player uses configured environment bus")
		_assert(first.stream.loop, "ambience stream is looped")
	_assert(service.current_ambience_event_id == "ambience_underchapel_drain", "audio service records current ambience event")
	var same = service.play_ambience("ambience_underchapel_drain")
	_assert(same == first, "audio service reuses current ambience player for same event")
	var second = service.play_ambience("ambience_hidden_hospital")
	_assert(second is AudioStreamPlayer, "audio service creates replacement ambience player")
	_assert(second != first, "audio service swaps ambience player when event changes")
	_assert(service.current_ambience_event_id == "ambience_hidden_hospital", "audio service records replacement ambience event")
	var one_shot = service.play_event("door_museum_open")
	_assert(one_shot is AudioStreamPlayer, "audio service creates one-shot audio player")
	if DisplayServer.get_name() == "headless" and one_shot is AudioStreamPlayer:
		_assert(not one_shot.playing, "audio service does not start one-shot playback in headless tests")
	service.stop_ambience()
	_assert(service.current_ambience_event_id.is_empty(), "audio service clears current ambience event when stopped")
	_assert(service.current_ambience_player == null, "audio service clears ambience player when stopped")
	service.stop_all()
	_assert(service.get_child_count() == 0, "audio service stop_all frees one-shot audio players")
	root.remove_child(service)
	service.free()

func _test_authored_slice_maps_expose_audio_profiles() -> void:
	var expected := {
		"res://scenes/field/maps/hallowmere_street_map.tscn": {
			"map_id": "hallowmere_street",
			"ambience": "ambience_plague_town",
			"entry": "plague_cough",
			"museum_override": "curator_warning",
		},
		"res://scenes/field/maps/mira_apothecary_map.tscn": {
			"map_id": "mira_apothecary",
			"ambience": "ambience_apothecary",
			"entry": "item_pickup",
			"museum_override": "curator_warning",
		},
		"res://scenes/field/maps/sainted_bell_chapel_map.tscn": {
			"map_id": "sainted_bell_chapel",
			"ambience": "ambience_chapel_bell",
			"entry": "bell_clapper_relic",
			"museum_override": "curator_warning",
		},
		"res://scenes/field/maps/underchapel_drain_map.tscn": {
			"map_id": "underchapel_drain",
			"ambience": "ambience_underchapel_drain",
			"entry": "door_museum_open",
			"museum_override": "curator_warning",
		},
		"res://scenes/field/maps/hidden_hospital_corridor_map.tscn": {
			"map_id": "hidden_hospital_corridor",
			"ambience": "ambience_hidden_hospital",
			"entry": "curator_warning",
			"museum_override": "curator_warning",
		},
		"res://scenes/field/maps/bell_tower_boss_room_map.tscn": {
			"map_id": "bell_tower_boss_room",
			"ambience": "ambience_bell_tower",
			"entry": "bell_clapper_relic",
			"museum_override": "curator_warning",
		},
	}
	var AudioEventCatalog = load("res://scripts/core/audio_event_catalog.gd")
	var catalog = AudioEventCatalog.new()
	for scene_path in expected.keys():
		var MapScene = load(scene_path)
		if MapScene == null:
			_assert(false, "%s loads" % scene_path)
			continue
		var map_scene = MapScene.instantiate()
		root.add_child(map_scene)
		var profile: Dictionary = map_scene.get_meta("audio_profile", {})
		_assert(profile.get("map_id", "") == expected[scene_path]["map_id"], "%s audio profile records map id" % scene_path)
		_assert(profile.get("ambience", "") == expected[scene_path]["ambience"], "%s audio profile records ambience event" % scene_path)
		_assert(profile.get("entry", "") == expected[scene_path]["entry"], "%s audio profile records entry event" % scene_path)
		_assert(profile.get("museum_override", "") == expected[scene_path]["museum_override"], "%s audio profile records museum override" % scene_path)
		_assert(not catalog.event(String(profile.get("ambience", ""))).is_empty(), "%s ambience event exists in audio catalog" % scene_path)
		_assert(not catalog.event(String(profile.get("entry", ""))).is_empty(), "%s entry event exists in audio catalog" % scene_path)
		_assert(not catalog.event(String(profile.get("museum_override", ""))).is_empty(), "%s override event exists in audio catalog" % scene_path)
		map_scene.queue_free()

func _test_authored_slice_props_expose_story_inspection_metadata() -> void:
	var expected := {
		"res://scenes/field/maps/hallowmere_street_map.tscn": {
			"Landmarks/CoffinStack": "plague_cost",
			"Landmarks/TollStall": "shop_anchor",
			"Landmarks/ChapelRoad": "route_marker",
		},
		"res://scenes/field/maps/mira_apothecary_map.tscn": {
			"Landmarks/MedicineShelf": "medical_supply",
			"Landmarks/WorkTable": "mira_workspace",
		},
		"res://scenes/field/maps/underchapel_drain_map.tscn": {
			"Landmarks/MuseumPipe": "museum_infrastructure",
			"Landmarks/PumpMachine": "cross_era_machine",
			"Landmarks/WarningPanel": "curator_warning_label",
		},
		"res://scenes/field/maps/hidden_hospital_corridor_map.tscn": {
			"Landmarks/PatientBed": "medical_evidence",
			"Landmarks/MedicalChart": "memory_fever_record",
			"Landmarks/MedicineCabinet": "medical_supply",
		},
		"res://scenes/field/maps/sainted_bell_chapel_map.tscn": {
			"Landmarks/SaintStatue": "belief_anchor",
			"Landmarks/CellarDoor": "hidden_route",
		},
		"res://scenes/field/maps/bell_tower_boss_room_map.tscn": {
			"Landmarks/PlagueBell": "anchor_relic_source",
			"Landmarks/BellSaintStatue": "boss_foreshadow",
			"Landmarks/AnchorDoor": "museum_lock",
		},
	}
	for scene_path in expected.keys():
		var MapScene = load(scene_path)
		if MapScene == null:
			_assert(false, "%s loads" % scene_path)
			continue
		var map_scene = MapScene.instantiate()
		root.add_child(map_scene)
		for node_path in expected[scene_path].keys():
			_assert(map_scene.has_node(node_path), "%s has story prop %s" % [scene_path, node_path])
			if not map_scene.has_node(node_path):
				continue
			var prop = map_scene.get_node(node_path)
			_assert(prop.get_meta("story_role", "") == expected[scene_path][node_path], "%s records story role" % node_path)
			_assert(not String(prop.get_meta("inspect_text", "")).is_empty(), "%s records inspect text" % node_path)
		map_scene.queue_free()

func _test_vista_catalog_defines_bell_saint_vistas() -> void:
	_assert(ResourceLoader.exists("res://data/vistas/vista_engines.json"), "vista engine data exists")
	_assert(ResourceLoader.exists("res://scripts/core/vista_catalog.gd"), "vista catalog script exists")
	var VistaCatalog = load("res://scripts/core/vista_catalog.gd")
	var catalog = VistaCatalog.new()
	var gallery = catalog.vista("vista_gallery")
	_assert(gallery.display_name == "Vista Gallery", "Vista Gallery is defined")
	_assert(gallery.curator_claim.contains("optimized"), "Vista Gallery includes Curator framing")
	var plague = catalog.vista_for_phase("plague_town_street")
	_assert(plague.id == "plague_wing_distant", "Plague street maps to plague vista")
	_assert(plague.truth.contains("graves"), "Plague vista records hidden truth")
	_assert(catalog.vista("missing_vista").is_empty(), "missing vista returns empty dictionary")
