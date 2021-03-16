extends Interactable
class_name PressurePlate


signal activated()
signal deactivated()

signal toggled()


var _is_active := false

export(Array, NodePath) var doors := []


func _ready() -> void:
	for path in doors:
		var door: Door = get_node(path)
		connect("toggled", door, "toggle")


func toggle() -> void:
	if _is_active:
		deactivate()
	else:
		activate()
	emit_signal("toggled")


func activate() -> void:
	sprite.frame = 1
	_is_active = true
	emit_signal("activated")


func deactivate() -> void:
	sprite.frame = 0
	_is_active = false
	emit_signal("deactivated")