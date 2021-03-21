extends Node

var sfx := {}

var _is_muted := false

onready var tween: Tween = $Tween

func mute() -> void:
	_is_muted = true

func unmute() -> void:
	_is_muted = false


func _ready() -> void:
	for child in get_children():
		sfx[child.name] = child


func play(sfx_name: String, fade_in := 0.0, start_db := -40, end_db := -10) -> void:
	if _is_muted:
		return

	if sfx.has(sfx_name):
		var player: Sound = sfx[sfx_name]

		if fade_in:
			var __ = tween.interpolate_property(player, "volume_db", start_db, end_db, fade_in)
			__ = tween.start()

		player.play()


func play_2d(sfx_name: String, position: Vector2) -> void:
	if _is_muted:
		return

	if sfx.has(sfx_name):
		var player: Sound2D = sfx[sfx_name]
		player.play_at(position)


func stop(sfx_name: String) -> void:
	if sfx.has(sfx_name):
		var player: Sound = sfx[sfx_name]
		var __ = tween.stop(player)
		__ = tween.remove(player)
		player.stop()


func stop_2d(sfx_name: String) -> void:
	if sfx.has(sfx_name):
		var player: Sound2D = sfx[sfx_name]
		var __ = tween.stop(player)
		__ = tween.remove(player)
		player.stop()
