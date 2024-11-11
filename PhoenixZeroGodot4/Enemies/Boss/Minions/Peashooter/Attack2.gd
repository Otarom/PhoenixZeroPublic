extends State

var gun1_timer = 0
var shoot_count = 4
@export var gun1 : Node3D
@export var HealthComponent : HealthComponent

var count = 1

func _ready():
	state_name = "Attack2"

func enter():
	count = 1
	gun1_timer = 0
	HealthComponent.toggle_invulnerability(true)
	pass

func exit():
	HealthComponent.toggle_invulnerability(false)
	pass

func update(delta):
	pass
	
func physics_update(delta):
	gun1_timer-=delta
	if gun1_timer<=0:
		if count > shoot_count:
			emit_signal("changed", self, "Attack1")
		else:
			count+=1
			gun1_timer = 4
			gun1.shoot()
	
	
