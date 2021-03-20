extends Node

var outline_material: Material = preload("res://assets/shaders/outline.tres")

var collectible_textures := {
	Collectible.Type.VINYL: load("res://assets/images/vinyl.png")
}

var current_level := 1

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
