extends Panel

var dialogue: String
var character_index: int = 0
var writing_dialogue := false

@onready var timer = $Timer
@onready var text = $Dialogue


func start_showing_dialogue(text: String) -> void:
	visible = true
	dialogue = text
	writing_dialogue = true
	timer.start()


func _on_timeout():
	if writing_dialogue:
		text.text += dialogue[character_index]
		character_index += 1
		if character_index >= dialogue.length():
			writing_dialogue = false


func stop_it() -> void:
	timer.stop()
	visible = false
	text.text = ""
	character_index = 0
	writing_dialogue = false
