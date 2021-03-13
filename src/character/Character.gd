extends Node2D
class_name Character

enum Ability {
	MOVE,
	HACK,
	SQUEEZE,
	CLIMB,
	SWIM,
	RAM,
}

var facing := Vector2(0, 1)
var cell := Vector2()

var fragments := {}

export(Array, Ability) var abilities := []

onready var tween: Tween = $Tween


func add_fragment(fragment: int) -> void:
	if fragments.has(fragment):
		fragments[fragment] += 1
	else:
		fragments[fragment] = 1


func get_fragments(id: int) -> int:
	if fragments.has(id):
		return fragments[id]
	else:
		return 0


func move_to(target_position: Vector2) -> void:
	tween.interpolate_property(self, "position", position, target_position, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()


func can_move() -> bool:
	return not tween.is_active()
