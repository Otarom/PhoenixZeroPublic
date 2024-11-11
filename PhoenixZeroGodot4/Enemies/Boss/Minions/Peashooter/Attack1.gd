extends State

var gun1_timer = 10
@export var gun1 : Node3D

func _ready():
	state_name = "Attack1"

func enter():
	gun1_timer = 10
	gun1.shoot()
	pass

func exit():
	pass

func update(delta):
	pass
	
func physics_update(delta):
	gun1_timer-=delta
	
	if gun1_timer<=0:
		emit_signal("changed", self, "Attack2")
		
