extends Node3D

var timer = 0.2


func _process(delta):
	timer-=delta
	if timer <=0:
		queue_free()
	
