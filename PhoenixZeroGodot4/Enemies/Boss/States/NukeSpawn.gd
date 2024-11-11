extends State

var timer
var timer_inv

@onready var main = get_tree().current_scene

func _ready():
	state_name = "NukeSpawn"

func enter():
	$"../../Weapons2".shoot()
	timer = 20
	timer_inv = 2
		
	$"../../Weapons1".shoot()
	
	var nuke = load("res://Enemies/Boss/Minions/Nuke/enemy_nuke.tscn")
	var ang = 0
	for n in range(0,4):
		var minion = nuke.instantiate()
		minion.y_rot = ang + (90*n)
		main.add_child(minion)
		minion.transform.origin = MainNode.transform.origin

func exit():
	$"../../Weapons2".shoot()
	var fighter = load("res://Enemies/Boss/Minions/Fighter/enemy_fighter_1.tscn")
	var ang = 30 * $"../../Minions".get_child_count()
	for n in range(0,4):
		var minion = fighter.instantiate()
		minion.y_rot = ang + (90*n)
		main.add_child(minion)
		minion.transform.origin = MainNode.transform.origin
	pass

func update(delta):
	pass
	
func physics_update(delta):
	var rot = $"../../Minions".get_rotation()
	rot.y+=0.009
	$"../../Minions".set_rotation(rot)
	
	timer_inv-=delta
	if timer_inv <= 0:
		MainNode.HealthComponent.toggle_invulnerability(false)
	
	timer-=delta
	if timer <= 0:
		emit_signal("changed", self, "InvLaser")
	
	
