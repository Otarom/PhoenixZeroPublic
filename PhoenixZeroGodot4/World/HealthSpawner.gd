extends Node3D

var timer = 3



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if get_child_count() == 0:
		timer-=delta
	
	if timer<=0:
		timer = 5
		var pickup = load("res://Pickups/health_pickup.tscn")
		var Health = pickup.instantiate()
		add_child(Health)
