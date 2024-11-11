extends Node3D

var timer = 0.1

func _ready():
	visible=false

func _process(delta):
	timer -= delta
	if timer <= 0:
		visible = false
	
