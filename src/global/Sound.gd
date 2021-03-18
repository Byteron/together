extends AudioStreamPlayer
class_name Sound

export var singleton := true


func play(from_position := 0.0) -> void:
	if singleton:
		.play(from_position)
	else:
		var player = self.duplicate()
		player.singleton = false
		player.connect("finished", self, "_on_finished", [ player ])
		get_tree().current_scene.add_child(player)
		player.play()


func _on_finished(player: AudioStreamPlayer) -> void:
	player.queue_free()
