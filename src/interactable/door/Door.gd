extends Interactable
class_name Door

var _is_closed = true


func toggle() -> void:
	if _is_closed:
		open()
	else:
		close()


func open() -> void:
	sprite.frame = 1
	_is_closed = false


func close() -> void:
	sprite.frame = 0
	_is_closed = true


func _is_blocking(character: Character) -> bool:
	return _is_closed
