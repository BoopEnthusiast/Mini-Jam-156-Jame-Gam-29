extends Node

@onready var bgm_player = $BGMPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	Singleton.game_won.connect(game_has_been_won)


func game_has_been_won() -> void:
	bgm_player.stop()
