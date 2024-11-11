extends State

@export var ship_count : int = 5
@export var HealthComponent : HealthComponent

var SpawnedShips : Array = []
@onready var main = get_tree().current_scene

var trailblazers_spawn = 10

func _ready():
	state_name = "InvState"

func enter():
	MainNode.HealthComponent.toggle_invulnerability(true)
	if SpawnedShips == []:
		$"../../Spawner1".spawn()
		spawn_ships()
	else:
		for s in SpawnedShips:
			s.model.toggle_shield(true)
		trailblazers_spawn = 10
		SpawnedShips[0].start_inv_timer(5)
		update_ships(1.2)

func exit():
	for s in SpawnedShips:
		s.model.toggle_shield(false)
	pass

func update(delta):
	pass
	
func physics_update(delta):
	$"../../Minions".rotate_y(0.009)
	trailblazers_spawn -= delta
	if trailblazers_spawn <= 0:
		trailblazers_spawn=30
		var trailb = load("res://Enemies/Boss/Minions/Trailblazers/enemy_traiblazer_1.tscn")
		var ang = -30
		for n in range(0,3):
			var minion = trailb.instantiate()
			minion.y_rot = ang + (120*n)
			main.add_child(minion)
			minion.transform.origin = MainNode.transform.origin
			
	
	var hp = HealthComponent.health
	var max_hp = HealthComponent.StatHandler.max_health
	if hp <= max_hp*0.6:
		kill_ships()
		emit_signal("changed", self, "Laser")
	
	

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
	update_ships(1.2)

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
		emit_signal("changed", self, "Spawn")
		update_ships(3)
	else:
		emit_signal("changed", self, "Laser")
