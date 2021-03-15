extends Control
class_name TitleScreen

onready var label_gwj : Label = $Label_GWJ
onready var vbox_menu : VBoxContainer = $VBox_Menu
onready var background : TextureRect = $Background
onready var audio_tape_stop : AudioStreamPlayer = $Audio_TapeStop
onready var audio_bgm : AudioStreamPlayer = $Audio_BGM
onready var audio_ambience : AudioStreamPlayer = $Audio_Ambience
onready var tween : Tween = $Tween

func sudden_stop() -> void:
	tween.stop_all() # Just in case it's still moving in
	background.hide()
	vbox_menu.hide()
	audio_ambience.stop()
	audio_bgm.stop()
	audio_tape_stop.play()

func _on_Play_pressed() -> void:
	sudden_stop()
	yield(get_tree().create_timer(1.5), "timeout")
	get_tree().change_scene_to(Scenes.Game)

func _on_Quit_pressed() -> void:
	sudden_stop()
	yield(get_tree().create_timer(1.5), "timeout")
	get_tree().quit()

func do_intro() -> void:
	tween.interpolate_property(audio_ambience, "volume_db", -40.0, -10.0, 2.0)
	tween.interpolate_property(label_gwj, "modulate", Color.transparent, Color.white, 2.0, Tween.TRANS_LINEAR, Tween.EASE_OUT, 2.0)
	tween.interpolate_property(background, "modulate", Color.black, Color.white, 5.0, Tween.TRANS_LINEAR, Tween.EASE_OUT, 5.0)
	tween.interpolate_property(label_gwj, "modulate", Color.white, Color.transparent, 2.0, Tween.TRANS_LINEAR, Tween.EASE_OUT, 6.0)
	tween.interpolate_property(vbox_menu, "modulate", Color.transparent, Color.white, 1.0, Tween.TRANS_LINEAR, Tween.EASE_OUT, 8.0)
	tween.start()
	yield(get_tree().create_timer(3.0), "timeout")
	audio_bgm.play()
	yield(get_tree().create_timer(5.0), "timeout")
	vbox_menu.visible = true

func _ready() -> void:
	audio_ambience.play()
	do_intro()

func _enter_tree() -> void:
	$Background.modulate = Color.black
	$VBox_Menu.visible = false
	$VBox_Menu.modulate = Color.transparent
	$Label_GWJ.modulate = Color.transparent
	$Label_GWJ.visible = true
	$Audio_Ambience.volume_db = -40.0
