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
		modulate = modulate + Color(0.1,0.1,0.1)
	
	
	if setup:
		return
		
	var player = Singleton.player_node
	player.player_attacking.connect(player_has_attacked)

func player_has_attacked(which_attack: int) -> void:
	if which_attack != currentNum:
		return
	modulate = Color.GREEN
