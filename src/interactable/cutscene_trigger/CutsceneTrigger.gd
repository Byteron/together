extends Interactable
class_name CutsceneTrigger

signal toggled()

var _is_active := false


func _is_blocking(abilities: Array) -> bool:
  return false


func enter() -> void:
	_is_active = true
	emit_signal("toggled")


func exit() -> void:
	_is_active = false
	emit_signal("toggled")
