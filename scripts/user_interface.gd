extends Control

@onready var animation_player = $AnimationPlayer
@onready var the_licc = $TheLicc
@onready var label = $CanvasLayer/ColorRect/Label
@onready var timer = $Timer

# Called when the node enters the scene tree for the first time.
func _ready():
	Singleton.game_won.connect(_game_is_won)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if Singleton.player_node.allow_attack_1:
		$Gem1.visible = true
	if Singleton.player_node.allow_attack_2:
		$Gem2.visible = true
	if Singleton.player_node.allow_attack_3:
		$Gem3.visible = true


func _game_is_won() -> void:
	animation_player.play("fade_to_black")


func _on_animation_player_animation_finished(anim_name):
	the_licc.play()
	label.visible = true
	timer.start()


func _on_timer_timeout():
	get_tree().quit()
