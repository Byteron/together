extends Interactable
class_name Vent

const OPEN_TEX = preload("res://assets/images/vent_open.png")
const CLOSED_TEX = preload("res://assets/images/vent_closed.png")

signal interacted(character, pos)


export var exit: NodePath = NodePath()
export var _is_closed = true

onready var exit_vent = get_node(exit)


func _ready() -> void:
	if not _is_closed:
		open()


func toggle() -> void:
	if _is_closed:
		open()
	else:
		close()


func open() -> void:
	sprite.texture = OPEN_TEX
	_is_closed = false


func close() -> void:
	sprite.texture = CLOSED_TEX
	_is_closed = true


func _interact(character: Character) -> void:
	if exit_vent and not _is_closed:
		emit_signal("interacted", character, exit_vent.position)
