extends Node3D


func _ready():
	refresh()
	Global.init()
	Global.connect("changed", on_global_changed)
	pass # Replace with function body.

func refresh():
	if Global.bgquality == 0:
		change_settings(true, false, false)
	elif Global.bgquality == 1:
		change_settings(false, true, false)
	elif Global.bgquality == 2:
		change_settings(false, true, true)
	
	if Global.wallquality == 0:
		$"../SimpleMap".visible = true
		$"../DetailedMap".visible = false
	else:
		$"../SimpleMap".visible = false
		$"../DetailedMap".visible = true
	

func change_settings(ground, fog, misc):
	$GroundLowSettings.visible = ground
	$"../Env".environment.fog_enabled = fog
	$"../Misc".visible = misc

func on_global_changed():
	refresh()
