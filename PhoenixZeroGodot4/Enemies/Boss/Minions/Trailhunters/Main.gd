extends State

var gun1_timer = 0
var explode_timer = 20
var shoot_count = 30
@export var gun1 : Node3D
@export var gun2 : Node3D

var smoke_timer = 0
var smoke_storage = []
@onready var main = get_tree().current_scene

func _ready():
	state_name = "Main"

func enter():
	gun1_timer = 0
	StateMachine.model.play()
	pass

func exit():
	pass

func update(delta):
	pass
	
func physics_update(delta):
	gun1_timer-=delta
	if gun1_timer<=0:
			gun1_timer = 0.25
			gun1.shoot()
			
	
	smoke_timer-=delta
	spawn_smoke()
	
	var rng = RandomNumberGenerator.new()
	
	explode_timer-=delta
	if explode_timer<=0 or MainNode.global_position.distance_to(MainNode.Player.global_position) <=0.1:
		explode()
	
	var spd = clamp(5 - (MainNode.global_position.distance_to(MainNode.Player.global_position)*0.3), 0, 5) 
	StateMachine.model.speed(spd)
	
	var newdir = MainNode.global_position.direction_to(MainNode.Player.global_position)
	
#	newdir.x += (rng.randf()*2) -1
#	newdir.z += (rng.randf()*2) -1
	
#	MainNode.direction.x = move_toward(MainNode.direction.x, newdir.x + (rng.randf()*2) -1, 0.7)
#	MainNode.direction.z = move_toward(MainNode.direction.z, newdir.z + (rng.randf()*2) -1, 0.7)
	MainNode.direction.x = move_toward(MainNode.direction.x, newdir.x, 0.7)
	MainNode.direction.z = move_toward(MainNode.direction.z, newdir.z, 0.7)
#	MainNode.direction.x -= 0.02 * sign(MainNode.direction.z) * turning
#	MainNode.direction.z += 0.02 * sign(MainNode.direction.x) * turning
	MainNode.direction = MainNode.direction.normalized()
#	MainNode.y_rot += turning
		

func spawn_smoke():
	if smoke_timer <= 0:
			smoke_timer=0.2
			var smoke = get_smoke_particle()
			main.add_child(smoke)
			smoke.global_position = global_position

func get_smoke_particle() -> SmokePart:
	# get a smoke particle from the pool
	if smoke_storage.size() > 0:
		return smoke_storage.pop_front()
	
	# create a new smoke particle if the pool is empty
	else:
		var new_smoke = load("res://Misc/VFX/2D_Explosion/smoke.tscn").instantiate()
		new_smoke.tree_exiting.connect(
			func():smoke_storage.append(new_smoke))

		return new_smoke

func explode():
	var Expl = Global.sm_expl.instantiate()
	MainNode.main.add_child(Expl)
	Expl.global_transform.origin = global_transform.origin
	gun2.shoot()
	MainNode.queue_free()
