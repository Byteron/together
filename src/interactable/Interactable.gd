extends Node2D
class_name Interactable

const MOVE_TIME = 0.28

signal move_finished()

export(Array, Character.Ability) var allow_interaction := []
export(Array, Vector2) var size := [Vector2(0, 0)]
export var is_jumpable := false

onready var sprite: Sprite = $Sprite
onready var anim: AnimationPlayer = $AnimationPlayer
onready var tween: Tween = $Tween


func move_to(target_position: Vector2) -> void:
	tween.interpolate_property(self, "position", position, target_position, MOVE_TIME, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()


func can_move() -> bool:
	return not tween.is_active()


func interact(character: Character) -> void:
	_interact(character)


func highlight() -> void:
	var color = Data.abilities[get_allowed_interaction()].color

	sprite.material = Data.outline_material.duplicate()
	sprite.material.set_shader_param("outline_color", color)


func unhighlight() -> void:
	sprite.material = null


func is_blocking(abilities: Array) -> bool:
	return _is_blocking(abilities)


func get_allowed_interaction() -> int:
	return allow_interaction[0] if allow_interaction else Character.Ability.MOVE


func can_interact(character: Character) -> bool:
	return _can_interact(character)


func _interact(_character: Character) -> void:
	pass


func _is_blocking(_abilities: Array) -> bool:
	return true


func _can_interact(character: Character) -> bool:
	for ability in character.abilities:
		if allow_interaction.has(ability):
			return true
	return false


func _on_Tween_tween_all_completed() -> void:
	emit_signal("move_finished")
