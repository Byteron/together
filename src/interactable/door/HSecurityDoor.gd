extends Door
class_name HSecurityDoor

onready var top: Sprite = $Top

func highlight() -> void:
	var color = Data.abilities[get_allowed_interaction()].color

	sprite.material = Data.outline_material.duplicate()
	top.material = Data.outline_material.duplicate()
	sprite.material.set_shader_param("outline_color", color)
	top.material.set_shader_param("outline_color", color)


func unhighlight() -> void:
	sprite.material = null
	top.material = null
