extends StaticBody2D

var is_getting_attacked := false
var needed_order_of_attacks: Array[int] = [1, 2, 3, 2, 3, 2, 1, 3, 2, 1]
var current_attack_index: int = 0

@onready var gems = [$BlueGem, $RedGem, $YellowGem]
@onready var crack_frames = $CrackFrames


func _ready():
	Singleton.player_node.player_attacking.connect(player_has_attacked)
	update_gem_sprites()


func _on_attack_area_body_entered(body):
	print(body)
	if body is Player:
		is_getting_attacked = true


func _on_attack_area_body_exited(body):
	if body is Player:
		is_getting_attacked = false


func player_has_attacked(which_attack: int) -> void:
	print(is_getting_attacked)
	if not is_getting_attacked:
		return
	
	if needed_order_of_attacks[current_attack_index] == which_attack:
		current_attack_index += 1
		if current_attack_index >= needed_order_of_attacks.size() - 1:
			print("Winner here!")
	else:
		current_attack_index = 0
	
	update_gem_sprites()
	update_cracks()


func update_gem_sprites() -> void:
	for gem in gems:
		gem.visible = false
	gems[needed_order_of_attacks[current_attack_index] - 1].visible = true


func update_cracks() -> void:
	match current_attack_index:
		0:
			crack_frames.frame = 0
		1:
			crack_frames.frame = 1
		2, 3:
			crack_frames.frame = 2
		4, 5:
			crack_frames.frame = 3
		6, 7:
			crack_frames.frame = 4
		8, 9:
			crack_frames.frame = 5
