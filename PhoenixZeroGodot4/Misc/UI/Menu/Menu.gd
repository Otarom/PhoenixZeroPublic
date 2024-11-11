extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_start_pressed():
	self.visible = false


func _on_quit_pressed():
	get_tree().quit()
	pass # Replace with function body.


func _on_options_pressed():
	
	Global.options.visible = true
	pass # Replace with function body.
