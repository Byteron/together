class_name Location

signal collectible_collected(collectible)

var cell := Vector2()
var position := Vector2()

var terrain: Terrain = null
var interactable: Interactable = null setget _set_interactable
var collectible: Collectible = null
var pressure_plate: PressurePlate = null
var character: Character = null setget _set_character


func can_interact(character: Character) -> bool:
	if interactable:
		return interactable.can_interact(character)
	return false


func interact(character: Character) -> void:
	if interactable:
		interactable.interact(character)


func entered() -> void:
	if pressure_plate:
		pressure_plate.toggle()

	if collectible:
		emit_signal("collectible_collected", collectible)
		collectible.queue_free()
		collectible = null


func exited() -> void:
	if pressure_plate:
		pressure_plate.toggle()


func is_jumpable() -> bool:
	return terrain and terrain.is_jumpable and (not interactable or interactable.is_jumpable) and not character


func is_blocking(abilities: Array) -> bool:
	return interactable and interactable.is_blocking(abilities) or self.character or terrain.is_blocking(abilities)


func _set_interactable(_interactable: Interactable) -> void:
	interactable = _interactable

	if interactable:
		entered()
	else:
		exited()


func _set_character(_character: Character) -> void:
	character = _character

	if character:
		entered()
	else:
		exited()
