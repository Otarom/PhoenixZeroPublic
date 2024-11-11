extends Hit

var Bullet = load("res://Player/Weapons/Cluster/ClusterBulletSmall.tscn")

@onready var main_s = get_tree().current_scene

func main(delta):
	direction = transform.basis.z * speed/10
	move_and_collide(direction)
	if dist(global_transform.origin, origin) > range:
		explode()

func explode():
	for mount in $Spawner.get_children():
		var bullet = Bullet.instantiate()
		main_s.add_child(bullet)
		bullet.MainNode = MainNode
		bullet.transform = mount.global_transform
		bullet.transform.origin.y = 0
		bullet.damage = damage/$Spawner.get_child_count()
		bullet.range = range
		bullet.ap = ap
		bullet.piercing = false
		bullet.speed = 16
		bullet.direction = mount.get_child(0).global_transform.origin - global_transform.origin
		bullet.origin = global_transform.origin
	queue_free()
	pass

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
		explode()
