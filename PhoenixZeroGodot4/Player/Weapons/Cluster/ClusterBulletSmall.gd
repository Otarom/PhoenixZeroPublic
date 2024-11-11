extends Hit

func main(delta):
	direction = transform.basis.z * speed/10
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
