extends CanvasLayer

const _PauseScreen : PackedScene = preload("res://src/game/hud/PauseScreen.tscn")

func spawn_pause_screen() -> void:
	var pause_screen : Control = _PauseScreen.instance()
	self.add_child(pause_screen)
