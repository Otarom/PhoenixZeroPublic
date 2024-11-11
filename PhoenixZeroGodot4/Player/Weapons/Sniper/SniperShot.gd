extends Hit

var newrot = get_rotation()
var shotnum = 0
var numshots = 0
var rotchang = 0
var timer = 0.1

var count = 4
var decay = 3
var dmg_value

func _ready():
	count = decay+1
	

func _physics_process(delta):
	timer-=delta
	newrot.z = 0
	newrot.x = 0
	set_rotation(newrot)
	direction = transform.basis.z * speed/10
	if dist(global_transform.origin, origin) > range/count:
		if not dmg_value:
			dmg_value = damage
		damage = (dmg_value/decay)*(count-1)
		count-=1
	if speed == 0 && timer <= 0:
		queue_free()
	move_and_collide(direction)
	if dist(global_transform.origin, origin) > range:
		queue_free()



func dist(from, to):
	var xdif = (to.x - from.x)
	var ydif = (to.y - from.y)
	var zdif = (to.z - from.z)
	var distance = sqrt( xdif*xdif + ydif*ydif + zdif*zdif )
	return distance



func _on_collision_body_entered(body):
	if body.is_in_group("Enemies"):
		body.HealthComponent.damage(self)
		if not piercing:
			queue_free()

#	if not body.is_in_group("Player") and not body.is_in_group("Aimplate") and not body.is_in_group("Enemies"):
	if body is StaticBody3D or body is CSGBox3D:
		queue_free()


