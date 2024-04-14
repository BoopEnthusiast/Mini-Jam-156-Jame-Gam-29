extends AnimatedSprite2D

@export var flash_count: int = 2
@export var flash_on_duration: float = 0.05
@export var flash_off_duration: float = 0.05
@onready var flash_timer: Timer = $flash_timer

var current_flash_count = 0
var is_flash_on = false

func _on_flash_timer_timeout():
	flash_timer.stop()
	
	if current_flash_count == flash_count:
		current_flash_count = 0
		is_flash_on = false
		modulate = Color(1, 1, 1)
		return
		
	is_flash_on = not is_flash_on
	
	if is_flash_on:
		modulate = Color(10, 10, 10)
		flash_timer.start(flash_on_duration)
	else:
		modulate = Color(1, 1, 1)
		flash_timer.start(flash_off_duration)
	
	if not is_flash_on:
		current_flash_count += 1
