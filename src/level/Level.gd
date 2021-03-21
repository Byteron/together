extends Node2D
class_name Level

signal started()
signal finished()

var CELL_SIZE = Vector2(16, 16)

var active_character_index = 0
var active_character: Character = null

var locations := {}
var exits := []

var is_finished = false

var collected_collectibles := 0

export var song := "Solitude"

onready var character_container := $Characters
onready var object_container := $Objects
onready var exit_container := $Exits
onready var brittle_floor_container := $BrittleFloors
onready var plate_container := $Plates
onready var collectible_container := $Collectibles
onready var camera: LevelCamera = $LevelCamera

onready var walls: TileMap = $Walls
onready var floors: TileMap = $Floors


func _ready() -> void:
	_init_locations()
	_init_characters()
	_init_brittle_floors()
	_init_exits()
	_init_plates()
	_init_objects()
	_init_collectibles()

	camera.set_limits(floors.get_used_rect().position * floors.cell_size, floors.get_used_rect().end * floors.cell_size)

	var character = $Characters.get_child(0)

	if character:
		_change_character(character)

	get_tree().call_group("CharacterPanel", "update_info", character_container.get_children())

	Music.play(song, 0.5)

	yield(get_tree().create_timer(0.1), "timeout")
	emit_signal("started")


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
	elif loc.interactable:
		get_tree().call_group("UI", "show_ability_warning", loc.interactable.position, loc.interactable.get_allowed_interaction())


func spawn_character(character: Character) -> void:
	character_container.add_child(character)
	get_tree().call_group("CharacterPanel", "update_info", character_container.get_children())


func teleport_character(character: Character, target_cell: Vector2) -> void:
	var loc: Location = locations[active_character.cell]
	var next_loc: Location = locations[target_cell]

	loc.character = null
	next_loc.character = character

	var target_position = map_to_world(target_cell)
	character.cell = target_cell
	character.position = target_position

	if character == active_character:
		camera.move_to(character.position)


func jump_character() -> void:
	if is_finished:
		return

	if not active_character.can_jump() and active_character.can_move():
		get_tree().call_group("UI", "show_ability_warning", active_character.position, Character.Ability.JUMP)

	if not active_character.can_jump():
		return

	var direction = active_character.facing

	var loc: Location = locations[active_character.cell]

	if not locations.has(active_character.cell + direction):
		return

	var next_loc: Location = locations[active_character.cell + direction]

	if next_loc.is_blocking(active_character.abilities) and next_loc.is_jumpable():
		next_loc = locations[active_character.cell + direction * 2]

	if next_loc.is_blocking(active_character.abilities):
		print(next_loc.cell, " is blocked")
		return

	loc.character = null
	next_loc.character = active_character

	active_character.cell = next_loc.cell
	active_character.jump_to(next_loc.position)


func move_character(direction: Vector2) -> void:
	if not active_character.can_move() or is_finished:
		return

	var loc: Location = locations[active_character.cell]

	var interact_loc: Location = locations[loc.cell + active_character.facing]

	if interact_loc.interactable:
		interact_loc.interactable.unhighlight()

	if not locations.has(active_character.cell + direction):
		return

	var next_loc: Location = locations[active_character.cell + direction]

	active_character.facing = direction

	if next_loc.is_blocking(active_character.abilities):
		highlight_interactable(loc.cell + active_character.facing)
		return

	loc.character = null
	next_loc.character = active_character

	active_character.cell = next_loc.cell
	active_character.move_to(next_loc.position)

	highlight_interactable(next_loc.cell + active_character.facing)


func highlight_interactable(cell: Vector2) -> void:
	if not locations.has(cell):
		return

	var interact_loc = locations[cell]

	if interact_loc.interactable:
		interact_loc.interactable.highlight()


func select_character(number: int) -> void:
	if is_finished:
		return

	if character_container.get_child_count() > number:
		_change_character(character_container.get_child(number))


func cycle_character() -> void:
	if is_finished:
		return

	var index = (active_character_index + 1) % character_container.get_child_count()
	var character = character_container.get_child(index)
	_change_character(character)


func _change_character(character: Character) -> void:
	if active_character:
		active_character.disconnect("move_finished", self, "_on_character_move_finished")
	active_character_index = character.get_index()
	active_character = character
	active_character.connect("move_finished", self, "_on_character_move_finished")
	camera.target = character
	get_tree().call_group("AbilityPanel", "update_info", character)
	SFX.play("Swap")


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

			loc.connect("collectible_collected", self, "_on_collectible_collected")

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

		if object is Crate:
			object.connect("interacted", self, "_on_crate_interacted")


func _init_brittle_floors() -> void:
	for brittle in brittle_floor_container.get_children():
		var cell = world_to_map(brittle.position)
		for vec in brittle.size:
			var loc: Location = locations[cell + vec]
			loc.floor_interactable = brittle

		brittle.connect("destroyed", self, "_on_brittle_floor_destroyed", [cell])


func _init_plates() -> void:
	for plate in plate_container.get_children():
		var cell = world_to_map(plate.position)
		for vec in plate.size:
			var loc: Location = locations[cell + vec]
			loc.floor_interactable = plate


func _init_exits() -> void:
	for exit in exit_container.get_children():
		var cell = world_to_map(exit.position)
		exits.append(cell)


func _init_collectibles() -> void:
	for collectible in collectible_container.get_children():
		var cell = world_to_map(collectible.position)
		var loc: Location = locations[cell]

		loc.collectible = collectible


func _move_interactable(cell: Vector2, direction: Vector2) -> void:
	var loc: Location = locations[cell]
	var interactable := loc.interactable

	if not interactable.can_move() or is_finished:
		return

	if not locations.has(cell + direction):
		return

	var next_loc: Location = locations[cell + direction]

	if next_loc.interactable or next_loc.is_blocking([Character.Ability.MOVE]):
		return

	loc.interactable = null
	next_loc.interactable = interactable

	interactable.move_to(next_loc.position)
	interactable.unhighlight()


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
	emit_signal("finished")
	Progress.set_max_collectibles(collectible_container.get_child_count())
	Progress.set_collectibles(collected_collectibles)
	Progress.next_level()


func _on_character_move_finished() -> void:
	_check_end_conditions()


func _on_collectible_collected(collectible: Collectible) -> void:
	collected_collectibles += 1
	SFX.play("Collect")


func _on_brittle_floor_destroyed(cell: Vector2) -> void:
	var loc: Location = locations[cell]
	loc.floor_interactable = null
	loc.terrain = Data.terrains["Chasm"]
	walls.set_cellv(cell, walls.tile_set.find_tile_by_name("Chasm"))
	walls.update_bitmask_area(cell)


func _on_crate_interacted(cell: Vector2, direction: Vector2):
	_move_interactable(cell, direction)


func _on_vent_interacted(character: Character, pos: Vector2) -> void:
	var cell = world_to_map(pos)
	teleport_character(character, cell)


func _on_character_freed(character: Character, cell: Vector2) -> void:
	spawn_character(character)
	teleport_character(character, cell)
