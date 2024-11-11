extends Hit

var size = 1

func main(delta):
	
	scale*=1.01
	
	direction = transform.basis.z * speed/10 
	move_and_collide(direction)
	if dist(global_transform.origin, origin) > range:
		queue_free()


func _on_collision_body_entered(body):
	if body.is_in_group("Enemies"):
		body.HealthComponent.damage(self)
