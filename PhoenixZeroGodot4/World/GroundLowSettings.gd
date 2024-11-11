extends CSGBox3D


func _ready():
	refresh()
	Global.connect("changed", on_global_changed)
	pass # Replace with function body.

func refresh():
	if Global.bgquality == 0:
		visible = true
		$"../../Env".environment.fog_enabled = false
		$"../../Misc".visible = false
	elif Global.bgquality == 1:
		visible = false
		$"../../Env".environment.fog_enabled = false
		$"../../Misc".visible = false
	elif Global.bgquality == 2:
		$"../../Env".environment.fog_enabled = true
		$"../../Misc".visible = false
	elif Global.bgquality == 3:
		$"../../Env".environment.fog_enabled = true
		$"../../Misc".visible = true
	pass


func on_global_changed():
	refresh()
