extends Hit

var newrot = get_rotation()
var shotnum = 0
var numshots = 0
var rotchang = 0
var timer = 2
var stopped = false

var hit_timer = 0.2
var hit = 0

var enemies : Array = []
	
func connect_recall():
	MainNode.control.WeaponHolder.on_shoot_no_ammo.connect(recall)

func _physics_process(delta):
	newrot.z = 0
	newrot.x = 0
	set_rotation(newrot)
	direction = transform.basis.z * speed/10
	if dist(global_transform.origin, origin) >= range:
		#Go back
		direction = Vector3(0,0,0)
		stopped = true
		timer-=delta
		pass
	
	if timer <= 0 and stopped:
		direction = global_position.direction_to(MainNode.global_position)
	
	if dist(global_position, MainNode.global_position) <= 1 and timer <= 0:
		MainNode.control.WeaponHolder.reload()
		queue_free()
		
	hit-=delta
	if hit <= 0:
		for e in enemies:
			e.HealthComponent.damage(self)
		hit = hit_timer
		
	
	move_and_collide(direction)



func dist(from, to):
	var xdif = (to.x - from.x)
	var ydif = (to.y - from.y)
	var zdif = (to.z - from.z)
	var distance = sqrt( xdif*xdif + ydif*ydif + zdif*zdif )
	return distance



func _on_collision_body_entered(body):
	if body.is_in_group("Enemies"):
		hit = hit_timer
		enemies.append(body)
		body.HealthComponent.damage(self)

func recall():
	timer = 0

func _on_collision_body_exited(body):
	if body.is_in_group("Enemies"):
		enemies.erase(body)
	pass # Replace with function body.
