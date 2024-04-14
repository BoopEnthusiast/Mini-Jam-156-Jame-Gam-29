extends StaticBody2D

var can_toggle = true
var on = false
var player_detected = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("interact") and can_toggle and player_detected:
		toggle()
		can_toggle = false
		$Timer.start();


func toggle():
	if on:
		on = false
		$Sprite2D.set_frame(2)
	else:
		on = true
		$Sprite2D.set_frame(3)


func _on_area_2d_body_entered(body):
	if body is Player:
		player_detected = true


func _on_area_2d_body_exited(body):
	if body is Player:
		player_detected = false


func _on_timer_timeout():
	can_toggle = true
