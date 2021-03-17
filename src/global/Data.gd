extends Node

var ability_warnings := {
	Character.Ability.HACK: load("res://assets/images/hack_!.png"),
#	Character.Ability.MOVE: load("res://assets/images/move_!.png"),
	Character.Ability.SQUEEZE: load("res://assets/images/small_!.png"),
	Character.Ability.PUSH: load("res://assets/images/muscle_!.png"),
	Character.Ability.JUMP: load("res://assets/images/jump_!.png"),
}

var levels := {}
var terrains := {}
var abilities := {}


func _ready() -> void:
	_load_levels()
	_load_terrains()
	_load_abilities()


func _load_levels() -> void:
	levels.clear()

	var files = Loader.load_dir("res://data/levels/", ["tscn"])

	for file in files:
		var level = file.data
		levels[file.id] = level

	print(levels)


func _load_terrains() -> void:
	terrains.clear()

	var files = Loader.load_dir("res://data/terrains/", ["tres"])

	for file in files:
		var terrain = file.data
		terrains[file.id] = terrain

	print(terrains)


func _load_abilities() -> void:
	abilities.clear()

	var files = Loader.load_dir("res://data/abilities/", ["tres"])

	for file in files:
		var ability = file.data
		abilities[file.data.ability] = ability

	print(abilities)
