extends Node2D
class_name Level

var CELL_SIZE = Vector2(16, 16)

var active_character_index = 0
var active_character: Character = null

var locations := {}

onready var characters := $Characters
onready var objects := $Objects

onready var camera: LevelCamera = $LevelCamera
onready var tile_map: TileMap = $TileMap


func _ready() -> void:
	_init_locations()
	_init_characters()
	_init_objects()
	_change_character($Characters/Nerd)


func world_to_map(position: Vector2) -> Vector2:
	return (position / CELL_SIZE).floor()


func map_to_world(cell: Vector2) -> Vector2:
	return cell * CELL_SIZE + CELL_SIZE / 2


func interact() -> void:
	var loc: Location = locations[active_character.cell + active_character.facing]
	if loc.can_interact(active_character):
		loc.interact(active_character)


func spawn_character(character: Character) -> void:
	characters.add_child(character)


func teleport_character(character: Character, target_cell: Vector2) -> void:
	var loc: Location = locations[target_cell]
	loc.character = character

	var target_position = map_to_world(target_cell)
	character.cell = target_cell
	character.position = target_position


func move_character(direction: Vector2) -> void:
	if not active_character.can_move():
		return

	var loc: Location = locations[active_character.cell]
	var next_loc: Location = locations[active_character.cell + direction]

	active_character.facing = direction

	if next_loc.is_blocking(active_character):
		print(next_loc.cell, " is blocked")
		return

	loc.character = null
	next_loc.character = active_character

	active_character.cell = next_loc.cell
	active_character.move_to(next_loc.position)


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
			var tile = tile_map.get_cell(x, y)

			if tile == TileMap.INVALID_CELL:
				continue

			var cell := Vector2(x, y)
			var loc := Location.new()

			loc.cell = cell
			loc.position = map_to_world(cell)


			print(Data.terrains, tile_map.tile_set.tile_get_name(tile))
			loc.terrain = Data.terrains[tile_map.tile_set.tile_get_name(tile)]

			locations[cell] = loc


func _init_characters() -> void:
	for character in characters.get_children():
		var cell = world_to_map(character.position)
		var loc: Location = locations[cell]

		character.cell = cell
		character.position = map_to_world(cell)

		loc.character = character


func _init_objects() -> void:
	for object in objects.get_children():
		var cell = world_to_map(object.position)
		for vec in object.size:
			var loc = locations[cell + vec]
			loc.interactable = object

		if object is Bunker:
			object.connect("character_freed", self, "_on_character_freed", [cell])


func _on_character_freed(character: Character, cell: Vector2) -> void:
	spawn_character(character)
	teleport_character(character, cell)
