extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_resume_pressed():
	Global.escmenu = false
	visible = false


func _on_options_pressed():
	$"../Options".visible = true


func _on_quit_pressed():
	Global.escmenu = false
	visible = false
	get_tree().change_scene_to_file("res://Misc/UI/Menu/menu.tscn")


func _on_retry_pressed():
	Global.escmenu = false
	visible = false
	get_tree().reload_current_scene()
	pass # Replace with function body.
