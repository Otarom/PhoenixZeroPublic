extends Area3D
class_name ModelHandler


@export var ModelRig : Marker3D
@onready var default_pos = ModelRig.global_transform
var up = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if up:
		var transf = ModelRig.global_transform.origin.y 
		ModelRig.global_transform.origin.y = move_toward(transf,default_pos.origin.y+10, 0.3)
	else:
		var transf = ModelRig.global_transform.origin.y 
		ModelRig.global_transform.origin.y = move_toward(transf,default_pos.origin.y, 0.3)
		if ModelRig.global_transform.origin.y < default_pos.origin.y:
			ModelRig.global_transform.origin.y = default_pos.origin.y


func _on_body_entered(body):
	if body is StaticBody3D or body is CSGBox3D:
		up = true
	
func _on_body_exited(body):
	if body is StaticBody3D or body is CSGBox3D:
		up = false
