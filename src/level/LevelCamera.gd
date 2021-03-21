extends Camera2D
class_name LevelCamera

var target: Character = null setget _set_target

onready var tween: Tween = $Tween


func _process(delta: float) -> void:
	if target and not tween.is_active():
		position = target.position


func set_limits(pos: Vector2, end: Vector2) -> void:
	limit_left = pos.x
	limit_top = pos.y
	limit_right = end.x
	limit_bottom = end.y


func move_to(new_position: Vector2) -> void:
	tween.stop_all()
	tween.remove_all()

	var __ = tween.interpolate_property(self, "position", position, new_position, 0.28, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	__ = tween.start()


func _set_target(character: Character) -> void:
	target = character
	move_to(character.position)


