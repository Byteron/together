extends Node

var current_level := 2
var collectibles := {}
var collected_collectibles := {}

var time := 0

func _process(delta: float) -> void:
	time += delta

func set_max_collectibles(amount: int) -> void:
	collectibles[current_level] = amount

func set_collectibles(amount: int) -> void:
	collected_collectibles[current_level] = amount


func get_collectible_percent() -> float:
	var all := 0.0
	var collected := 0.0

	for level in collectibles:
		all += collectibles[level]

	for level in collected_collectibles:
		collected += collected_collectibles[level]

	return collected / all


func next_level() -> void:
	current_level += 1

	if current_level < Data.levels.size():
		get_tree().change_scene_to(Scenes.Game)
	else:
		get_tree().change_scene_to(Scenes.TitleScreen)
