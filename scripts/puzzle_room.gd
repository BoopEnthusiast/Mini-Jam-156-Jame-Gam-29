extends TileMap


# Called when the node enters the scene tree for the first time.
func _ready():
	$Artefact/CollisionShape2D.disabled = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $Lever.on and not $Lever2.on and $Lever3.on:
		$Artefact.visible = true
		$Artefact/CollisionShape2D.disabled = false
