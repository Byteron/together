extends Node2D
class_name Game

onready var level: Level = $Level


func _ready() -> void:
	Music.play("Solitude")


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("swap_character"):
		level.cycle_character()

	if event.is_action_pressed("interact"):
		level.interact()

func _process(delta: float) -> void:
	var direction = get_input_direction()

	if direction:
		level.move_character(direction)


func get_input_direction() -> Vector2:
	var left = Input.is_action_pressed("walk_left")
	var right = Input.is_action_pressed("walk_right")
	var up = Input.is_action_pressed("walk_up")
	var down = Input.is_action_pressed("walk_down")

	var direction = Vector2(int(right) - int(left), int(down) - int(up))
	return Vector2.ZERO if direction.length() > 1 else direction
