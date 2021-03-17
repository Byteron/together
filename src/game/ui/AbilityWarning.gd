extends Control
class_name AbilityWarning

var _position := Vector2()
var _ability := 0

onready var texture_rect: TextureRect = $TextureRect
onready var tween: Tween = $Tween


func _ready() -> void:
	rect_scale = Vector2(1, 0)
	rect_position = _position
	texture_rect.texture = Data.abilities[_ability].warning
	tween.interpolate_property(self, "rect_scale", Vector2(1, 0), Vector2(1, 1), 0.2, Tween.TRANS_BACK, Tween.EASE_OUT)
	tween.interpolate_property(self, "modulate:a", 1, 0, 0.2, Tween.TRANS_SINE, Tween.EASE_OUT, 0.2)
	tween.start()


func initialize(position: Vector2, ability: int) -> void:
	_position = position
	_ability = ability


func _on_Tween_tween_all_completed() -> void:
	queue_free()
