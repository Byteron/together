extends Interactable
class_name Terminal

signal toggled()
signal used()

var _is_used = false

export var is_closed := true


func _ready() -> void:
	if not is_closed:
		open()


func toggle() -> void:
	if _is_used:
		return

	if is_closed:
		open()
	else:
		close()

	emit_signal("toggled")


func open() -> void:
	if _is_used:
		return

	anim.play("open")
	is_closed = false


func close() -> void:
	if _is_used:
		return

	anim.play("close")
	is_closed = true


func _interact(character: Character):
	if is_closed or _is_used:
		return

	anim.play("use")
	_is_used = true
	emit_signal("used")
