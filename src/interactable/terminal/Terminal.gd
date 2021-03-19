extends Interactable
class_name Terminal

signal toggled()
signal used()

var _is_closed = true
var _is_used = false


func toggle() -> void:
	if _is_used:
		return

	if _is_closed:
		open()
	else:
		close()

	emit_signal("toggled")


func open() -> void:
	if _is_used:
		return

	anim.play("open")
	_is_closed = false


func close() -> void:
	if _is_used:
		return

	anim.play("close")
	_is_closed = true


func _interact(character: Character):
	if _is_closed or _is_used:
		return

	anim.play("use")
	_is_used = true
	emit_signal("used")
