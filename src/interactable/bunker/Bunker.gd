extends Interactable
class_name Bunker

signal character_freed(character)
signal opened()

var _was_opened = false

export var Character: PackedScene = null
export(Array, String) var story := []

export var _is_closed := true


func _ready() -> void:
	if not _is_closed:
		open()


func open() -> void:
	anim.play("open")
	_was_opened = true


func _interact(character: Character):
	if not _was_opened:
		open()


func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if Character:
		emit_signal("character_freed", Character.instance())

	emit_signal("opened")

	for text in story:
		Writer.write(text)
	Writer.start()

