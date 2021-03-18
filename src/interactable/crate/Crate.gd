extends Interactable
class_name Crate

signal interacted(pos, direction)


func _interact(character: Character) -> void:
	print("interacted with crate")
	emit_signal("interacted", character.cell + character.facing,  character.facing)



