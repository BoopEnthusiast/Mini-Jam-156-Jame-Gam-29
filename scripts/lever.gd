extends StaticBody2D

var on = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.start();


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("attack1"):
		if $Timer.is_stopped():
			toggle()
			$Timer.start();


func toggle():
	if on:
		on = false
		$Sprite2D.set_frame(4)
	else:
		on = true
		$Sprite2D.set_frame(0)
