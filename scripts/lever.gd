extends StaticBody2D

var on = false
var player_detected = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.start();


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("interact") and $Timer.is_stopped() and player_detected:
		toggle()
		$Timer.start();


func toggle():
	if on:
		on = false
		$Sprite2D.set_frame(4)
	else:
		on = true
		$Sprite2D.set_frame(0)


func _on_area_2d_body_entered(body):
	if body is Player:
		player_detected = true


func _on_area_2d_body_exited(body):
	if body is Player:
		player_detected = false
