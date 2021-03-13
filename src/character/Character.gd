extends Node2D
class_name Character

enum Ability {
	HACK,
	SQUEEZE,
	CLIMB,
	SWIM,
	RAM,
}

var cell := Vector2()

export(Array, Ability) var abilities := []

onready var tween: Tween = $Tween


func move_to(target_position: Vector2) -> void:
	tween.interpolate_property(self, "position", position, target_position, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()


func can_move() -> bool:
	return not tween.is_active()
