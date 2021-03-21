extends Interactable
class_name PressurePlate

signal toggled()

var _is_active := false

export(Array, NodePath) var doors := []


func _ready() -> void:
	for path in doors:
		var door: Door = get_node(path)
		connect("toggled", door, "toggle")


func enter() -> void:
	sprite.frame = 1
	_is_active = true
	emit_signal("toggled")


func exit() -> void:
	sprite.frame = 0
	_is_active = false
	emit_signal("toggled")
