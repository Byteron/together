extends PanelContainer
class_name CollectiblePanel

export var CollectibleItem: PackedScene = null

onready var container := $HBoxContainer

func update_info(collectibles: Dictionary, collected: Dictionary) -> void:
	for child in container.get_children():
		container.remove_child(child)
		child.queue_free()

	for key in collectibles:
		var total = collectibles[key]
		var amount = 0

		if collected.has(key):
			amount = collected[key]

		var item: CollectibleItem = CollectibleItem.instance()
		container.add_child(item)
		item.update_info(Data.collectible_textures[key], amount, total)
