extends Marker3D

@export var Bullet : PackedScene
@export var damage : float
@export var armour_penetration : int
@onready var main = get_tree().current_scene

var shooting = false
@onready var def_rots = []
@onready var def_rot = get_rotation()



# Called when the node enters the scene tree for the first time.
func _ready():
	for m in get_children():
		def_rots.append(m.get_rotation())

func _physics_process(delta):
	if shooting:
		for m in get_children():
			var bullet = Bullet.instantiate()
			main.add_child(bullet)
			bullet.transform *= 8
			bullet.set_rotation(m.get_rotation())
			bullet.global_transform.origin = m.global_transform.origin
			bullet.transform.origin.y = 0
			bullet.damage = damage
			bullet.range = 999
			bullet.ap = armour_penetration
			bullet.speed = 0.1
			bullet.origin = m.global_transform.origin
			bullet.despawnTimer = 2
			bullet.explosion = true
	else:
		shooting = false
		reset_rotations()

func reset_rotations():
	var count = 0
	set_rotation(def_rot)
	for m in get_children():
		m.set_rotation(def_rots[count])
		count+=1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func shoot():
	shooting = true
	
		
		
