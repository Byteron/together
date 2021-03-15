extends Node

const CONFIG_PATH : String = "user://settings.cfg"

const ACTIONS : Array = ["walk_left", "walk_right", "walk_up", "walk_down", "swap_character", "interact", "pause"]

var fullscreen : bool
var show_cursor : bool
var sfx_volume : float
var bgm_volume : float
var amb_volume : float
var ui_volume : float

var config : ConfigFile

func apply_config() -> void:
	OS.window_fullscreen = fullscreen
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear2db(sfx_volume))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("BGM"), linear2db(bgm_volume))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Ambience"), linear2db(amb_volume))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("UI"), linear2db(ui_volume))
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE if show_cursor else Input.MOUSE_MODE_HIDDEN)

func get_key_binding(action_name : String) -> int:
	return InputMap.get_action_list(action_name)[0].scancode

func set_key_binding(action_name : String, scancode : int) -> void:
	InputMap.action_erase_events(action_name)
	var event : InputEventKey = InputEventKey.new()
	event.scancode = scancode
	InputMap.action_add_event(action_name, event)

func load_config() -> void:
	config = ConfigFile.new()
	var err = config.load(CONFIG_PATH)
	if err == ERR_FILE_NOT_FOUND:
		err = config.save(CONFIG_PATH)
	if err == OK:
		fullscreen = config.get_value("graphics", "fullscreen", false)
		show_cursor = config.get_value("graphics", "show_cursor", true)
		sfx_volume = config.get_value("audio", "sfx_volume", 1.0)
		bgm_volume = config.get_value("audio", "bgm_volume", 1.0)
		amb_volume = config.get_value("audio", "amb_volume", 1.0)
		ui_volume = config.get_value("audio", "ui_volume", 1.0)
		# Deal with keybindings
		for action_name in ACTIONS:
			var scancode : int = config.get_value("controls", action_name, -1)
			if scancode != -1:
				set_key_binding(action_name, scancode)

func save_config() -> void:
	config.set_value("graphics", "fullscreen", fullscreen)
	config.set_value("graphics", "show_cursor", show_cursor)
	config.set_value("audio", "sfx_volume", sfx_volume)
	config.set_value("audio", "bgm_volume", bgm_volume)
	config.set_value("audio", "amb_volume", amb_volume)
	config.set_value("audio", "ui_volume", ui_volume)
	for action_name in ACTIONS:
		config.set_value("controls", action_name, get_key_binding(action_name))
	config.save(CONFIG_PATH)

func _enter_tree() -> void:
	load_config()
	yield(get_tree().create_timer(0.25), "timeout") # For the life of me, I can't remember why I put this here
	apply_config()
	OS.center_window()
