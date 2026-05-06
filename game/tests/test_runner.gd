extends SceneTree

var failures: Array[String] = []

func _init() -> void:
	_run_tests()
	if failures.is_empty():
		print("All tests passed.")
		quit(0)
	else:
		for failure in failures:
			push_error(failure)
		quit(1)

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
	_test_class_stats_and_leveling()
	_test_atb_wait_mode_pause()
	_test_encounter_selection()
	_test_first_slice_plague_encounters_defined()
	_test_save_payload_roundtrip()
	_test_field_movement_and_interactions()
	_test_first_slice_map_catalog_defines_town_and_dungeon()
	_test_prototype_field_resolves_first_slice_map_data()
	_test_prototype_field_generates_first_slice_map_markers()
	_test_prototype_field_exposes_transition_zones()
	_test_first_slice_maps_define_visible_graybox_layouts()
	_test_prototype_field_renders_graybox_layout()
	_test_first_slice_tile_asset_catalog_defines_runtime_tiles()
	_test_prototype_field_renders_real_tile_art_layer()
	_test_hallowmere_authored_map_scene_renders_curated_props()
	_test_hallowmere_authored_map_defines_story_landmarks()
	_test_apothecary_authored_map_defines_interior_story_landmarks()
	_test_apothecary_sliced_props_exist_and_render()
	_test_apothecary_slice_manifest_documents_exported_regions()
	_test_prototype_field_mounts_authored_hallowmere_map()
	_test_prototype_field_mounts_authored_apothecary_map()
	_test_prototype_field_changes_maps_when_player_enters_transition()
	_test_prototype_field_blocks_out_of_order_slice_transitions()
	_test_field_story_trigger_catalog_maps_route_events()
	_test_prototype_field_runs_entry_story_trigger_once()
	_test_prototype_field_queues_and_advances_entry_dialogue()
	_test_prototype_field_renders_entry_dialogue_in_dialogue_box()
	_test_dialogue_box_renders_continue_prompt()
	_test_field_player_locks_movement_during_dialogue()
	_test_first_slice_objective_catalog_tracks_route_goals()
	_test_prototype_field_renders_current_objective()
	_test_prototype_field_exposes_bell_saint_battle_payload()
	_test_prototype_field_emits_boss_battle_request()
	_test_prototype_field_interact_launches_boss_after_dialogue()
	_test_app_root_handles_field_battle_request()
	_test_battle_screen_emits_completion_payload()
	_test_app_root_handles_battle_completion_rewards()
	_test_dialogue_interpolation()
	_test_portrait_catalog_resolves_creator_portraits()
	_test_dialogue_box_uses_profile_portrait_for_sev()
	_test_voice_blip_catalog_resolves_creator_voice()
	_test_dialogue_box_uses_profile_voice_for_sev()
	_test_battle_attack_and_victory_rewards()
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
	_test_audio_service_resolves_runtime_event()
	_test_vista_catalog_defines_bell_saint_vistas()

func _assert(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)

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
		_assert(image.get_width() <= int(slice.get("max_width", 256)), "%s output width stays within quality gate" % slice.id)
		_assert(image.get_height() <= int(slice.get("max_height", 256)), "%s output height stays within quality gate" % slice.id)

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
