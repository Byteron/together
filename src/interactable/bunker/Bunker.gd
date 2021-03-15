extends Interactable
class_name Bunker

signal character_freed(character)

var _was_opened = false

export var id := 0
export var fragments_needed := 3

export var Character: PackedScene = null
export(Array, String) var story := []


func open() -> void:
	anim.play("open")
	_was_opened = true


func _interact(character: Character):
	print(character.get_fragments(id), " / ", fragments_needed)
	if character.get_fragments(id) >= fragments_needed and not _was_opened:
		open()


func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	emit_signal("character_freed", Character.instance())

	for text in story:
		Writer.write(text)
	Writer.start()
