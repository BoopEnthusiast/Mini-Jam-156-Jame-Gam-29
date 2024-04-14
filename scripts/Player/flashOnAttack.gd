extends TextureRect
static var num = 0
var currentNum
var setup:bool = false
# Called when the node enters the scene tree for the first time.
func _ready():
	num += 1
	currentNum = num

func _process(delta):
	if modulate != Color.WHITE:
		modulate = lerp(modulate,Color.WHITE,0.005)
	
	
	if setup:
		return
	setup = true
	var player = Singleton.player_node
	player.player_attacking.connect(player_has_attacked)

func player_has_attacked(which_attack: int) -> void:
	if which_attack != currentNum:
		return
	modulate = Color.GREEN
