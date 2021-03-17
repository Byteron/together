extends HBoxContainer
class_name CollectibleItem

onready var label = $Label
onready var texture_rect = $TextureRect


func update_info(tex: Texture, amount: int, total: int) -> void:
	texture_rect.texture = tex
	label.text = "%d / %d" % [amount, total]
