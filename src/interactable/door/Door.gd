extends Interactable
class_name Door

export var _is_closed = true


func _ready() -> void:
	if not _is_closed:
		open()


func toggle() -> void:
	if _is_closed:
		open()
	else:
		close()


func open() -> void:
	anim.play("open")
	_is_closed = false
	is_jumpable = true


func close() -> void:
	anim.play("close")
	_is_closed = true
	is_jumpable = false


func _is_blocking(abilities: Array) -> bool:
	return _is_closed
