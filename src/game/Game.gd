extends Node2D
class_name Game

onready var level: Level = $Level


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		level.cycle_character()


func _process(delta: float) -> void:
	var direction = get_input_direction()

	if direction:
		level.move_character(direction)


func get_input_direction() -> Vector2:
	var left = Input.is_action_pressed("ui_left")
	var right = Input.is_action_pressed("ui_right")
	var up = Input.is_action_pressed("ui_up")
	var down = Input.is_action_pressed("ui_down")

	var direction = Vector2(int(right) - int(left), int(down) - int(up))
	return Vector2.ZERO if direction.length() > 1 else direction
