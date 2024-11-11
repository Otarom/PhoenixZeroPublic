extends Hit

var rotation_value = 0
var count = 0
var hitlist = []



func main(delta):
	direction = transform.basis.z * speed/10 
	move_and_collide(direction)
	if dist(global_transform.origin, origin) > range:
		queue_free()


func _on_collision_body_entered(body):
	if body is Player or body.is_in_group("Shield"):
		if not body in hitlist:
			body.HealthComponent.damage(self)
			hitlist.append(body)

#	if not body.is_in_group("Player") and not body.is_in_group("Aimplate") and not body.is_in_group("Enemies"):
	if body is StaticBody3D or body is CSGBox3D:
		queue_free()
