extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	refresh()
	Global.connect("changed", on_global_changed)
	pass # Replace with function body.

func refresh():
	$CloudGen.emitting = Global.clouds
	
	var value = 60 + (5*Global.cloud_level)
	$CloudGen.process_material.set_shader_parameter("clumping_strength", value)
	$CloudGen2.process_material.set_shader_parameter("clumping_strength", value)
	pass


func on_global_changed():
	refresh()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
