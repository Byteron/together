class_name Location

var cell := Vector2()
var position := Vector2()

var terrain: Terrain = null
var interactable: Interactable = null
var character: Character = null


func can_interact(character: Character) -> bool:
	if interactable:
		return interactable.can_interact(character)
	return false


func interact(character: Character) -> void:
	if interactable:
		interactable.interact(character)


func is_jumpable() -> bool:
	return terrain and terrain.is_jumpable and (not interactable or interactable.is_jumpable) and not character


func is_blocking(character: Character) -> bool:
	return interactable and interactable.is_blocking(character) or self.character or terrain.is_blocking(character)
