extends Interactable

var _is_broken := false


func _interact(character: Character) -> void:
	if not _is_broken:
		anim.play("break")
		_is_broken = true


func _is_blocking(abilities: Array) -> bool:
	return not _is_broken
