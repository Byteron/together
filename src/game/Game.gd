extends Node2D
class_name Game

var level: Level = null


onready var level_container := $LevelContainer
onready var hud := $UI/HUD
onready var ui := $UI


func _ready() -> void:
	seed(0) # so junk sprites are always the same
	level = Data.levels["Level%d" % Progress.current_level].instance()
	level_container.add_child(level)


func _input(event: InputEvent) -> void:
	_handle_character_selection(event)

	if event.is_action_pressed("interact"):
		level.interact()

	if event.is_action_pressed("jump"):
		level.jump_character()

	if event.is_action_pressed("pause"):
		hud.spawn_pause_screen()


func _process(delta: float) -> void:
	var direction = get_input_direction()

	if direction:
		level.move_character(direction)


func _handle_character_selection(event: InputEvent) -> void:
	if event.is_action_pressed("swap_character"):
		level.cycle_character()

	if event.is_action_pressed("select_calvin"):
		level.select_character(0)

	if event.is_action_pressed("select_becky"):
		level.select_character(1)

	if event.is_action_pressed("select_aaron"):
		level.select_character(2)

	if event.is_action_pressed("select_kathy"):
		level.select_character(3)


func get_input_direction() -> Vector2:
	var left = Input.is_action_pressed("walk_left")
	var right = Input.is_action_pressed("walk_right")
	var up = Input.is_action_pressed("walk_up")
	var down = Input.is_action_pressed("walk_down")

	var direction = Vector2(int(right) - int(left), int(down) - int(up))
	return Vector2.ZERO if direction.length() > 1 else direction
