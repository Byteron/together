extends Interactable
class_name Terminal

var _is_closed = true
var _is_used = false

export(Array, int) var fragments := []


func toggle() -> void:
	if _is_used:
		return

	if _is_closed:
		open()
	else:
		close()


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

	for fragment in fragments:
		character.add_fragment(fragment)
	fragments.clear()
	anim.play("use")
	_is_used = true
