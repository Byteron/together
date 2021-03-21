extends Control

onready var dialogue: Dialogue = $Dialogue
onready var speech: Speech = $Dialogue/Speech


func _ready() -> void:
	var texts := [
		"Hello, This is me.",
		"You've got %d%% trash" % (Progress.get_collectible_percent() * 100),
		"And you spent %d minutes in this game." % (Progress.time / 60),
		"GBye",
	]

	speech.lines = texts

	dialogue.start()


func _on_Dialogue_finished() -> void:
	get_tree().change_scene_to(Scenes.TitleScreen)
