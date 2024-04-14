class_name NPC extends StaticBody2D

@export var dialogue: String = "Text goes here..."
@export_range(0, 2) var which_npc: int = 0

@onready var text_background = $TextBackground


func _on_talk_area_body_entered(body):
	text_background.start_showing_dialogue(dialogue)


func _on_talk_area_body_exited(body):
	text_background.stop_it()
