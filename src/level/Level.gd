extends Node2D
class_name Level


var active_character_index = 0
var active_character: Character = null

export var start_position := Vector2()

onready var characters := $Characters
onready var camera: LevelCamera = $LevelCamera
onready var map: Map = $Map


func _ready() -> void:
	change_character($Characters/Nerd)
	teleport_character(start_position)


func add_character(character: Character) -> void:
	characters.add_child(character)


func teleport_character(target_cell: Vector2) -> void:
	var target_position = map.map_to_world(target_cell)
	active_character.cell = target_cell
	active_character.position = target_position


func move_character(direction: Vector2) -> void:
	if not active_character.can_move():
		return

	var target_cell = active_character.cell + direction
	var target_position = map.map_to_world(target_cell)
	active_character.cell = target_cell
	active_character.move_to(target_position)


func cycle_character() -> void:
	var index = (active_character_index + 1) % characters.get_child_count()
	var character = characters.get_child(index)
	change_character(character)



func change_character(character: Character) -> void:
	active_character_index = character.get_index()
	active_character = character
	camera.target = character
