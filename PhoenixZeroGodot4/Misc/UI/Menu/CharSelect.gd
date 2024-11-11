extends Control

var timer = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	timer -= delta
	if $Loading.visible and timer<=0:
		get_tree().change_scene_to_file("res://World/world.tscn")
	pass


func _on_blu_jay_select_pressed():
	$WeapSelect.visible = true
	$WeapSelect/Machinegun.visible = true
	$WeapSelect/EnergySword.visible = true
	Global.playerSkill = 2
	Global.playerMovtype = 0
	pass # Replace with function body.


func _on_robin_select_pressed():
	$WeapSelect.visible = true
	$WeapSelect/Saw.visible = true
	$WeapSelect/Sniper.visible = true
	Global.playerSkill = 1
	Global.playerMovtype = 1
	pass # Replace with function body.


func _on_waddles_select_pressed():
	$WeapSelect.visible = true
	$WeapSelect/Laser.visible = true
	$WeapSelect/Cluster.visible = true
	Global.playerSkill = 0
	Global.playerMovtype = 2
	pass # Replace with function body.


func _on_back_pressed():
	$"../../Menu".visible = true
	pass # Replace with function body.
