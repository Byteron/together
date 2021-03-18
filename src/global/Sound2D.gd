extends AudioStreamPlayer2D
class_name Sound2D


func play_at(position: Vector2) -> void:
	var player = duplicate()
	player.position = position
	player.connect("finished", self, "_on_finished", [ player ])
	get_tree().current_scene.add_child(player)
	player.play()


func _on_finished(player: Sound2D) -> void:
	player.queue_free()
