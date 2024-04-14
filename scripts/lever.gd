extends StaticBody2D

var can_toggle = true
var on = false
var player_detected = false

@onready var timer = $Timer
@onready var sprite_2d = $Sprite2D
@onready var toggle_sound = $toggleSound

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if Input.is_action_pressed("interact") and can_toggle and player_detected:
		toggle()
		can_toggle = false
		timer.start();


func toggle():
	if on:
		on = false
		sprite_2d.set_frame(2)
	else:
		on = true
		sprite_2d.set_frame(3)
	toggle_sound.play()


func _on_area_2d_body_entered(body):
	if body is Player:
		player_detected = true


func _on_area_2d_body_exited(body):
	if body is Player:
		player_detected = false


func _on_timer_timeout():
	can_toggle = true
