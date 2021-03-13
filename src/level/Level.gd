extends Node2D
class_name Level

var CELL_SIZE = Vector2(16, 16)

var active_character_index = 0
var active_character: Character = null

var locations := {}

export var start_position := Vector2()

onready var characters := $Characters
onready var camera: LevelCamera = $LevelCamera
onready var tile_map: TileMap = $TileMap

onready var WALL_TILE = tile_map.tile_set.find_tile_by_name("Wall")
onready var FLOOR_TILE = tile_map.tile_set.find_tile_by_name("Floor")
onready var WATER_TILE = tile_map.tile_set.find_tile_by_name("Water")


func _ready() -> void:
	_init_locations()
	_change_character($Characters/Nerd)
	teleport_character(start_position)


func world_to_map(position: Vector2) -> Vector2:
	return (position / CELL_SIZE).floor()


func map_to_world(cell: Vector2) -> Vector2:
	return cell * CELL_SIZE + CELL_SIZE / 2


func spawn_character(character: Character) -> void:
	characters.add_child(character)


func teleport_character(target_cell: Vector2) -> void:
	var target_position = map_to_world(target_cell)
	active_character.cell = target_cell
	active_character.position = target_position


func move_character(direction: Vector2) -> void:
	if not active_character.can_move():
		return

	var loc = locations[active_character.cell + direction]

	if loc.terrain.is_blocking(active_character):
		print(loc.cell, " is blocked")
		return

	active_character.cell = loc.cell
	active_character.move_to(loc.position)


func cycle_character() -> void:
	var index = (active_character_index + 1) % characters.get_child_count()
	var character = characters.get_child(index)
	_change_character(character)


func _change_character(character: Character) -> void:
	active_character_index = character.get_index()
	active_character = character
	camera.target = character


func _init_locations() -> void:
	var rect = tile_map.get_used_rect()

	for y in range(rect.position.y, rect.end.y):
		for x in range(rect.position.x, rect.end.x):
			var cell := Vector2(x, y)
			var loc := Location.new()

			loc.cell = cell
			loc.position = map_to_world(cell)

			var tile = tile_map.get_cell(x, y)

			if tile == WALL_TILE:
				loc.terrain = load("res://data/terrains/wall.tres")
			if tile == FLOOR_TILE:
				loc.terrain = load("res://data/terrains/floor.tres")
			if tile == WATER_TILE:
				loc.terrain = load("res://data/terrains/water.tres")

			locations[cell] = loc
