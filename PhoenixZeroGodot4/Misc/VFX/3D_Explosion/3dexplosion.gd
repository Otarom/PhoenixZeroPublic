extends Node3D

var testing = false

func _ready():
	$Animation.play("explode")
	if not testing:
		$SFX.play()


func _on_animation_animation_finished(anim_name):
	queue_free()
