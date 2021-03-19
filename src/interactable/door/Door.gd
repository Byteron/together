extends Interactable
class_name Door

export var _is_closed = true
export var _interactable := false


func _ready() -> void:
	if not _is_closed:
		open()


func _interact(character: Character) -> void:
	if _interactable:
		toggle()
	else:
		get_tree().call_group("UI", "show_ability_warning", position, Character.Ability.MOVE)


func toggle() -> void:
	if _is_closed:
		open()
	else:
		close()


func open() -> void:
	anim.play("open")
	_is_closed = false
	is_jumpable = true
	SFX.play_2d("DoorOpen", position)


func close() -> void:
	anim.play("close")
	_is_closed = true
	is_jumpable = false
	SFX.play_2d("DoorClose", position)


func _is_blocking(abilities: Array) -> bool:
	return _is_closed
