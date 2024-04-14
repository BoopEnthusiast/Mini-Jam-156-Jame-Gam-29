extends Control


const MAIN = preload("res://scenes/main.tscn")


func _input(event):
	if event is InputEventKey:
		if event.pressed:
			Singleton.timer.start(300)
			get_tree().change_scene_to_packed(MAIN)


