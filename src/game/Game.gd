extends Node2D
class_name Game

var level: Level = null

export var song := "Solitude"
onready var level_container := $LevelContainer
onready var hud := $UI/HUD
onready var ui := $UI


func _ready() -> void:
#	Music.play(song)
	level = Data.levels["Level%d" % Progress.current_level].instance()
	level_container.add_child(level)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("swap_character"):
		level.cycle_character()

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


func get_input_direction() -> Vector2:
	var left = Input.is_action_pressed("walk_left")
	var right = Input.is_action_pressed("walk_right")
	var up = Input.is_action_pressed("walk_up")
	var down = Input.is_action_pressed("walk_down")

	var direction = Vector2(int(right) - int(left), int(down) - int(up))
	return Vector2.ZERO if direction.length() > 1 else direction
