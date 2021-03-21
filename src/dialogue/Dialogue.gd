extends CanvasLayer
class_name Dialogue

signal finished()

var current := -1
var speech: Speech = null

func _ready() -> void:
	for speech in get_children():
		speech.connect("finished", self, "_on_speech_finished")
		speech.set_process_input(false)


func start() -> void:
	get_tree().paused = true

	Music.play("Conversation", 0.5)

	if has_next():
		next()
	else:
		finish()


func next() -> void:
	if speech:
		speech.set_process_input(false)

	current += 1

	speech = get_child(current)
	speech.set_process_input(true)
	speech.start()


func finish() -> void:
	Music.play(Music.previous_song, 0.5)

	get_tree().paused = false
	emit_signal("finished")


func has_next() -> bool:
	return current + 1 < get_child_count()


func _on_speech_finished() -> void:
	if has_next():
		next()
	else:
		if speech:
			speech.set_process_input(false)
			speech = null

		finish()
