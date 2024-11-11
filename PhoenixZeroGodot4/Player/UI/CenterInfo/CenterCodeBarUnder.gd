extends TextureProgressBar

var timer = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timer-= delta/10
	var tgvalue = self.get_child(0).value
	if timer <= 0 && value > tgvalue:
		value -= 1
	if value < tgvalue:
		value=tgvalue
