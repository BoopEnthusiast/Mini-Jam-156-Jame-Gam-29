extends Panel

var dialogue: String
var character_index: int = 0

@onready var timer = $Timer
@onready var text = $Dialogue


func start_showing_dialogue(text: String) -> void:
	dialogue = text
	timer.start()


func _on_timeout():
	text.text += dialogue[character_index]
	character_index += 1


func stop_it() -> void:
	timer.stop()
	visible = false
	text.text = ""
	character_index = 0
