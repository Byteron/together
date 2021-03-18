extends AudioStreamPlayer2D
class_name Sound2D


func play_at(position: Vector2) -> void:
	var player = self.duplicate()
	player.position = position
	player.connect("finished", self, "_on_finished", [ player ])
	add_child(player)
	player.play()


func _on_finished(player: AudioStreamPlayer) -> void:
	player.queue_free()
