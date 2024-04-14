class_name player_hitbox extends ShapeCast2D
var length = 100;

var recentlyHit = []

func resetSwing():
	recentlyHit.clear()
	

func updateRot(vec2Dir:Vector2):
	if vec2Dir != null:
		target_position = vec2Dir.normalized() * length

func tickHitbox(damage):
	var hits = collision_result
	for hit in hits:
		if hit.collider is Enemy && recentlyHit.find(hit.collider) == -1:
			recentlyHit.append(hit.collider)
			hit.collider.take_damage(damage)

