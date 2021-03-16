extends Control

onready var menu : Control = $Center/Menu

func init_menu() -> void:
	menu.items = {
		"pause_menu": {
			"type": "menu",
			"children": ["resume", "settings", "restart_level", "back_to_title"]
		},
		"resume": {
			"type": "button",
			"label": "Resume"
		},
		"settings": {
			"label": "Settings",
			"type": "menu",
			"children": ["video", "audio", "controls", "back"],
			"parent": "pause_menu"
		},
		"video": {
			"label": "Video",
			"type": "menu",
			"children": ["fullscreen", "show_cursor", "back"],
			"parent": "settings"
		},
		"fullscreen": {
			"label": "Fullscreen",
			"type": "variable",
			"variable_name": "fullscreen"
		},
		"show_cursor": {
			"label": "Show Mouse Cursor",
			"type": "variable",
			"variable_name": "show_cursor"
		},
		"audio": {
			"label": "Audio",
			"type": "menu",
			"children": ["sfx_volume", "bgm_volume", "amb_volume", "ui_volume", "back"],
			"parent": "settings"
		},
		"sfx_volume": {
			"label": "SFX",
			"type": "variable",
			"variable_name": "sfx_volume"
		},
		"bgm_volume": {
			"label": "Music",
			"type": "variable",
			"variable_name": "bgm_volume"
		},
		"amb_volume": {
			"label": "Ambience",
			"type": "variable",
			"variable_name": "amb_volume"
		},
		"ui_volume": {
			"label": "UI",
			"type": "variable",
			"variable_name": "ui_volume"
		},
		"controls": {
			"label": "Controls",
			"type": "menu",
			"children": ["key_binding_walk_up", "key_binding_walk_down", "key_binding_walk_left", "key_binding_walk_right", "key_binding_jump", "key_binding_interact", "key_binding_swap_character", "key_binding_pause", "back"],
			"parent": "settings"
		},
		"key_binding_walk_up": {
			"label": "Walk Up",
			"type": "key_binding",
			"action_name": "walk_up"
		},
		"key_binding_walk_down": {
			"label": "Walk Down",
			"type": "key_binding",
			"action_name": "walk_down"
		},
		"key_binding_walk_left": {
			"label": "Walk Left",
			"type": "key_binding",
			"action_name": "walk_left"
		},
		"key_binding_walk_right": {
			"label": "Walk Right",
			"type": "key_binding",
			"action_name": "walk_right"
		},
		"key_binding_swap_character": {
			"label": "Swap Character",
			"type": "key_binding",
			"action_name": "swap_character"
		},
		"key_binding_jump": {
			"label": "Jump",
			"type": "key_binding",
			"action_name": "jump"
		},
		"key_binding_interact": {
			"label": "Interact",
			"type": "key_binding",
			"action_name": "interact"
		},
		"key_binding_pause": {
			"label": "Pause",
			"type": "key_binding",
			"action_name": "pause"
		},
		"restart_level": {
			"type": "button",
			"label": "Restart Level"
		},
		"back_to_title": {
			"type": "button",
			"label": "Back to Title"
		},
		"back": {
			"type": "button",
			"label": "Back"
		}
	}
	menu.variables = {
		"fullscreen": {"type": "tickbox", "value": Settings.fullscreen},
		"show_cursor": {"type": "tickbox", "value": Settings.show_cursor},
		"sfx_volume": {"type": "volume", "value": Settings.sfx_volume},
		"bgm_volume": {"type": "volume", "value": Settings.bgm_volume},
		"amb_volume": {"type": "volume", "value": Settings.amb_volume},
		"ui_volume": {"type": "volume", "value": Settings.ui_volume}
	}
	menu.current_item = "pause_menu"
	menu.resize(true)
	menu.active = true

func _on_Menu_variable_changed(variable_name : String) -> void:
	Settings.fullscreen = menu.variables["fullscreen"]["value"]
	Settings.show_cursor = menu.variables["show_cursor"]["value"]
	Settings.sfx_volume = menu.variables["sfx_volume"]["value"]
	Settings.bgm_volume = menu.variables["bgm_volume"]["value"]
	Settings.amb_volume = menu.variables["amb_volume"]["value"]
	Settings.ui_volume = menu.variables["ui_volume"]["value"]
	Settings.apply_config()
	Settings.save_config()

func _on_Menu_button_pressed(slug : String) -> void:
	match slug:
		"resume":
			resume()
		#"credits":
			#open_credits()
		#"quit":
			#quit()


func _on_Menu_back_from_root() -> void:
	resume()

func resume() -> void:
	get_tree().paused = false
	self.queue_free()

func _ready() -> void:
	init_menu()
