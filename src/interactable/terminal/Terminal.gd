extends Interactable
class_name Terminal

export(Array, int) var fragments := []


func _interact(character: Character):
	for fragment in fragments:
		character.add_fragment(fragment)
	fragments.clear()
	sprite.frame = 1
