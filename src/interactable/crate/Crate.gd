extends Interactable
class_name Crate

signal interacted(pos, direction)


func _interact(character: Character) -> void:
	SFX.play("Crate")
	emit_signal("interacted", character.cell + character.facing,  character.facing)


