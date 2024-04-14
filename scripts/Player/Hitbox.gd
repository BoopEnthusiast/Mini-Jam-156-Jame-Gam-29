class_name player_hitbox extends ShapeCast2D
var length = 100;
var rad:float = 60

var slowFactor:float = 0

var recentlyHit = []

func resetSwing():
	recentlyHit.clear()
	

func updateRot(vec2Dir:Vector2):
	if vec2Dir != null:
		target_position = vec2Dir.normalized() * length

func tickHitbox(damage):
	shape.radius = rad
	var hits = collision_result
	for hit in hits:
		if hit.collider is Enemy && recentlyHit.find(hit.collider) == -1:
			recentlyHit.append(hit.collider)
			hit.collider.take_damage(damage)
			if slowFactor>0:
				hit.collider.apply_slow(slowFactor)
				

