extends Interactable
class_name BrittleFloor

signal destroyed()

var _stage := 0

export(Array, NodePath) var doors := []


func _ready() -> void:
	for path in doors:
		var door: Door = get_node(path)
		connect("toggled", door, "toggle")


func enter() -> void:
	pass


func exit() -> void:
	if _stage == 0:
		sprite.frame = 1
		_stage = 1
		SFX.play("Crack")
	elif _stage == 1:
		SFX.play("Break")
		anim.play("break")
		emit_signal("destroyed")


func _on_AnimationPlayer_animation_finished(__: String) -> void:
	queue_free()
