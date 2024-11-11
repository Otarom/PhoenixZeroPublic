extends Button

var ID : int
var action : String

signal change_key(action, button)

func _ready():
	pressed.connect(on_pressed)
		

func on_pressed():
	emit_signal("change_key", action, self)
