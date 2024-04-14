extends StaticBody2D

var is_getting_attacked := false
var needed_order_of_attacks: Array[int] = []
var current_attack_index: int = 0


func _ready():
	Singleton.player_node.player_attacking.connect(player_has_attacked)


func _on_attack_area_body_entered(body):
	if body is Player:
		is_getting_attacked = true


func _on_attack_area_body_exited(body):
	if body is Player:
		is_getting_attacked = false


func player_has_attacked(which_attack: int) -> void:
	if not is_getting_attacked:
		return
