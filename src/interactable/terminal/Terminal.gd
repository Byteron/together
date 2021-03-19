extends Interactable
class_name Terminal

signal used()

var _is_used = false

export var is_closed := true

export(Array, NodePath) var doors := []


func _ready() -> void:
	for path in doors:
		var door: Interactable = get_node(path)
		connect("used", door, "toggle")

	if not is_closed:
		open()


func toggle() -> void:
	if _is_used:
		return

	if is_closed:
		open()
	else:
		close()


func open() -> void:
	if _is_used:
		return

	anim.play("open")
	SFX.play_2d("ConsoleOpen", position)
	is_closed = false


func close() -> void:
	if _is_used:
		return

	anim.play("close")
	SFX.play_2d("ConsoleClose", position)
	is_closed = true


func _interact(character: Character):
	if is_closed or _is_used:
		return

	anim.play("use")
	_is_used = true
	emit_signal("used")
