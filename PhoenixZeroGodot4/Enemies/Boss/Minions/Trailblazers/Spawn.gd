extends State

@export var HealthComponent : HealthComponent

@export var spawn_time = 0.5

func _ready():
	state_name = "Spawn"

func enter():
	HealthComponent.toggle_invulnerability(true)
	pass

func exit():
	HealthComponent.toggle_invulnerability(false)
	pass

func update(delta):
	pass
	
func physics_update(delta):
	spawn_time -= delta
	if spawn_time <= 0:
		emit_signal("changed", self, "Main")
	
		

	
