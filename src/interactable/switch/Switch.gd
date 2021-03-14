extends Interactable
class_name Switch

signal activated()
signal deactivated()

signal toggled()


var _is_active := false


func _interact(__: Character) -> void:
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
