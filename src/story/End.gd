extends Control

onready var dialogue: Dialogue = $Dialogue
onready var speech: Speech = $Dialogue/Speech


func _ready() -> void:

	var time_text := "Nice job not wasting my time there."


	var collectible_text := ""
	if Progress.get_collectible_percent() == 0.0:
		collectible_text = "Are you, like, the new Marie Kondo? Wow."
	elif Progress.get_collectible_percent() < 0.5:
		collectible_text = "Guess you like to travel light, huh?"
	elif Progress.get_collectible_percent() < 1.0:
		collectible_text = "Remind me not to come 'round your place any time soon."
	else:
		collectible_text = "As in... all of it. I'm not even joking, you might have a problem or something."

	var texts := [
		"Oh, you're still here, are you? You beat the game. What do you want, a round of applause? Well, let's see...",
		"You finished the game in %d minutes" % (Progress.time / 60),
		time_text,
		"And you collected %d%% of the random junk you found lying about." % (Progress.get_collectible_percent() * 100),
		collectible_text,
		"Alright, that's it. Go and be, like, someone else's problem.",
	]

	speech.lines = texts

	dialogue.start()


func _on_Dialogue_finished() -> void:
	get_tree().change_scene_to(Scenes.TitleScreen)
