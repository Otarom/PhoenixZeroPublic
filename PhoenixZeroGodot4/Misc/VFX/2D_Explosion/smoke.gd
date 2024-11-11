extends AnimatedSprite3D
class_name SmokePart

# Called when the node enters the scene tree for the first time.
func _ready():
#	play("default")
	play("exp2")
#	play("exp3")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_inside_tree():
		global_position.y+=delta
	pass


func _on_animation_finished():
	if is_inside_tree():
		get_parent().remove_child(self)
