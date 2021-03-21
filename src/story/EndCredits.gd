extends Control
class_name EndCredits

onready var label : Label = $Label
onready var tween : Tween = $Tween

onready var fading_out : bool = false

func finish() -> void:
	fading_out = true
	tween.interpolate_property(label, "modulate", Color.white, Color.transparent, 2.0)
	tween.start()
	yield(tween, "tween_all_completed")
	get_tree().change_scene_to(Scenes.End)

func _on_Timer_MusicFinished_timeout() -> void:
	finish()

func _input(event : InputEvent) -> void:
	if event.is_action_pressed("ui_accept") and not fading_out:
		Music.fade_out_and_stop()
		finish()

func _ready() -> void:
	tween.interpolate_property(label, "modulate", Color.transparent, Color.white, 2.0)
	tween.start()
	Music.play("Epilogue")

func _enter_tree() -> void:
	$Label.modulate = Color.transparent
