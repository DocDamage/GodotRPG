extends Control

signal new_game_requested
signal continue_requested
signal memory_catalog_requested
signal options_requested
signal exit_requested

const TITLE_DATA_PATH := "res://data/ui/title_screen.json"
const InputPromptService = preload("res://scripts/core/input_prompt_service.gd")
const ContentCatalog = preload("res://scripts/core/content_catalog.gd")

@onready var new_game_button: Button = %NewGameButton
@onready var continue_button: Button = %ContinueButton
@onready var status_label: Label = %StatusLabel
@onready var prompt_label: Label = %PromptLabel
@onready var pane_host: HBoxContainer = %PaneHost
@onready var backdrop: TextureRect = %Backdrop
@onready var title_top_label: Label = %TitleTopLabel
@onready var title_bottom_label: Label = %TitleBottomLabel
@onready var tagline_label: Label = %TaglineLabel
@onready var submenu_panel: PanelContainer = %SubmenuPanel
@onready var submenu_title: Label = %SubmenuTitle
@onready var submenu_body: Label = %SubmenuBody
@onready var submenu_controls: VBoxContainer = %SubmenuControls
@onready var submenu_back_button: Button = %SubmenuBackButton

var title_data: Dictionary = {}
var has_continue_slot := false
var _menu_wired := false
var _option_widgets: Dictionary = {}
var game_state_override = null

func _ready() -> void:
	title_data = _load_title_data()
	_apply_title_data()
	_wire_menu()
	set_continue_available(_detect_continue_slot())
	_apply_controller_prompt()
	if is_inside_tree() and DisplayServer.get_name() != "headless":
		new_game_button.grab_focus.call_deferred()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("cancel"):
		if submenu_panel != null and submenu_panel.visible:
			close_submenu()
			set_status(String(title_data.get("status", "ARCHIVE STATUS: UNSTABLE")))
		else:
			set_status("ARCHIVE EXIT REQUEST IGNORED")
		var viewport := get_viewport()
		if viewport != null:
			viewport.set_input_as_handled()

func set_continue_available(value: bool) -> void:
	has_continue_slot = value
	if continue_button == null:
		return
	continue_button.disabled = not has_continue_slot
	continue_button.tooltip_text = "Load manual archive." if has_continue_slot else "No saved archive found."

func set_status(message: String) -> void:
	if status_label != null:
		status_label.text = message

func open_memory_catalog() -> void:
	_open_submenu("Memory Catalog", _memory_catalog_text())
	set_status("MEMORY CATALOG OPEN")

func open_options_menu() -> void:
	_open_submenu("Options", "Adjust title and combat accessibility settings.")
	_build_options_controls()
	set_status("OPTIONS TERMINAL OPEN")

func close_submenu() -> void:
	if submenu_panel != null:
		submenu_panel.visible = false
	if new_game_button != null and is_inside_tree() and DisplayServer.get_name() != "headless":
		new_game_button.grab_focus.call_deferred()

func set_option_value(option_id: String, value) -> void:
	var game_state = _game_state()
	if game_state == null or game_state.accessibility == null:
		return
	match option_id:
		"text_speed_seconds_per_character":
			game_state.accessibility.text_speed_seconds_per_character = clampf(float(value), 0.01, 0.2)
		"menu_scale":
			game_state.accessibility.menu_scale = clampf(float(value), 0.75, 2.0)
		"atb_mode":
			game_state.accessibility.atb_mode = "active" if String(value) == "active" else "wait"
		"high_contrast_ui":
			game_state.accessibility.high_contrast_ui = bool(value)
		"reduced_flashing":
			game_state.accessibility.reduced_flashing = bool(value)
		"controller_deadzone":
			game_state.accessibility.controller_deadzone = clampf(float(value), 0.05, 0.6)
		"controller_glyph_family":
			game_state.accessibility.controller_glyph_family = _valid_glyph(String(value))
		"window_mode":
			game_state.accessibility.window_mode = "fullscreen" if String(value) == "fullscreen" else "windowed"
		"master_volume", "music_volume", "ambience_volume", "sfx_volume", "ui_volume", "dialogue_volume", "combat_volume", "environment_volume":
			game_state.accessibility.set(option_id, clampf(float(value), 0.0, 1.0))
	_sync_option_widgets()
	_apply_controller_prompt()

