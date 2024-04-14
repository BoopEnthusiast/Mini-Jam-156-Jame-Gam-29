extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if Singleton.player_node.allow_attack_1:
		$Gem1.visible = true
	if Singleton.player_node.allow_attack_2:
		$Gem2.visible = true
	if Singleton.player_node.allow_attack_3:
		$Gem3.visible = true

