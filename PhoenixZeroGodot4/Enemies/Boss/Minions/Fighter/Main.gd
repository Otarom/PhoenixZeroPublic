extends State

var gun1_timer = 0
var shoot_count = 30
var rotspd = 0.1
var delay = 0
var passed = false
var passed_delay = 1
var old_dir
var randx = 0
var randz = 0
var rando_delay = 0
var positive = true
@export var gun1 : Node3D
@export var gun2 : Node3D

func _ready():
	state_name = "Main"

func enter():
	gun1_timer = 0
	rotspd = 0.1
	delay = 1
	pass

func exit():
	pass

func update(delta):
	pass
	
func physics_update(delta):
	gun1_timer-=delta
	if gun1_timer<=0:
			gun1_timer = 0.25
#			gun1.shoot()
	
	delay-=delta
	if MainNode.global_position.distance_to(MainNode.Player.global_position) <=5 and delay <= 0:
		emit_signal("changed", self, "Attack")
		pass
		
	rando_delay-=delta
	if rando_delay<=0:
		rando_delay = 0.1
		var spd= 0.2
		if positive:
			randx = move_toward(randx,1,spd)
			randz = move_toward(randz,1,spd)
			if randx and randz >= 0.9:
				positive = false
		else:
			randx = move_toward(randx,-1,spd)
			randz = move_toward(randz,-1,spd)
			if randx and randz <= -0.9:
				positive = true
		
	
	passed_delay-=delta
	if MainNode.global_position.distance_to(MainNode.Player.global_position) <=1:
		passed = true
		passed_delay = 1
	
#	var dest = Vector3()
#
##			Sets original position far ahead of the player
#	var rot = MainNode.global_position
#
##			Lerp to create smooth rotation
#	dest = lerp(rot, MainNode.Player.global_position, 0.1)
#
##			Rotates the bullet
#	MainNode.look_at(dest ,Vector3.UP)
#	var newrot = MainNode.get_rotation()
#	newrot.z = 0
#	newrot.x = 0
#	MainNode.set_rotation(newrot)
#
##			Move foward
#	MainNode.direction = -MainNode.transform.basis.z
#	MainNode.direction = MainNode.direction.normalized()
	
	
	var newdir = MainNode.global_position.direction_to(MainNode.Player.global_position).normalized()

	MainNode.spd_mult = move_toward(MainNode.spd_mult,1, 0.05)
	MainNode.direction.x = lerp(MainNode.direction.x, newdir.x+randx, 0.1)
	MainNode.direction.z = lerp(MainNode.direction.z, newdir.z+randz, 0.1)
	MainNode.direction = MainNode.direction.normalized()
	var model_rot = $"../../ModelRig".get_rotation()
	var angle = atan2(MainNode.direction.x, MainNode.direction.z)
	model_rot.y = angle
	$"../../ModelRig".set_rotation(model_rot)
	$"../../Weapon1".set_rotation(model_rot)
	
#	newdir.x += (rng.randf()*2) -1
#	newdir.z += (rng.randf()*2) -1
	
	
#	MainNode.direction.x -= 0.02 * sign(MainNode.direction.z) * turning
#	MainNode.direction.z += 0.02 * sign(MainNode.direction.x) * turning
#	MainNode.y_rot += turning
		

