extends State

var gun1_timer = 0
var chase_timer = 5
var turn_timer = 3
var shoot_count = 30
var old_dir
var randx
var randz
var turned = false
var newdirlerp = Vector3()
@export var gun1 : Node3D
@export var gun2 : Node3D

func _ready():
	state_name = "Attack"

func enter():
	gun1_timer = 0.5
	chase_timer = 5
	turn_timer = 3
	old_dir = MainNode.direction 
	var rng = RandomNumberGenerator.new()
	randx = (rng.randf()*2)-1
	randz = (rng.randf()*2)-1
	newdirlerp = MainNode.direction
	turned = false
	pass

func exit():
	pass

func update(delta):
	pass
	
func physics_update(delta):
	chase_timer-=delta
	if chase_timer <= 0:
		turn_timer-=delta
		MainNode.spd_mult = move_toward(MainNode.spd_mult,1, 0.05)
		if not turned:
			MainNode.direction = MainNode.global_position.direction_to(MainNode.Player.global_position).normalized()
			turned = true
		MainNode.direction.x += randx*0.02
		MainNode.direction.z += randz*0.02
		MainNode.direction = MainNode.direction.normalized()
		var model_rot = $"../../ModelRig".get_rotation()
		var angle = atan2(MainNode.direction.x, MainNode.direction.z)
		model_rot.y = angle
		$"../../ModelRig".set_rotation(model_rot)
		$"../../Weapon1".set_rotation(model_rot)
		
		if turn_timer <= 0:
			emit_signal("changed", self, "Main")
	else:
		gun1_timer-=delta
		if gun1_timer<=0:
			gun1_timer = 10
			$"../../Weapon1".shoot()
		var newdir = MainNode.global_position.direction_to(MainNode.Player.global_position).normalized()
		MainNode.spd_mult = move_toward(MainNode.spd_mult,0.2, 0.01)
		var model_rot = $"../../ModelRig".get_rotation()
		newdirlerp.x = move_toward(newdirlerp.x,newdir.x,0.04)
		newdirlerp.z = move_toward(newdirlerp.z,newdir.z,0.04)
		var angle = atan2(newdirlerp.x, newdirlerp.z)
		model_rot.y = angle
		$"../../ModelRig".set_rotation(model_rot)
		$"../../Weapon1".set_rotation(model_rot)
	
		
