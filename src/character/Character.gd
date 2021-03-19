extends Node2D
class_name Character

signal move_finished()

const MOVE_TIME := 0.2

enum Ability {
	MOVE,
	HACK,
	SQUEEZE,
	JUMP,
	PUSH,
	SING,
}

var facing := Vector2(0, 1)
var cell := Vector2()

export(Array, Ability) var abilities := []

onready var tween: Tween = $Tween
onready var sprite: Sprite = $Sprite


func move_to(target_position: Vector2) -> void:
	tween.interpolate_property(self, "position", position, target_position, MOVE_TIME, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	SFX.play("Step")


func jump_to(target_position: Vector2) -> void:
	tween.interpolate_property(self, "position", position, target_position, MOVE_TIME, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.interpolate_property(sprite, "position", Vector2(), Vector2(0, -8), MOVE_TIME / 2, Tween.TRANS_SINE, Tween.EASE_IN)
	tween.interpolate_property(sprite, "position", Vector2(0, -8), Vector2(), MOVE_TIME / 2, Tween.TRANS_SINE, Tween.EASE_OUT, MOVE_TIME / 2)
	tween.start()


func can_jump() -> bool:
	return can_move() and abilities.has(Ability.JUMP)


func can_move() -> bool:
	return not tween.is_active()


func _on_Tween_tween_all_completed() -> void:
	emit_signal("move_finished")
