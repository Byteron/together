extends Node

var sfx := {}

onready var tween: Tween = $Tween


func _ready() -> void:
	for child in get_children():
		sfx[child.name] = child


func play(sfx_name: String, fade_in := 0.0, start_db := -40, end_db := -10) -> void:
	if sfx.has(sfx_name):
		var player: AudioStreamPlayer = sfx[sfx_name]

		if fade_in:
			tween.interpolate_property(player, "volume_db", start_db, end_db, fade_in)
			tween.start()

		player.play()


func stop(sfx_name: String) -> void:
	if sfx.has(sfx_name):
		var player: AudioStreamPlayer = sfx[sfx_name]
		tween.stop(player)
		tween.remove(player)
		player.stop()
