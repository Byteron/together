extends PanelContainer

export var CharacterItem: PackedScene = null

onready var container: HBoxContainer = $HBoxContainer


func update_info(characters: Array) -> void:
	for child in container.get_children():
		remove_child(child)
		child.queue_free()

	for character in characters:
		var item = CharacterItem.instance()
		item.texture = character.portrait
		container.add_child(item)
