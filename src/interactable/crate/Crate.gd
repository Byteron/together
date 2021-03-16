extends Interactable
class_name Crate

const MOVE_TIME = 0.28

signal interacted(pos, direction)

onready var tween: Tween = $Tween


func _interact(character: Character) -> void:
	print("interacted with crate")
	emit_signal("interacted", character.cell + character.facing,  character.facing)


func move_to(target_position: Vector2) -> void:
	tween.interpolate_property(self, "position", position, target_position, MOVE_TIME, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()


func can_move() -> bool:
	return not tween.is_active()
