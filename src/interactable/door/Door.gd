extends Interactable
class_name Door

var _is_closed = true

export var id := 0
export var fragments_needed := 3


func open() -> void:
	sprite.frame = 1
	_is_closed = false


func close() -> void:
	sprite.frame = 0
	_is_closed = true


func _interact(character: Character):
	print(character.get_fragments(id), " / ", fragments_needed)
	if character.get_fragments(id) >= fragments_needed:
		toggle()


func toggle() -> void:
	if _is_closed:
		open()
	else:
		close()


func _is_blocking(character: Character) -> bool:
	return _is_closed
