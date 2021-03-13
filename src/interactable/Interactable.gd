extends Node2D
class_name Interactable

onready var sprite: Sprite = $Sprite


func interact() -> void:
	_interact()


func is_blocking(character: Character) -> bool:
	return _is_blocking(character)


func _interact() -> void:
	pass


func _is_blocking(character: Character) -> bool:
	return true
