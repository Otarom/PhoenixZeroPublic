extends Node

@export var Player : Player
@export var WeaponHolder : Node
@export var SkillHolder : Node
@export var StatHandler : StatHandler
@export var HealthComponent : HealthComponent
@export var Inventory : Node3D
@export var Sound : Node
@export var model_rig : Marker3D

@onready var main = get_tree().current_scene

var smoke_storage : Array = []

var regen_timer = 0
var st_regen_timer = 0
var inv_time = 0
var godmode=false
var one_shot_prot = 0.3
var death_timer = 3
var expl_timer = 0

var smoke_timer = 0

var low_alarm = false

# Controls equipment, calls functions from base nodes, controls UI, changes player states
# Calls like death, invulnerability frames, pauses, changes in plane/models, inventory changes, etc.
# Main node of the player created to avoid unnecessary complex lines inside the main Character Body node.

func _ready():
	spawn_protection()
	

func refresh():
	pass

func spawn_protection():
	$"../Forcefield".visible=true
	HealthComponent.toggle_invulnerability(true)
	inv_time = 3

func toggle_godmode():
	godmode = !godmode
	$"../Forcefield".visible=godmode
	HealthComponent.toggle_invulnerability(godmode)

func _physics_process(delta):
	inv_time-=delta
	one_shot_prot-=delta
	
	regen_timer-=delta
	if regen_timer <= 0 and not Player.dead:
		HealthComponent.regen = true
		
	st_regen_timer-=delta
	if st_regen_timer <= 0:
		SkillHolder.regen = true
	
	if inv_time<=0 and not godmode:
		$"../Forcefield".visible=false
		HealthComponent.toggle_invulnerability(false)
	
	if HealthComponent.health == StatHandler.max_health:
		one_shot_prot=0.5
	
	smoke_timer-=delta
	if HealthComponent.health > StatHandler.max_health*0.3:
		low_alarm=false
		$"../Fire".emitting = false
	else:
		$"../Fire".emitting = true
		spawn_smoke()
	
	
	if Player.dead:
		expl_timer-=delta
		death_timer-=delta
		var char_rot = model_rig.get_rotation()
		if Player.single_stick:
			char_rot.z += 0.1
		else:
			char_rot.y += 0.1
		if expl_timer <= 0 and model_rig.visible:
			expl_timer=0.3
			var explosion = load("res://Misc/VFX/2D_Explosion/explosion.tscn").instantiate()
			main.add_child(explosion)
			explosion.global_position = Player.global_position
		char_rot.x = 0
		model_rig.set_rotation(char_rot)
	
	if death_timer <= 0:
		if model_rig.visible:
			var Expl = Global.sm_expl.instantiate()
			Expl.testing = true
			main.add_child(Expl)
			Expl.global_transform.origin = Player.global_transform.origin
		Player.last_dir = null
		Player.direction = null
#		Player.visible = false
		$"../AimRig/Aim_Circle".visible = false
		$"../Fire".emitting = false
		model_rig.visible = false
		

func spawn_smoke():
	if smoke_timer <= 0 and model_rig.visible and not Player.dead:
			smoke_timer=0.2
			var smoke = get_smoke_particle()
			main.add_child(smoke)
			smoke.global_position = Player.global_position

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

func change_weapon(weapon_type):
	# Temporary code (Will be replaced on later versions by inventory management)
	var weapon_object
	var weapon
	if weapon_type == 0:
		# Machinegun
		weapon_object = load("res://Player/Weapons/Machinegun/Machinegun.tscn")
		
	elif weapon_type == 1:
		# Sword
#		weapon_object = load("res://Player/Weapons/Sword/Sword.tscn")
		weapon_object = load("res://Player/Weapons/Sword2/Sword2.tscn")
		
	elif weapon_type == 2:
		# Saw
#		weapon_object = load("res://Player/Weapons/Shotgun/Shotgun.tscn")
		weapon_object = load("res://Player/Weapons/Saw/Saw.tscn")
		
	elif weapon_type == 3:
		# Sniper
		weapon_object = load("res://Player/Weapons/Sniper/Sniper.tscn")
		
	elif weapon_type == 4:
		# Laser
		weapon_object = load("res://Player/Weapons/LaserBeam/LaserBeam.tscn")
	
	elif weapon_type == 5:
		# Cluster Shotgun
		weapon_object = load("res://Player/Weapons/Cluster/Cluster.tscn")
		
	else:
		# Machinegun
		weapon_object = load("res://Player/Weapons/Machinegun/Machinegun.tscn")
		
	weapon = weapon_object.instantiate()
	if WeaponHolder.Weapon:
		WeaponHolder.remove_child(WeaponHolder.Weapon)
	WeaponHolder.add_child(weapon)
	WeaponHolder.Weapon = weapon
	WeaponHolder.refresh()
	
func load_skill():
	var skill_object
	var skill
	if Player.skill_type == 0:
		skill_object = load("res://Player/Skills/Bomb/bomb_skill.tscn")

	elif Player.skill_type == 1:
		skill_object = load("res://Player/Skills/Heal/HealArea.tscn")

	elif Player.skill_type == 2:
		skill_object = load("res://Player/Skills/Shield/shield_skill.tscn")
		
	else:
		skill_object = load("res://Player/Skills/Shield/shield_skill.tscn")
	
	skill = skill_object.instantiate()
	SkillHolder.add_child(skill)
	SkillHolder.Skill = skill
	SkillHolder.refresh()

func _on_health_component_on_death():
	if HealthComponent.health < 0:
		HealthComponent.health = 0
	if not Player.dead:
		$"../LockMark".visible = false
		$"../CameraRig".cam_lock = false
		Player.dead = true
		Sound.Motor.stop()
		Sound.Death.play()
	pass # Replace with function body.


func _on_buff_handler_damage_buff_start(amount):
	pass # Replace with function body.


func _on_health_component_on_damage_received(damage):
	HealthComponent.Invulnerable = true
#	$"../Forcefield".visible=true
	if one_shot_prot > 0 and damage > HealthComponent.health:
#		print(one_shot_prot)
		HealthComponent.health = 1
	if godmode:
		HealthComponent.health += damage
		if HealthComponent.health > StatHandler.max_health:
			HealthComponent.health = StatHandler.max_health
	inv_time = 0.3
	HealthComponent.regen = false
	regen_timer = 10
	
	if HealthComponent.health < StatHandler.max_health*0.3 and not Sound.LowHealth.playing and not low_alarm:
		low_alarm = true
		Sound.LowHealth.play()
	


func _on_skill_holder_on_skill_used():
	SkillHolder.regen = false
	st_regen_timer = 8


func _on_player_stats_on_refresh():
#	HealthComponent.refresh()
	
	pass # Replace with function body.


func _on_health_component_on_heal(heal):
	if Player.dead and death_timer > 0:
		death_timer = 3
		Player.dead = false
		Sound.Motor.play()
		Sound.Death.stop()
		
	pass # Replace with function body.


func _on_health_component_on_bleed(bleed):
	HealthComponent.regen = false
	regen_timer = 10
	if HealthComponent.health < StatHandler.max_health*0.3 and not Sound.LowHealth.playing and not low_alarm:
		low_alarm = true
		Sound.LowHealth.play()
	pass # Replace with function body.


func _on_health_component_on_hit(Hit):
	if not Player.dead:
		$"../Sound/Hit".play()
	pass # Replace with function body.
