extends State

var gun1_timer = 0
var shoot_count = 30
@export var gun1 : Node3D

var count = 1
var turning = 0.8

func _ready():
	state_name = "Main"

func enter():
	count = 1
	gun1_timer = 0
	pass

func exit():
	pass

func update(delta):
	pass
	
func physics_update(delta):
	gun1_timer-=delta
	if gun1_timer<=0:
		if count > shoot_count:
			count = 1
			gun1_timer = 0
			turning *= 0.9
		else:
			count+=1
			gun1_timer = 0.08
			gun1.shoot()
			
	MainNode.direction.x -= 0.02 * sign(MainNode.direction.z) * turning
	MainNode.direction.z += 0.02 * sign(MainNode.direction.x) * turning
	MainNode.direction = MainNode.direction.normalized()
#	MainNode.y_rot += turning
	
	if turning < 0.35:
		MainNode.HealthComponent.die()
		

	
