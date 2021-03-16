extends Resource
class_name Terrain

export(Array, Character.Ability) var allow_movement = [ Character.Ability.MOVE ]
export var is_jumpable := true


func is_blocking(abilities: Array) -> bool:
	for ability in abilities:
		if allow_movement.has(ability):
			return false
	return true
