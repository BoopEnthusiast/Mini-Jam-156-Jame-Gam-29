extends Area2D

@export_range(0, 2) var which_gem: int = 0 # 0: blue, 1: red, 2: yellow

@onready var gem_sprites: Array[Sprite2D] = [$GemBlue, $GemRed, $GemYellow]


func _ready():
	assert(which_gem >= 0 or which_gem < len(gem_sprites), "Artefact is only meant to be 0, 1, or 2. It is not 0, 1, or 2, change this on the node since it's an @export variable. Also hi dummy :)")
	for sprite in gem_sprites:
		sprite.visible = false
	gem_sprites[which_gem].visible = true


func _on_body_entered(body):
	if body is Player:
		match which_gem:
			0:
				body.allow_attack_1 = true
			1:
				body.allow_attack_2 = true
			2:
				body.allow_attack_3 = true
		var sprite_texture = gem_sprites[which_gem].texture as AtlasTexture
		sprite_texture.region.position.x = 48
