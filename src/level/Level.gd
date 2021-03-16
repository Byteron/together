extends Node2D
class_name Level

var CELL_SIZE = Vector2(16, 16)

var active_character_index = 0
var active_character: Character = null

var locations := {}
var exits := []

var is_finished = false

onready var character_container := $Characters
onready var object_container := $Objects
onready var exit_container := $Exits

onready var camera: LevelCamera = $LevelCamera

onready var walls: TileMap = $Walls
onready var floors: TileMap = $Floors


func _ready() -> void:
	_init_locations()
	_init_characters()
	_init_exits()
	_init_objects()

	var character = $Characters.get_child(0)

	if character:
		_change_character(character)


func world_to_map(position: Vector2) -> Vector2:
	return (position / CELL_SIZE).floor()


func map_to_world(cell: Vector2) -> Vector2:
	return cell * CELL_SIZE + CELL_SIZE / 2


func interact() -> void:
	if is_finished:
		return

	var loc: Location = locations[active_character.cell + active_character.facing]
	if loc.can_interact(active_character):
		loc.interact(active_character)


func spawn_character(character: Character) -> void:
	character_container.add_child(character)


func teleport_character(character: Character, target_cell: Vector2) -> void:
	var loc: Location = locations[active_character.cell]
	var next_loc: Location = locations[target_cell]

	loc.character = null
	next_loc.character = character

	var target_position = map_to_world(target_cell)
	character.cell = target_cell
	character.position = target_position


func jump_character() -> void:
	if not active_character.can_jump() or is_finished:
		return

	var loc: Location = locations[active_character.cell + active_character.facing]

	if not loc.is_jumpable():
		return

	_jump_character(active_character.facing * 2)


func _jump_character(direction: Vector2) -> void:
	if not direction:
		return

	var loc: Location = locations[active_character.cell]

	if not locations.has(active_character.cell + direction):
		_jump_character(direction - active_character.facing)
		return

	var next_loc: Location = locations[active_character.cell + direction]


	if next_loc.is_blocking(active_character):
		print(next_loc.cell, " is blocked")
		_jump_character(direction - active_character.facing)
		return

	loc.character = null
	next_loc.character = active_character

	active_character.cell = next_loc.cell
	active_character.jump_to(next_loc.position)

	_check_end_conditions()


func move_character(direction: Vector2) -> void:
	if not active_character.can_move() or is_finished:
		return

	var loc: Location = locations[active_character.cell]

	if not locations.has(active_character.cell + direction):
		return

	var next_loc: Location = locations[active_character.cell + direction]

	active_character.facing = direction

	if next_loc.is_blocking(active_character):
		print(next_loc.cell, " is blocked")
		return

	loc.character = null
	next_loc.character = active_character

	active_character.cell = next_loc.cell
	active_character.move_to(next_loc.position)

	_check_end_conditions()


func cycle_character() -> void:
	if is_finished:
		return

	var index = (active_character_index + 1) % character_container.get_child_count()
	var character = character_container.get_child(index)
	_change_character(character)


func _change_character(character: Character) -> void:
	active_character_index = character.get_index()
	active_character = character
	camera.target = character
	get_tree().call_group("AbilityPanel", "update_info", character)


func _init_locations() -> void:
	var rect = floors.get_used_rect()

	for y in range(rect.position.y, rect.end.y):
		for x in range(rect.position.x, rect.end.x):
			var tile = walls.get_cell(x, y)

			if tile == TileMap.INVALID_CELL:
				tile = floors.get_cell(x, y)

			if tile == TileMap.INVALID_CELL:
				continue

			var cell := Vector2(x, y)
			var loc := Location.new()

			loc.cell = cell
			loc.position = map_to_world(cell)

			loc.terrain = Data.terrains[floors.tile_set.tile_get_name(tile)]

			locations[cell] = loc


func _init_characters() -> void:
	for character in character_container.get_children():
		var cell = world_to_map(character.position)
		var loc: Location = locations[cell]

		character.cell = cell
		character.position = map_to_world(cell)

		loc.character = character


func _init_objects() -> void:
	for object in object_container.get_children():
		var cell = world_to_map(object.position)
		for vec in object.size:
			var loc = locations[cell + vec]
			loc.interactable = object

		if object is Bunker:
			object.connect("character_freed", self, "_on_character_freed", [cell])

		if object is Vent:
			object.connect("interacted", self, "_on_vent_interacted")

func _init_exits() -> void:
	for exit in exit_container.get_children():
		var cell = world_to_map(exit.position)
		exits.append(cell)


func _check_end_conditions() -> void:
	var all_chars_on_exit = true

	for character in character_container.get_children():
		if not exits.has(character.cell):
			all_chars_on_exit = false

	if character_container.get_child_count() == exits.size() and all_chars_on_exit:
		is_finished = true

	print("check condition: ", is_finished)
	if is_finished:
		_finish()


func _finish() -> void:
	print("finish")
	yield(get_tree().create_timer(1.0), "timeout")
	get_tree().reload_current_scene()


func _on_vent_interacted(character: Character, pos: Vector2) -> void:
	var cell = world_to_map(pos)
	teleport_character(active_character, cell)


func _on_character_freed(character: Character, cell: Vector2) -> void:
	spawn_character(character)
	teleport_character(character, cell)
