extends Interactable
class_name Door

var _is_closed = true


func open() -> void:
	sprite.frame = 1
	_is_closed = false


func close() -> void:
	sprite.frame = 0
	_is_closed = true


func _interact():
	if _is_closed:
		open()
	else:
		close()


func _is_blocking(character: Character) -> bool:
	return _is_closed
