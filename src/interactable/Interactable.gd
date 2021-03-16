extends Node2D
class_name Interactable

export(Array, Character.Ability) var allow_interaction := []
export(Array, Vector2) var size := [Vector2(0, 0)]
export var is_jumpable := false

onready var sprite: Sprite = $Sprite
onready var anim: AnimationPlayer = $AnimationPlayer


func interact(character: Character) -> void:
	_interact(character)


func is_blocking(abilities: Array) -> bool:
	return _is_blocking(abilities)


func can_interact(character: Character) -> bool:
	return _can_interact(character)


func _interact(character: Character) -> void:
	pass


func _is_blocking(abilities: Array) -> bool:
	return true


func _can_interact(character: Character) -> bool:
	for ability in character.abilities:
		if allow_interaction.has(ability):
			return true
	return false
