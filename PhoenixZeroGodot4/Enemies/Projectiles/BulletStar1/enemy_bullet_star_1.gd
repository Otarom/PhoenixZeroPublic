extends Hit

var rotation_value = 1
var count = 0



func main(delta):
	var rot = get_rotation()
	var max_count = 90/rotation_value
	
	if count <= max_count:
		rot.y += deg_to_rad(rotation_value)*delta
		count+=delta
	
	set_rotation(rot)
	direction = transform.basis.z * speed/10 
	move_and_collide(direction)
	if dist(global_transform.origin, origin) > range:
		queue_free()


func _on_collision_body_entered(body):
	if body is Player or body.is_in_group("Shield"):
		body.HealthComponent.damage(self)
		if not piercing or body.is_in_group("Shield"):
			queue_free()

#	if not body.is_in_group("Player") and not body.is_in_group("Aimplate") and not body.is_in_group("Enemies"):
	if body is StaticBody3D or body is CSGBox3D:
		queue_free()
