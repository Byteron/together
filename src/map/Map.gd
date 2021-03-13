extends Node2D
class_name Map

var CELL_SIZE = Vector2(16, 16)

var locations := {}

func _ready() -> void:
	pass


func world_to_map(position: Vector2) -> Vector2:
	return (position / CELL_SIZE).floor()


func map_to_world(cell: Vector2) -> Vector2:
	return cell * CELL_SIZE + CELL_SIZE / 2
