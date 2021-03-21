extends Control

onready var label : Label = $Label
onready var tween : Tween = $Tween

func do_stuff() -> void:
	tween.interpolate_property(label, "modulate", Color.black, Color.white, 2.0, Tween.TRANS_LINEAR, Tween.EASE_OUT, 2.0)
	tween.interpolate_property(label, "modulate", Color.white, Color.black, 2.0, Tween.TRANS_LINEAR, Tween.EASE_OUT, 8.0)
	tween.start()
	yield(tween, "tween_all_completed")
	yield(get_tree().create_timer(2.0), "timeout")
	Progress.next_level()

func _ready() -> void:
	do_stuff()

func _enter_tree() -> void:
	$Label.modulate = Color.black
