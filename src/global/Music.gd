extends Node

var songs := {}
var current_song: AudioStreamPlayer = null


func _ready() -> void:
	for child in get_children():
		songs[child.name] = child


func play(song_name: String) -> void:
	if current_song:
		current_song.stop()

	current_song = songs[song_name]
	current_song.play()


func stop() -> void:
	current_song.stop()
	current_song = null
