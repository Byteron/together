extends Interactable
class_name Vent

export var open_tex: StreamTexture = null
export var closed_tex: StreamTexture = null

signal interacted(character, pos)


export var exit: NodePath = NodePath()
export var is_closed = true

onready var exit_vent = get_node(exit)


func _ready() -> void:
	if not is_closed:
		open()


func toggle() -> void:
	if is_closed:
		open()
	else:
		close()


func open() -> void:
	sprite.texture = open_tex
	is_closed = false
	SFX.play_2d("VentOpen", position)


func close() -> void:
	sprite.texture = closed_tex
	is_closed = true
	SFX.play_2d("VentOpen", position)


func _interact(character: Character) -> void:
	if exit_vent and not exit_vent.is_closed and not is_closed:
		emit_signal("interacted", character, exit_vent.position)
	else:
		get_tree().call_group("UI", "show_ability_warning", position, Character.Ability.MOVE)
