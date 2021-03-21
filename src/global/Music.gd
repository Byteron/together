extends Node

onready var tween: Tween = $Tween

var songs := {}
var current_song: AudioStreamPlayer = null
var previous_song := ""


func _ready() -> void:
	for child in get_children():
		songs[child.name] = child


func play(song_name: String, fade_in := 0.0, start_db := -40, end_db = -10) -> void:
	if current_song:
		stop()

	current_song = songs[song_name]

	if fade_in:
		var __ = tween.interpolate_property(current_song, "volume_db", start_db, end_db, fade_in)
		__ = tween.start()

	current_song.play()
	print("Now Playing: %s" % song_name)

func fade_out_and_stop() -> void:
	tween.interpolate_property(current_song, "volume_db", null, -40.0, 1.0)
	tween.start()
	yield(tween, "tween_all_completed")
	stop()

func stop() -> void:
	if not current_song:
		return

	print("Stop Playing: %s" % current_song.name)

	previous_song = current_song.name
	current_song.stop()
	var __ = tween.stop(current_song)
	__ = tween.remove(current_song)
	current_song = null
