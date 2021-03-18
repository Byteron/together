extends AudioStreamPlayer
class_name Sound

export var singleton := true


func play(from_position := 0.0) -> void:
	if singleton:
		.play(from_position)
	else:
		var player = self.duplicate()
		player.connect("finished", self, "_on_finished", [ player ])
		add_child(player)


func _on_finished(player: AudioStreamPlayer) -> void:
	player.queue_free()
