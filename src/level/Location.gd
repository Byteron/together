class_name Location

var cell := Vector2()
var position := Vector2()

var terrain: Terrain = null
var interactable: Interactable = null
var character: Character = null


func interact() -> void:
	if interactable:
		interactable.interact()


func is_blocking(character: Character) -> bool:
	return interactable and interactable.is_blocking(character) or self.character or terrain.is_blocking(character)
