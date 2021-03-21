extends Collectible
class_name Junk

onready var sprite: Sprite = $Sprite

func _ready() -> void:
	sprite.frame = randi() % 3
