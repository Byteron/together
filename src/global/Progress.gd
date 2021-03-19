extends Node

var current_level := 1


func next_level() -> void:
	current_level += 1

	if current_level < Data.levels.size():
		get_tree().change_scene_to(Scenes.Game)
	else:
		get_tree().change_scene_to(Scenes.TitleScreen)
