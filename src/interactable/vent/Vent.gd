extends Interactable
class_name Vent

signal interacted(character, pos)


export var exit: NodePath = NodePath()
onready var exit_vent = get_node(exit)


func _interact(character: Character) -> void:
	if exit_vent:
		emit_signal("interacted", character, exit_vent.position)
