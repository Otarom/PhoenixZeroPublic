extends TextureRect


# Called when the node enters the scene tree for the first time.
func _ready():
	if Global.playerMovtype == 1:
		texture = load("res://Misc/UI/Portraits/Robin.png")
	if Global.playerMovtype == 2:
		texture = load("res://Misc/UI/Portraits/Waddles.png")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
