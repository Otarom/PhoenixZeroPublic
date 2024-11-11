extends CharacterBody3D

@export var model : Node3D
@export_range(-360.0,360.0) var y_rot = 0

var SPEED = 1.0

@onready var model_rot = $ModelRig.get_rotation()
var direction = Vector3(0,0,1)

var timer = 5

@onready var main = get_tree().current_scene

func _ready():
	direction = direction.rotated(Vector3.UP,deg_to_rad(y_rot))
	direction = direction.normalized()
	for i in findmeshes(model):
			i.material_overlay = load("res://Enemies/EnemyInvMaterial.tres")

func _physics_process(delta):
	
	timer-=delta
	if timer<=0:
		explode()
		
	
	SPEED = move_toward(SPEED,5.0,0.1)
	
	
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		model_rot = $ModelRig.get_rotation()
		var angle = atan2(direction.x, direction.z)
		model_rot.y = angle
		$ModelRig.set_rotation(model_rot)
		$Weapon1.set_rotation(model_rot)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

func findmeshes(model):
	var array = []
	for n in model.get_children():
		if n is MeshInstance3D or n is CSGShape3D:
			array.append(n)
		if n.get_child_count() > 0:
			array += findmeshes(n)
	return array

func explode():
	$Weapon1.shoot()
	var Expl = Global.sm_expl.instantiate()
	main.add_child(Expl)
	Expl.global_transform.origin = global_transform.origin
	queue_free()
