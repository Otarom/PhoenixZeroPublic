extends Marker3D

@export var Bullet : PackedScene
@export var damage : float
@export var range : float
@export var armour_penetration : int
@export var piercing : bool
@export var speed : float
@export var shots : int
@export var cooldown : float
@export var size : float = 1
@onready var main = get_tree().current_scene

var timer = 0.0
var n = 0
var shooting = false
@onready var def_rots = []



# Called when the node enters the scene tree for the first time.
func _ready():
	n = shots
	for m in get_children():
		def_rots.append(m.get_rotation())

func _physics_process(delta):
	timer-=delta
	if n < shots and shooting:
		if timer <= 0:
			timer = cooldown
			for m in get_children():
				var rot = m.get_rotation()
				rot.y += deg_to_rad(45)
				m.set_rotation(rot)
				
			for m in get_children():
				create_bullet(m)
				rotate_y(deg_to_rad(15))
				create_bullet(m)
				rotate_y(deg_to_rad(15))
				create_bullet(m)
				rotate_y(deg_to_rad(-30))
				
			n+=1
	else:
		shooting = false
		reset_rotations()

func reset_rotations():
	var count = 0
	for m in get_children():
		m.set_rotation(def_rots[count])
		count+=1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func shoot():
	shooting = true
	timer = cooldown
	n = 0
	
func create_bullet(m):
	var bullet = Bullet.instantiate()
	main.add_child(bullet)
	bullet.transform = m.global_transform
	bullet.transform = bullet.transform.scaled_local(Vector3(size,size,size))
	bullet.transform.origin.y = 0
	bullet.damage = damage
	bullet.range = range
	bullet.ap = armour_penetration
	bullet.piercing = piercing
	bullet.speed = speed/10
	bullet.origin = m.global_transform.origin
	bullet.rotation_value = 45
		
