extends State

var timer_inv
var timer
var weap_timer

var shot

func _ready():
	state_name = "Laser"

func enter():
	$"../../Weapons2".shoot()
	timer_inv = 10
	timer = 18
	weap_timer = 5
	$"../../Weapons3".shoot()
	$"../../Spawner1".despawn()
	$"../../Laser".shoot()
	$"../../InsideDamageOrb".active = true

func exit():
	pass

func update(delta):
	pass
	
func physics_update(delta):
	timer_inv-=delta
	timer-=delta
	weap_timer-=delta
	
	var laserrot = $"../../Laser".get_rotation()
	$"../../ModelRig".set_rotation(laserrot)
	$"../../Weapons3".set_rotation(laserrot)
	
	
	if weap_timer <= 0:
		$"../../Weapons3".shoot()
		weap_timer = 5
	
	if timer_inv <= 0 and MainNode.HealthComponent.Invulnerable:
		$"../../Weapons2".shoot()
		MainNode.HealthComponent.toggle_invulnerability(false)
		

	if timer <= 0:
		emit_signal("changed", self, "Nuke")
