extends Control

const FONT : Font = preload("res://assets/fonts/menu.tres")

const COLOUR_BRIGHT : Color = Color(1.0, 1.0, 1.0)
const COLOUR_DIM : Color = Color(0.5, 0.5, 0.5)
const COLOUR_SHADOW : Color = Color(0.2, 0.2, 0.2)

const VOLUME_INCR : float = 0.1
const ITEM_HEIGHT : float = 42.0

onready var audio_back : AudioStreamPlayer = $Audio_Back
onready var audio_move : AudioStreamPlayer = $Audio_Move
onready var audio_select : AudioStreamPlayer = $Audio_Select
onready var audio_start : AudioStreamPlayer = $Audio_Start
onready var tween : Tween = $Tween

var items : Dictionary
var variables : Dictionary

var current_item : String
var current_child : int = 0
onready var active : bool = false
onready var rebinding : bool = false
var rebinding_action : String

var cursor_pos : float = 0.0
var bindings_max_target : float = 0.0
var bindings_max_actual : float = 0.0

signal button_pressed
signal variable_changed
signal menu_entered
signal back_from_root

func get_current_item() -> Dictionary:
	if items.has(current_item):
		return items[current_item]
	return {}

func get_current_children() -> Array:
	var item : Dictionary = get_current_item()
	if item.has("children"):
		return item["children"]
	return []

func get_label_for_item(slug : String) -> String:
	if items.has(slug):
		var item : Dictionary = items[slug]
		if item.has("label"):
			return item["label"]
	# Special cases
	if slug == "back":
		return "Back"
	return ""

func get_current_menu_child_slug(position : int) -> String:
	var item : Dictionary = items[current_item]
	if not item.has("children"): return ""
	return item["children"][position]

func get_child_type(slug : String) -> String:
	if not items.has(slug): return "null"
	var item : Dictionary = items[slug]
	if item.has("type"):
		return item["type"]
	return "null"

func is_child_button(slug : String) -> bool:
	return get_child_type(slug) == "button"

func is_child_menu(slug : String) -> bool:
	return get_child_type(slug) == "menu"

func is_child_variable(slug : String) -> bool:
	return get_child_type(slug) == "variable"

func is_child_key_binding(slug : String) -> bool:
	return get_child_type(slug) == "key_binding"

func get_select_size(options : Array) -> float:
	var max_option_size : float = 0.0
	for option in options:
		var option_size : Vector2 = FONT.get_string_size(option)
		max_option_size = max(option_size.x, max_option_size)
	return max_option_size + 24.0

func resize(instant : bool = false) -> void:
	var size : Vector2 = Vector2(0, 0)
	var children : Array = get_current_children()
	for i in range(0, children.size()):
		var child : String = children[i]
		var menu_item : Dictionary = items[child]
		size = Vector2(size.x, size.y + ITEM_HEIGHT)
	if instant:
		rect_min_size = size
		rect_size = size
		update()
	else:
		# Tween it
		tween.interpolate_property(self, "rect_size", rect_size, size, 0.25, Tween.TRANS_QUINT, Tween.EASE_OUT)
		tween.interpolate_property(self, "rect_min_size", rect_min_size, size, 0.25, Tween.TRANS_QUINT, Tween.EASE_OUT)
		tween.start()

func draw_text_with_shadow(text : String, position : Vector2, color : Color) -> void:
	draw_string(FONT, position, text, color)

func draw_button(label : String, position : Vector2, is_current : bool) -> void:
	var color : Color = COLOUR_BRIGHT if is_current else COLOUR_DIM
	var label_size : Vector2 = FONT.get_string_size(label)
	draw_text_with_shadow(label, position - Vector2(label_size.x, 0), color)

func draw_tickbox(label : String, variable : Dictionary, position : Vector2, is_current : bool) -> void:
	var color : Color = COLOUR_BRIGHT if is_current else COLOUR_DIM
	var value : bool = variable["value"]
	var label_size : Vector2 = FONT.get_string_size(label)
	draw_text_with_shadow(label, position - Vector2(label_size.x + 120, 0), color)
	var label_value : String = "ON" if value else "OFF"
	var label_value_size : Vector2 = FONT.get_string_size(label_value)
	draw_text_with_shadow(label_value, position - Vector2(label_value_size.x, 0), color)

