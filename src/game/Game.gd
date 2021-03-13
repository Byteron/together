extends Node2D
class_name Game

onready var level: Level = $Level


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		level.cycle_character()


func _process(delta: float) -> void:
	level.move_character(get_input_direction())


func get_input_direction() -> Vector2:
	var left = Input.is_action_pressed("ui_left")
	var right = Input.is_action_pressed("ui_right")
	var up = Input.is_action_pressed("ui_up")
	var down = Input.is_action_pressed("ui_down")

	return Vector2(int(right) - int(left), int(down) - int(up))
