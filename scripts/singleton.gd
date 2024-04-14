extends Node

signal reset_signal
signal game_won

@onready var timer
@onready var player_node: Player
@onready var time_left
var has_game_won := false

# Called when the node enters the scene tree for the first time.
func _ready():
	timer = Timer.new()
	add_child(timer)
	timer.timeout.connect(_on_timer_timeout)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time_left = timer.time_left

func _on_timer_timeout():
	if not game_won:
		reset()
		reset_signal.emit()

func reset():
	if not game_won:
		#quick note regarding player_node.reset()
		#if you want the full animation to play out before the full reset, call playernode.reset() and that only, it will call the full reset when the animation is done
		player_node.reset() 
		get_tree().reload_current_scene()