func save_options() -> Error:
	var game_state = _game_state()
	if game_state == null or not game_state.has_method("save_settings_slot"):
		set_status("OPTIONS SAVE FAILED")
		return FAILED
	var error = game_state.save_settings_slot()
	set_status("OPTIONS SAVED" if error == OK else "OPTIONS SAVE FAILED")
	return error

func pane_count() -> int:
	if pane_host == null:
		return 0
	return pane_host.get_child_count()

func active_pane_ids() -> Array[String]:
	var ids: Array[String] = []
	for pane in _pane_entries():
		if String(pane.get("state", "")) == "active":
			ids.append(String(pane.get("id", "")))
	return ids

func locked_pane_ids() -> Array[String]:
	var ids: Array[String] = []
	for pane in _pane_entries():
		if String(pane.get("state", "")) == "locked":
			ids.append(String(pane.get("id", "")))
	return ids

func _wire_menu() -> void:
	if _menu_wired:
		return
	_menu_wired = true
	%NewGameButton.pressed.connect(func(): new_game_requested.emit())
	%ContinueButton.pressed.connect(_on_continue_pressed)
	%MemoryCatalogButton.pressed.connect(func():
		open_memory_catalog()
		memory_catalog_requested.emit()
	)
	%OptionsButton.pressed.connect(func():
		open_options_menu()
		options_requested.emit()
	)
	%ExitButton.pressed.connect(func(): exit_requested.emit())
	%SubmenuBackButton.pressed.connect(close_submenu)

func _on_continue_pressed() -> void:
	if not has_continue_slot:
		set_status("NO SAVED ARCHIVE FOUND")
		return
	continue_requested.emit()

func _apply_title_data() -> void:
	title_top_label.text = String(title_data.get("title_top", "THE LAST"))
	title_bottom_label.text = String(title_data.get("title_bottom", "WORLD MUSEUM"))
	tagline_label.text = String(title_data.get("tagline", "History was preserved. Truth was archived separately."))
	set_status(String(title_data.get("status", "ARCHIVE STATUS: UNSTABLE")))
	var backdrop_path := String(title_data.get("museum_backdrop", ""))
	if not backdrop_path.is_empty():
		backdrop.texture = _load_texture(backdrop_path)
	_render_panes()

func _render_panes() -> void:
	for child in pane_host.get_children():
		pane_host.remove_child(child)
		child.queue_free()
	for pane in _pane_entries():
		pane_host.add_child(_create_pane(pane))

func _create_pane(pane: Dictionary) -> Control:
	var panel := PanelContainer.new()
	panel.name = "%sPane" % String(pane.get("id", "wing")).capitalize()
	panel.custom_minimum_size = Vector2(104, 276)
	var state := String(pane.get("state", "locked"))
	panel.add_theme_stylebox_override("panel", _pane_style(state))

	var stack := VBoxContainer.new()
	stack.name = "Stack"
	stack.add_theme_constant_override("separation", 4)
	panel.add_child(stack)

	var image := TextureRect.new()
	image.name = "Image"
	image.custom_minimum_size = Vector2(96, 236)
	image.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	image.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	image.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	image.texture = _load_texture(String(pane.get("texture", "")))
	image.modulate = Color(0.72, 0.78, 0.78, 1.0) if state == "active" else Color(0.37, 0.43, 0.47, 0.82)
	stack.add_child(image)

	var label := Label.new()
	label.name = "Label"
	label.text = String(pane.get("label", "WING"))
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override("font_size", 12)
	label.add_theme_color_override("font_color", Color(0.78, 0.83, 0.87, 1.0) if state == "active" else Color(0.48, 0.56, 0.62, 1.0))
	stack.add_child(label)

	if state == "locked":
		var seal := Label.new()
		seal.name = "Seal"
		seal.text = "SEALED"
		seal.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		seal.add_theme_font_size_override("font_size", 9)
		seal.add_theme_color_override("font_color", Color(0.45, 0.58, 0.68, 0.75))
		stack.add_child(seal)
	return panel

