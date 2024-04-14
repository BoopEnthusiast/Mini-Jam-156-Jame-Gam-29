extends Node

@onready var bgm_player = $BGMPlayer

var music_array = ["res://resources/audio/Music_test_1.wav", "res://resources/audio/Music_test_2.wav", "res://resources/audio/Music_test_3.wav", "res://resources/audio/Music_test_4.wav", "res://resources/audio/Music_test_5.wav"]

# Called when the node enters the scene tree for the first time.
func _ready():
	Singleton.game_won.connect(game_has_been_won)


func game_has_been_won() -> void:
	bgm_player.stop()


func _on_bgm_player_finished():
	bgm_player.play()
