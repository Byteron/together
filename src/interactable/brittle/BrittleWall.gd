extends Interactable

var _is_broken := false

var _stage := 0

func _interact(__: Character) -> void:
	if _stage == 0:
		_stage = 1
		sprite.frame = 1
		SFX.play("Crack")
	elif _stage == 1:
		_stage = 2
		SFX.play("Break")
		anim.play("break")


func _is_blocking(__: Array) -> bool:
	return not _stage == 2