func draw_volume(label : String, variable : Dictionary, position : Vector2, is_current : bool) -> void:
	var color : Color = COLOUR_BRIGHT if is_current else COLOUR_DIM
	var label_size : Vector2 = FONT.get_string_size(label)
	draw_text_with_shadow(label, position - Vector2(label_size.x + 120, 0), color)
	var label_value : String = str(round(variable["value"] * 100.0)) + "%"
	var label_value_size : Vector2 = FONT.get_string_size(label_value)
	draw_text_with_shadow(label_value, position - Vector2(label_value_size.x, 0), color)

func draw_select(label : String, variable : Dictionary, position : Vector2, is_current : bool) -> void:
	var color : Color = COLOUR_BRIGHT if is_current else COLOUR_DIM
	var value : int = variable["value"]
	var options : Array = variable["options"]
	var label_option : String = options[value]
	var label_option_size : Vector2 = FONT.get_string_size(label_option)
	var max_label_size : float = get_select_size(options)
	draw_text_with_shadow(label_option, position + Vector2(rect_size.x - label_option_size.x + 4, 13), color)
	draw_text_with_shadow("<", position + Vector2(rect_size.x - max_label_size + 20, 13), color)
	draw_text_with_shadow(">", position + Vector2(rect_size.x + 8, 13), color)

func draw_key_binding(label : String, action_name : String, position : Vector2, is_current : bool) -> void:
	var color : Color = COLOUR_BRIGHT if is_current else COLOUR_DIM
	var label_size : Vector2 = FONT.get_string_size(label)
	draw_text_with_shadow(label, position - Vector2(label_size.x + bindings_max_actual + 40, 0), color)
	if rebinding and rebinding_action == action_name:
		draw_text_with_shadow("...", position + Vector2(rect_size.x - FONT.get_string_size("...").x, 0), color)
	else:
		var binding_name : String = OS.get_scancode_string(Settings.get_key_binding(action_name))
		var binding_size : Vector2 = FONT.get_string_size(binding_name)
		draw_text_with_shadow(binding_name, position + Vector2(rect_size.x - binding_size.x, 0), color)

func draw_variable(label : String, variable_name : String, position : Vector2, is_current : bool) -> void:
	var variable : Dictionary = variables[variable_name]
	match variable["type"]:
		"tickbox":
			draw_tickbox(label, variable, position, is_current)
		"volume":
			draw_volume(label, variable, position, is_current)
		"select":
			draw_select(label, variable, position, is_current)

func draw_menu_item(menu_item : Dictionary, position : Vector2, is_current : bool) -> void:
	var label : String = menu_item["label"]
	var color : Color = COLOUR_BRIGHT if is_current else COLOUR_DIM
	match menu_item["type"]:
		"button", "menu":
			draw_button(label, position, is_current)
		"variable":
			var variable_name : String = menu_item["variable_name"]
			draw_variable(label, variable_name, position, is_current)
		"key_binding":
			var action_name : String = menu_item["action_name"]
			draw_key_binding(label, action_name, position, is_current)

func _draw() -> void:
	var offset : Vector2 = Vector2.ZERO
	var children : Array = get_current_children()
	for i in range(0, children.size()):
		var menu_item_name : String = children[i]
		var menu_item : Dictionary = items[menu_item_name]
		draw_menu_item(menu_item, offset, i == current_child)
		offset.y += ITEM_HEIGHT

func _process(delta : float) -> void:
	bindings_max_actual = lerp(bindings_max_actual, bindings_max_target, delta * 5.0)
	update()

