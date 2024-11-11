extends CharacterBody3D

var timer = 5
var direction = Vector3(0,0,0)
var speed = 5

@export var Bullet : PackedScene

var damage = 1000.0
var armour_penetration = 0

var MainNode

@onready var main = get_tree().current_scene

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	timer-=delta
	if timer <=0:
		direction.z = move_toward(direction.z, 0, 0.1)
		direction.x = move_toward(direction.x, 0, 0.1)
		explode()
	else:
		direction = transform.basis.z * speed/10
		
	
	move_and_collide(direction)
	
	pass

func explode():
	for m in $ExplosionHandle.get_children():
			var bullet = Bullet.instantiate()
			main.add_child(bullet)
			bullet.transform *= 3
			bullet.MainNode = MainNode
			bullet.set_rotation(m.get_rotation())
			bullet.global_transform.origin = m.global_transform.origin
			bullet.transform.origin.y = 0
			bullet.damage = damage
			bullet.range = 999
			bullet.ap = armour_penetration
			bullet.speed = 0
			bullet.origin = m.global_transform.origin
			bullet.despawnTimer = 1
	var Expl = Global.sm_expl.instantiate()
	main.add_child(Expl)
	Expl.global_transform.origin = global_transform.origin
	queue_free()
	pass


func _on_area_3d_body_entered(body):
	if body.is_in_group("Enemies"):
		explode()
	if body is StaticBody3D:
		explode()
	pass # Replace with function body.
