extends Control
class_name TitleScreen

onready var label_gwj : Label = $Label_GWJ
onready var menu : Control = $Center/Menu
onready var background : TextureRect = $Background
onready var tween : Tween = $Tween

onready var skipped_intro : bool = false

func init_menu() -> void:

	menu.items = {
		"main_menu": {
			"type": "menu",
			"children": ["play", "settings", "credits", "quit"]
		},
		"play": {
			"type": "button",
			"label": "Play"
		},
		"settings": {
			"label": "Settings",
			"type": "menu",
			"children": ["video", "audio", "controls", "back"],
			"parent": "main_menu"
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
		"credits": {
			"type": "button",
			"label": "Credits"
		},
		"quit": {
			"type": "button",
			"label": "Quit"
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
	menu.current_item = "main_menu"
	menu.resize(true)

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
		"play":
			start_game()
		#"credits":
			#open_credits()
		"quit":
			quit()

func sudden_stop() -> void:
	tween.stop_all() # Just in case it's still moving in
	background.hide()
	menu.hide()
	Music.stop()
	SFX.stop("IntroAmbience")
	SFX.play("TapeStop")


func start_game() -> void:
	sudden_stop()
	yield(get_tree().create_timer(1.5), "timeout")
	Progress.next_level()

func quit() -> void:
	sudden_stop()
	yield(get_tree().create_timer(1.5), "timeout")
	get_tree().quit()

func do_intro() -> void:
	tween.interpolate_property(label_gwj, "modulate", Color.transparent, Color.white, 2.0, Tween.TRANS_LINEAR, Tween.EASE_OUT, 2.0)
	tween.interpolate_property(background, "modulate", Color.black, Color.white, 5.0, Tween.TRANS_LINEAR, Tween.EASE_OUT, 5.0)
	tween.interpolate_property(label_gwj, "modulate", Color.white, Color.transparent, 2.0, Tween.TRANS_LINEAR, Tween.EASE_OUT, 6.0)
	tween.interpolate_property(menu, "modulate", Color.transparent, Color.white, 1.0, Tween.TRANS_LINEAR, Tween.EASE_OUT, 8.0)
	tween.start()
	yield(get_tree().create_timer(3.0), "timeout")
	Music.play("Intro")
	yield(get_tree().create_timer(5.0), "timeout")
	if not skipped_intro:
		menu.visible = true
		menu.active = true

func _input(event : InputEvent) -> void:
	if not tween.is_active():
		return
	if event.is_action_pressed("ui_accept"):
		tween.stop_all()
		label_gwj.modulate = Color.transparent
		background.modulate = Color.white
		menu.modulate = Color.white
		menu.visible = true
		menu.active = true
		skipped_intro = true

func _ready() -> void:
	init_menu()
	SFX.play("IntroAmbience", 2.0, -40, -10)
	do_intro()

func _enter_tree() -> void:
	$Background.modulate = Color.black
	$Center/Menu.visible = false
	$Center/Menu.modulate = Color.transparent
	$Center/Menu.active = false
	$Label_GWJ.modulate = Color.transparent
	$Label_GWJ.visible = true
