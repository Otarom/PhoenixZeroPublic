extends State

var timer
var timer_inv

@export var HealthComponent : HealthComponent

@onready var main = get_tree().current_scene

func _ready():
	state_name = "Spawn"

func enter():
	$"../../Weapons2".shoot()
	timer = 20
	timer_inv = 2
	
	var trailhunt = load("res://Enemies/Boss/Minions/Trailhunters/enemy_traihunter_1.tscn")
	var p_dir = global_position.direction_to(MainNode.targets[0].global_position)
	var ang = rad_to_deg(atan2(p_dir.x,p_dir.z)) - (5*2.5)
	for n in range(0,4):
		var minion = trailhunt.instantiate()
		minion.y_rot = ang + (8*n)
		main.add_child(minion)
		minion.transform.origin = MainNode.transform.origin

func exit():
	$"../../Weapons2".shoot()
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
	
	var hp = HealthComponent.health
	var max_hp = HealthComponent.StatHandler.max_health
	if hp <= max_hp*0.6:
		emit_signal("changed", self, "InvState")
	
	timer-=delta
	if timer <= 0:
		emit_signal("changed", self, "InvState")
	
	
