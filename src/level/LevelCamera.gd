extends Camera2D
class_name LevelCamera

var target: Character = null


func _process(delta: float) -> void:
	if target:
		position = target.position
