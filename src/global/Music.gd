extends Node

onready var tween: Tween = $Tween

var songs := {}
var current_song: AudioStreamPlayer = null


func _ready() -> void:
	for child in get_children():
		songs[child.name] = child


func play(song_name: String, fade_in := 0.0, start_db := -40, end_db = -10) -> void:
	if current_song:
		stop()

	current_song = songs[song_name]

	if fade_in:
		tween.interpolate_property(current_song, "volume_db", start_db, end_db, fade_in)
		tween.start()

	current_song.play()


func stop() -> void:
	current_song.stop()
	tween.stop(current_song)
	tween.remove(current_song)
	current_song = null