func _pane_style(state: String) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.03, 0.04, 0.055, 0.84)
	style.border_width_left = 2
	style.border_width_top = 2
	style.border_width_right = 2
	style.border_width_bottom = 2
	style.border_color = Color(0.66, 0.35, 0.32, 0.95) if state == "active" else Color(0.26, 0.34, 0.42, 0.72)
	style.corner_radius_top_left = 0
	style.corner_radius_top_right = 0
	style.corner_radius_bottom_left = 0
	style.corner_radius_bottom_right = 0
	style.content_margin_left = 4
	style.content_margin_top = 4
	style.content_margin_right = 4
	style.content_margin_bottom = 4
	return style

func _apply_controller_prompt() -> void:
	var game_state = _game_state()
	var preference := "auto"
	if game_state != null and game_state.accessibility != null:
		preference = String(game_state.accessibility.controller_glyph_family)
	var prompts := InputPromptService.new()
	var family := prompts.resolve_glyph_family(preference, "")
	prompt_label.text = "%s select  |  %s back" % [
		prompts.mixed_action_label("interact", family),
		prompts.mixed_action_label("cancel", family),
	]

func _detect_continue_slot() -> bool:
	var game_state = _game_state()
	if game_state != null and game_state.has_method("has_manual_slot"):
		return game_state.has_manual_slot()
	return FileAccess.file_exists("user://manual_slot.save")

func _open_submenu(title: String, body: String) -> void:
	submenu_title.text = title
	submenu_body.text = body
	for child in submenu_controls.get_children():
		if child != submenu_back_button:
			submenu_controls.remove_child(child)
			child.queue_free()
	_option_widgets.clear()
	submenu_panel.visible = true
	if is_inside_tree() and DisplayServer.get_name() != "headless":
		submenu_back_button.grab_focus.call_deferred()

func _memory_catalog_text() -> String:
	var game_state = _game_state()
	var owned: Array = []
	if game_state != null:
		owned = game_state.memory_cards.get("owned", [])
	if owned.is_empty():
		return "No memory cards recovered.\n\nRecovered memories will appear here after anchor relics, boss fights, and evidence discoveries."
	var catalog := ContentCatalog.new()
	var lines: Array[String] = ["Recovered Memory Cards:"]
	for card_id in owned:
		var card := catalog.memory_card(String(card_id))
		var display_name := String(card.get("display_name", String(card_id).replace("_", " ").capitalize()))
		var description := String(card.get("description", "Recovered archive fragment."))
		lines.append("- %s: %s" % [display_name, description])
	return "\n".join(lines)

func _build_options_controls() -> void:
	var game_state = _game_state()
	if game_state == null or game_state.accessibility == null:
		submenu_body.text = "Options unavailable: GameState is not loaded."
		return
	var before_back := submenu_back_button.get_index()
	var controls: Array[Control] = [
		_create_option_button("controller_glyph_family", "Controller Glyphs", ["auto", "xbox", "playstation", "switch", "keyboard"]),
		_create_option_button("window_mode", "Display", ["windowed", "fullscreen"]),
		_create_option_button("atb_mode", "ATB Mode", ["wait", "active"]),
		_create_check_button("high_contrast_ui", "High Contrast UI"),
		_create_check_button("reduced_flashing", "Reduced Flashing"),
		_create_slider("controller_deadzone", "Controller Deadzone", 0.05, 0.6, 0.01),
		_create_slider("text_speed_seconds_per_character", "Text Speed", 0.01, 0.2, 0.005),
		_create_slider("menu_scale", "Menu Scale", 0.75, 2.0, 0.05),
		_create_slider("master_volume", "Master Volume", 0.0, 1.0, 0.01),
		_create_slider("music_volume", "Music Volume", 0.0, 1.0, 0.01),
		_create_slider("ambience_volume", "Ambience Volume", 0.0, 1.0, 0.01),
		_create_slider("sfx_volume", "SFX Volume", 0.0, 1.0, 0.01),
		_create_slider("ui_volume", "UI Volume", 0.0, 1.0, 0.01),
		_create_slider("dialogue_volume", "Dialogue Volume", 0.0, 1.0, 0.01),
		_create_slider("combat_volume", "Combat Volume", 0.0, 1.0, 0.01),
		_create_slider("environment_volume", "Environment Volume", 0.0, 1.0, 0.01),
		_create_save_button(),
	]
	for control in controls:
		submenu_controls.add_child(control)
		submenu_controls.move_child(control, before_back)
		before_back += 1
	_sync_option_widgets()

