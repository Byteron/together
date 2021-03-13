extends Node

var terrains := {}


func _ready() -> void:
	_load_terrains()


func _load_terrains() -> void:
	terrains.clear()

	var files = Loader.load_dir("res://data/terrains/", ["tres"])

	for file in files:
		var terrain = file.data
		terrains[file.id] = terrain

	print(terrains)
