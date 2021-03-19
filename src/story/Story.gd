extends CanvasLayer
class_name Story

const BLEND_TIME := 1.0
const TEXT_BLEND_TIME := 1.0
const TEXT_SHOW_TIME := 2.0

onready var tween: Tween = $Tween
onready var backdrop: TextureRect = $Backdrop
onready var frame: TextureRect = $Frame
onready var label: Label = $Label

var toggle = false

export(Array, String, MULTILINE) var texts := []

var _is_finished = true

func _ready() -> void:
	frame.rect_scale = Vector2(1.2, 1.2)
	backdrop.modulate.a = 0
	label.modulate.a = 0


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") and not _is_finished:
		end()


func start() -> void:
	if texts.empty():
		return

	get_tree().paused = true
	_is_finished = false
	_blend_in()


func _blend_in() -> void:
	print("blend in")
	tween.interpolate_property(backdrop, "modulate:a", 0.0, 1.0, 0.8, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	tween.interpolate_property(frame, "rect_scale", Vector2(1.2, 1.2), Vector2(1, 1), BLEND_TIME, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	tween.start()


func _show_text(text: String) -> void:
	print("show text: ", text)
	var delay := 0.0
	label.text = text
	tween.interpolate_property(label, "modulate:a", 0.0, 1.0, TEXT_BLEND_TIME, Tween.TRANS_CUBIC, Tween.EASE_OUT, delay)
	delay += TEXT_BLEND_TIME + TEXT_SHOW_TIME
	tween.interpolate_property(label, "modulate:a", 1.0, 0.0, TEXT_BLEND_TIME, Tween.TRANS_CUBIC, Tween.EASE_OUT, delay)
	delay += TEXT_BLEND_TIME
	tween.start()


func _blend_out() -> void:
	print("blend out")
	tween.interpolate_property(label, "modulate:a", label.modulate.a, 0.0, BLEND_TIME / 2, Tween.TRANS_CUBIC, Tween.EASE_IN)
	tween.interpolate_property(backdrop, "modulate:a", 1.0, 0.0, 0.8, Tween.TRANS_CUBIC, Tween.EASE_IN)
	tween.interpolate_property(frame, "rect_scale", Vector2(1, 1), Vector2(1.2, 1.2), BLEND_TIME, Tween.TRANS_CUBIC, Tween.EASE_IN)
	tween.start()


func end() -> void:
	print("end")

	_is_finished = true

	tween.stop_all()
	tween.remove_all()

	texts.clear()

	_blend_out()



func _on_Tween_tween_all_completed() -> void:
	if not texts.empty():
		var text = texts.pop_front()
		_show_text(text)
	elif not _is_finished:
		end()
	else:
		get_tree().paused = false
