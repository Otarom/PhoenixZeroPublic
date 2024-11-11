extends Panel

var template = load("res://Misc/UI/Menu/keybind_template.tscn")
@onready var list = $Keybinds/List
@onready var keymenu = $"../KeybindsMenu"

var Button_Keys : Array[Button]

const key_names : Dictionary = {
	"Up" : ["player_up", "player_up_alt"],
	"Left" : ["player_left", "player_left_alt"],
	"Down" : ["player_down", "player_down_alt"],
	"Right" : ["player_right", "player_right_alt"],
	"Shoot" : ["player_shoot", "player_shoot_alt"],
	"Skill" : ["player_skill", "player_skill_alt"],
	"Sprint" : ["player_sprint", "player_sprint_alt"],
	"Dodge" : ["player_dodge", "player_dodge_alt"],
	"Drag Camera" : ["cam_drag", "cam_drag_alt"],
	"Rotate Camera R" : ["cam_right", "cam_right_alt"],
	"Rotate Camera L" : ["cam_left", "cam_left_alt"],
	"Cam Zoom In" : ["cam_in", "cam_in_alt"],
	"Cam Zoom Out" : ["cam_out", "cam_out_alt"],
	"Camera Reset" : ["cam_reset", "cam_reset_alt"],
	"Camera Lock" : ["cam_lock", "cam_lock_alt"],
	"Camera Mode" : ["cam_mode", "cam_mode_alt"],
	"0" : ["", ""] # apparently it never adds the last entry so you need to leave a null one here
}

func _ready():
	keymenu.keybind_changed.connect(on_keybind_change)
	Global.loaded_setings.connect(init)
	
func init():
	if Global.user_settings.keybindings == {}:
		Global.user_settings.keybindings = load("res://Resources/def_user_settings_demo.tres").keybindings
	load_keymap()

func load_keymap():
	for action in Global.user_settings.keybindings:
		var events = Global.user_settings.keybindings[action]
		if action != "":
			InputMap.action_erase_events(action)
		if not events.is_empty():
			InputMap.action_add_event(action, events[0])
	populate()

# Called when the node enters the scene tree for the first time.
func populate():
	if list.get_child_count() > 0:
		for child in list.get_children():
			child.queue_free()
		
	var count = 0
	for key in key_names:
		var Keybind = template.instantiate()
		list.add_child(Keybind)
		Keybind.name = key
		Keybind.get_children()[0].text = key
		
		var button
		var action
		var event_name
		
		button = Keybind.get_children()[1]
		action = key_names[key][0]
		if InputMap.action_get_events(action).is_empty():
			event_name = "none"
		else:
			event_name = InputMap.action_get_events(action)[0].as_text()
		event_name = format_event_name(event_name)
		button.ID = count
		button.action = action
		button.text = event_name
		button.change_key.connect(on_key_change)
		Button_Keys.append(button)
		count+=1
		
		button = Keybind.get_children()[2]
		action = key_names[key][1]
		if InputMap.action_get_events(action).is_empty():
			event_name = "none"
		else:
			event_name = InputMap.action_get_events(action)[0].as_text()
		event_name = format_event_name(event_name)
		button.ID = count
		button.action = action
		button.text = event_name
		button.change_key.connect(on_key_change)
		Button_Keys.append(button)
	pass # Replace with function body.


func on_key_change(action, button):
	keymenu.change_key(action, button)

func format_event_name(event_name):
	event_name = event_name.replace(" (Physical)", "")
	event_name = event_name.replace("Left Mouse Button", "LMB")
	event_name = event_name.replace("Right Mouse Button", "RMB")
	event_name = event_name.replace("Middle Mouse Button", "MMB")
	return event_name

func on_keybind_change():
	pass


func _on_revert_pressed():
	Global.user_settings.keybindings = load("res://Resources/def_user_settings_demo.tres").keybindings
	Global.user_settings.save()
	load_keymap()
	pass # Replace with function body.
