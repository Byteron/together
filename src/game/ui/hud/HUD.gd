extends CanvasLayer
class_name HUD

export var PauseScreen: PackedScene = null


func spawn_pause_screen() -> void:
	var pause_screen : Control = PauseScreen.instance()
	self.add_child(pause_screen)
	get_tree().paused = true
