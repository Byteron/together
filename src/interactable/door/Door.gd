extends Interactable
class_name Door

export var _is_closed = true
export var _is_interactable := false

export var locked_tex: Texture = null
export var unlocked_tex: Texture = null

onready var locking_sprite: Sprite = $LockingSprite


func _ready() -> void:
	if not _is_closed:
		open()

	if _is_interactable:
		locking_sprite.texture = unlocked_tex


func _interact(character: Character) -> void:
	if _is_interactable:
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
	SFX.play_2d("DoorOpen", position)


func close() -> void:
	anim.play("close")

	SFX.play_2d("DoorClose", position)


func _is_blocking(abilities: Array) -> bool:
	return _is_closed


func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "open":
		_is_closed = false
		is_jumpable = true
	else:
		_is_closed = true
		is_jumpable = false
