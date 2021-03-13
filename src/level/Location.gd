class_name Location

var cell := Vector2()
var position := Vector2()

var terrain: Terrain = null
var interactable: Interactable = null
var character: Character = null

func is_blocking(character: Character) -> bool:
	print(interactable, self.character, terrain.is_blocking(character))
	return interactable or self.character or terrain.is_blocking(character)
