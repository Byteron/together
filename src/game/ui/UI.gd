extends CanvasLayer
class_name UI

export var AbilityWarning: PackedScene = null


func show_ability_warning(position: Vector2, ability: int) -> void:
	var warning: AbilityWarning = AbilityWarning.instance()
	warning.initialize(position, ability)
	add_child(warning)
