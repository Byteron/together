extends Interactable
class_name Bunker

signal character_freed(character)

var _was_opened = false

export var id := 0
export var fragments_needed := 3

export var Character: PackedScene = null


func open() -> void:
	sprite.frame = 1
	if not _was_opened:
		emit_signal("character_freed", Character.instance())

	_was_opened = true


func _interact(character: Character):
	print(character.get_fragments(id), " / ", fragments_needed)
	if character.get_fragments(id) >= fragments_needed and not _was_opened:
		open()
