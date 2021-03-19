extends Camera2D
class_name LevelCamera

var target: Character = null


func _process(delta: float) -> void:
	if target:
		position = target.position


func set_limits(pos: Vector2, end: Vector2) -> void:
	limit_left = pos.x
	limit_top = pos.y
	limit_right = end.x
	limit_bottom = end.y
