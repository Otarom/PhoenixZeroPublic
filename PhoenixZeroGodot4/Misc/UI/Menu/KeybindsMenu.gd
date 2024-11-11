extends Panel

var listening = false
var temp_event : InputEvent
var Action : String
var KeyButton : Button
@onready var keybinds = $"../Keybinds"
@onready var keychanger = $Key

signal keybind_changed()

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false

func change_key(action : String, button : Button):
	visible = true
	listening = true
	Action = action
	KeyButton = button
	keychanger.text = "..."
	
	

func _input(event):
	if listening and not event is InputEventMouseMotion:
#		print(event)
		keychanger.text = event.as_text()
		temp_event = event
		listening = false


func _on_remove_pressed():
	listening = false
	InputMap.action_erase_events(Action)
	
	Global.user_settings.keybindings[Action] = []
	Global.user_settings.save()
	
	KeyButton.text = "none"
	temp_event = null
	Action = ""
	KeyButton = null
	visible = false
	emit_signal("keybind_changed")


func _on_key_pressed():
	if not listening:
		listening = true
		temp_event = null
		keychanger.text = "..."


func _on_cancel_pressed():
	visible = false
	listening = false
	temp_event = null
	Action = ""
	KeyButton = null


func _on_accept_pressed():
	InputMap.action_erase_events(Action)
	InputMap.action_add_event(Action, temp_event)
	
	var name = keybinds.format_event_name(temp_event.as_text())
	KeyButton.text = name
	
	Global.user_settings.keybindings[Action] = [temp_event]
	Global.user_settings.save()
	
	visible = false
	listening = false
	temp_event = null
	Action = ""
	KeyButton = null
	emit_signal("keybind_changed")