func move_cursor() -> void:
	tween.interpolate_property(self, "cursor_pos", cursor_pos, current_child * 16, 0.25, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tween.start()

func update_bindings_max() -> void:
	bindings_max_target = 0
	for action_name in Settings.ACTIONS:
		var binding_name : String = OS.get_scancode_string(Settings.get_key_binding(action_name))
		var binding_size : Vector2 = FONT.get_string_size(binding_name)
		bindings_max_target = max(binding_size.x, bindings_max_target)

func toggle_tickbox(variable_slug : String) -> void:
	var value : bool = variables[variable_slug]["value"]
	value = !value
	variables[variable_slug]["value"] = value
	emit_signal("variable_changed", variable_slug)

func increase_volume(variable_slug : String) -> void:
	var value : float = variables[variable_slug]["value"]
	if value < 1.0:
		value += VOLUME_INCR
		variables[variable_slug]["value"] = value
		emit_signal("variable_changed", variable_slug)

func decrease_volume(variable_slug : String) -> void:
	var value : float = variables[variable_slug]["value"]
	if value > 0.0:
		value -= VOLUME_INCR
		variables[variable_slug]["value"] = value
		emit_signal("variable_changed", variable_slug)

func next_option(variable_slug : String) -> void:
	var variable : Dictionary = variables[variable_slug]
	var option_count : int = variable["options"].size()
	var value : int = variable["value"]
	value += 1
	if value >= option_count:
		value = 0
	variable["value"] = value
	emit_signal("variable_changed", variable_slug)

func previous_option(variable_slug : String) -> void:
	var variable : Dictionary = variables[variable_slug]
	var option_count : int = variable["options"].size()
	var value : int = variable["value"]
	value -= 1
	if value < 0:
		value = option_count - 1
	variable["value"] = value
	emit_signal("variable_changed", variable_slug)

func up() -> void:
	current_child -= 1
	if current_child < 0:
		current_child = get_current_children().size() - 1
	move_cursor()
	audio_move.play()

func down() -> void:
	current_child += 1
	if current_child >= get_current_children().size():
		current_child = 0
	move_cursor()
	audio_move.play()

func left_or_right(left : bool) -> void:
	var menu_item_name : String = get_current_children()[current_child]
	var menu_item : Dictionary = items[menu_item_name]
	if menu_item["type"] == "variable":
		var variable_name : String = menu_item["variable_name"]
		var variable : Dictionary = variables[variable_name]
		match variable["type"]:
			"volume":
				if left: decrease_volume(variable_name)
				else: increase_volume(variable_name)
			"select":
				if left: previous_option(variable_name)
				else: next_option(variable_name)
		audio_move.play()

func accept() -> void:
	var slug : String = get_current_menu_child_slug(current_child)
	if slug == "back":
		back()
	elif is_child_variable(slug):
		var variable_name : String = items[slug]["variable_name"]
		var variable_type : String = variables[variable_name]["type"]
		if variable_type == "tickbox":
			toggle_tickbox(variable_name)
			audio_select.play()
	elif is_child_button(slug):
		if slug != "play": # janky hack
			audio_select.play()
		emit_signal("button_pressed", slug)
	elif is_child_menu(slug):
		current_item = slug
		current_child = 0
		move_cursor()
		audio_select.play()
		emit_signal("menu_entered", current_item)
	elif is_child_key_binding(slug):
		rebinding = true
		rebinding_action = items[slug]["action_name"]
		audio_select.play()

func back() -> void:
	var item : Dictionary = get_current_item()
	if item.has("parent"):
		current_item = item["parent"]
		current_child = 0
		move_cursor()
		audio_back.play()
		emit_signal("menu_entered", current_item)
	else:
		emit_signal("back_from_root")

func _input(event : InputEvent) -> void:
	if not active: return
	get_tree().set_input_as_handled()
	if rebinding:
		if event is InputEventKey and event.pressed:
			Settings.set_key_binding(rebinding_action, event.scancode)
			rebinding = false
			audio_select.play()
			Settings.save_config()
			update_bindings_max()
	else:
		if Input.is_action_just_pressed("ui_up"):
			up()
		elif Input.is_action_just_pressed("ui_down"):
			down()
		elif Input.is_action_just_pressed("ui_left"):
			left_or_right(true)
		elif Input.is_action_just_pressed("ui_right"):
			left_or_right(false)
		elif Input.is_action_just_pressed("ui_accept"):
			accept()
		elif Input.is_action_just_pressed("ui_cancel"):
			back()
	resize()
	update()

func _ready() -> void:
	update_bindings_max()
