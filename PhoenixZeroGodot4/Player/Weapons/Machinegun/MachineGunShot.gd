extends Hit

var newrot = get_rotation()
var rand = newrot.y
var rng = RandomNumberGenerator.new()
var randomized = false

func _physics_process(delta):
	newrot.z = 0
	newrot.x = 0
	if not randomized:
		rng.randomize()
		rand = rng.randf_range(newrot.y-deg_to_rad(7.5),newrot.y+deg_to_rad(7.5))
		newrot.y = rand
		randomized = true
	set_rotation(newrot)
	direction = transform.basis.z * speed/10 * rng.randf_range(.5, 1)
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
		queue_free()

#	if not body.is_in_group("Player") and not body.is_in_group("Aimplate") and not body.is_in_group("Enemies"):
	if body is StaticBody3D or body is CSGBox3D:
		queue_free()


