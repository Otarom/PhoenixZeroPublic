extends State

@export var ship_count : int = 5
@export var HealthComponent : HealthComponent

var SpawnedShips : Array = []
@onready var main = get_tree().current_scene

var trailblazers_spawn = 10
var laser_shoot = 30
var weap_timer = 10
var weap2_timer = 10
var weap3_timer = 5

func _ready():
	state_name = "InvLaser"

func enter():
	MainNode.HealthComponent.toggle_invulnerability(true)
	if SpawnedShips == []:
		spawn_ships()
		update_ships(2)
	else:
		trailblazers_spawn = 10
		SpawnedShips[0].start_inv_timer(5)
		update_ships(2)
	$"../../Weapons2".shoot()
	weap_timer = 5
	weap3_timer = 0
	weap2_timer = 10
	laser_shoot = 20

func exit():
	$"../../Laser".stop()
	pass

func update(delta):
	pass
	
func physics_update(delta):
	$"../../Minions".rotate_y(0.007)
	trailblazers_spawn -= delta
	if trailblazers_spawn <= 0:
		trailblazers_spawn=30
		var trailb = load("res://Enemies/Boss/Minions/Trailblazers/enemy_traiblazer_2.tscn")
		var ang = -30
		for n in range(0,3):
			var minion = trailb.instantiate()
			minion.y_rot = ang + (120*n)
			main.add_child(minion)
			minion.transform.origin = MainNode.transform.origin
			
	weap_timer-=delta
	if weap_timer <=0:
		$"../../Weapons4".shoot()
		update_ships(2)
		weap_timer = 10
		
	weap2_timer -= delta
	if weap2_timer <=0:
		$"../../Weapons2".shoot()
		weap2_timer = 10
	
	weap3_timer -= delta
	if weap3_timer <=0:
		$"../../Weapons3".shoot()
		weap3_timer = 5
	
	laser_shoot-=delta
	if laser_shoot <= 0:
		$"../../Laser".shoot()
		update_ships(2)
		laser_shoot = 20
	
	if $"../../Laser".active:
		var laserrot = $"../../Laser".get_rotation()
		$"../../ModelRig".set_rotation(laserrot)
		$"../../Weapons3".set_rotation(laserrot)
	
	
	var hp = HealthComponent.health
	var max_hp = HealthComponent.StatHandler.max_health
	
	

func spawn_ships():
	var ship = load("res://Enemies/Boss/Minions/InvShip/inv_ship.tscn")
	var rot_amount = deg_to_rad(360/ship_count)
	
	for i in range(0,ship_count):
		var mount = get_child(0)
		var child = ship.instantiate()
		SpawnedShips.append(child)
		child.HealthComponent.Invulnerable = true
		child.set_rotation(mount.get_rotation())
		child.rotate_y(rot_amount*i)
		child.target_pos = mount.global_transform.origin - $"../..".global_transform.origin
		child.on_death.connect(on_ship_death)
		$"../../Minions".add_child(child)
		rotate_y(rot_amount)
	SpawnedShips[0].start_inv_timer(3)

func update_ships(dist):
	var mount = get_child(0)
	var count = SpawnedShips.size()
	var rot_amount = deg_to_rad(360/count)
	
	for i in range(0,count):
		SpawnedShips[i].set_rotation(mount.get_rotation())
		SpawnedShips[i].rotate_y(rot_amount*i)
		SpawnedShips[i].target_pos = mount.global_transform.origin - $"../..".global_transform.origin
		SpawnedShips[i].target_pos *= dist
		rotate_y(rot_amount)
		

func kill_ships():
	for Ship in $"../../Minions".get_children():
		Ship.queue_free()
		SpawnedShips.erase(Ship)
		

func on_ship_death(Ship:Node3D):
	SpawnedShips.erase(Ship)
	Ship.queue_free()
	if SpawnedShips.size() > 0:
#		MainNode.HealthComponent.toggle_invulnerability(false)
		emit_signal("changed", self, "NukeSpawn")
		update_ships(3)
	else:
		emit_signal("changed", self, "Laser")
