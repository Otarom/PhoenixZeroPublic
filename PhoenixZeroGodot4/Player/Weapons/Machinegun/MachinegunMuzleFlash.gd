extends Node3D

var timer = 0.1

func _ready():
	var frame = randi_range(0,3)
	$AnimatedSprite3D.frame = frame

func _process(delta):
	timer-=delta
	if timer <=0:
		queue_free()
	
