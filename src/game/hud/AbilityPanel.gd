extends PanelContainer
class_name AbilityPanel

export var AbilityItem: PackedScene = null

onready var container = $VBoxContainer


func update_info(character: Character) -> void:
	_clear()

	for ability in character.abilities:
		var data: AbilityData = Data.abilities[ability]
		var item: TextureRect = AbilityItem.instance()
		item.hint_tooltip = data.hint
		item.texture = data.texture
		container.add_child(item)


func _clear() -> void:
	for child in container.get_children():
		container.remove_child(child)
		child.queue_free()