func _create_option_button(option_id: String, label_text: String, values: Array[String]) -> HBoxContainer:
	var row := _option_row(label_text)
	var picker := OptionButton.new()
	picker.name = "%sOption" % option_id.capitalize()
	picker.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	for value in values:
		picker.add_item(value.capitalize(), values.find(value))
		picker.set_item_metadata(values.find(value), value)
	picker.item_selected.connect(func(index: int):
		set_option_value(option_id, String(picker.get_item_metadata(index)))
	)
	row.add_child(picker)
	_option_widgets[option_id] = picker
	return row

func _create_check_button(option_id: String, label_text: String) -> CheckButton:
	var check := CheckButton.new()
	check.name = "%sCheck" % option_id.capitalize()
	check.text = label_text
	check.toggled.connect(func(enabled: bool): set_option_value(option_id, enabled))
	_option_widgets[option_id] = check
	return check

func _create_slider(option_id: String, label_text: String, minimum: float, maximum: float, step: float) -> VBoxContainer:
	var stack := VBoxContainer.new()
	stack.name = "%sSliderRow" % option_id.capitalize()
	var label := Label.new()
	label.name = "Label"
	label.text = label_text
	stack.add_child(label)
	var slider := HSlider.new()
	slider.name = "%sSlider" % option_id.capitalize()
	slider.min_value = minimum
	slider.max_value = maximum
	slider.step = step
	slider.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	slider.value_changed.connect(func(value: float): set_option_value(option_id, value))
	stack.add_child(slider)
	_option_widgets[option_id] = slider
	return stack

func _create_save_button() -> Button:
	var button := Button.new()
	button.name = "SaveOptionsButton"
	button.text = "Save Options"
	button.pressed.connect(save_options)
	return button

func _option_row(label_text: String) -> HBoxContainer:
	var row := HBoxContainer.new()
	row.name = "%sRow" % label_text.replace(" ", "")
	row.add_theme_constant_override("separation", 10)
	var label := Label.new()
	label.text = label_text
	label.custom_minimum_size = Vector2(170, 0)
	row.add_child(label)
	return row

func _sync_option_widgets() -> void:
	var game_state = _game_state()
	if game_state == null or game_state.accessibility == null:
		return
	var settings = game_state.accessibility
	for option_id in _option_widgets.keys():
		var widget = _option_widgets[option_id]
		match option_id:
			"controller_glyph_family", "atb_mode", "window_mode":
				if widget is OptionButton:
					var current := String(settings.get(option_id))
					for index in widget.item_count:
						if String(widget.get_item_metadata(index)) == current:
							widget.select(index)
							break
			"high_contrast_ui", "reduced_flashing":
				if widget is CheckButton:
					widget.button_pressed = bool(settings.get(option_id))
			_:
				if widget is HSlider:
					widget.value = float(settings.get(option_id))

func _valid_glyph(value: String) -> String:
	return value if ["auto", "xbox", "playstation", "switch", "keyboard"].has(value) else "auto"

func _game_state():
	if game_state_override != null:
		return game_state_override
	return get_node_or_null("/root/GameState") if is_inside_tree() else null

func _pane_entries() -> Array:
	return title_data.get("panes", [])

func _load_title_data() -> Dictionary:
	var file := FileAccess.open(TITLE_DATA_PATH, FileAccess.READ)
	if file == null:
		push_error("Unable to load title screen data.")
		return {}
	var parsed = JSON.parse_string(file.get_as_text())
	return parsed if parsed is Dictionary else {}

func _load_texture(path: String) -> Texture2D:
	if path.is_empty():
		return null
	if path.begins_with("res://") or path.begins_with("user://"):
		if not FileAccess.file_exists(path):
			return null
	var image := Image.new()
	if image.load(path) != OK:
		var loaded = load(path)
		if loaded is Texture2D:
			return loaded
		return null
	return ImageTexture.create_from_image(image)
