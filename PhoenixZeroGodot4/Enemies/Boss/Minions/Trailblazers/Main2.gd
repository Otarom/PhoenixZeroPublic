extends State

var gun1_timer = 0
var shoot_count = 30
@export var gun1 : Node3D

var count = 1
var turning = 0.8
var timer = 10

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
		else:
			count+=1
			gun1_timer = 0.4
			gun1.shoot()
	
	turning = move_toward(turning, 0.4,0.001)
	MainNode.turn_spd = move_toward(MainNode.turn_spd, 2,0.005)
	MainNode.direction.x -= 0.02 * sign(MainNode.direction.z) * turning
	MainNode.direction.z += 0.02 * sign(MainNode.direction.x) * turning
	MainNode.direction = MainNode.direction.normalized()
#	MainNode.y_rot += turning
	
	timer-=delta
	if timer <= 0:
		MainNode.HealthComponent.die()
		

	
