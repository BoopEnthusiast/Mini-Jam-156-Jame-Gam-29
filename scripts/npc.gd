class_name NPC extends StaticBody2D

@export var dialogue: String = "Text goes here..."
@export_range(0, 2) var which_npc: int = 0

@onready var text_background = $TextBackground
@onready var animated_sprite = $AnimatedSprite


func _ready():
	animated_sprite.play(str(which_npc))


func _on_talk_area_body_entered(body):
	print(body)
	if body is Player:
		text_background.start_showing_dialogue(dialogue)


func _on_talk_area_body_exited(body):
	if body is Player:
		text_background.stop_it()
